# iQue body, transcribed from the cart (0x800D2D00): standard libultra
# WatchLo write, absent from the retail mk64 link. Called by the cn
# osInitialize (watchpoint at 0x04900000).
.set noat
.set noreorder
.include "macros.inc"
.ifdef VERSION_CN
.section .text, "ax"
.balign 16
glabel __osSetWatchLo
    mtc0  $a0, $18
    nop
    jr    $ra
     nop
.endif
