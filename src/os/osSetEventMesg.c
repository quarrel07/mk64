#ifdef VERSION_CN
/* iQue compiles this file with EGCS at -O0; body via sm64's matched cn
   libultra (adds the prenmi resend + __osPreNMI latch) */
extern int __osShutdown;
#ifndef TRUE
#define TRUE 1
#endif
#include "libultra_internal.h"
#include "osint.h"

__OSEventState __osEventStateTab[OS_NUM_EVENTS];

#ifdef VERSION_CN
u32 __osPreNMI = 0;
#endif

void osSetEventMesg(OSEvent e, OSMesgQueue *mq, OSMesg msg) {
    register u32 int_disabled;
    __OSEventState *msgs;
    int_disabled = __osDisableInt();

    msgs = __osEventStateTab + e;
    msgs->messageQueue = mq;
    msgs->message = msg;

#ifdef VERSION_CN
    if (e == OS_EVENT_PRENMI) {
        if (__osShutdown && !__osPreNMI) {
            osSendMesg(mq, msg, OS_MESG_NOBLOCK);
        }

        __osPreNMI = TRUE;
    }
#endif

    __osRestoreInt(int_disabled);
}
#else
#include "libultra_internal.h"

typedef struct OSEventMessageStruct_0_s {
    OSMesgQueue* queue;
    OSMesg msg;
} OSEventMessageStruct_0;

OSEventMessageStruct_0 __osEventStateTab[16];

void osSetEventMesg(OSEvent e, OSMesgQueue* mq, OSMesg msg) {
    register u32 int_disabled;
    OSEventMessageStruct_0* msgs;
    int_disabled = __osDisableInt();
    msgs = __osEventStateTab + e;
    msgs->queue = mq;
    msgs->msg = msg;
    __osRestoreInt(int_disabled);
}
#endif
