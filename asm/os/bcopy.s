.set noat      # allow manual use of $at
.set noreorder # don't insert nops after branches
.set gp=64

.include "macros.inc"


.section .text, "ax"


.ifdef VERSION_CN
# iQue body (via sm64's matched cn libultra asm); pseudo-ops may use $at
.set at
glabel bcopy
    beqz  $a2, .L80323A4C
     addu $a3, $a1, $zero
    beq   $a0, $a1, .L80323A4C
     nop
    slt   $at, $a1, $a0
    bnez  $at, .L80323A14
     nop
    add   $v0, $a0, $a2
    slt   $at, $a1, $v0
    beqz   $at, .L80323A14
     nop
    b     .L80323B78
     nop
.L80323A14:
    slti  $at, $a2, 0x10
    bnez  $at, .L80323A2C
     nop
    andi  $v0, $a0, 3
    andi  $v1, $a1, 3
    beq   $v0, $v1, .L80323A54
     nop
.L80323A2C:
    beqz  $a2, .L80323A4C
     nop
    addu  $v1, $a0, $a2
.L80323A38:
    lb    $v0, ($a0)
    addiu $a0, $a0, 1
    sb    $v0, ($a1)
    bne   $a0, $v1, .L80323A38
     addiu $a1, $a1, 1
.L80323A4C:
    jr    $ra
     addu $v0, $a3, $zero
.L80323A54:
    beqz  $v0, .L80323AB8
     nop
    li    $at, 1
    beq   $v0, $at, .L80323A9C
     nop
    li    $at, 2
    beq   $v0, $at, .L80323A88
     nop
    lb    $v0, ($a0)
    addiu $a0, $a0, 1
    sb    $v0, ($a1)
    addiu $a1, $a1, 1
    b     .L80323AB8
     addiu $a2, $a2, -1
.L80323A88:
    lh    $v0, ($a0)
    addiu $a0, $a0, 2
    sh    $v0, ($a1)
    addiu $a1, $a1, 2
    b     .L80323AB8
     addiu $a2, $a2, -2
.L80323A9C:
    lb    $v0, ($a0)
    lh    $v1, 1($a0)
    addiu $a0, $a0, 3
    sb    $v0, ($a1)
    sh    $v1, 1($a1)
    addiu $a1, $a1, 3
    addiu $a2, $a2, -3
.L80323AB8:
    slti  $at, $a2, 0x20
    bnez  $at, .L80323B14
     nop
    lw    $v0, ($a0)
    lw    $v1, 4($a0)
    lw    $t0, 8($a0)
    lw    $t1, 0xc($a0)
    lw    $t2, 0x10($a0)
    lw    $t3, 0x14($a0)
    lw    $t4, 0x18($a0)
    lw    $t5, 0x1c($a0)
    addiu $a0, $a0, 0x20
    sw    $v0, ($a1)
    sw    $v1, 4($a1)
    sw    $t0, 8($a1)
    sw    $t1, 0xc($a1)
    sw    $t2, 0x10($a1)
    sw    $t3, 0x14($a1)
    sw    $t4, 0x18($a1)
    sw    $t5, 0x1c($a1)
    addiu $a1, $a1, 0x20
    b     .L80323AB8
     addiu $a2, $a2, -0x20
.L80323B14:
    slti  $at, $a2, 0x10
.L80323B18:
    bnez  $at, .L80323B50
	 nop
    lw    $v0, ($a0)
    lw    $v1, 4($a0)
    lw    $t0, 8($a0)
    lw    $t1, 0xc($a0)
    addiu $a0, $a0, 0x10
    sw    $v0, ($a1)
    sw    $v1, 4($a1)
    sw    $t0, 8($a1)
    sw    $t1, 0xc($a1)
    addiu $a1, $a1, 0x10
    b     .L80323B14
     addiu $a2, $a2, -0x10
.L80323B50:
    slti  $at, $a2, 4
.L80323B54:
    bnez  $at, .L80323A2C
     nop
    lw    $v0, ($a0)
    addiu $a0, $a0, 4
    sw    $v0, ($a1)
    addiu $a1, $a1, 4
    b     .L80323B50
     addiu $a2, $a2, -4
.L80323B78:
    add   $a0, $a0, $a2
    add   $a1, $a1, $a2
    slti  $at, $a2, 0x10
    bnez  $at, .L80323B94
     nop
    andi  $v0, $a0, 3
    andi  $v1, $a1, 3
    beq   $v0, $v1, .L80323BC4
     nop
.L80323B94:
    beqz  $a2, .L80323A4C
     nop
    addiu $a0, $a0, -1
    addiu $a1, $a1, -1
    subu  $v1, $a0, $a2
.L80323BA8:
    lb    $v0, ($a0)
    addiu $a0, $a0, -1
    sb    $v0, 0($a1)
    bne   $a0, $v1, .L80323BA8
     addiu $a1, $a1, -1
    jr    $ra
     addu $v0, $a3, $zero
