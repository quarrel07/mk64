# iQue body, transcribed from the cart (0x800D3320): the hand-scheduled
# sibling of the asm guMtxF2L - unpacks the 16.16 fixed rows and scales by
# 1/65536 (0x37800000). The C counterpart is cn-excluded in guMtxF2L.c.
.set noat
.set noreorder
.include "macros.inc"
.ifdef VERSION_CN
.section .text, "ax"
.balign 32
glabel guMtxL2F
    lui   $at, 0x3780
    mtc1  $at, $f0
    lui   $t9, 0xffff
    addiu $t8, $a1, 0x20
.Lloop:
    lw    $t0, ($a1)
    lw    $t1, 0x20($a1)
    and   $t2, $t0, $t9
    srl   $t3, $t1, 16
    or    $t4, $t2, $t3
    sll   $t5, $t0, 16
    andi  $t6, $t1, 0xffff
    or    $t7, $t5, $t6
    mtc1  $t4, $f4
    cvt.s.w $f6, $f4
    mul.s $f8, $f6, $f0
    mtc1  $t7, $f10
    cvt.s.w $f16, $f10
    mul.s $f18, $f16, $f0
    swc1  $f8, ($a0)
    swc1  $f18, 4($a0)
    addiu $a1, $a1, 4
    bne   $a1, $t8, .Lloop
     addiu $a0, $a0, 8
    jr    $ra
     nop
.endif
