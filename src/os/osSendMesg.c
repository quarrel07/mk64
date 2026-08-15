#include "libultra_internal.h"

#ifdef VERSION_CN
/* iQue compiles this file with EGCS at -O0; the natural spellings below are
   byte-exact there, where the IDO-matched temps in the #else arm are not */
s32 osSendMesg(OSMesgQueue* mq, OSMesg msg, s32 flag) {
    register u32 int_disabled;
    register s32 index;
    int_disabled = __osDisableInt();

    while (MQ_IS_FULL(mq)) {
        if (flag == OS_MESG_BLOCK) {
            __osRunningThread->state = 8;
            __osEnqueueAndYield(&mq->fullqueue);
        } else {
            __osRestoreInt(int_disabled);
            return -1;
        }
    }

    index = (mq->first + mq->validCount) % mq->msgCount;
    mq->msg[index] = msg;
    mq->validCount++;

    if (mq->mtqueue->next != NULL) {
        osStartThread(__osPopThread(&mq->mtqueue));
    }

    __osRestoreInt(int_disabled);
    return 0;
}
#else
s32 osSendMesg(OSMesgQueue* mq, OSMesg msg, s32 flag) {
    register u32 int_disabled;
    register s32 index;
    register OSThread* s2;
    int_disabled = __osDisableInt();

    while (mq->validCount >= mq->msgCount) {
        if (flag == OS_MESG_BLOCK) {
            __osRunningThread->state = 8;
            __osEnqueueAndYield(&mq->fullqueue);
        } else {
            __osRestoreInt(int_disabled);
            return -1;
        }
    }

    index = (mq->first + mq->validCount) % mq->msgCount;
    mq->msg[index] = msg;
    mq->validCount++;

    if (mq->mtqueue->next != NULL) {
        s2 = __osPopThread(&mq->mtqueue);
        osStartThread(s2);
    }

    __osRestoreInt(int_disabled);
    return 0;
}
#endif
