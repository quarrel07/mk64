#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile); body via sm64's
   matched cn libultra */
#include "ique_compat.h"
#include "libultra_internal.h"
#include "PR/rcp.h"

s32 __osSpSetPc(void *pc) {
    register u32 status = IO_READ(SP_STATUS_REG);
    if (!(status & SPSTATUS_HALT)) {
        return -1;
    } else {
        IO_WRITE(SP_PC_REG, pc);
        return 0;
    }
}
#else
#include "libultra_internal.h"
#include "hardware.h"

s32 __osSpSetPc(void* pc) {
    register u32 status = HW_REG(SP_STATUS_REG, u32);
    if (!(status & SPSTATUS_HALT)) {
        return -1;
    } else {
        HW_REG(SP_PC_REG, void*) = pc;
        return 0;
    }
}
#endif
