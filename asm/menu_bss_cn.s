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
#   gMenuItems: 0x174 (ours 0x500; __osPfsInodeCache follows at +0x174, which
#                      the cart's own bcopy length at 0x8019386C fixes at 0x100,
#                      and __osEventStateTab then follows at 0x8019396C)

.include "macros.inc"

.ifdef VERSION_CN

.section .bss

.align 3
# iQue-ADDED: a second full-size menu-item array their rewritten finder
# family iterates (base 0x801922c0 and bound +0x500 read directly from the
# finders' code at cart 0xAA880-0xAA970; no matched code references it).
# gSaveData follows at +0x6F0, cart-measured.
.global gMenuItemsCN
gMenuItemsCN: .space 0x500
# The old 0x1F0 pad here decomposes exactly (2026-08-14 symaddr profile):
# __osThreadSave 0x801927C0 (OSThread, 0x1B0) + __osContPifRam 0x80192970
# (OSPifRam, 0x40) abut gSaveData with zero slack. Both arrive as commons
# (exception handler asm / osContInit's common group) and resolve here.
.global __osThreadSave
__osThreadSave: .space 0x1b0
.global __osContPifRam
__osContPifRam: .space 0x40
.global gSaveData
gSaveData: .space 0x200
# 0x80192BB0 - the cart's __osCurrentHandle[1] word literally holds this
# address, and five byte-stores in osInitialize land on +4..+8. 0x74 (the
# symtab size, not the map's 0x78 stride) closes on D_8018E768 exactly.
.global __Dom2SpeedParam
__Dom2SpeedParam: .space 0x74
.global D_8018E768
D_8018E768: .space 0x40
.global gControllerPak1FileHandle
gControllerPak1FileHandle: .space 0x68
# 0x80192CCC - three lui/daddiu sites, plus an interior one at +8 that already
# agrees. Moved here from 0x8019355C.
.global D_8018E0E8
D_8018E0E8: .space 0x28
.global pfsState
pfsState: .space 0x200
.global sMenuTextureMap
sMenuTextureMap: .space 0x640
.global D_8018E810
D_8018E810: .space 0x28
# 0x8019355C - unclaimed. D_8018E0E8 used to sit here; it measures at
# 0x80192CCC instead, and nothing in the ROM resolves into this run.
.space 0x44
# 0x801935A0 - four sites across __osPiCreateAccessQueue.o and
# osCreatePiManager.o. .data in our build, bss on cart.
.global gOsPiMessageQueue
gOsPiMessageQueue: .space 0x18
# 0x801935B8 - the cart's __osCurrentHandle[0] word holds this address, and
# 0x801935B8 + 0x74 = D_8018E7E8, which already agrees (5 votes).
.global __Dom1SpeedParam
__Dom1SpeedParam: .space 0x74
.global D_8018E7E8
D_8018E7E8: .space 0x28
.space 0x4
# 0x80193658 - osTimer.o(.data)'s only relocation is __osTimerList =
# &__osBaseTimer, and the cart's word there is this address. 8-aligned as
# OSTimer needs; 0x80193658 + 0x20 = pfsError (4 votes).
.global __osBaseTimer
__osBaseTimer: .space 0x20
.global pfsError
pfsError: .space 0x40
# 0x801936B8 (1 vote) - arrives as a common from osContInit.o
.global __osEepromTimer
__osEepromTimer: .space 0x20
.global gCurrentTransitionTime
gCurrentTransitionTime: .space 0x10
# 0x801936E8 (4 votes)
.global D_8018E7E0
D_8018E7E0: .space 0x4
.global D_8018DEE0
D_8018DEE0: .space 0xc
.global gMenuItems
# The old 0x274 was still two objects: gMenuItems (0x174) followed by the pfs
# inode cache. contpfs.o's two bcopy call sites in the cart build 0x8019386C
# with a2 = 0x100, so the run 0x8019386C..0x8019396C is one 0x100 object and
# __osEventStateTab then starts at 0x8019396C as before. The 0x40 after the
# event table up to D_8018E060 stays pad until an anchor claims it.
gMenuItems: .space 0x174
# 0x8019386C - two sites in __osPfsRWInode. Only 4-aligned, so no .align may
# be emitted here; contpfs.c's ALIGNED(0x8) is not what iQue built.
.global __osPfsInodeCache
__osPfsInodeCache: .space 0x100
.global __osEventStateTab
__osEventStateTab: .space 0xC0
# v4 places D_8018E060 and the pak-2 handle 8 earlier, with the slack
# returned after the handle; the block's total and every neighbor are
# unchanged (read from the callers' address constants in both carts)
.ifdef VERSION_CN_V5
.space 0x40
.else
.space 0x38
.endif
.global D_8018E060
D_8018E060: .space 0x80
.space 0x8
.global gControllerPak2FileHandle
gControllerPak2FileHandle: .space 0x68
.ifdef VERSION_CN_V5
.space 0x4
.else
.space 0xC
.endif
# 0x80193B60 - four base sites across pfsisplug.o and pfsgetstatus.o, plus one
# at +0x3C (the OSPifRam status byte) that independently fixes the 0x40 extent.
.global __osPfsPifRam
__osPfsPifRam: .space 0x40
.global D_8018E840
D_8018E840: .space 0x10
# 0x80193BB0 (2026-08-14 profile): the eeprom timer queue fills the old
# 0x18 pad before gTransitionDuration exactly (osContInit's common
# resolves here)
.global __osEepromTimerQ
__osEepromTimerQ: .space 0x18
.global gTransitionDuration
gTransitionDuration: .space 0x14
# 0x80193BDC: the SI access queue abuts sMemoryPool (0x80193BF4) with
# zero slack (3 votes, no disagreement; the PI queue's conflicting vote
# is the known misattribution - it stays a pool common)
.global gOsSiMessageQueue
gOsSiMessageQueue: .space 0x18

.endif
