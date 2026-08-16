#include "libultra_internal.h"
#include <PR/rcp.h>
#include "controller.h"

/* cn: pak writes go straight to the memory-mapped BB pak; same shape as the
   cn __osContRamRead, keeping the retail ID-area (1..6) write filter.
   Parked 1 word short of the cart: iQue's compile carries an extra register
   move before the copy loop that no source shape or flag reproduces here
   (allocation-only, patchlevel-class; evidence in IQUE-SCOPING.md). */
#ifdef VERSION_CN
extern u32 __osBbPakAddress[];
extern u32 __osBbPakSize;

s32 __osContRamWrite(OSMesgQueue* mq, int channel, u16 address, u8* buffer, int force) {
    s32 ret = 0;
    int i;
    u32 pakAddr;

    if (force != 1 && address < 7 && address != 0) {
        return 0;
    }
    __osSiGetAccess();
    if (__osBbPakAddress[channel] != 0) {
        if ((address << 5) <= __osBbPakSize - 0x20) {
            for (i = 0; i < 0x20; i++) {
                pakAddr = __osBbPakAddress[channel];
                *(u8*) ((address << 5) + pakAddr + i) = buffer[i];
            }
        }
    } else {
        ret = PFS_ERR_NOPACK;
    }
    __osSiRelAccess();
    return ret;
}
#else
extern s32 __osPfsGetStatus(OSMesgQueue*, s32);
void __osPackRamWriteData(int channel, u16 address, u8* buffer);

s32 __osContRamWrite(OSMesgQueue* mq, int channel, u16 address, u8* buffer, int force) {
    s32 ret;
    int i;
    u8* ptr;
    __OSContRamReadFormat ramreadformat;
    int retry;

    ret = 0;
    ptr = (u8*) &__osPfsPifRam;
    retry = 2;
    if (force != 1 && address < 7 && address != 0) {
        return 0;
    }
    __osSiGetAccess();
    __osContLastCmd = CONT_CMD_WRITE_MEMPACK;
    __osPackRamWriteData(channel, address, buffer);
    ret = __osSiRawStartDma(OS_WRITE, &__osPfsPifRam);
    osRecvMesg(mq, NULL, OS_MESG_BLOCK);
    do {
        for (i = 0; i < 16; i++) {
            __osPfsPifRam.ramarray[i] = 0xFF;
        }
        __osPfsPifRam.pifstatus = 0;
        ret = __osSiRawStartDma(OS_READ, &__osPfsPifRam);
        osRecvMesg(mq, NULL, OS_MESG_BLOCK);
        ptr = (u8*) &__osPfsPifRam;
        if (channel != 0) {
            for (i = 0; i < channel; i++) {
                ptr++;
            }
        }

        ramreadformat = *(__OSContRamReadFormat*) ptr;

        ret = CHNL_ERR(ramreadformat);
        if (ret == 0) {
            if (__osContDataCrc(buffer) != ramreadformat.datacrc) {
                ret = __osPfsGetStatus(mq, channel);
                if (ret != 0) {
                    __osSiRelAccess();
                    return ret;
                }
                ret = PFS_ERR_CONTRFAIL;
            }
        }
        if (ret != PFS_ERR_CONTRFAIL) {
            break;
        }
    } while ((retry-- >= 0));
    __osSiRelAccess();
    return ret;
}

void __osPackRamWriteData(int channel, u16 address, u8* buffer) {
    u8* ptr;
    __OSContRamReadFormat ramreadformat;
    int i;

    ptr = (u8*) __osPfsPifRam.ramarray;

    for (i = 0; i < ARRLEN(__osPfsPifRam.ramarray) + 1; i++) { // also clear pifstatus
        __osPfsPifRam.ramarray[i] = 0;
    }

    __osPfsPifRam.pifstatus = CONT_CMD_EXE;
    ramreadformat.dummy = CONT_CMD_NOP;
    ramreadformat.txsize = CONT_CMD_WRITE_MEMPACK_TX;
    ramreadformat.rxsize = CONT_CMD_WRITE_MEMPACK_RX;
    ramreadformat.cmd = CONT_CMD_WRITE_MEMPACK;
    ramreadformat.address = (address << 0x5) | __osContAddressCrc(address);
    ramreadformat.datacrc = CONT_CMD_NOP;
    for (i = 0; i < ARRLEN(ramreadformat.data); i++) {
        ramreadformat.data[i] = *buffer++;
    }
    if (channel != 0) {
        for (i = 0; i < channel; i++) {
            *ptr++ = 0;
        }
    }
    *(__OSContRamReadFormat*) ptr = ramreadformat;
    ptr += sizeof(__OSContRamReadFormat);
    ptr[0] = CONT_CMD_END;
}
#endif
