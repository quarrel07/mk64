#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile for the opt level); this
   arm is the byte-exact body, via sm64's matched cn libultra */
#include "libultra_internal.h"

extern u32 __osBbIsBb;

extern OSViContext *__osViNext;

void osViSetMode(OSViMode *mode) {
    register u32 int_disabled = __osDisableInt();
#ifdef VERSION_CN
    if (__osBbIsBb != 0) {
        mode->comRegs.ctrl &= ~0x2000;
    }
#endif
    __osViNext->modep = mode;
    __osViNext->unk00 = 1;
    __osViNext->features = __osViNext->modep->comRegs.ctrl;
    __osRestoreInt(int_disabled);
}
#else
#include "libultra_internal.h"

extern OSViContext* __osViNext;

void osViSetMode(OSViMode* mode) {
    register u32 int_disabled = __osDisableInt();
    __osViNext->modep = mode;
    __osViNext->unk00 = 1;
    __osViNext->features = __osViNext->modep->comRegs.ctrl;
    __osRestoreInt(int_disabled);
}
#endif
