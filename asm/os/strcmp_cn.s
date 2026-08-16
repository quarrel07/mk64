# iQue body, transcribed from the cart (0x800CFE00): a plain signed-char
# strcmp. It sits in an undecompiled iQue string object between the kernel-call
# stubs and bcopy; menu_item_credits_render is its only caller in this ROM.
# The same object also holds memset (0x800CFE50), an unsigned n-compare
# (0x800CFE74) and strncmp (0x800CFEAC), none of which anything here calls yet.
.set noat
.set noreorder
.include "macros.inc"
.ifdef VERSION_CN
.section .text, "ax"
glabel strcmp
    j     .Lload2
     lbu   $a2, ($a0)
.Lnext:
    bnez  $a3, .Ladvance
     addiu $a0, $a0, 1
    jr    $ra
     addu  $v0, $zero, $zero
.Ladvance:
    addiu $a1, $a1, 1
    lbu   $a2, ($a0)
.Lload2:
    lbu   $t0, ($a1)
    lb    $v1, ($a1)
    sll   $v0, $a2, 24
    sra   $v0, $v0, 24
    beq   $v0, $v1, .Lnext
     addu  $a3, $a2, $zero
    sll   $v1, $a2, 24
    sra   $v1, $v1, 24
    sll   $v0, $t0, 24
    sra   $v0, $v0, 24
    jr    $ra
     subu  $v0, $v1, $v0
.endif
