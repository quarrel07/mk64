# handwritten - VERSION_CN only
# iQue's head block: the small-scalar (.scommon) members of menu_items,
# gathered at the START of main bss on the cart (0x800F3B54-0x800F3C10,
# right at the entry point's measured bss-clear start). Same technique as
# menu_bss_cn.s: real definitions override the EGCS commons and the ld
# script places this object at the *(.scommon) point. Anchored addresses
# are v2-profile singles (1 vote each - the uniform-band check grades the
# result); unanchored members sit in the measured gaps best-effort, and
# leftover gap space stays padding (unobserved variables).
# D_8018E7E0 is deliberately NOT here (parked: its lone vote points past
# sMemoryPool); it stays a common.

.include "macros.inc"

.ifdef VERSION_CN

.section .bss

.align 2
.global gControllerPak1NumFilesUsed
gControllerPak1NumFilesUsed: .space 4
.global gControllerPak1NumPagesFree
gControllerPak1NumPagesFree: .space 4
.global gSomeDLBuffer
gSomeDLBuffer: .space 4
.global sMenuTextureBufferIndex
sMenuTextureBufferIndex: .space 4
.global gCycleFlashMenu
gCycleFlashMenu: .space 4
.global sMenuTextureEntries
sMenuTextureEntries: .space 4
.global D_8018E83C
D_8018E83C: .space 4
.global gTransitionType
gTransitionType: .space 5
.space 3
.global gGPPointsByCharacterId
gGPPointsByCharacterId: .space 8
.global sIntroModelTimer
sIntroModelTimer: .space 4
.global D_8018D9D8
D_8018D9D8: .space 1
.global D_8018D9D9
D_8018D9D9: .space 1
.global gTextColor
gTextColor: .space 1
.space 9
.global D_8018E850
D_8018E850: .space 8
.global D_8018ED91
D_8018ED91: .space 1
.space 3
.global gControllerPak1FileNote
gControllerPak1FileNote: .space 4
.global D_8018E838
D_8018E838: .space 4
.global sGPPointsCopy
sGPPointsCopy: .space 4
.space 0x10
.global sGfxPtr
sGfxPtr: .space 4
.space 0xc
.global gControllerPak2FileNote
gControllerPak2FileNote: .space 4
.global D_8018ED90
D_8018ED90: .space 1
.space 0xb
.global D_8018E858
D_8018E858: .space 8
.global gMenuCompressedBuffer
gMenuCompressedBuffer: .space 4
.space 0xc
.global gControllerPak1MaxWriteableFiles
gControllerPak1MaxWriteableFiles: .space 4
.space 4
.global gNumD_8018E768Entries
gNumD_8018E768Entries: .space 4
.space 0xc
.global gMenuTextureBuffer
gMenuTextureBuffer: .space 4
.global sTKMK00_LowResBuffer
sTKMK00_LowResBuffer: .space 4

.endif
