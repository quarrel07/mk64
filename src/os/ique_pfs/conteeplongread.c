#ifdef VERSION_CN
/* iQue's controller-pak layer is the 2.0L SDK revision compiled with
   EGCS -O2 (verbatim via decompals/ultralib; measured 100 percent on
   this file's functions unless noted in the Makefile) */
#include "PR/os_internal.h"
#include "PRinternal/controller.h"

s32 osEepromLongRead(OSMesgQueue* mq, u8 address, u8* buffer, int length) {
    s32 ret = 0;

    while (length > 0) {
        ERRCK(osEepromRead(mq, address, buffer));
        length -= EEPROM_BLOCK_SIZE;
        address++;
        buffer += EEPROM_BLOCK_SIZE;
    }

    return ret;
}
#endif
