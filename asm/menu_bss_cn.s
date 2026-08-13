# handwritten - VERSION_CN only
# iQue's linker laid out menu_items' COMMON block in a different order with
# different sizes for two symbols. Real .bss definitions here override the
# EGCS commons (ld resolves a common against a same-name definition), and the
# ld script places this object right after *(COMMON), reproducing the cart's
# block byte for byte. Every address and size below is measured from the v3
# symaddr profile; the .space pads between symbols are the measured gaps
# (unobserved small variables to be named later).
#
#   gSaveData 0x801929B0 .. gTransitionDuration 0x80193BC8 on the cart.
#
# Two deliberate size changes vs our C definitions, both cart-measured:
#   D_8018DEE0: 0xC   (ours 0x180; gMenuItems follows at +0xC on cart)
#   gMenuItems: 0x374 (ours 0x500; D_8018E060 follows at +0x374 on cart)

.include "macros.inc"

.ifdef VERSION_CN

.section .bss

.align 3
.global gSaveData
gSaveData: .space 0x200
.space 0x74
.global D_8018E768
D_8018E768: .space 0x40
.global gControllerPak1FileHandle
gControllerPak1FileHandle: .space 0x68
.space 0x28
.global pfsState
pfsState: .space 0x200
.global sMenuTextureMap
sMenuTextureMap: .space 0x640
.global D_8018E810
D_8018E810: .space 0x28
.global D_8018E0E8
D_8018E0E8: .space 0x28
.space 0xa8
.global D_8018E7E8
D_8018E7E8: .space 0x28
.space 0x24
.global pfsError
pfsError: .space 0x40
.space 0x20
.global gCurrentTransitionTime
gCurrentTransitionTime: .space 0x10
.space 0x4
.global D_8018DEE0
D_8018DEE0: .space 0xc
.global gMenuItems
gMenuItems: .space 0x374
.global D_8018E060
D_8018E060: .space 0x80
.space 0x8
.global gControllerPak2FileHandle
gControllerPak2FileHandle: .space 0x68
.space 0x44
.global D_8018E840
D_8018E840: .space 0x10
.space 0x18
.global gTransitionDuration
gTransitionDuration: .space 0x14

.endif
