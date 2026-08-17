#include "libultra_internal.h"

#define PIAccessQueueSize 2

#ifdef VERSION_CN
/* iQue keeps both of these in main bss, not in this object's .data:
   osPiMesgBuff at 0x801922B0 and gOsPiMessageQueue at 0x801935A0, both real
   definitions in asm. This file is built with -fno-common and EGCS emits the
   tentative definitions into .data, so they have to be externed rather than
   left to be overridden - and the 0x20 they occupy is the build stamp's slot. */
extern OSMesg osPiMesgBuff[PIAccessQueueSize];
extern OSMesgQueue gOsPiMessageQueue;
#else
OSMesg osPiMesgBuff[PIAccessQueueSize];
OSMesgQueue gOsPiMessageQueue;
#endif
u32 gOsPiAccessQueueCreated = 0;

void __osPiCreateAccessQueue(void) {
    gOsPiAccessQueueCreated = 1;
    osCreateMesgQueue(&gOsPiMessageQueue, &osPiMesgBuff[0], PIAccessQueueSize - 1);
    osSendMesg(&gOsPiMessageQueue, NULL, OS_MESG_NOBLOCK);
}

void __osPiGetAccess(void) {
    OSMesg sp1c;
    if (!gOsPiAccessQueueCreated) {
        __osPiCreateAccessQueue();
    }
    osRecvMesg(&gOsPiMessageQueue, &sp1c, OS_MESG_BLOCK);
}

void __osPiRelAccess(void) {
    osSendMesg(&gOsPiMessageQueue, NULL, OS_MESG_NOBLOCK);
}
