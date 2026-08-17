#include "libultra_internal.h"
#include "hardware.h"
#include <macros.h>

#define PIF_ADDR_START (void*) 0x1FC007FC

typedef struct {
    u32 instr00;
    u32 instr01;
    u32 instr02;
    u32 instr03;
} exceptionPreamble;

#ifdef VERSION_CN
/* iQue keeps this flag in the head bss block at 0x800F3C10, not in this
   object's .data; real definition in asm/menu_sbss_cn.s */
extern u32 D_80194040;
#else
u32 D_80194040;
#endif

u64 osClockRate = 62500000;
#ifdef VERSION_CN
/* iQue keeps osViClock at the head of this object's .data, right before
   __osShutdown (cart 0x800E8678/0x800E867C); the cn arm of __osViInit does
   not define it (mirrors sm64's SH/CN guard) */
u32 osViClock = 48681812; /* VI_NTSC_CLOCK; cart bytes 02E6D354 */
#endif
u32 __osShutdown = 0;
#ifdef VERSION_CN
/* iQue: Count latched at first prenmi (cart 0x800E8680, right after
   __osShutdown; written by the cn exception handler) */
u32 __osPreNMICount = 0;
#endif
u32 __OSGlobalIntMask = OS_IM_ALL;
u32 D_800EA5F0 = 0;

#define EXCEPTION_TLB_MISS 0x80000000
#define EXCEPTION_XTLB_MISS 0x80000080
#define EXCEPTION_CACHE_ERROR 0x80000100
#define EXCEPTION_GENERAL 0x80000180

extern u32 osResetType;
extern exceptionPreamble __osExceptionPreamble;

#ifdef VERSION_CN
/* cn: the iQue init, reconstructed from the cart (0x800D1FB0/0x800D2064)
   against sm64's cn arm - same source minus the osMemSize default. EGCS,
   no -O (core class). The BB globals are kernel-page words (0x8000035C..
   0x80000388, asm/parameters.s); the 64DD probe and PI clock read are gone. */
#include <PR/rcp.h>
#include <PR/ique.h>
#include "ique_compat.h"

extern OSPiHandle __Dom1SpeedParam;
extern OSPiHandle __Dom2SpeedParam;
extern s32 osRomType;
extern s32 osVersion;
extern u32 __osGetCause(void);
extern void __osSetWatchLo(u32);
extern void osUnmapTLBAll(void);
extern void osMapTLBRdb(void);

void __createSpeedParam(void) {
    __Dom1SpeedParam.type = DEVICE_TYPE_INIT;
    __Dom1SpeedParam.latency = IO_READ(PI_BSD_DOM1_LAT_REG);
    __Dom1SpeedParam.pulse = IO_READ(PI_BSD_DOM1_PWD_REG);
    __Dom1SpeedParam.pageSize = IO_READ(PI_BSD_DOM1_PGS_REG);
    __Dom1SpeedParam.relDuration = IO_READ(PI_BSD_DOM1_RLS_REG);

    __Dom2SpeedParam.type = DEVICE_TYPE_INIT;
    __Dom2SpeedParam.latency = IO_READ(PI_BSD_DOM2_LAT_REG);
    __Dom2SpeedParam.pulse = IO_READ(PI_BSD_DOM2_PWD_REG);
    __Dom2SpeedParam.pageSize = IO_READ(PI_BSD_DOM2_PGS_REG);
    __Dom2SpeedParam.relDuration = IO_READ(PI_BSD_DOM2_RLS_REG);
}

