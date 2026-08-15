#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile for the opt level); this
   arm is the byte-exact body, via sm64's matched cn libultra */
#include "libultra_internal.h"
#include "PR/rcp.h"

extern OSViContext *__osViNext;
extern OSViContext *__osViCurr;

extern u32 __additional_scanline;

void __osViSwapContext() {
    register OSViMode *viMode;
    register OSViContext *s1;
    u32 origin;
    u32 hStart;
#ifdef VERSION_CN
    u32 vStart;
#endif
    u32 sp34;
    u32 field;
    field = 0;
    s1 = __osViNext;
    viMode = s1->modep;
    field = IO_READ(VI_V_CURRENT_LINE_REG) & 1;
    origin = osVirtualToPhysical(s1->buffer) + viMode->fldRegs[field].origin;
    if (s1->unk00 & 2) {
        s1->unk20 |= viMode->comRegs.xScale & ~0xfff;
    } else {
        s1->unk20 = viMode->comRegs.xScale;
    }
    if (s1->unk00 & 4) {
        sp34 = (u32)(viMode->fldRegs[field].yScale & 0xfff);
        s1->unk2c = s1->unk24 * sp34;
        s1->unk2c |= viMode->fldRegs[field].yScale & ~0xfff;
    } else {
        s1->unk2c = viMode->fldRegs[field].yScale;
    }

#ifdef VERSION_CN
    vStart = viMode->fldRegs[field].vStart - (__additional_scanline << 0x10) + __additional_scanline;
#endif
    hStart = viMode->comRegs.hStart;

    if (s1->unk00 & 0x20) {
        hStart = 0;
    }
    if (s1->unk00 & 0x40) {
        s1->unk2c = 0;
        origin = osVirtualToPhysical(s1->buffer);
    }
    if (s1->unk00 & 0x80) {
        s1->unk2c = (s1->unk28 << 0x10) & 0x3ff0000;
        origin = osVirtualToPhysical(s1->buffer);
    }
    IO_WRITE(VI_ORIGIN_REG, origin);
    IO_WRITE(VI_WIDTH_REG, viMode->comRegs.width);
    IO_WRITE(VI_BURST_REG, viMode->comRegs.burst);
    IO_WRITE(VI_V_SYNC_REG, viMode->comRegs.vSync);
    IO_WRITE(VI_H_SYNC_REG, viMode->comRegs.hSync);
    IO_WRITE(VI_LEAP_REG, viMode->comRegs.leap);
    IO_WRITE(VI_H_START_REG, hStart);
#ifdef VERSION_CN
    IO_WRITE(VI_V_START_REG, vStart);
#else
    IO_WRITE(VI_V_START_REG, viMode->fldRegs[field].vStart);
#endif
    IO_WRITE(VI_V_BURST_REG, viMode->fldRegs[field].vBurst);
    IO_WRITE(VI_INTR_REG, viMode->fldRegs[field].vIntr);
    IO_WRITE(VI_X_SCALE_REG, s1->unk20);
    IO_WRITE(VI_Y_SCALE_REG, s1->unk2c);
    IO_WRITE(VI_CONTROL_REG, s1->features);
    __osViNext = __osViCurr;
    __osViCurr = s1;
    *__osViNext = *__osViCurr;
}
#else
#include "libultra_internal.h"
#include "hardware.h"

extern OSViContext* __osViNext;
extern OSViContext* __osViCurr;

void __osViSwapContext() {
    register OSViMode* s0;
    register OSViContext* s1;
    u32 origin;
    u32 hStart;
    u32 sp34;
    u32 field;
    register u32 s2;
    field = 0;
    s1 = __osViNext;
    s0 = s1->modep;
    field = HW_REG(VI_V_CURRENT_LINE_REG, u32) & 1;
    s2 = osVirtualToPhysical(s1->buffer);
    origin = (s0->fldRegs[field].origin) + s2;
    if (s1->unk00 & 2) {
        s1->unk20 |= s0->comRegs.xScale & ~0xfff;
    } else {
        s1->unk20 = s0->comRegs.xScale;
    }
    if (s1->unk00 & 4) {
        sp34 = (u32) (s0->fldRegs[field].yScale & 0xfff);
        s1->unk2c = s1->unk24 * sp34;
        s1->unk2c |= s0->fldRegs[field].yScale & ~0xfff;
    } else {
        s1->unk2c = s0->fldRegs[field].yScale;
    }
    hStart = s0->comRegs.hStart;
    if (s1->unk00 & 0x20) {
        hStart = 0;
    }
    if (s1->unk00 & 0x40) {
        s1->unk2c = 0;
        origin = osVirtualToPhysical(s1->buffer);
    }
    if (s1->unk00 & 0x80) {
        s1->unk2c = (s1->unk28 << 0x10) & 0x3ff0000;
        origin = osVirtualToPhysical(s1->buffer);
    }
    HW_REG(VI_ORIGIN_REG, u32) = origin;
    HW_REG(VI_WIDTH_REG, u32) = s0->comRegs.width;
    HW_REG(VI_BURST_REG, u32) = s0->comRegs.burst;
    HW_REG(VI_V_SYNC_REG, u32) = s0->comRegs.vSync;
    HW_REG(VI_H_SYNC_REG, u32) = s0->comRegs.hSync;
    HW_REG(VI_LEAP_REG, u32) = s0->comRegs.leap;
    HW_REG(VI_H_START_REG, u32) = hStart;
    HW_REG(VI_V_START_REG, u32) = s0->fldRegs[field].vStart;
    HW_REG(VI_V_BURST_REG, u32) = s0->fldRegs[field].vBurst;
    HW_REG(VI_INTR_REG, u32) = s0->fldRegs[field].vIntr;
    HW_REG(VI_X_SCALE_REG, u32) = s1->unk20;
    HW_REG(VI_Y_SCALE_REG, u32) = s1->unk2c;
    HW_REG(VI_CONTROL_REG, u32) = s1->features;
    __osViNext = __osViCurr;
    __osViCurr = s1;
    *__osViNext = *__osViCurr;
}
#endif