.L80323BC4:
    beqz  $v0, .L80323C28
     nop
     li    $at, 3
    beq   $v0, $at, .L80323C0C
     nop
     li    $at, 2
    beq   $v0, $at, .L80323BF4
	 nop
    lb    $v0, -1($a0)
    addiu $a0, $a0, -1
    sb    $v0, -1($a1)
    addiu $a1, $a1, -1
    b     .L80323C28
     addiu $a2, $a2, -1
.L80323BF4:
    lh    $v0, -2($a0)
.L80323BF8:
    addiu $a0, $a0, -2
    sh    $v0, -2($a1)
    addiu $a1, $a1, -2
    b     .L80323C28
     addiu $a2, $a2, -2
.L80323C0C:
    lb    $v0, -1($a0)
    lh    $v1, -3($a0)
    addiu $a0, $a0, -3
    sb    $v0, -1($a1)
    sh    $v1, -3($a1)
    addiu $a1, $a1, -3
    addiu $a2, $a2, -3
.L80323C28:
    slti  $at, $a2, 0x20
    bnez  $at, .L80323C84
	 nop
    lw    $v0, -4($a0)
    lw    $v1, -8($a0)
    lw    $t0, -0xc($a0)
    lw    $t1, -0x10($a0)
    lw    $t2, -0x14($a0)
    lw    $t3, -0x18($a0)
    lw    $t4, -0x1c($a0)
    lw    $t5, -0x20($a0)
    addiu $a0, $a0, -0x20
    sw    $v0, -4($a1)
    sw    $v1, -8($a1)
    sw    $t0, -0xc($a1)
    sw    $t1, -0x10($a1)
    sw    $t2, -0x14($a1)
    sw    $t3, -0x18($a1)
    sw    $t4, -0x1c($a1)
    sw    $t5, -0x20($a1)
    addiu $a1, $a1, -0x20
    b     .L80323C28
     addiu  $a2, $a2, -0x20
.L80323C84:
    slti  $at, $a2, 0x10
.L80323C88:
    bnez $at, .L80323CC0
     nop
    lw    $v0, -4($a0)
    lw    $v1, -8($a0)
    lw    $t0, -0xc($a0)
    lw    $t1, -0x10($a0)
    addiu $a0, $a0, -0x10
    sw    $v0, -4($a1)
    sw    $v1, -8($a1)
    sw    $t0, -0xc($a1)
    sw    $t1, -0x10($a1)
    addiu $a1, $a1, -0x10
    b     .L80323C84
     addiu $a2, $a2, -0x10
.L80323CC0:
    slti  $at, $a2, 4
.L80323CC4:
    bnez  $at, .L80323B94
     nop
    lw    $v0, -4($a0)
    addiu $a0, $a0, -4
    sw    $v0, -4($a1)
    addiu $a1, $a1, -4
    b     .L80323CC0
     addiu $a2, $a2, -4
.set noat
.else
glabel bcopy
    beqz  $a2, ret
     move  $a3, $a1
    beq   $a0, $a1, ret
     slt   $at, $a1, $a0
    bnezl $at, goforwards
     slti  $at, $a2, 0x10
    add   $v0, $a0, $a2
    slt   $at, $a1, $v0
    beql  $at, $zero, goforwards
     slti  $at, $a2, 0x10
    b     gobackwards
     slti  $at, $a2, 0x10
    slti  $at, $a2, 0x10
goforwards:
    bnez  $at, forwards_bytecopy
     nop
    andi  $v0, $a0, 3
    andi  $v1, $a1, 3
    beq   $v0, $v1, forwalignable
     nop
forwards_bytecopy:
    beqz  $a2, ret
     nop
    addu  $v1, $a0, $a2
.L80323A38:
    lb    $v0, ($a0)
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    bne   $a0, $v1, .L80323A38
     sb    $v0, -1($a1)
ret:
    jr    $ra
     move  $v0, $a3

forwalignable:
    beqz  $v0, forwards
     li    $at, 1
    beq   $v0, $at, forw_copy3
     li    $at, 2
    beql  $v0, $at, forw_copy2
     lh    $v0, ($a0)
    lb    $v0, ($a0)
    addiu $a0, $a0, 1
    addiu $a1, $a1, 1
    addiu $a2, $a2, -1
    b     forwards
     sb    $v0, -1($a1)
    lh    $v0, ($a0)
forw_copy2:
    addiu $a0, $a0, 2
    addiu $a1, $a1, 2
    addiu $a2, $a2, -2
    b     forwards
     sh    $v0, -2($a1)
forw_copy3:
    lb    $v0, ($a0)
    lh    $v1, 1($a0)
    addiu $a0, $a0, 3
    addiu $a1, $a1, 3
    addiu $a2, $a2, -3
    sb    $v0, -3($a1)
    sh    $v1, -2($a1)
