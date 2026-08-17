# handwritten - VERSION_CN only
# The PI manager's three objects, in the order the cart has them. They arrive
# as commons from osCreatePiManager.o, and ld decides a common block's internal
# order for itself, so they are written out here as real definitions instead -
# the same technique menu_bss_cn.s uses.
#
# Two reference sites fix the ends and the sizes fill the middle exactly:
# piMgrThread at 0x801910E0 plus its own 0x1B0 plus the stack's 0x1000 lands on
# 0x80192290, which is where piEventQueue is measured. Our own order puts the
# stack first and misses by 0x1000.

.include "macros.inc"

.ifdef VERSION_CN

.section .bss

.align 4

# 0x801910E0
.global piMgrThread
piMgrThread: .space 0x1b0
# 0x80191290
.global piMgrStack
piMgrStack: .space 0x1000
# 0x80192290
.global piEventQueue
piEventQueue: .space 0x18

.endif
