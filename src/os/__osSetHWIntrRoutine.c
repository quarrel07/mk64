#include "libultra_internal.h"

// Its not clear how big this array should be.
// In order for file alignment to be correct, it needs to be
// at least 5 but no more than 8. Beyond that its not clear
// what its size should be
#ifdef VERSION_CN
/* the cn exception handler owns the table (10 slots, in its .data) */
extern s32 (*__osHwIntTable[])(void);
#else
s32 (*__osHwIntTable[5])(void) = { NULL };
#endif
/* cn: no cart body and no callers - the cart's __osHwIntTable is all zeros
   in .data and nothing in the cart text ever writes it (the cn osInitialize
   does not register the 64DD handler; BB has no disk drive) */
#ifndef VERSION_CN
void __osSetHWIntrRoutine(OSHWIntr interrupt, s32 (*handler)(void)) {
    register u32 saveMask;
    saveMask = __osDisableInt();
    __osHwIntTable[interrupt] = handler;
    __osRestoreInt(saveMask);
}
#endif
