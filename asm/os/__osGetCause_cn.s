# iQue body, transcribed from the cart (0x800D2CC0): standard libultra
# Cause read, absent from the retail mk64 link. Called by the cn osInitialize
# (interrupt-pending hang check).
.set noat
.set noreorder
.include "macros.inc"
.ifdef VERSION_CN
.section .text, "ax"
.balign 16
glabel __osGetCause
    mfc0  $v0, $13
    jr    $ra
     nop
.endif
