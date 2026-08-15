#include "libultra_internal.h"

void __osCleanupThread(void);

// Don't warn about pointer->u64 cast
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wpointer-to-int-cast"

#ifdef VERSION_CN
/* iQue compiles this file with EGCS at -O0, where the non-register mask
   local is byte-exact and the IDO temp spelling below is not */
void osCreateThread(OSThread* thread, OSId id, void (*entry)(void*), void* arg, void* sp, OSPri pri) {
    register u32 saveMask;
    u32 mask;

    thread->id = id;
    thread->priority = pri;
    thread->next = NULL;
    thread->queue = NULL;
    thread->context.pc = (u32) entry;
    thread->context.a0 = (u64) arg;
    thread->context.sp = (u64) sp - 16;
    thread->context.ra = (u64) __osCleanupThread;

    mask = OS_IM_ALL;
    /* -O0 keeps every read of `mask`: the cart computes sr FROM the variable
       (andi/ori), so the constant-folded 65283 spelling cannot match */
    thread->context.sr = (mask & 0xFF01) | 2;
    thread->context.rcp = (mask & 0x3f0000) >> 16;
    thread->context.fpcsr = (u32) 0x01000800;
    thread->fp = 0;
    thread->state = OS_STATE_STOPPED;
    thread->flags = 0;
    saveMask = __osDisableInt();
    thread->tlnext = __osActiveQueue;

    __osActiveQueue = thread;
    __osRestoreInt(saveMask);
}
#else
void osCreateThread(OSThread* thread, OSId id, void (*entry)(void*), void* arg, void* sp, OSPri pri) {
    register u32 int_disabled;
    u32 tmp;
    thread->id = id;
    thread->priority = pri;
    thread->next = NULL;
    thread->queue = NULL;
    thread->context.pc = (u32) entry;
    thread->context.a0 = (u64) arg;
    thread->context.sp = (u64) sp - 16;
    thread->context.ra = (u64) __osCleanupThread;
    tmp = OS_IM_ALL;
    thread->context.sr = 65283;
    thread->context.rcp = (tmp & 0x3f0000) >> 16;
    thread->context.fpcsr = (u32) 0x01000800;
    thread->fp = 0;
    thread->state = OS_STATE_STOPPED;
    thread->flags = 0;
    int_disabled = __osDisableInt();
    thread->tlnext = __osActiveQueue;

    __osActiveQueue = thread;
    __osRestoreInt(int_disabled);
}
#endif

#pragma GCC diagnostic pop
