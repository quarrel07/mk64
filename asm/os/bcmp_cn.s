# iQue body, transcribed from the cart (0x800D2710): 2.0L libultra's bcmp,
# which the old SDK in this tree never shipped. Called by the 2.0L pfs
# layer (__osCheckId/__osGetId id compares).
.set noat
.set noreorder
.include "macros.inc"
.ifdef VERSION_CN
.section .text, "ax"
glabel bcmp
    xor   $v0, $a0, $a1
    slti  $at, $a2, 16
    bnez  $at, .Lbytecmp
     nop
    andi  $v0, $v0, 3
    bnez  $v0, .Lunalgncmp
     subu  $t8, $zero, $a0
    andi  $t8, $t8, 3
    beqz  $t8, .Lwordcmp
     subu  $a2, $a2, $t8
    addu  $v0, $v1, $zero
    lwl   $v0, ($a0)
    lwl   $v1, ($a1)
    addu  $a0, $a0, $t8
    bne   $v0, $v1, .Lcmpne
     addu  $a1, $a1, $t8
.Lwordcmp:
    addiu $at, $zero, -4
    and   $a3, $a2, $at
    beqz  $a3, .Lbytecmp
     subu  $a2, $a2, $a3
    addu  $a3, $a3, $a0
.Lwloop:
    lw    $v0, ($a0)
    lw    $v1, ($a1)
    addiu $a0, $a0, 4
    bne   $v0, $v1, .Lcmpne
     addiu $a1, $a1, 4
    bne   $a0, $a3, .Lwloop
     nop
    b     .Lbytecmp
     nop
.Lunalgncmp:
    subu  $a3, $zero, $a1
    andi  $a3, $a3, 3
    beqz  $a3, .Lpartaligncmp
     subu  $a2, $a2, $a3
    addu  $a3, $a3, $a0
.Lbloop1:
    lbu   $v0, ($a0)
    lbu   $v1, ($a1)
    addiu $a0, $a0, 1
    bne   $v0, $v1, .Lcmpne
     addiu $a1, $a1, 1
    bne   $a0, $a3, .Lbloop1
     nop
.Lpartaligncmp:
    addiu $at, $zero, -4
    and   $a3, $a2, $at
    beqz  $a3, .Lbytecmp
     subu  $a2, $a2, $a3
    addu  $a3, $a3, $a0
.Luloop:
    lwl   $v0, ($a0)
    lwr   $v0, 3($a0)
    lw    $v1, ($a1)
    addiu $a0, $a0, 4
    bne   $v0, $v1, .Lcmpne
     addiu $a1, $a1, 4
    bne   $a0, $a3, .Luloop
     nop
.Lbytecmp:
    blez  $a2, .Lret0
     addu  $a3, $a2, $a0
.Lbloop2:
    lbu   $v0, ($a0)
    lbu   $v1, ($a1)
    addiu $a0, $a0, 1
    bne   $v0, $v1, .Lcmpne
     addiu $a1, $a1, 1
    bne   $a0, $a3, .Lbloop2
     nop
.Lret0:
    jr    $ra
     addu  $v0, $zero, $zero
.Lcmpne:
    jr    $ra
     addiu $v0, $zero, 1
.endif
