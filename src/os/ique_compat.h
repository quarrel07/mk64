#ifndef IQUE_COMPAT_H
#define IQUE_COMPAT_H

/* Shims for the VERSION_CN libultra arms ported from sm64's matched iQue
   sources: names their headers provide that this tree spells differently
   (or not at all). Macros only plus externs - nothing here changes codegen. */

#include <ultra64.h>
#include <PR/ique.h>

#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif

#ifndef VI_STATE_BLACK
#define VI_STATE_BLACK 0x20
#endif
#ifndef DEVICE_TYPE_INIT
#define DEVICE_TYPE_INIT 7
#endif
#ifndef M_TASK_FLAG2
#define M_TASK_FLAG2 4
#endif

/* sm64 uses this to pin iQue commons; our placements go through the linker
   script and asm def files instead */
#define FORCE_BSS

extern u32 __osShutdown;

/* iQue-only PI handles (gathered commons; defined in ique_globals.c) */
extern OSPiHandle __Dom1SpeedParam;
extern OSPiHandle __Dom2SpeedParam;
extern OSPiHandle __CartRomHandle;

#endif
