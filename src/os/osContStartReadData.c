#ifdef VERSION_CN
/* iQue compiles this file with EGCS -O2; body via sm64's matched cn
   libultra (shims in ique_compat.h) */
#include "ique_compat.h"
#define errnum errno
#include "libultra_internal.h"
#include "osContInternal.h"
#include "PR/ique.h"
#include <macros.h>
#include "controller.h"

ALIGNED8 OSPifRam __osContPifRam;

extern u8 __osContLastCmd;
extern u8 __osMaxControllers;

void __osPackReadData(void);

s32 osContStartReadData(OSMesgQueue *mesg) {
#ifdef VERSION_CN
    s32 ret;
#else
    s32 ret = 0;
    s32 i;
#endif
    __osSiGetAccess();
    if (__osContLastCmd != CONT_CMD_READ_BUTTON) {
        __osPackReadData();
        ret = __osSiRawStartDma(OS_WRITE, __osContPifRam.ramarray);
        osRecvMesg(mesg, NULL, OS_MESG_BLOCK);
    }
#ifndef VERSION_CN
    for (i = 0; i < ARRAY_COUNT(__osContPifRam.ramarray) + 1; i++) {
        __osContPifRam.ramarray[i] = 0xff;
    }
    __osContPifRam.pifstatus = 0;
#endif

    ret = __osSiRawStartDma(OS_READ, __osContPifRam.ramarray);
#ifdef VERSION_CN
    __osContLastCmd = 0xfd;
#else
    __osContLastCmd = CONT_CMD_READ_BUTTON;
#endif
    __osSiRelAccess();
    return ret;
}

void osContGetReadData(OSContPad *pad) {
    u8 *cmdBufPtr;
    OSContPackedRead response;
    s32 i;
    cmdBufPtr = (u8 *) __osContPifRam.ramarray;
    for (i = 0; i < __osMaxControllers; i++, cmdBufPtr += sizeof(OSContPackedRead), pad++) {
        response = * (OSContPackedRead *) cmdBufPtr;
        pad->errnum = (response.rxLen & 0xc0) >> 4;
        if (pad->errnum == 0) {
            pad->button = response.button;
            pad->stick_x = response.rawStickX;
            pad->stick_y = response.rawStickY;
        }
    }
#ifdef VERSION_CN
    if (__osBbIsBb != 0 && __osBbHackFlags != 0) {
        OSContPad tmp;
        pad -= __osMaxControllers;
        tmp = *pad;
        *pad = pad[__osBbHackFlags];
        pad[__osBbHackFlags] = tmp;
    }
#endif
}

void __osPackReadData() {
    u8 *cmdBufPtr;
    OSContPackedRead request;
    s32 i;
    cmdBufPtr = (u8 *) __osContPifRam.ramarray;

#ifdef VERSION_CN
    for (i = 0; i < ARRAY_COUNT(__osContPifRam.ramarray); i++) {
#else
    for (i = 0; i < ARRAY_COUNT(__osContPifRam.ramarray) + 1; i++) {
#endif
        __osContPifRam.ramarray[i] = 0;
    }

    __osContPifRam.pifstatus = 1;
    request.padOrEnd = 255;
    request.txLen = 1;
    request.rxLen = 4;
    request.command = 1;
    request.button = 65535;
    request.rawStickX = -1;
    request.rawStickY = -1;
    for (i = 0; i < __osMaxControllers; i++) {
        * (OSContPackedRead *) cmdBufPtr = request;
        cmdBufPtr += sizeof(OSContPackedRead);
    }
    *cmdBufPtr = 254;
}
#else
#include "libultra_internal.h"
#include "controller.h"
#include <macros.h>

extern u8 __osContLastCmd;
extern u8 _osContNumControllers;

void __osPackReadData(void);
s32 osContStartReadData(OSMesgQueue* mesg) {
    s32 ret = 0;
    s32 i;

    __osSiGetAccess();

    if (__osContLastCmd != CONT_CMD_READ_BUTTON) {
        __osPackReadData();
        ret = __osSiRawStartDma(OS_WRITE, __osContPifRam.ramarray);
        osRecvMesg(mesg, NULL, OS_MESG_BLOCK);
    }

    for (i = 0; i < ARRLEN(__osContPifRam.ramarray) + 1; i++) {
        __osContPifRam.ramarray[i] = CONT_CMD_NOP;
    }

    __osContPifRam.pifstatus = 0;
    ret = __osSiRawStartDma(OS_READ, __osContPifRam.ramarray);
    __osContLastCmd = CONT_CMD_READ_BUTTON;

    __osSiRelAccess();

    return ret;
}
void osContGetReadData(OSContPad* pad) {
    u8* ptr = (u8*) __osContPifRam.ramarray;
    __OSContReadFormat readformat;
    s32 i;

    for (i = 0; i < _osContNumControllers; i++, ptr += sizeof(readformat), pad++) {
        readformat = *(__OSContReadFormat*) ptr;
        pad->errno = CHNL_ERR(readformat);

        if (pad->errno != 0) {
            continue;
        }

        pad->button = readformat.button;
        pad->stick_x = readformat.stick_x;
        pad->stick_y = readformat.stick_y;
    }
}
void __osPackReadData() {
    u8* ptr = (u8*) __osContPifRam.ramarray;
    __OSContReadFormat readformat;
    s32 i;

    for (i = 0; i < ARRLEN(__osContPifRam.ramarray) + 1; i++) {
        __osContPifRam.ramarray[i] = 0;
    }

    __osContPifRam.pifstatus = CONT_CMD_EXE;
    readformat.dummy = CONT_CMD_NOP;
    readformat.txsize = CONT_CMD_READ_BUTTON_TX;
    readformat.rxsize = CONT_CMD_READ_BUTTON_RX;
    readformat.cmd = CONT_CMD_READ_BUTTON;
    readformat.button = 0xFFFF;
    readformat.stick_x = -1;
    readformat.stick_y = -1;

    for (i = 0; i < _osContNumControllers; i++) {
        *(__OSContReadFormat*) ptr = readformat;
        ptr += sizeof(readformat);
    }
    *ptr = CONT_CMD_END;
}
#endif
