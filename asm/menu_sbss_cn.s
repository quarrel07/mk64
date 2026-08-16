# handwritten - VERSION_CN only
# iQue's head block: the small scalars gathered at the very START of main bss
# on the cart, 0x800F3B50 through 0x800F3C20, where gControllers begins. Real
# definitions here override the gathered commons and the ld script places this
# object first in the segment, so nothing may precede it.
#
# Every address below is measured, not guessed. With the ROM's .text finally
# sitting at the cart's own offsets, each %hi/%lo pair in our code can be read
# against the very same word in the cart, which gives the cart's address for
# whatever that pair refers to. The vote count on each line is how many
# independent reference sites agree; the whole block is covered by two or more
# except the three noted.
#
# The block is 0xD0 bytes. The last 0x10 is unclaimed - no reference in the ROM
# resolves into it.
#
# Four members that used to sit here have been taken out because the same
# measurement puts them elsewhere: sIntroModelTimer at 0x8018ABD8, and
# D_8018E83C / D_8018E850 / D_8018E858 with no site referring to them at all.
# They go back to being gathered commons until they are placed.

.include "macros.inc"

.ifdef VERSION_CN

.section .bss

.align 2

# 0x800F3B50
.global __osBaseCounter
__osBaseCounter: .space 4                          # 4 votes
.global gControllerPak1NumFilesUsed
gControllerPak1NumFilesUsed: .space 4              # 8
.global gControllerPak1NumPagesFree
gControllerPak1NumPagesFree: .space 4              # 17
.global gSomeDLBuffer
gSomeDLBuffer: .space 4                            # 10
# 0x800F3B60
.global sMenuTextureEntries
sMenuTextureEntries: .space 4                      # 16
.global gCycleFlashMenu
gCycleFlashMenu: .space 4                          # 4
.global sMenuTextureBufferIndex
sMenuTextureBufferIndex: .space 4                  # 21
.global sNumCountOverflows
sNumCountOverflows: .space 4                       # 2
# 0x800F3B70
.global gTransitionType
gTransitionType: .space 8                          # 4
.global sLastHighestCount
sLastHighestCount: .space 8                        # 2
# 0x800F3B80
.global gGPPointsByCharacterId
gGPPointsByCharacterId: .space 8                   # 1 vote
.global __osViIntrCount
__osViIntrCount: .space 16                         # 3
# 0x800F3B98
.global D_8018ED91
D_8018ED91: .space 4                               # 4
.global gControllerPak1FileNote
gControllerPak1FileNote: .space 4                  # 10
.global D_8018E838
D_8018E838: .space 4                               # 1 vote
.global sGPPointsCopy
sGPPointsCopy: .space 4                            # 7
# 0x800F3BA8
.global __osMaxControllers
__osMaxControllers: .space 8                       # 14
.global __osCurrentTime
__osCurrentTime: .space 8                          # 6
# 0x800F3BB8
.global sGfxPtr
sGfxPtr: .space 4                                  # 10
.global D_8018D9D8
D_8018D9D8: .space 4                               # 15
.global gCharacterIdByGPOverallRank
gCharacterIdByGPOverallRank: .space 8              # 3
# 0x800F3BC8
.global gControllerPak2FileNote
gControllerPak2FileNote: .space 4                  # 4
.global D_8018ED90
D_8018ED90: .space 4                               # 4
.global sLastHighestCount2
sLastHighestCount2: .space 16                      # 3
# 0x800F3BE0
.global gMenuCompressedBuffer
gMenuCompressedBuffer: .space 4                    # 32
.global __osContLastCmd
__osContLastCmd: .space 4                          # 5
.global __osEepromTimerMsg
__osEepromTimerMsg: .space 8                       # 2 - the cart gives it 8
                                                   # bytes where our OSMesg[4]
                                                   # declaration wants 0x10
# 0x800F3BF0
.global gControllerPak1MaxWriteableFiles
gControllerPak1MaxWriteableFiles: .space 4         # 8
.global __osTimerCounter
__osTimerCounter: .space 4                         # 6
.global gNumD_8018E768Entries
gNumD_8018E768Entries: .space 4                    # 4
.global D_8018D9D9
D_8018D9D9: .space 4                               # 3
# 0x800F3C00
.global sNumCountOverflows2
sNumCountOverflows2: .space 4                      # 3
.global gTextColor
gTextColor: .space 4                               # 2
.global gMenuTextureBuffer
gMenuTextureBuffer: .space 4                       # 24
.global sTKMK00_LowResBuffer
sTKMK00_LowResBuffer: .space 4                     # 10
# 0x800F3C10 - unclaimed, up to gControllers at 0x800F3C20
.space 0x10

.endif
