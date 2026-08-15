#include "libultra_internal.h"

#ifdef VERSION_CN
/* iQue compiles this file with EGCS at -O0, where the switch spelling and
   nested pop-then-enqueue are byte-exact; the IDO if-chain below is not */
void osStartThread(OSThread* thread) {
    register u32 int_disabled;
    int_disabled = __osDisableInt();

    switch (thread->state) {
        case OS_STATE_WAITING:
            thread->state = OS_STATE_RUNNABLE;
            __osEnqueueThread(&__osRunQueue, thread);
            break;
        case OS_STATE_STOPPED:
            if (thread->queue == NULL || thread->queue == &__osRunQueue) {
                thread->state = OS_STATE_RUNNABLE;

                __osEnqueueThread(&__osRunQueue, thread);
            } else {
                thread->state = OS_STATE_WAITING;
                __osEnqueueThread(thread->queue, thread);
                __osEnqueueThread(&__osRunQueue, __osPopThread(thread->queue));
            }
            break;
    }

    if (__osRunningThread == NULL) {
        __osDispatchThread();
    } else {
        if (__osRunningThread->priority < __osRunQueue->priority) {
            __osRunningThread->state = OS_STATE_RUNNABLE;
            __osEnqueueAndYield(&__osRunQueue);
        }
    }

    __osRestoreInt(int_disabled);
}
#else
void osStartThread(OSThread* thread) {
    register u32 int_disabled;
    register uintptr_t state;
    int_disabled = __osDisableInt();
    state = thread->state;

    if (state != OS_STATE_STOPPED) {
        if (state == OS_STATE_WAITING) {
            do {
            } while (0);
            thread->state = OS_STATE_RUNNABLE;
            __osEnqueueThread(&__osRunQueue, thread);
        }
    } else {
        if (thread->queue == NULL || thread->queue == &__osRunQueue) {
            thread->state = OS_STATE_RUNNABLE;

            __osEnqueueThread(&__osRunQueue, thread);
        } else {
            thread->state = OS_STATE_WAITING;
            __osEnqueueThread(thread->queue, thread);
            state = (uintptr_t) __osPopThread(thread->queue);
            __osEnqueueThread(&__osRunQueue, (OSThread*) state);
        }
    }
    if (__osRunningThread == NULL) {
        __osDispatchThread();
    } else {
        if (__osRunningThread->priority < __osRunQueue->priority) {
            __osRunningThread->state = OS_STATE_RUNNABLE;
            __osEnqueueAndYield(&__osRunQueue);
        }
    }
    __osRestoreInt(int_disabled);
}
#endif
