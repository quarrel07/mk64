# handwritten - VERSION_CN only
# The cart carries an ASCII libultra build stamp in the middle of the os .data
# chain that neither N64 cart has and that no object in this tree emits. It is
# 26 characters at 0x800E8650, NUL-terminated and zero-padded to 0x20, and the
# next 0x10 boundary is osInitialize.o's .data (osClockRate, 0x800E8670, which
# already agrees). Nothing in the ROM references the address - a scan of every
# %hi/%lo pair in the cart finds no target in 0x800E8648..0x800E866F and the
# raw word 0x800E8650 appears nowhere - so the label below is arbitrary. The
# real libultra symbol name is not recoverable from the ROM.
#
# This object is size-neutral only as part of the whole cluster: it is paid for
# by __osPiCreateAccessQueue.o(.data) shrinking 0x30 -> 0x10 and by mk64.ld
# dropping its ". += 0x10" filler. Landing it on its own grows .main by 0x20,
# which moves ADDR(.main.noload) and the whole menu block with it.

.include "macros.inc"

# v5 only: the v4 image has no stamp and no padding in its place - its
# .data chain runs straight from the access queue into osInitialize's
# (measured: v4's osClockRate sits exactly 0x20 below v5's, and the
# symbol table read out of v4's own code puts every earlier .data symbol
# at the v5 position). The v4 libultra predates the stamp; the string is
# dated 02/24/04 and the game shipped 12/03.
.ifdef VERSION_CN_V5

.section .data

.align 4

# 0x800E8650
D_CN_800E8650:
    .asciz "libultra 02/24/04 14:07:48"
    .space 5

.endif
