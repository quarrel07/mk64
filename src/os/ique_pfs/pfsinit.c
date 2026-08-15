#ifdef VERSION_CN
/* iQue's controller-pak layer is the 2.0L SDK revision compiled with
   EGCS -O2 (verbatim via decompals/ultralib; measured 100 percent on
   this file's functions unless noted in the Makefile) */
#include "PR/os_internal.h"
#include "PRinternal/controller.h"
#include "PRinternal/siint.h"

s32 osPfsInit(OSMesgQueue* queue, OSPfs* pfs, int channel) {
    s32 ret = 0;

    __osSiGetAccess();
    ret = __osPfsGetStatus(queue, channel);
    __osSiRelAccess();

    if (ret != 0) {
        return ret;
    }

    pfs->queue = queue;
    pfs->channel = channel;
    pfs->status = 0;
    pfs->activebank = -1;
    ERRCK(__osGetId(pfs));

    ret = osPfsChecker(pfs);
    pfs->status |= PFS_INITIALIZED;
    return ret;
}
#endif
