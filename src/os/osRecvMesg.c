#include "libultra_internal.h"

#ifdef VERSION_CN
/* iQue compiles this file with EGCS at -O0; the explicit else arm and the
   nested pop-then-start call are byte-exact there */
s32 osRecvMesg(OSMesgQueue* mq, OSMesg* msg, s32 flag) {
    register u32 int_disabled;
    int_disabled = __osDisableInt();

    while (!mq->validCount) {
        if (!flag) {
            __osRestoreInt(int_disabled);
            return -1;
        } else {
            __osRunningThread->state = OS_STATE_WAITING;
            __osEnqueueAndYield(&mq->mtqueue);
        }
    }

    if (msg != NULL) {
        *msg = *(mq->first + mq->msg);
    }

    mq->first = (mq->first + 1) % mq->msgCount;
    mq->validCount--;

    if (mq->fullqueue->next != NULL) {
        osStartThread(__osPopThread(&mq->fullqueue));
    }

    __osRestoreInt(int_disabled);
    return 0;
}
#else
s32 osRecvMesg(OSMesgQueue* mq, OSMesg* msg, s32 flag) {
    register u32 int_disabled;
    register OSThread* thread;
    int_disabled = __osDisableInt();

    while (!mq->validCount) {
        if (!flag) {
            __osRestoreInt(int_disabled);
            return -1;
        }
        __osRunningThread->state = OS_STATE_WAITING;
        __osEnqueueAndYield(&mq->mtqueue);
    }

    if (msg != NULL) {
        *msg = *(mq->first + mq->msg);
    }

    mq->first = (mq->first + 1) % mq->msgCount;
    mq->validCount--;

    if (mq->fullqueue->next != NULL) {
        thread = __osPopThread(&mq->fullqueue);
        osStartThread(thread);
    }

    __osRestoreInt(int_disabled);
    return 0;
}
#endif
