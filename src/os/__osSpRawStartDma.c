#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile); body via sm64's
   matched cn libultra */
#include "ique_compat.h"
#include "libultra_internal.h"
#include "PR/rcp.h"

s32 __osSpRawStartDma(u32 dir, void *sp_ptr, void *dram_ptr, size_t size) {
    if (__osSpDeviceBusy()) {
        return -1;
    }

    IO_WRITE(SP_MEM_ADDR_REG, sp_ptr);
    IO_WRITE(SP_DRAM_ADDR_REG, osVirtualToPhysical(dram_ptr));

    if (dir == 0) {
        IO_WRITE(SP_WR_LEN_REG, size - 1);
    } else {
        IO_WRITE(SP_RD_LEN_REG, size - 1);
    }
    return 0;
}
#else
#include "libultra_internal.h"
#include "hardware.h"

s32 __osSpRawStartDma(u32 dir, void* sp_ptr, void* dram_ptr, size_t size) {
    if (__osSpDeviceBusy()) {
        return -1;
    }
    HW_REG(SP_MEM_ADDR_REG, void*) = sp_ptr;
    HW_REG(SP_DRAM_ADDR_REG, void*) = (void*) osVirtualToPhysical(dram_ptr);
    if (dir == 0) {
        HW_REG(SP_WR_LEN_REG, u32) = size - 1;
    } else {
        HW_REG(SP_RD_LEN_REG, u32) = size - 1;
    }
    return 0;
}
#endif
