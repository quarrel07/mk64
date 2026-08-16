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

/* iQue memset, cart 0x0D0A50 / vram 0x800CFE50 */
glabel memset
    .word 0x10C00006
    .word 0x00003821
    .word 0x00871021
    .word 0x24E70001
    .word 0x00E6182B
    .word 0x1460FFFC
    .word 0xA0450000
    .word 0x03E00008
    .word 0x00801021

/* iQue unsigned n-byte compare, cart 0x0D0A74 / vram 0x800CFE74 */
glabel func_800CFE74
    j     .Lfunc_800CFE74_10
    .word 0x00C01021
    .word 0x90A30000
    .word 0x24A50001
    .word 0x90820000
    .word 0x10430003
    .word 0x24840001
    .word 0x03E00008
    .word 0x00431023
    .word 0x00C01021
.Lfunc_800CFE74_10:
    .word 0x1440FFF7
    .word 0x24C6FFFF
    .word 0x03E00008
    .word 0x00001021

/* iQue strncmp, cart 0x0D0AAC / vram 0x800CFEAC */
glabel strncmp
    j     .Lstrncmp_16
    .word 0x00004021
    .word 0x0106102A
    .word 0x10400011
    .word 0x00000000
    .word 0x15400005
    .word 0x00000000
    .word 0x1520000D
    .word 0x00001021
    .word 0x03E00008
    .word 0x00000000
    .word 0x10E00009
    .word 0x00000000
    .word 0x24840001
    .word 0x24A50001
    .word 0x25080001
.Lstrncmp_16:
    .word 0x90830000
    .word 0x90A70000
    .word 0x00605021
    .word 0x1067FFEE
    .word 0x00E04821
    .word 0x11060006
    .word 0x00031E00
    .word 0x00031E03
    .word 0x00071600
    .word 0x00021603
    .word 0x03E00008
    .word 0x00621023
    .word 0x03E00008
    .word 0x00001021
.endif
