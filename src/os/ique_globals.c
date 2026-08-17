#include <ultra64.h>
#include "ique_compat.h"

/* iQue-only PI handle instances, referenced by the cn arms of osInitialize /
   osCreatePiManager (sm64's cn libultra keeps them as gathered commons).
   Deliberately plain definitions: they resolve against real defs or gather
   into the common pool until the data profile pins their cart addresses. */
#ifdef VERSION_CN
/* __Dom1SpeedParam (0x801935B8) and __Dom2SpeedParam (0x80192BB0) are real
   definitions in asm/menu_bss_cn.s now - the cart's own __osCurrentHandle words
   hold those two addresses, so they are not guesses. __CartRomHandle has no
   reference anywhere in the ROM, so its address cannot be measured; it stays
   here and stays parked past the memory pool. */
OSPiHandle __CartRomHandle;

/* the count-overflow trackers for osGetCount/__osSetCompare live in the
   head bss block on cart - real defs in asm/menu_sbss_cn.s */

/* __osThreadSave's real def lives in asm/menu_bss_cn.s (cart 0x801927C0,
   right after gMenuItemsCN) */
#endif
