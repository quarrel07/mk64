#ifdef VERSION_CN
/* iQue-only on this cart (body via sm64's matched cn libultra) */
#include "libultra_internal.h"
#include "PR/os.h"

void __osSetGlobalIntMask(s32 mask) {
    register u32 saveMask = __osDisableInt();
    __OSGlobalIntMask |= mask;
    __osRestoreInt(saveMask);
}
#endif
