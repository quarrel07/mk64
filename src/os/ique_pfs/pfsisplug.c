#ifdef VERSION_CN
/* iQue's controller-pak layer is the 2.0L SDK revision compiled with
   EGCS -O2 (verbatim via decompals/ultralib; measured 100 percent on
   this file's functions unless noted in the Makefile) */
#include "PRinternal/macros.h"
#include "PR/os_internal.h"
#include "PRinternal/controller.h"
#include "PRinternal/siint.h"

OSPifRam __osPfsPifRam;

s32 osPfsIsPlug(OSMesgQueue* mq, u8* pattern) {
    s32 ret = 0;
    OSMesg msg;
    u8 bitpattern;
    OSContStatus contData[MAXCONTROLLERS];
    s32 channel;
    s32 crcErrorCount = 3; /* iQue's build initializes this before `bits` */
    u8 bits = 0;

    __osSiGetAccess();

    do {
        __osPfsRequestData(CONT_CMD_REQUEST_STATUS);

        ret = __osSiRawStartDma(OS_WRITE, &__osPfsPifRam);
        osRecvMesg(mq, &msg, OS_MESG_BLOCK);

        ret = __osSiRawStartDma(OS_READ, &__osPfsPifRam);
        osRecvMesg(mq, &msg, OS_MESG_BLOCK);

        __osPfsGetInitData(&bitpattern, &contData[0]);

        for (channel = 0; channel < __osMaxControllers; channel++) {
            if ((contData[channel].status & CONT_ADDR_CRC_ER) == 0) {
                crcErrorCount--;
                break;
            }
        }

        if (channel == __osMaxControllers) {
            crcErrorCount = 0;
        }
    } while (crcErrorCount > 0);

    for (channel = 0; channel < __osMaxControllers; channel++) {
        if ((contData[channel].errno == 0) && ((contData[channel].status & CONT_CARD_ON) != 0)) {
            bits |= (1 << channel);
        }
    }
    __osSiRelAccess();
    *pattern = bits;
    return ret;
}

void __osPfsRequestData(u8 cmd) {
    u8* ptr = (u8*)&__osPfsPifRam;
    __OSContRequesFormat requestformat;
    int i;

    __osContLastCmd = cmd;
    __osPfsPifRam.pifstatus = CONT_CMD_EXE;
    requestformat.dummy = CONT_CMD_NOP;
    requestformat.txsize = CONT_CMD_REQUEST_STATUS_TX;
    requestformat.rxsize = CONT_CMD_REQUEST_STATUS_RX;
    requestformat.cmd = cmd;
    requestformat.typeh = CONT_CMD_NOP;
    requestformat.typel = CONT_CMD_NOP;
    requestformat.status = CONT_CMD_NOP;
    requestformat.dummy1 = CONT_CMD_NOP;

    for (i = 0; i < __osMaxControllers; i++) {
        *((__OSContRequesFormat*)ptr) = requestformat;
        ptr += sizeof(__OSContRequesFormat);
    }

    *ptr = CONT_CMD_END;
}

/* iQue rewrite (cart 0x800D0F24): the per-channel status byte becomes the
   kernel pak-present flag (__osBbPakAddress[i] != 0), and the BB hack-flags
   controller remap (the same idiom sm64's cn osContInit carries) swaps
   channel 0 with channel __osBbHackFlags at the end. */
extern u32 __osBbPakAddress[];
extern u32 __osBbIsBb;
extern u32 __osBbHackFlags;

void __osPfsGetInitData(u8* pattern, OSContStatus* data) {
    u8* ptr;
    __OSContRequesFormat requestformat;
    int i;
    u8 bits = 0;

    ptr = (u8*)&__osPfsPifRam;
    for (i = 0; i < __osMaxControllers; i++, ptr += sizeof(requestformat), data++) {
        requestformat = *(__OSContRequesFormat*)ptr;
        data->errno = CHNL_ERR(requestformat);

        if (data->errno == 0) {
            bits |= 1 << i;
            data->type = (requestformat.typel << 8) | (requestformat.typeh);
            data->status = (__osBbPakAddress[i] != 0);
        }
    }

    if (__osBbIsBb != 0 && __osBbHackFlags != 0) {
        OSContStatus tmp;
        data -= __osMaxControllers;
        bits = (bits & ~((1 << __osBbHackFlags) | 1)) |
               ((bits & 1) << __osBbHackFlags) |
               ((bits & (1 << __osBbHackFlags)) >> __osBbHackFlags);
        tmp = *data;
        *data = data[__osBbHackFlags];
        data[__osBbHackFlags] = tmp;
    }

    *pattern = bits;
}
#endif
