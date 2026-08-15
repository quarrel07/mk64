# handwritten - VERSION_CN only
# iQue's head block: the small-scalar (.scommon) members gathered at the
# START of main bss on the cart (0x800F3B50-0x800F3C10, the entry point's
# measured bss-clear start). Same technique as menu_bss_cn.s: real
# definitions override the gathered commons and the ld script places this
# object at the *(.scommon) point.
#
# Two symbol classes here:
# - menu_items scalars: v2-profile singles (1 vote each; the uniform-band
#   check grades the block)
# - the libultra timer/counter scalars (2026-08-14 symaddr profile, 2-6
#   votes each): __osBaseCounter heads the block at 0x800F3B50 and the
#   rest fill exactly the gaps the old roster left as "unobserved" -
#   sNumCountOverflows 3B6C, sLastHighestCount 3B78, __osViIntrCount 3B88,
#   __osCurrentTime 3BB0, sLastHighestCount2 3BD0, __osTimerCounter 3BF4,
#   sNumCountOverflows2 3C00. They arrive as COMMONs (osTimer compiles
#   without -fno-common; the trackers are asm-referenced only).
# Unanchored members (sMenuTextureBufferIndex, sMenuTextureEntries,
# D_8018E83C, sIntroModelTimer, D_8018D9D8/9, gTextColor,
# gGPPointsByCharacterId, D_8018ED91) sit in the remaining gaps
# best-effort; leftover gap space stays padding.
# PARKED: __osEepromTimerMsg measured 0x800F3BE8 (1 vote) but its [4]
# decl is 0x10 against 8 bytes of room - remeasure before wiring; it
# stays a gathered common. D_8018E7E0 also deliberately absent (its lone
# vote points past sMemoryPool).

.include "macros.inc"

.ifdef VERSION_CN

.section .bss

.align 2
# 0x800F3B50
.global __osBaseCounter
__osBaseCounter: .space 4
# 0x800F3B54
.global gControllerPak1NumFilesUsed
gControllerPak1NumFilesUsed: .space 4
.global gControllerPak1NumPagesFree
gControllerPak1NumPagesFree: .space 4
.global gSomeDLBuffer
gSomeDLBuffer: .space 4
.global sMenuTextureBufferIndex
sMenuTextureBufferIndex: .space 4
# 0x800F3B64
.global gCycleFlashMenu
gCycleFlashMenu: .space 4
.global sMenuTextureEntries
sMenuTextureEntries: .space 4
# 0x800F3B6C (profile, 2 votes)
.global sNumCountOverflows
sNumCountOverflows: .space 4
# 0x800F3B70
.global gTransitionType
gTransitionType: .space 5
.space 3
# 0x800F3B78 (profile, 2 votes)
.global sLastHighestCount
sLastHighestCount: .space 4
.global D_8018E83C
D_8018E83C: .space 4
# 0x800F3B80
.global sIntroModelTimer
sIntroModelTimer: .space 4
.global D_8018D9D8
D_8018D9D8: .space 1
.global D_8018D9D9
D_8018D9D9: .space 1
.global gTextColor
gTextColor: .space 1
.space 1
# 0x800F3B88 (profile, 3 votes)
.global __osViIntrCount
__osViIntrCount: .space 4
.space 4
# 0x800F3B90
.global D_8018E850
D_8018E850: .space 8
.global D_8018ED91
D_8018ED91: .space 1
.space 3
# 0x800F3B9C
.global gControllerPak1FileNote
gControllerPak1FileNote: .space 4
.global D_8018E838
D_8018E838: .space 4
.global sGPPointsCopy
sGPPointsCopy: .space 4
# 0x800F3BA8
.global gGPPointsByCharacterId
gGPPointsByCharacterId: .space 8
# 0x800F3BB0 (profile, 6 votes) - fills the old 0x10 gap exactly
.global __osCurrentTime
__osCurrentTime: .space 8
# 0x800F3BB8
.global sGfxPtr
sGfxPtr: .space 4
.space 0xc
# 0x800F3BC8
.global gControllerPak2FileNote
gControllerPak2FileNote: .space 4
.global D_8018ED90
D_8018ED90: .space 1
.space 3
# 0x800F3BD0 (profile, 3 votes)
.global sLastHighestCount2
sLastHighestCount2: .space 4
.space 4
# 0x800F3BD8
.global D_8018E858
D_8018E858: .space 8
.global gMenuCompressedBuffer
gMenuCompressedBuffer: .space 4
.space 0xc
# 0x800F3BF0
.global gControllerPak1MaxWriteableFiles
gControllerPak1MaxWriteableFiles: .space 4
# 0x800F3BF4 (profile, 6 votes)
.global __osTimerCounter
__osTimerCounter: .space 4
.global gNumD_8018E768Entries
gNumD_8018E768Entries: .space 4
.space 4
# 0x800F3C00 (profile, 3 votes)
.global sNumCountOverflows2
sNumCountOverflows2: .space 4
.space 4
# 0x800F3C08
.global gMenuTextureBuffer
gMenuTextureBuffer: .space 4
.global sTKMK00_LowResBuffer
sTKMK00_LowResBuffer: .space 4

.endif
