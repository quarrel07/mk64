#ifdef VERSION_CN
/* iQue's controller-pak layer is the 2.0L SDK revision compiled with
   EGCS -O2 (verbatim via decompals/ultralib; measured 100 percent on
   this file's functions unless noted in the Makefile) */
#include "PR/os_internal.h"
#include "PRinternal/controller.h"
#include "PRinternal/siint.h"

#if BUILD_VERSION >= VERSION_J
void __osPfsRequestOneChannel(int channel, u8 cmd);
#else
void __osPfsRequestOneChannel(int channel);
#endif
void __osPfsGetOneChannelData(int channel, OSContStatus* data);

/* iQue: pak presence is kernel-provided - a non-null entry in the
   __osBbPakAddress table (0x80000374) means the flash-emulated pak for
   that channel is mapped. No SI transaction at all (cart 0x800D1290,
   10 words). The SI helpers below survive for the other probe paths. */
extern u32 __osBbPakAddress[];

s32 __osPfsGetStatus(OSMesgQueue* queue, int channel) {
    if (__osBbPakAddress[channel] != 0) {
        return 0;
    }
    return PFS_ERR_NOPACK;
}

#if BUILD_VERSION >= VERSION_J
void __osPfsRequestOneChannel(int channel, u8 cmd) {
#else
void __osPfsRequestOneChannel(int channel) {
#endif
    u8* ptr;
    __OSContRequesFormatShort requestformat;
    int i;

#if BUILD_VERSION >= VERSION_J
    __osContLastCmd = CONT_CMD_END;
#else
    __osContLastCmd = CONT_CMD_REQUEST_STATUS;
#endif
    __osPfsPifRam.pifstatus = CONT_CMD_READ_BUTTON;

    ptr = (u8*)&__osPfsPifRam;

    requestformat.txsize = CONT_CMD_REQUEST_STATUS_TX;
    requestformat.rxsize = CONT_CMD_REQUEST_STATUS_RX;
#if BUILD_VERSION >= VERSION_J
    requestformat.cmd = cmd;
#else
    requestformat.cmd = CONT_CMD_REQUEST_STATUS;
#endif
    requestformat.typeh = CONT_CMD_NOP;
    requestformat.typel = CONT_CMD_NOP;
    requestformat.status = CONT_CMD_NOP;

    for (i = 0; i < channel; i++) {
        *ptr++ = CONT_CMD_REQUEST_STATUS;
    }

    *(__OSContRequesFormatShort*)ptr = requestformat;
    ptr += sizeof(__OSContRequesFormatShort);
    *ptr = CONT_CMD_END;
}

void __osPfsGetOneChannelData(int channel, OSContStatus* data) {
    u8* ptr = (u8*)&__osPfsPifRam;
    __OSContRequesFormatShort requestformat;
    int i;

    for (i = 0; i < channel; i++) {
        ptr++;
    }

    requestformat = *(__OSContRequesFormatShort*)ptr;
    data->errno = CHNL_ERR(requestformat);

    if (data->errno != 0) {
        return;
    }

    data->type = (requestformat.typel << 8) | (requestformat.typeh);
    data->status = requestformat.status;
}
#endif