void __osInitialize_common(void) {
    u32 pifdata;
    u32 intrMask1, intrMask2;

    D_80194040 = TRUE;
    __osSetSR(__osGetSR() | 0x20000000);
    __osSetFpcCsr(0x01000800);
    __osSetWatchLo(0x4900000);
    intrMask1 = IO_WRITE(MI_HW_INTR_MASK_REG, 0x22000);
    intrMask2 = IO_WRITE(MI_HW_INTR_MASK_REG, 0x11000);
    __osBbIsBb = (intrMask1 & 0x140) == 0x140 && (intrMask2 & 0x140) == 0 ? 1 : 0;
    if (__osBbIsBb != 0 && (IO_READ(PI_MISC_REG) & 0xC0000000) != 0) {
        __osBbIsBb = 2;
    }
    if (__osBbIsBb != 0) {
        osTvType = 1;
        osRomType = 0;
        osResetType = 0;
        osVersion = 1;
    }
    if (__osBbIsBb == 0) {
        while (__osSiRawReadIo(PIF_ADDR_START, &pifdata)) {
            ;
        }
        while (__osSiRawWriteIo(PIF_ADDR_START, pifdata | 8)) {
            ;
        }
    }
    *(exceptionPreamble*) EXCEPTION_TLB_MISS = __osExceptionPreamble;
    *(exceptionPreamble*) EXCEPTION_XTLB_MISS = __osExceptionPreamble;
    *(exceptionPreamble*) EXCEPTION_CACHE_ERROR = __osExceptionPreamble;
    *(exceptionPreamble*) EXCEPTION_GENERAL = __osExceptionPreamble;
    osWritebackDCache((void*) 0x80000000, EXCEPTION_GENERAL + sizeof(exceptionPreamble) - EXCEPTION_TLB_MISS);
    osInvalICache((void*) 0x80000000, EXCEPTION_GENERAL + sizeof(exceptionPreamble) - EXCEPTION_TLB_MISS);
    __createSpeedParam();
    osUnmapTLBAll();
    osMapTLBRdb();
    osClockRate = osClockRate * 3 / 4;
    if (osResetType == RESET_TYPE_COLD_RESET) {
        bzero(osAppNmiBuffer, sizeof(osAppNmiBuffer));
    }
    if (osTvType == 0) {
        osViClock = 49656530;
    } else if (osTvType == 2) {
        osViClock = 48628316;
    } else {
        osViClock = 48681812;
    }
    if (__osGetCause() & 0x1000) {
        while (TRUE) {
        }
    }
    if (__osBbIsBb == 0) {
        __osBbEepromSize = 0x200;
        __osBbPakSize = 0x8000;
        __osBbFlashSize = 0x20000;
        __osBbEepromAddress = (u8*) 0x803FFE00;
        __osBbPakAddress[0] = (u32*) 0x803F7E00;
        __osBbPakAddress[1] = NULL;
        __osBbPakAddress[2] = NULL;
        __osBbPakAddress[3] = NULL;
        __osBbFlashAddress = 0x803E0000;
        __osBbSramSize = __osBbFlashSize;
        __osBbSramAddress = __osBbFlashAddress;
    }
    if (__osBbIsBb != 0) {
        IO_WRITE(PI_BASE_REG + 0x64, IO_READ(PI_BASE_REG + 0x64) & 0x7FFFFFFF);
        IO_WRITE(MI_HW_INTR_MASK_REG, 0x20000);
        IO_WRITE(SI_BASE_REG + 0x0C, 0);
        IO_WRITE(SI_BASE_REG + 0x1C, (IO_READ(SI_BASE_REG + 0x1C) & 0x80FFFFFF) | 0x2F400000);
    }

    IO_WRITE(AI_CONTROL_REG, 1);
    IO_WRITE(AI_DACRATE_REG, 0x3fff);
    IO_WRITE(AI_BITRATE_REG, 0xf);
}

/* cart 0x800D2510, directly after the common body: empty, called second
   from main_func (sm64's split; mk64's main calls the pair inline) */
void __osInitialize_autodetect(void) {
}
#else
void osInitialize(void) {
    u32 sp34;
    u32 sp30 = 0;

    UNUSED u32 eu_sp34;
    UNUSED u32 eu_sp30;
    UNUSED u32 sp2c;
    D_80194040 = true;
    __osSetSR(__osGetSR() | 0x20000000);
    __osSetFpcCsr(0x01000800);
    while (__osSiRawReadIo(PIF_ADDR_START, &sp34)) {
        ;
    }
    while (__osSiRawWriteIo(PIF_ADDR_START, sp34 | 8)) {
        ;
    }
    *(exceptionPreamble*) EXCEPTION_TLB_MISS = __osExceptionPreamble;
    *(exceptionPreamble*) EXCEPTION_XTLB_MISS = __osExceptionPreamble;
    *(exceptionPreamble*) EXCEPTION_CACHE_ERROR = __osExceptionPreamble;
    *(exceptionPreamble*) EXCEPTION_GENERAL = __osExceptionPreamble;
    osWritebackDCache((void*) 0x80000000, EXCEPTION_GENERAL + sizeof(exceptionPreamble) - EXCEPTION_TLB_MISS);
    osInvalICache((void*) 0x80000000, EXCEPTION_GENERAL + sizeof(exceptionPreamble) - EXCEPTION_TLB_MISS);
    osMapTLBRdb();
    osPiRawReadIo(4, &sp30);
    sp30 &= ~0xf;
    if (sp30) {
        osClockRate = sp30;
    }
    osClockRate = osClockRate * 3 / 4;
    if (osResetType == RESET_TYPE_COLD_RESET) {
        bzero(osAppNmiBuffer, sizeof(osAppNmiBuffer));
    }

    eu_sp30 = HW_REG(PI_STATUS_REG, u32);
    while (eu_sp30 & PI_STATUS_ERROR) {
        eu_sp30 = HW_REG(PI_STATUS_REG, u32);
    };
    if (!((eu_sp34 = HW_REG(ASIC_STATUS, u32)) & _64DD_PRESENT_MASK)) {
        D_800EA5F0 = 1;
        __osSetHWIntrRoutine(1, &__osLeoInterrupt);
    } else {
        D_800EA5F0 = 0;
    }
}
#endif