forwards:
    slti  $at, $a2, 0x20
    bnezl $at, forwards_16
     slti  $at, $a2, 0x10
    lw    $v0, ($a0)
    lw    $v1, 4($a0)
    lw    $t0, 8($a0)
    lw    $t1, 0xc($a0)
    lw    $t2, 0x10($a0)
    lw    $t3, 0x14($a0)
    lw    $t4, 0x18($a0)
    lw    $t5, 0x1c($a0)
    addiu $a0, $a0, 0x20
    addiu $a1, $a1, 0x20
    addiu $a2, $a2, -0x20
    sw    $v0, -0x20($a1)
    sw    $v1, -0x1c($a1)
    sw    $t0, -0x18($a1)
    sw    $t1, -0x14($a1)
    sw    $t2, -0x10($a1)
    sw    $t3, -0xc($a1)
    sw    $t4, -8($a1)
    b     forwards
     sw    $t5, -4($a1)
.L80323B14:
    slti  $at, $a2, 0x10
forwards_16:
    bnezl $at, .L80323B54
     slti  $at, $a2, 4
    lw    $v0, ($a0)
    lw    $v1, 4($a0)
    lw    $t0, 8($a0)
    lw    $t1, 0xc($a0)
    addiu $a0, $a0, 0x10
    addiu $a1, $a1, 0x10
    addiu $a2, $a2, -0x10
    sw    $v0, -0x10($a1)
    sw    $v1, -0xc($a1)
    sw    $t0, -8($a1)
    b     .L80323B14
     sw    $t1, -4($a1)
forwards_4:
    slti  $at, $a2, 4
.L80323B54:
    bnez  $at, forwards_bytecopy
     nop
    lw    $v0, ($a0)
    addiu $a0, $a0, 4
    addiu $a1, $a1, 4
    addiu $a2, $a2, -4
    b     forwards_4
     sw    $v0, -4($a1)
    slti  $at, $a2, 0x10
gobackwards:
    add   $a0, $a0, $a2
    bnez  $at, .L80323B94
     add   $a1, $a1, $a2
    andi  $v0, $a0, 3
    andi  $v1, $a1, 3
    beq   $v0, $v1, .L80323BC4
     nop
.L80323B94:
    beqz  $a2, ret
     nop
    addiu $a0, $a0, -1
    addiu $a1, $a1, -1
    subu  $v1, $a0, $a2
.L80323BA8:
    lb    $v0, ($a0)
    addiu $a0, $a0, -1
    addiu $a1, $a1, -1
    bne   $a0, $v1, .L80323BA8
     sb    $v0, 1($a1)
    jr    $ra
     move  $v0, $a3

.L80323BC4:
    beqz  $v0, backwards_32
     li    $at, 3
    beq   $v0, $at, .L80323C0C
     li    $at, 2
    beql  $v0, $at, .L80323BF8
     lh    $v0, -2($a0)
    lb    $v0, -1($a0)
    addiu $a0, $a0, -1
    addiu $a1, $a1, -1
    addiu $a2, $a2, -1
    b     backwards_32
     sb    $v0, ($a1)
    lh    $v0, -2($a0)
.L80323BF8:
    addiu $a0, $a0, -2
    addiu $a1, $a1, -2
    addiu $a2, $a2, -2
    b     backwards_32
     sh    $v0, ($a1)
.L80323C0C:
    lb    $v0, -1($a0)
    lh    $v1, -3($a0)
    addiu $a0, $a0, -3
    addiu $a1, $a1, -3
    addiu $a2, $a2, -3
    sb    $v0, 2($a1)
    sh    $v1, ($a1)
backwards_32:
    slti  $at, $a2, 0x20
    bnezl $at, .L80323C88
     slti  $at, $a2, 0x10
    lw    $v0, -4($a0)
    lw    $v1, -8($a0)
    lw    $t0, -0xc($a0)
    lw    $t1, -0x10($a0)
    lw    $t2, -0x14($a0)
    lw    $t3, -0x18($a0)
    lw    $t4, -0x1c($a0)
    lw    $t5, -0x20($a0)
    addiu $a0, $a0, -0x20
    addiu $a1, $a1, -0x20
    addiu $a2, $a2, -0x20
    sw    $v0, 0x1c($a1)
    sw    $v1, 0x18($a1)
    sw    $t0, 0x14($a1)
    sw    $t1, 0x10($a1)
    sw    $t2, 0xc($a1)
    sw    $t3, 8($a1)
    sw    $t4, 4($a1)
    b     backwards_32
     sw    $t5, ($a1)
backwards_16:
    slti  $at, $a2, 0x10
.L80323C88:
    bnezl $at, .L80323CC4
     slti  $at, $a2, 4
    lw    $v0, -4($a0)
    lw    $v1, -8($a0)
    lw    $t0, -0xc($a0)
    lw    $t1, -0x10($a0)
    addiu $a0, $a0, -0x10
    addiu $a1, $a1, -0x10
    addiu $a2, $a2, -0x10
    sw    $v0, 0xc($a1)
    sw    $v1, 8($a1)
    sw    $t0, 4($a1)
    b     backwards_16
     sw    $t1, ($a1)
backwards_4:
    slti  $at, $a2, 4
.L80323CC4:
    bnez  $at, .L80323B94
     nop
    lw    $v0, -4($a0)
    addiu $a0, $a0, -4
    addiu $a1, $a1, -4
    addiu $a2, $a2, -4
    b     backwards_4
     sw    $v0, ($a1)
    nop
    nop
    nop


.endif
