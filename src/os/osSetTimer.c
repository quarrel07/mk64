#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile for the opt level); this
   arm is the byte-exact body, via sm64's matched cn libultra */
#include "libultra_internal.h"
#include "osint.h"

#pragma GCC diagnostic ignored "-Wunused-but-set-variable"

u32 osSetTimer(OSTimer *timer, OSTime countdown, OSTime interval, OSMesgQueue *mq, OSMesg msg) {
    OSTime time;
#ifdef VERSION_CN
    OSTimer *next;
    u32 count;
    u32 remaining;
    u32 prevInt;
#endif

    timer->next = NULL;
    timer->prev = NULL;
    timer->interval = interval;
    timer->remaining = countdown != 0 ? countdown : interval;
    timer->mq = mq;
    timer->msg = msg;

#ifdef VERSION_CN
    prevInt = __osDisableInt();
    if (__osTimerList->next == __osTimerList) {
    } else {
        next = __osTimerList->next;
        count = osGetCount();
        remaining = count - __osTimerCounter;

        if (remaining < next->remaining) {
            next->remaining -= remaining;
        } else {
            next->remaining = 1;
        }
    }

    time = __osInsertTimer(timer);
    __osSetTimerIntr(__osTimerList->next->remaining);

    __osRestoreInt(prevInt);
#else
    time = __osInsertTimer(timer);
    if (__osTimerList->next == timer) {
        __osSetTimerIntr(time);
    }
#endif

    return 0;
}
#else
#include "libultra_internal.h"

extern OSTimer* __osTimerList;
extern u64 __osInsertTimer(OSTimer*);

u32 osSetTimer(OSTimer* a0, OSTime a1, u64 a2, OSMesgQueue* a3, OSMesg a4) {
    u64 sp18;
    a0->next = NULL;
    a0->prev = NULL;
    a0->interval = a2;
    if (a1 != 0) {
        a0->remaining = a1;
    } else {
        a0->remaining = a2;
    }
    a0->mq = a3;
    a0->msg = a4;
    sp18 = __osInsertTimer(a0);
    if (__osTimerList->next == a0) {
        __osSetTimerIntr(sp18);
    }
    return 0;
}
#endif
