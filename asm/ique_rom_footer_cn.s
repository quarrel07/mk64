# handwritten - VERSION_CN only
# The last 0x50 bytes of the iQue image, transcribed from the cart.
#
# It is a run of RAM addresses and sizes closed by the ASCII tag "CAM", sitting
# after every segment with nothing but zero between. No cart code reads it and
# no address in it appears anywhere else in the image, so it is written by
# iQue's packaging rather than by the game, and it is kept as it stands.

.include "macros.inc"

.section .data

.balign 16

glabel gIqueRomFooter
.word 0x00000000, 0x00000000, 0x00000000, 0x807C0000
.word 0x00000200, 0x00000000, 0x00000000, 0x00000000
.word 0x00000000, 0x807C4000, 0x807CC000, 0x00000000
.word 0x00000000, 0x00008000, 0xB0000000, 0x00000001
.word 0x00400000, 0x00000000, 0x00000000, 0x43414D00
