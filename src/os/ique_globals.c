#include <ultra64.h>
#include "ique_compat.h"

/* iQue-only PI handle instances, referenced by the cn arms of osInitialize /
   osCreatePiManager (sm64's cn libultra keeps them as gathered commons).
   Deliberately plain definitions: they resolve against real defs or gather
   into the common pool until the data profile pins their cart addresses. */
#ifdef VERSION_CN
OSPiHandle __Dom1SpeedParam;
OSPiHandle __Dom2SpeedParam;
OSPiHandle __CartRomHandle;
#endif
