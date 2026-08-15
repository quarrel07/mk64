#ifndef VERSION_CN /* iQue uses the 2.0L bodies in src/os/ique_pfs/ */
#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile for the opt level); this
   arm is the byte-exact body, via sm64's matched cn libultra */
#include "libultra_internal.h"
#include "controller.h"

s32 osEepromLongRead(OSMesgQueue *mq, u8 address, u8 *buffer, s32 nbytes) {
    s32 status = 0;

#ifndef VERSION_CN
    if (address > 0x40) {
        return -1;
    }
#endif

    while (nbytes > 0) {
        status = osEepromRead(mq, address, buffer);
        if (status != 0) {
            return status;
        }

        nbytes -= EEPROM_BLOCK_SIZE;
        address++;
        buffer += EEPROM_BLOCK_SIZE;
#ifndef VERSION_CN
        osSetTimer(&__osEepromTimer, 12000 * osClockRate / 1000000, 0, &__osEepromTimerQ, __osEepromTimerMsg);
        osRecvMesg(&__osEepromTimerQ, NULL, OS_MESG_BLOCK);
#endif
    }

    return status;
}
#else
#include "libultra_internal.h"

extern u64 osClockRate;
extern u8 D_80365D20;
extern u8 _osContNumControllers;
extern OSTimer D_80196548; // not sure what this is yet
extern OSMesgQueue _osContMesgQueue;
extern OSMesg _osContMesgBuff[4];

s32 osEepromLongRead(OSMesgQueue* mq, u8 address, u8* buffer, s32 nbytes) {
    s32 status = 0;
    if (address > 0x40) {
        return -1;
    }

    while (nbytes > 0) {
        status = osEepromRead(mq, address, buffer);
        if (status != 0) {
            return status;
        }

        nbytes -= EEPROM_BLOCK_SIZE;
        address++;
        buffer += EEPROM_BLOCK_SIZE;
        osSetTimer(&D_80196548, 12000 * osClockRate / 1000000, 0, &_osContMesgQueue, _osContMesgBuff);
        osRecvMesg(&_osContMesgQueue, NULL, OS_MESG_BLOCK);
    }

    return status;
}
#endif

#endif
