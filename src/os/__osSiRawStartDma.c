#ifdef VERSION_CN
/* iQue compiles this file with EGCS -O2; body via sm64's matched cn
   libultra (shims in ique_compat.h) */
#include "ique_compat.h"
#include "libultra_internal.h"
#include "PR/rcp.h"
#include "PR/ique.h"

s32 __osSiRawStartDma(s32 dir, void *addr) {
#ifdef VERSION_CN
    if (IO_READ(SI_STATUS_REG) & (SI_STATUS_DMA_BUSY | SI_STATUS_RD_BUSY)) {
        return -1;
    }
#else
    if (__osSiDeviceBusy()) {
        return -1;
    }
#endif

    if (dir == OS_WRITE) {
        osWritebackDCache(addr, 64);
    }

    IO_WRITE(SI_DRAM_ADDR_REG, osVirtualToPhysical(addr));

    if (dir == OS_READ) {
#ifdef VERSION_CN
        if (__osBbIsBb != 0) {
            u32 prev = __osDisableInt();
            skKeepAlive();
            __osRestoreInt(prev);
        }
#endif
        IO_WRITE(SI_PIF_ADDR_RD64B_REG, 0x1FC007C0);
    } else {
        IO_WRITE(SI_PIF_ADDR_WR64B_REG, 0x1FC007C0);
    }

    if (dir == OS_READ) {
        osInvalDCache(addr, 64);
    }
    return 0;
}
#else
#include "libultra_internal.h"
#include "hardware.h"

s32 __osSiRawStartDma(s32 dir, void* addr) {
    if (__osSiDeviceBusy()) {
        return -1;
    }

    if (dir == OS_WRITE) {
        osWritebackDCache(addr, 64);
    }

    HW_REG(SI_DRAM_ADDR_REG, void*) = (void*) osVirtualToPhysical(addr);

    if (dir == OS_READ) {
        HW_REG(SI_PIF_ADDR_RD64B_REG, u32) = 0x1FC007C0;
    } else {
        HW_REG(SI_PIF_ADDR_WR64B_REG, u32) = 0x1FC007C0;
    }

    if (dir == OS_READ) {
        osInvalDCache(addr, 64);
    }
    return 0;
}
#endif
