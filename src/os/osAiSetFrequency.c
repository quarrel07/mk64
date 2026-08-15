#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile for the opt level); this
   arm is the byte-exact body, via sm64's matched cn libultra */
#include "libultra_internal.h"
#include "PR/rcp.h"
#include "osint.h"
#include "macros.h"

s32 osAiSetFrequency(u32 freq) {
    register u32 dacRate;
#ifdef VERSION_CN
    register u32 bitRate;
#else
    register s32 bitRate;
#endif
    register float ftmp;
    ftmp = osViClock / (float) freq + .5f;

    dacRate = ftmp;

    if (dacRate < AI_MIN_DAC_RATE) {
        return -1;
    }

    bitRate = (dacRate / 66) & 0xff;
    if (bitRate > AI_MAX_BIT_RATE) {
        bitRate = AI_MAX_BIT_RATE;
    }

    IO_WRITE(AI_DACRATE_REG, dacRate - 1);
    IO_WRITE(AI_BITRATE_REG, bitRate - 1);
#ifndef VERSION_CN
    IO_WRITE(AI_CONTROL_REG, AI_CONTROL_DMA_ON);
#endif
    return osViClock / (s32) dacRate;
}

#if !defined(VERSION_SH) && !defined(VERSION_CN)
// put some extra jr $ra's down there please
UNUSED static void filler1(void) {
}

UNUSED static void filler2(void) {
}
#endif
#else
#include "libultra_internal.h"
#include "osAi.h"
#include "hardware.h"

extern s32 osViClock;

s32 osAiSetFrequency(u32 freq) {
    register u32 a1;
    register s32 a2;
    register float ftmp;
    ftmp = osViClock / (float) freq + .5f;

    a1 = ftmp;

    if (a1 < 0x84) {
        return -1;
    }

    a2 = (a1 / 66) & 0xff;
    if (a2 > 16) {
        a2 = 16;
    }

    HW_REG(AI_DACRATE_REG, u32) = a1 - 1;
    HW_REG(AI_BITRATE_REG, u32) = a2 - 1;
    HW_REG(AI_CONTROL_REG, u32) = 1; // enable dma
    return osViClock / (s32) a1;
}
#endif
