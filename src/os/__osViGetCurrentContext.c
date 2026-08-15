#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile); body via sm64's
   matched cn libultra */
#include "ique_compat.h"
#include "libultra_internal.h"

extern OSViContext *__osViCurr;

OSViContext *__osViGetCurrentContext() {
    return __osViCurr;
}
#else
#include "libultra_internal.h"

extern OSViContext* __osViCurr;

OSViContext* __osViGetCurrentContext() {
    return __osViCurr;
}
#endif
