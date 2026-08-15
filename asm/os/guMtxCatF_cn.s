# iQue body, transcribed from the cart (0x800D33A0): rewritten 4x4 multiply.
# Pointer-walked rows/columns into an sp temp, fully unrolled dot product,
# then a block copy-out through 15 integer registers with the last element
# stored straight from the still-live $f8. The C counterpart (and the unused
# guMtxXFMF/guMtxXFML pair, absent from the cart) is cn-excluded.
.set noat
.set noreorder
.include "macros.inc"
.ifdef VERSION_CN
.section .text, "ax"
.balign 32
glabel guMtxCatF
    addiu $sp, $sp, -0x40
    addiu $v0, $a0, 0x40
    addiu $v1, $a1, 0x10
    addu  $t2, $sp, $zero
.Louter:
    addu  $a3, $a1, $zero
.Linner:
    lwc1  $f4, ($a0)
    lwc1  $f6, ($a3)
    mul.s $f8, $f4, $f6
    lwc1  $f10, 4($a0)
    lwc1  $f16, 0x10($a3)
    mul.s $f18, $f10, $f16
    add.s $f8, $f8, $f18
    lwc1  $f4, 8($a0)
    lwc1  $f6, 0x20($a3)
    mul.s $f18, $f4, $f6
    add.s $f8, $f8, $f18
    lwc1  $f10, 0xc($a0)
    lwc1  $f16, 0x30($a3)
    mul.s $f18, $f10, $f16
    add.s $f8, $f8, $f18
    swc1  $f8, ($t2)
    addiu $a3, $a3, 4
    bne   $a3, $v1, .Linner
     addiu $t2, $t2, 4
    addiu $a0, $a0, 0x10
    bne   $a0, $v0, .Louter
     nop
    swc1  $f8, 0x3c($a2)
    lw    $t0, ($sp)
    lw    $t1, 4($sp)
    lw    $t2, 8($sp)
    lw    $t3, 0xc($sp)
    lw    $t4, 0x10($sp)
    lw    $t5, 0x14($sp)
    lw    $t6, 0x18($sp)
    lw    $t7, 0x1c($sp)
    lw    $t8, 0x20($sp)
    lw    $t9, 0x24($sp)
    lw    $v0, 0x28($sp)
    lw    $v1, 0x2c($sp)
    lw    $a0, 0x30($sp)
    lw    $a1, 0x34($sp)
    lw    $a3, 0x38($sp)
    sw    $t0, ($a2)
    sw    $t1, 4($a2)
    sw    $t2, 8($a2)
    sw    $t3, 0xc($a2)
    sw    $t4, 0x10($a2)
    sw    $t5, 0x14($a2)
    sw    $t6, 0x18($a2)
    sw    $t7, 0x1c($a2)
    sw    $t8, 0x20($a2)
    sw    $t9, 0x24($a2)
    sw    $v0, 0x28($a2)
    sw    $v1, 0x2c($a2)
    sw    $a0, 0x30($a2)
    sw    $a1, 0x34($a2)
    sw    $a3, 0x38($a2)
    jr    $ra
     addiu $sp, $sp, 0x40
.endif
