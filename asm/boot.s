# assembler directives
.set noat      # allow manual use of $at
.set noreorder # don't insert nops after branches
.set gp=64

.include "macros.inc"

# 0xA0000000-0xBFFFFFFF: KSEG1 direct map non-cache mirror of 0x00000000
# 0xA4000000-0xA4000FFF: RSP DMEM

# 0xA4000000-0xA400003F: ROM header

.section .text, "ax"

# 0xA4000040-0xA4000B6F: IPL3

# IPL3 entry point jumped to from IPL2
.ifdef VERSION_CN

# An iQue image does not use the N64 CIC boot. This is the iQue boot code
# transcribed from the dump: 716 words, verified by assembling this block
# alone and requiring 0x40-0xB70 of the image back byte for byte. The 15
# .word entries are encodings the assembler will not round-trip as mnemonics,
# and j/jal are words because they encode an absolute address.
#
# The IPL3 font below is NOT inside this guard: it is byte-identical to US in
# this dump, so every version shares the same extracted asset.
glabel ipl3_entry # 0xA4000040
    mtc0   $zero, $13
    mtc0   $zero, $9
    mtc0   $zero, $11
    lui    $t0, 0xA470
    lw     $t1, 12($t0)
    bne    $t1, $zero, .Lboot_A40003FC
    nop
    addiu  $sp, $sp, -24
    sw     $s3, 0($sp)
    sw     $s4, 4($sp)
    sw     $s5, 8($sp)
    sw     $s6, 12($sp)
    sw     $s7, 16($sp)
    lui    $t0, 0xA470
    lui    $t2, 0xA3F8
    lui    $t3, 0xA3F0
    lui    $t4, 0xA430
    ori    $t1, $zero, 0x0040
    sw     $t1, 4($t0)
    addiu  $s1, $zero, 8000
.Lboot_A4000090:
    nop
    addi   $s1, $s1, -1
    bne    $s1, $zero, .Lboot_A4000090
    nop
    sw     $zero, 8($t0)
    ori    $t1, $zero, 0x0014
    sw     $t1, 12($t0)
    sw     $zero, 0($t0)
    addiu  $s1, $zero, 4
.Lboot_A40000B4:
    nop
    addi   $s1, $s1, -1
    bne    $s1, $zero, .Lboot_A40000B4
    nop
    ori    $t1, $zero, 0x000E
    sw     $t1, 0($t0)
    addiu  $s1, $zero, 32
.Lboot_A40000D0:
    addi   $s1, $s1, -1
    bne    $s1, $zero, .Lboot_A40000D0
    ori    $t1, $zero, 0x010F
    sw     $t1, 0($t4)
    lui    $t1, 0x1808
    ori    $t1, $t1, 0x2838
    sw     $t1, 8($t2)
    sw     $zero, 20($t2)
    lui    $t1, 0x8000
    sw     $t1, 4($t2)
    daddu  $t5, $zero, $zero
    daddu  $t6, $zero, $zero
    lui    $t7, 0xA3F0
    daddu  $t8, $zero, $zero
    lui    $t9, 0xA3F0
    lui    $s6, 0xA000
    daddu  $s7, $zero, $zero
    lui    $a2, 0xA3F0
    lui    $a3, 0xA000
    daddu  $s2, $zero, $zero
    lui    $s4, 0xA000
    addiu  $sp, $sp, -72
    daddu  $fp, $sp, $zero
    lui    $s0, 0xA430
    lw     $s0, 4($s0)
    lui    $s1, 0x0101
    ori    $s1, $s1, 0x0101
    bne    $s0, $s1, .Lboot_A4000154
    nop
    addiu  $s0, $zero, 512
    ori    $s1, $t3, 0x4000
    beq    $zero, $zero, .Lboot_A400015C
    nop
.Lboot_A4000154:
    addiu  $s0, $zero, 1024
    ori    $s1, $t3, 0x8000
.Lboot_A400015C:
    sw     $t6, 4($s1)
    addiu  $s5, $t7, 12
    .word 0x0D0001D4
    nop
    beq    $v0, $zero, .Lboot_A4000250
    nop
    sw     $v0, 0($sp)
    addiu  $t1, $zero, 8192
    sw     $t1, 0($t4)
    lw     $t3, 0($t7)
    lui    $t0, 0xF0FF
    and    $t3, $t3, $t0
    sw     $t3, 4($sp)
    addi   $sp, $sp, 8
    addiu  $t1, $zero, 4096
    sw     $t1, 0($t4)
    lui    $t0, 0xB019
    bne    $t3, $t0, .Lboot_A40001D4
    nop
    lui    $t0, 0x0800
    add    $t8, $t8, $t0
    add    $t9, $t9, $s0
    add    $t9, $t9, $s0
    lui    $t0, 0x0020
    add    $s6, $s6, $t0
    add    $s4, $s4, $t0
    sll    $s2, $s2, 1
    addi   $s2, $s2, 1
    beq    $zero, $zero, .Lboot_A40001DC
    nop
.Lboot_A40001D4:
    lui    $t0, 0x0010
    add    $s4, $s4, $t0
.Lboot_A40001DC:
    addiu  $t0, $zero, 8192
    sw     $t0, 0($t4)
    lw     $t1, 36($t7)
    lw     $k0, 0($t7)
    addiu  $t0, $zero, 4096
    sw     $t0, 0($t4)
    andi   $t1, $t1, 0xFFFF
    addiu  $t0, $zero, 1280
    bne    $t1, $t0, .Lboot_A4000224
    nop
    lui    $k1, 0x0100
    and    $k0, $k0, $k1
    bne    $k0, $zero, .Lboot_A4000224
    nop
    lui    $t0, 0x101C
    ori    $t0, $t0, 0x0A04
    sw     $t0, 24($t7)
    beq    $zero, $zero, .Lboot_A4000230
.Lboot_A4000224:
    lui    $t0, 0x080C
    ori    $t0, $t0, 0x1204
    sw     $t0, 24($t7)
.Lboot_A4000230:
    lui    $t0, 0x0800
    add    $t6, $t6, $t0
    add    $t7, $t7, $s0
    add    $t7, $t7, $s0
    addiu  $t5, $t5, 1
    sltiu  $t0, $t5, 8
    bne    $t0, $zero, .Lboot_A400015C
    nop
.Lboot_A4000250:
    lui    $t0, 0xC000
    sw     $t0, 12($t2)
    lui    $t0, 0x8000
    sw     $t0, 4($t2)
    daddu  $sp, $fp, $zero
    daddu  $v1, $zero, $zero
.Lboot_A4000268:
    lw     $t1, 4($sp)
    lui    $t0, 0xB009
    bne    $t1, $t0, .Lboot_A40002CC
    nop
    sw     $t8, 4($s1)
    addiu  $s5, $t9, 12
    lw     $a0, 0($sp)
    addi   $sp, $sp, 8
    addiu  $a1, $zero, 1
    .word 0x0D000285
    nop
    lw     $t0, 0($s6)
    lui    $t0, 0x0008
    add    $t0, $t0, $s6
    lw     $t1, 0($t0)
    lw     $t0, 0($s6)
    lui    $t0, 0x0008
    add    $t0, $t0, $s6
    lw     $t1, 0($t0)
    lui    $t0, 0x0400
    add    $t6, $t6, $t0
    add    $t9, $t9, $s0
    lui    $t0, 0x0010
    add    $s6, $s6, $t0
    beq    $zero, $zero, .Lboot_A4000350
.Lboot_A40002CC:
    sw     $s7, 4($s1)
    addiu  $s5, $a2, 12
    lw     $a0, 0($sp)
    addi   $sp, $sp, 8
    addiu  $a1, $zero, 1
    .word 0x0D000285
    nop
    lw     $t0, 0($a3)
    lui    $t0, 0x0008
    add    $t0, $t0, $a3
    lw     $t1, 0($t0)
    lui    $t0, 0x0010
    add    $t0, $t0, $a3
    lw     $t1, 0($t0)
    lui    $t0, 0x0018
    add    $t0, $t0, $a3
    lw     $t1, 0($t0)
    lw     $t0, 0($a3)
    lui    $t0, 0x0008
    add    $t0, $t0, $a3
    lw     $t1, 0($t0)
    lui    $t0, 0x0010
    add    $t0, $t0, $a3
    lw     $t1, 0($t0)
    lui    $t0, 0x0018
    add    $t0, $t0, $a3
    lw     $t1, 0($t0)
    lui    $t0, 0x0800
    add    $s7, $s7, $t0
    add    $a2, $a2, $s0
    add    $a2, $a2, $s0
    lui    $t0, 0x0020
    add    $a3, $a3, $t0
.Lboot_A4000350:
    addiu  $v1, $v1, 1
    slt    $t0, $v1, $t5
    bne    $t0, $zero, .Lboot_A4000268
    nop
    lui    $t2, 0xA470
    sll    $s2, $s2, 19
    lui    $t1, 0x0006
    ori    $t1, $t1, 0x3634
    or     $t1, $t1, $s2
    sw     $t1, 16($t2)
    lw     $t1, 16($t2)
    lui    $t0, 0xA000
    ori    $t0, $t0, 0x0300
    lui    $t1, 0x0FFF
    ori    $t1, $t1, 0xFFFF
    and    $s6, $s6, $t1
    sw     $s6, 24($t0)
    daddu  $sp, $fp, $zero
    addiu  $sp, $sp, 72
    lw     $s3, 0($sp)
    lw     $s4, 4($sp)
    lw     $s5, 8($sp)
    lw     $s6, 12($sp)
    lw     $s7, 16($sp)
    addiu  $sp, $sp, 24
    lui    $t0, 0x8000
    addiu  $t1, $t0, 16384
    addiu  $t1, $t1, -32
    mtc0   $zero, $28
    mtc0   $zero, $29
.Lboot_A40003C8:
    .word 0xBD080000
    sltu   $at, $t0, $t1
    bne    $at, $zero, .Lboot_A40003C8
    addiu  $t0, $t0, 32
    lui    $t0, 0x8000
    addiu  $t1, $t0, 8192
    addiu  $t1, $t1, -16
.Lboot_A40003E4:
    .word 0xBD090000
    sltu   $at, $t0, $t1
    bne    $at, $zero, .Lboot_A40003E4
    addiu  $t0, $t0, 16
    beq    $zero, $zero, .Lboot_A400043C
    nop
.Lboot_A40003FC:
    lui    $t0, 0x8000
    addiu  $t1, $t0, 16384
    addiu  $t1, $t1, -32
    mtc0   $zero, $28
    mtc0   $zero, $29
.Lboot_A4000410:
    .word 0xBD080000
    sltu   $at, $t0, $t1
    bne    $at, $zero, .Lboot_A4000410
    addiu  $t0, $t0, 32
    lui    $t0, 0x8000
    addiu  $t1, $t0, 8192
    addiu  $t1, $t1, -16
.Lboot_A400042C:
    .word 0xBD010000
    sltu   $at, $t0, $t1
    bne    $at, $zero, .Lboot_A400042C
    addiu  $t0, $t0, 16
.Lboot_A400043C:
    lui    $t0, 0x0400
    daddiu $t0, $t0, 1180
    lui    $t1, 0x000F
    ori    $t1, $t1, 0xFFFF
    and    $t0, $t0, $t1
    lui    $t2, 0xA400
    lui    $t3, 0xFFF0
    and    $t2, $t2, $t3
    or     $t0, $t0, $t2
    lui    $t3, 0x0400
    daddiu $t3, $t3, 1868
    and    $t3, $t3, $t1
    or     $t3, $t3, $t2
    lui    $t1, 0xA000
.Lboot_A4000474:
    lw     $t5, 0($t0)
    sw     $t5, 0($t1)
    addiu  $t0, $t0, 4
    addiu  $t1, $t1, 4
    sltu   $at, $t0, $t3
    bne    $at, $zero, .Lboot_A4000474
    nop
    lui    $t4, 0x8000
    jr     $t4
    nop
    lui    $t3, 0xB000
    lui    $t2, 0x1FFF
    ori    $t2, $t2, 0xFFFF
    lw     $t1, 8($t3)
    and    $t1, $t1, $t2
    lui    $at, 0xA460
    sw     $t1, 0($at)
.Lboot_A40004B8:
    lui    $t0, 0xA460
    lw     $t0, 16($t0)
    andi   $t0, $t0, 0x0002
    bne    $t0, $zero, .Lboot_A40004B8
    nop
    addiu  $t0, $zero, 4096
    add    $t0, $t0, $t3
    and    $t0, $t0, $t2
    lui    $at, 0xA460
    sw     $t0, 4($at)
    lui    $t2, 0x000F
    ori    $t2, $t2, 0xFFFF
    lui    $at, 0xA460
    sw     $t2, 12($at)
.Lboot_A40004F0:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lui    $t3, 0xA460
    lw     $t3, 16($t3)
    andi   $t3, $t3, 0x0001
    bne    $t3, $zero, .Lboot_A40004F0
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lui    $t1, 0xA408
    lw     $t1, 0($t1)
    beq    $t1, $zero, .Lboot_A4000698
    nop
    addiu  $t2, $zero, 65
    lui    $at, 0xA404
    sw     $t2, 16($at)
    lui    $at, 0xA408
    sw     $zero, 0($at)
.Lboot_A4000698:
    lui    $t3, 0x00AA
    ori    $t3, $t3, 0xAAAE
    lui    $at, 0xA404
    sw     $t3, 16($at)
    addiu  $t0, $zero, 1365
    lui    $at, 0xA430
    sw     $t0, 12($at)
    lui    $at, 0xA480
    sw     $zero, 24($at)
    lui    $at, 0xA450
    sw     $zero, 12($at)
    addiu  $t1, $zero, 2048
    lui    $at, 0xA430
    sw     $t1, 0($at)
    addiu  $t1, $zero, 2
    lui    $at, 0xA460
    sw     $t1, 16($at)
    lui    $t0, 0xA000
    ori    $t0, $t0, 0x0300
    sw     $s4, 0($t0)
    sw     $s3, 4($t0)
    sw     $s5, 12($t0)
    beq    $s3, $zero, .Lboot_A4000700
    sw     $s7, 20($t0)
    beq    $zero, $zero, .Lboot_A4000704
    lui    $t1, 0xA600
.Lboot_A4000700:
    lui    $t1, 0xB000
.Lboot_A4000704:
    sw     $t1, 8($t0)
    lui    $t0, 0xA400
    addi   $t1, $t0, 4096
.Lboot_A4000710:
    sw     $zero, 0($t0)
    addiu  $t0, $t0, 4
    bne    $t0, $t1, .Lboot_A4000710
    nop
    lui    $t0, 0xA400
    ori    $t0, $t0, 0x1000
    addi   $t1, $t0, 4096
.Lboot_A400072C:
    sw     $zero, 0($t0)
    addiu  $t0, $t0, 4
    bne    $t0, $t1, .Lboot_A400072C
    nop
    lui    $t3, 0xB000
    lw     $t1, 8($t3)
    jr     $t1
    nop
    nop
.Lboot_A4000750:
    addiu  $sp, $sp, -160
    sw     $v0, 0($sp)
    sw     $v1, 4($sp)
    sw     $a0, 8($sp)
    sw     $a1, 12($sp)
    sw     $a2, 16($sp)
    sw     $a3, 20($sp)
    sw     $t0, 24($sp)
    sw     $t1, 28($sp)
    sw     $t2, 32($sp)
    sw     $t3, 36($sp)
    sw     $t4, 40($sp)
    sw     $t5, 44($sp)
    sw     $t6, 48($sp)
    sw     $t7, 52($sp)
    sw     $t8, 56($sp)
    sw     $t9, 60($sp)
    sw     $s0, 64($sp)
    sw     $s1, 68($sp)
    sw     $s2, 72($sp)
    sw     $s3, 76($sp)
    sw     $s4, 80($sp)
    sw     $s5, 84($sp)
    sw     $s6, 88($sp)
    sw     $s7, 92($sp)
    sw     $fp, 96($sp)
    sw     $ra, 100($sp)
    daddu  $s0, $zero, $zero
    daddu  $s1, $zero, $zero
.Lboot_A40007C4:
    .word 0x0D000217
    nop
    addiu  $s0, $s0, 1
    addu   $s1, $s1, $v0
    slti   $t1, $s0, 4
    bne    $t1, $zero, .Lboot_A40007C4
    nop
    srl    $a0, $s1, 2
    .word 0x0D000285
    addiu  $a1, $zero, 1
    srl    $v0, $s1, 2
    lw     $v1, 4($sp)
    lw     $a0, 8($sp)
    lw     $a1, 12($sp)
    lw     $a2, 16($sp)
    lw     $a3, 20($sp)
    lw     $t0, 24($sp)
    lw     $t1, 28($sp)
    lw     $t2, 32($sp)
    lw     $t3, 36($sp)
    lw     $t4, 40($sp)
    lw     $t5, 44($sp)
    lw     $t6, 48($sp)
    lw     $t7, 52($sp)
    lw     $t8, 56($sp)
    lw     $t9, 60($sp)
    lw     $s0, 64($sp)
    lw     $s1, 68($sp)
    lw     $s2, 72($sp)
    lw     $s3, 76($sp)
    lw     $s4, 80($sp)
    lw     $s5, 84($sp)
    lw     $s6, 88($sp)
    lw     $s7, 92($sp)
    lw     $fp, 96($sp)
    lw     $ra, 100($sp)
    jr     $ra
    addiu  $sp, $sp, 160
.Lboot_A400085C:
    addiu  $sp, $sp, -32
    sw     $ra, 28($sp)
    daddu  $t1, $zero, $zero
    daddu  $t3, $zero, $zero
    daddu  $t4, $zero, $zero
.Lboot_A4000870:
    slti   $k0, $t4, 64
    beq    $k0, $zero, .Lboot_A40008D4
    nop
    .word 0x0D000239
    daddu  $a0, $t4, $zero
    blez   $v0, .Lboot_A40008A0
    nop
    subu   $k0, $v0, $t1
    multu  $k0, $t4
    mflo   $k0
    addu   $t3, $t3, $k0
    daddu  $t1, $v0, $zero
.Lboot_A40008A0:
    addiu  $t4, $t4, 1
    slti   $k0, $t1, 80
    bne    $k0, $zero, .Lboot_A4000870
    nop
    sll    $a0, $t3, 2
    subu   $a0, $a0, $t3
    sll    $a0, $a0, 2
    subu   $a0, $a0, $t3
    sll    $a0, $a0, 1
    .word 0x0D000256
    addiu  $a0, $a0, -880
    beq    $zero, $zero, .Lboot_A40008D8
    nop
.Lboot_A40008D4:
    daddu  $v0, $zero, $zero
.Lboot_A40008D8:
    lw     $ra, 28($sp)
    jr     $ra
    addiu  $sp, $sp, 32
.Lboot_A40008E4:
    addiu  $sp, $sp, -40
    sw     $ra, 28($sp)
    daddu  $v0, $zero, $zero
    .word 0x0D000285
    addiu  $a1, $zero, 2
    daddu  $fp, $zero, $zero
.Lboot_A40008FC:
    addiu  $k0, $zero, -1
    sw     $k0, 0($s4)
    sw     $k0, 0($s4)
    sw     $k0, 4($s4)
    lw     $v1, 4($s4)
    srl    $v1, $v1, 16
    daddu  $gp, $zero, $zero
.Lboot_A4000918:
    andi   $k0, $v1, 0x0001
    beq    $k0, $zero, .Lboot_A4000928
    nop
    addiu  $v0, $v0, 1
.Lboot_A4000928:
    srl    $v1, $v1, 1
    addiu  $gp, $gp, 1
    slti   $k0, $gp, 8
    bne    $k0, $zero, .Lboot_A4000918
    nop
    addiu  $fp, $fp, 1
    slti   $k0, $fp, 10
    bne    $k0, $zero, .Lboot_A40008FC
    nop
    lw     $ra, 28($sp)
    jr     $ra
    addiu  $sp, $sp, 40
.Lboot_A4000958:
    addiu  $sp, $sp, -40
    sw     $ra, 28($sp)
    sw     $a0, 32($sp)
    daddu  $t0, $zero, $zero
    daddu  $t2, $zero, $zero
    ori    $t5, $zero, 0xC800
    sb     $zero, 39($sp)
    daddu  $t6, $zero, $zero
.Lboot_A4000978:
    slti   $k0, $t6, 64
    bne    $k0, $zero, .Lboot_A400098C
    nop
    beq    $zero, $zero, .Lboot_A4000A08
    daddu  $v0, $zero, $zero
.Lboot_A400098C:
    daddu  $a0, $t6, $zero
    .word 0x0D000285
    addiu  $a1, $zero, 1
    .word 0x0D0002AA
    addiu  $a0, $sp, 39
    .word 0x0D0002AA
    addiu  $a0, $sp, 39
    lbu    $k0, 39($sp)
    addiu  $k1, $zero, 800
    multu  $k0, $k1
    mflo   $t0
    lw     $a0, 32($sp)
    subu   $k0, $t0, $a0
    bgez   $k0, .Lboot_A40009CC
    nop
    subu   $k0, $a0, $t0
.Lboot_A40009CC:
    slt    $k1, $k0, $t5
    beq    $k1, $zero, .Lboot_A40009E0
    nop
    daddu  $t5, $k0, $zero
    daddu  $t2, $t6, $zero
.Lboot_A40009E0:
    lw     $a0, 32($sp)
    slt    $k1, $t0, $a0
    beq    $k1, $zero, .Lboot_A4000A00
    nop
    addiu  $t6, $t6, 1
    slti   $k1, $t6, 65
    bne    $k1, $zero, .Lboot_A4000978
    nop
.Lboot_A4000A00:
    addu   $v0, $t2, $t6
    srl    $v0, $v0, 1
.Lboot_A4000A08:
    lw     $ra, 28($sp)
    jr     $ra
    addiu  $sp, $sp, 40
.Lboot_A4000A14:
    addiu  $sp, $sp, -40
    sw     $ra, 28($sp)
    lui    $t7, 0x4200
    andi   $a0, $a0, 0x00FF
    xori   $a0, $a0, 0x003F
    addiu  $k1, $zero, 1
    bne    $a1, $k1, .Lboot_A4000A3C
    nop
    lui    $k0, 0x8000
    or     $t7, $t7, $k0
.Lboot_A4000A3C:
    andi   $k0, $a0, 0x0001
    sll    $k0, $k0, 6
    or     $t7, $t7, $k0
    andi   $k0, $a0, 0x0002
    sll    $k0, $k0, 13
    or     $t7, $t7, $k0
    andi   $k0, $a0, 0x0004
    sll    $k0, $k0, 20
    or     $t7, $t7, $k0
    andi   $k0, $a0, 0x0008
    sll    $k0, $k0, 4
    or     $t7, $t7, $k0
    andi   $k0, $a0, 0x0010
    sll    $k0, $k0, 11
    or     $t7, $t7, $k0
    andi   $k0, $a0, 0x0020
    sll    $k0, $k0, 18
    or     $t7, $t7, $k0
    sw     $t7, 0($s5)
    addiu  $k1, $zero, 1
    bne    $a1, $k1, .Lboot_A4000A9C
    nop
    lui    $k0, 0xA430
    sw     $zero, 0($k0)
.Lboot_A4000A9C:
    lw     $ra, 28($sp)
    jr     $ra
    addiu  $sp, $sp, 40
.Lboot_A4000AA8:
    addiu  $sp, $sp, -40
    sw     $ra, 28($sp)
    daddu  $fp, $zero, $zero
    addiu  $k0, $zero, 8192
    lui    $k1, 0xA430
    sw     $k0, 0($k1)
    lw     $fp, 0($s5)
    addiu  $k0, $zero, 4096
    sw     $k0, 0($k1)
    daddu  $k0, $zero, $zero
    addiu  $k1, $zero, 64
    and    $k1, $k1, $fp
    srl    $k1, $k1, 6
    or     $k0, $k0, $k1
    addiu  $k1, $zero, 16384
    and    $k1, $k1, $fp
    srl    $k1, $k1, 13
    or     $k0, $k0, $k1
    lui    $k1, 0x0040
    and    $k1, $k1, $fp
    srl    $k1, $k1, 20
    or     $k0, $k0, $k1
    addiu  $k1, $zero, 128
    and    $k1, $k1, $fp
    srl    $k1, $k1, 4
    or     $k0, $k0, $k1
    ori    $k1, $zero, 0x8000
    and    $k1, $k1, $fp
    srl    $k1, $k1, 11
    or     $k0, $k0, $k1
    lui    $k1, 0x0080
    and    $k1, $k1, $fp
    srl    $k1, $k1, 18
    or     $k0, $k0, $k1
    sb     $k0, 0($a0)
    lw     $ra, 28($sp)
    jr     $ra
    addiu  $sp, $sp, 40
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

.else

glabel ipl3_entry # 0xA4000040
    mtc0  $zero, $13
    mtc0  $zero, $9
    mtc0  $zero, $11
    lui   $t0, %hi(PHYS_TO_K1|RI_MODE_REG)
    addiu $t0, %lo(PHYS_TO_K1|RI_MODE_REG)
    lw    $t1, 0xc($t0)
    bnez  $t1, .LA4000410
     nop
    addiu $sp, $sp, -0x18
    sw    $s3, ($sp)
    sw    $s4, 4($sp)
    sw    $s5, 8($sp)
    sw    $s6, 0xc($sp)
    sw    $s7, 0x10($sp)
    lui   $t0, %hi(PHYS_TO_K1|RI_MODE_REG)
    addiu $t0, %lo(PHYS_TO_K1|RI_MODE_REG)
    lui   $t2, (0xa3f80000 >> 16)
    lui   $t3, (0xa3f00000 >> 16)
    lui   $t4, %hi(PHYS_TO_K1|MI_MODE_REG)
    addiu $t4, %lo(PHYS_TO_K1|MI_MODE_REG)
    ori   $t1, $zero, 64
    sw    $t1, 4($t0)
    li   $s1, 8000
.LA400009C:
    nop
    addi  $s1, $s1, -1
    bnez  $s1, .LA400009C
     nop
    sw    $zero, 8($t0)
    ori   $t1, $zero, 20
    sw    $t1, 0xc($t0)
    sw    $zero, ($t0)
    li    $s1, 4
.LA40000C0:
    nop
    addi  $s1, $s1, -1
    bnez  $s1, .LA40000C0
     nop
    ori   $t1, $zero, 14
    sw    $t1, ($t0)
    li    $s1, 32
.LA40000DC:
    addi  $s1, $s1, -1
    bnez  $s1, .LA40000DC
    ori   $t1, $zero, 271
    sw    $t1, ($t4)
    lui   $t1, (0x18082838 >> 16)
    ori   $t1, (0x18082838 & 0xFFFF)
    sw    $t1, 0x8($t2)
    sw    $zero, 0x14($t2)
    lui   $t1, 0x8000
    sw    $t1, 0x4($t2)
    move  $t5, $zero
    move  $t6, $zero
    lui   $t7, (0xA3F00000 >> 16)
    move  $t8, $zero
    lui   $t9, (0xA3F00000 >> 16)
    lui   $s6, (0xA0000000 >> 16)
    move  $s7, $zero
    lui   $a2, (0xA3F00000 >> 16)
    lui   $a3, (0xA0000000 >> 16)
    move  $s2, $zero
    lui   $s4, (0xA0000000 >> 16)
    addiu $sp, $sp, -0x48
    move  $fp, $sp
    lui   $s0, %hi(PHYS_TO_K1|MI_VERSION_REG)
    lw    $s0, %lo(PHYS_TO_K1|MI_VERSION_REG)($s0)
    lui   $s1, (0x01010101 >> 16)
    addiu $s1, (0x01010101 & 0xFFFF)
    bne   $s0, $s1, .LA4000160
     nop
    li    $s0, 512
    ori   $s1, $t3, 0x4000
    b     .LA4000168
     nop
.LA4000160:
    li    $s0, 1024
    ori   $s1, $t3, 0x8000
.LA4000168:
    sw    $t6, 4($s1)
    addiu $s5, $t7, 0xc
    jal   func_A4000778
     nop
    beqz  $v0, .LA400025C
     nop
    sw    $v0, ($sp)
    li    $t1, 8192
    sw    $t1, ($t4)
    lw    $t3, ($t7)
    lui   $t0, 0xf0ff
    and   $t3, $t3, $t0
    sw    $t3, 4($sp)
    addi  $sp, $sp, 8
    li    $t1, 4096
    sw    $t1, ($t4)
    lui   $t0, 0xb019
    bne   $t3, $t0, .LA40001E0
     nop
    lui   $t0, 0x800
    add   $t8, $t8, $t0
    add   $t9, $t9, $s0
    add   $t9, $t9, $s0
    lui   $t0, 0x20
    add   $s6, $s6, $t0
    add   $s4, $s4, $t0
    sll   $s2, $s2, 1
    addi  $s2, $s2, 1
    b     .LA40001E8
     nop
.LA40001E0:
    lui   $t0, 0x10
    add   $s4, $s4, $t0
.LA40001E8:
    li    $t0, 8192
    sw    $t0, ($t4)
    lw    $t1, 0x24($t7)
    lw    $k0, ($t7)
    li    $t0, 4096
    sw    $t0, ($t4)
    andi  $t1, $t1, 0xffff
    li    $t0, 1280
    bne   $t1, $t0, .LA4000230
     nop
    lui   $k1, 0x100
    and   $k0, $k0, $k1
    bnez  $k0, .LA4000230
     nop
    lui   $t0, (0x101C0A04 >> 16)
    ori   $t0, (0x101C0A04 & 0xFFFF)
    sw    $t0, 0x18($t7)
    b     .LA400023C
.LA4000230:
     lui   $t0, (0x080C1204 >> 16)
    ori   $t0, (0x080C1204 & 0xFFFF)
    sw    $t0, 0x18($t7)
.LA400023C:
    lui   $t0, 0x800
    add   $t6, $t6, $t0
    add   $t7, $t7, $s0
    add   $t7, $t7, $s0
    addiu $t5, $t5, 1
    sltiu $t0, $t5, 8
    bnez  $t0, .LA4000168
     nop
.LA400025C:
    li    $t0, 0xc4000000
    sw    $t0, 0xc($t2)
    li    $t0, 0x80000000
    sw    $t0, 0x4($t2)
    move  $sp, $fp
    move  $v1, $zero
.LA4000274:
    lw    $t1, 4($sp)
    lui   $t0, 0xb009
    bne   $t1, $t0, .LA40002D8
     nop
    sw    $t8, 4($s1)
    addiu $s5, $t9, 0xc
    lw    $a0, ($sp)
    addi  $sp, $sp, 8
    li    $a1, 1
    jal   func_A4000A40
     nop
    lw    $t0, ($s6)
    lui   $t0, 8
    add   $t0, $t0, $s6
    lw    $t1, ($t0)
    lw    $t0, ($s6)
    lui   $t0, 8
    add   $t0, $t0, $s6
    lw    $t1, ($t0)
    lui   $t0, 0x400
    add   $t6, $t6, $t0
    add   $t9, $t9, $s0
    lui   $t0, 0x10
    add   $s6, $s6, $t0
    b     .LA400035C
.LA40002D8:
     sw    $s7, 4($s1)
    addiu $s5, $a2, 0xc
    lw    $a0, ($sp)
    addi  $sp, $sp, 8
    li    $a1, 1
    jal   func_A4000A40
     nop
    lw    $t0, ($a3)
    lui   $t0, 8
    add   $t0, $t0, $a3
    lw    $t1, ($t0)
    lui   $t0, 0x10
    add   $t0, $t0, $a3
    lw    $t1, ($t0)
    lui   $t0, 0x18
    add   $t0, $t0, $a3
    lw    $t1, ($t0)
    lw    $t0, ($a3)
    lui   $t0, 8
    add   $t0, $t0, $a3
    lw    $t1, ($t0)
    lui   $t0, 0x10
    add   $t0, $t0, $a3
    lw    $t1, ($t0)
    lui   $t0, 0x18
    add   $t0, $t0, $a3
    lw    $t1, ($t0)
    lui   $t0, 0x800
    add   $s7, $s7, $t0
    add   $a2, $a2, $s0
    add   $a2, $a2, $s0
    lui   $t0, 0x20
    add   $a3, $a3, $t0
.LA400035C:
    addiu $v1, $v1, 1
    slt   $t0, $v1, $t5
    bnez  $t0, .LA4000274
     nop
    lui   $t2, %hi(PHYS_TO_K1|RI_REFRESH_REG)
    sll   $s2, $s2, 0x13
    lui   $t1, (0x00063634 >> 16)
    ori   $t1, (0x00063634 & 0xFFFF)
    or    $t1, $t1, $s2
    sw    $t1, %lo(PHYS_TO_K1|RI_REFRESH_REG)($t2)
    lw    $t1, %lo(PHYS_TO_K1|RI_REFRESH_REG)($t2)
    lui   $t0, (0xA0000300 >> 16)
    ori   $t0, (0xA0000300 & 0xFFFF)
    lui   $t1, (0x0FFFFFFF >> 16)
    ori   $t1, (0x0FFFFFFF & 0xFFFF)
    and   $s6, $s6, $t1
    sw    $s6, 0x18($t0)
    move  $sp, $fp
    addiu $sp, $sp, 0x48
    lw    $s3, ($sp)
    lw    $s4, 4($sp)
    lw    $s5, 8($sp)
    lw    $s6, 0xc($sp)
    lw    $s7, 0x10($sp)
    addiu $sp, $sp, 0x18
    lui   $t0, %hi(EXCEPTION_TLB_MISS)
    addiu $t0, $t0, %lo(EXCEPTION_TLB_MISS)
    addiu $t1, $t0, 0x4000
    addiu $t1, $t1, -0x20
    mtc0  $zero, $28
    mtc0  $zero, $29
.LA40003D8:
    cache 8, ($t0)
    sltu  $at, $t0, $t1
    bnez  $at, .LA40003D8
     addiu $t0, $t0, 0x20
    lui   $t0, %hi(EXCEPTION_TLB_MISS)
    addiu $t0, %lo(EXCEPTION_TLB_MISS)
    addiu $t1, $t0, 0x2000
    addiu $t1, $t1, -0x10
.LA40003F8:
    cache 9, ($t0)
    sltu  $at, $t0, $t1
    bnez  $at, .LA40003F8
     addiu $t0, $t0, 0x10
    b     .LA4000458
     nop
.LA4000410:
    lui   $t0, %hi(EXCEPTION_TLB_MISS)
    addiu $t0, %lo(EXCEPTION_TLB_MISS)
    addiu $t1, $t0, 0x4000
    addiu $t1, $t1, -0x20
    mtc0  $zero, $28
    mtc0  $zero, $29
.LA4000428:
    cache 8, ($t0)
    sltu  $at, $t0, $t1
    bnez  $at, .LA4000428
     addiu $t0, $t0, 0x20
    lui   $t0, %hi(EXCEPTION_TLB_MISS)
    addiu $t0, %lo(EXCEPTION_TLB_MISS)
    addiu $t1, $t0, 0x2000
    addiu $t1, $t1, -0x10
.LA4000448:
    cache 1, ($t0)
    sltu  $at, $t0, $t1
    bnez  $at, .LA4000448
     addiu $t0, $t0, 0x10
.LA4000458:
    lui   $t2, %hi(SP_DMEM)
    addiu $t2, $t2, %lo(SP_DMEM)
    lui   $t3, 0xfff0
    lui   $t1, 0x0010
    and   $t2, $t2, $t3
    lui   $t0, %hi(SP_DMEM_UNK0)
    addiu $t1, -1
    lui   $t3, %hi(SP_DMEM_UNK1)
    addiu $t0, %lo(SP_DMEM_UNK0)
    addiu $t3, %lo(SP_DMEM_UNK1)
    and   $t0, $t0, $t1
    and   $t3, $t3, $t1
    lui   $t1, 0xa000
    or    $t0, $t0, $t2
    or    $t3, $t3, $t2
    addiu $t1, $t1, 0
.LA4000498:
    lw    $t5, ($t0)
    addiu $t0, $t0, 4
    sltu  $at, $t0, $t3
    addiu $t1, $t1, 4
    bnez  $at, .LA4000498
     sw    $t5, -4($t1)
    lui   $t4, %hi(EXCEPTION_TLB_MISS)
    addiu $t4, %lo(EXCEPTION_TLB_MISS)
    jr    $t4
     nop
    lui   $t3, %hi(D_B0000008)
    lw    $t1, %lo(D_B0000008)($t3)
    lui   $t2, (0x1FFFFFFF >> 16)
    ori   $t2, (0x1FFFFFFF & 0xFFFF)
    lui   $at, %hi(PHYS_TO_K1|PI_DRAM_ADDR_REG)
    and   $t1, $t1, $t2
    sw    $t1, %lo(PHYS_TO_K1|PI_DRAM_ADDR_REG)($at)
    lui   $t0, %hi(PHYS_TO_K1|PI_STATUS_REG)
.LA40004D0:
    lw    $t0, %lo(PHYS_TO_K1|PI_STATUS_REG)($t0)
    andi  $t0, $t0, 2
    bnezl $t0, .LA40004D0
     lui   $t0, %hi(PHYS_TO_K1|PI_STATUS_REG)
    li    $t0, 0x1000
    add   $t0, $t0, $t3
    and   $t0, $t0, $t2
    lui   $at, %hi(PHYS_TO_K1|PI_CART_ADDR_REG)
    sw    $t0, %lo(PHYS_TO_K1|PI_CART_ADDR_REG)($at)
    lui   $t2, 0x0010
    addiu $t2, 0xFFFF
    lui   $at, %hi(PHYS_TO_K1|PI_WR_LEN_REG)
    sw    $t2, %lo(PHYS_TO_K1|PI_WR_LEN_REG)($at)

.LA4000514:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    lui   $t3, %hi(PHYS_TO_K1|PI_STATUS_REG)
    lw    $t3, %lo(PHYS_TO_K1|PI_STATUS_REG)($t3)
    andi  $t3, $t3, 0x1
    bnez  $t3, .LA4000514
     nop
    lui   $t3, %hi(D_B0000008)
    lw    $a0, %lo(D_B0000008)($t3)
    move  $a1, $s6
    lui   $at, (0x5D588B65 >> 16)
    ori   $at, (0x5D588B65 & 0xFFFF)
    multu $a1, $at
    addiu $sp, $sp, -0x20
    sw    $ra, 0x1c($sp)
    sw    $s0, 0x14($sp)
    lui   $ra, 0x10
    move  $v1, $zero
    move  $t0, $zero
    move  $t1, $a0
    li    $t5, 32
    mflo  $v0
    addiu $v0, $v0, 1
    move  $a3, $v0
    move  $t2, $v0
    move  $t3, $v0
    move  $s0, $v0
    move  $a2, $v0
    move  $t4, $v0
.LA40005F0:
    lw    $v0, ($t1)
    addu  $v1, $a3, $v0
    sltu  $at, $v1, $a3
    beqz  $at, .LA4000608
     move  $a1, $v1
    addiu $t2, $t2, 1
.LA4000608:
    andi  $v1, $v0, 0x1f
    subu  $t7, $t5, $v1
    srlv  $t8, $v0, $t7
    sllv  $t6, $v0, $v1
    or    $a0, $t6, $t8
    sltu  $at, $a2, $v0
    move  $a3, $a1
    xor   $t3, $t3, $v0
    beqz  $at, .LA400063C
     addu  $s0, $s0, $a0
    xor   $t9, $a3, $v0
    b     .LA4000640
     xor   $a2, $t9, $a2
.LA400063C:
    xor   $a2, $a2, $a0
.LA4000640:
    addiu $t0, $t0, 4
    xor   $t7, $v0, $s0
    addiu $t1, $t1, 4
    bne   $t0, $ra, .LA40005F0
     addu  $t4, $t7, $t4
    xor   $t6, $a3, $t2
    xor   $a3, $t6, $t3
    xor   $t8, $s0, $a2
    xor   $s0, $t8, $t4
    lui   $t3, %hi(D_B0000010)
    lw    $t0, %lo(D_B0000010)($t3)
    bne   $a3, $t0, halt
     nop
    lw    $t0, %lo(D_B0000014)($t3)
    bne   $s0, $t0, halt
     nop
    bal   func_A4000690
     nop

halt: # checksum fail
    bal   halt
     nop

func_A4000690:
    lui   $t1, %hi(PHYS_TO_K1|SP_PC_REG)
    lw    $t1, %lo(PHYS_TO_K1|SP_PC_REG)($t1)
    lw    $s0, 0x14($sp)
    lw    $ra, 0x1c($sp)
    beqz  $t1, .LA40006BC
     addiu $sp, $sp, 0x20
    li    $t2, 65
    lui   $at, %hi(PHYS_TO_K1|SP_STATUS_REG)
    sw    $t2, %lo(PHYS_TO_K1|SP_STATUS_REG)($at)
    lui   $at, %hi(PHYS_TO_K1|SP_PC_REG)
    sw    $zero, %lo(PHYS_TO_K1|SP_PC_REG)($at)
.LA40006BC:
    lui   $t3, (0x00AAAAAE >> 16)
    ori   $t3, (0x00AAAAAE & 0xFFFF)
    lui   $at, %hi(PHYS_TO_K1|SP_STATUS_REG)
    sw    $t3, %lo(PHYS_TO_K1|SP_STATUS_REG)($at)
    lui   $at, %hi(PHYS_TO_K1|MI_INTR_MASK_REG)
    li    $t0, 1365
    sw    $t0, %lo(PHYS_TO_K1|MI_INTR_MASK_REG)($at)
    lui   $at, %hi(PHYS_TO_K1|SI_STATUS_REG)
    sw    $zero, %lo(PHYS_TO_K1|SI_STATUS_REG)($at)
    lui   $at, %hi(PHYS_TO_K1|AI_STATUS_REG)
    sw    $zero, %lo(PHYS_TO_K1|AI_STATUS_REG)($at)
    lui   $at, %hi(PHYS_TO_K1|MI_MODE_REG)
    li    $t1, 2048
    sw    $t1, %lo(PHYS_TO_K1|MI_MODE_REG)($at)
    li    $t1, 2
    lui   $at, %hi(PHYS_TO_K1|PI_STATUS_REG)
    lui   $t0, (0xA0000300 >> 16)
    ori   $t0, (0xA0000300 & 0xFFFF)
    sw    $t1, %lo(PHYS_TO_K1|PI_STATUS_REG)($at)
    sw    $s7, 0x14($t0)
    sw    $s5, 0xc($t0)
    sw    $s3, 0x4($t0)
    beqz  $s3, .LA4000728
     sw    $s4, ($t0)
    lui   $t1, 0xa600
    b     .LA4000730
     addiu $t1, $t1, 0
.LA4000728:
    lui   $t1, 0xb000
    addiu $t1, $t1, 0
.LA4000730:
    sw    $t1, 0x8($t0)
    lui   $t0, %hi(SP_DMEM)
    addiu $t0, %lo(SP_DMEM)
    addi  $t1, $t0, 0x1000
.LA4000740:
    addiu $t0, $t0, 4
    bne   $t0, $t1, .LA4000740
     sw    $zero, -4($t0)
    lui   $t0, %hi(SP_IMEM)
    addiu $t0, %lo(SP_IMEM)
    addi  $t1, $t0, 0x1000
.LA4000758:
    addiu $t0, $t0, 4
    bne   $t0, $t1, .LA4000758
     sw    $zero, -4($t0)
    lui   $t3, %hi(D_B0000008)
    lw    $t1, %lo(D_B0000008)($t3)
    jr    $t1
     nop
    nop

func_A4000778:
    addiu $sp, $sp, -0xa0
    sw    $s0, 0x40($sp)
    sw    $s1, 0x44($sp)
    move  $s1, $zero
    move  $s0, $zero
    sw    $v0, ($sp)
    sw    $v1, 4($sp)
    sw    $a0, 8($sp)
    sw    $a1, 0xc($sp)
    sw    $a2, 0x10($sp)
    sw    $a3, 0x14($sp)
    sw    $t0, 0x18($sp)
    sw    $t1, 0x1c($sp)
    sw    $t2, 0x20($sp)
    sw    $t3, 0x24($sp)
    sw    $t4, 0x28($sp)
    sw    $t5, 0x2c($sp)
    sw    $t6, 0x30($sp)
    sw    $t7, 0x34($sp)
    sw    $t8, 0x38($sp)
    sw    $t9, 0x3c($sp)
    sw    $s2, 0x48($sp)
    sw    $s3, 0x4c($sp)
    sw    $s4, 0x50($sp)
    sw    $s5, 0x54($sp)
    sw    $s6, 0x58($sp)
    sw    $s7, 0x5c($sp)
    sw    $fp, 0x60($sp)
    sw    $ra, 0x64($sp)
.LA40007EC:
    jal   func_A4000880
     nop
    addiu $s0, $s0, 1
    slti  $t1, $s0, 4
    bnez  $t1, .LA40007EC
     addu  $s1, $s1, $v0
    srl   $a0, $s1, 2
    jal   func_A4000A40
     li    $a1, 1
    lw    $ra, 0x64($sp)
    srl   $v0, $s1, 2
    lw    $s1, 0x44($sp)
    lw    $v1, 4($sp)
    lw    $a0, 8($sp)
    lw    $a1, 0xc($sp)
    lw    $a2, 0x10($sp)
    lw    $a3, 0x14($sp)
    lw    $t0, 0x18($sp)
    lw    $t1, 0x1c($sp)
    lw    $t2, 0x20($sp)
    lw    $t3, 0x24($sp)
    lw    $t4, 0x28($sp)
    lw    $t5, 0x2c($sp)
    lw    $t6, 0x30($sp)
    lw    $t7, 0x34($sp)
    lw    $t8, 0x38($sp)
    lw    $t9, 0x3c($sp)
    lw    $s0, 0x40($sp)
    lw    $s2, 0x48($sp)
    lw    $s3, 0x4c($sp)
    lw    $s4, 0x50($sp)
    lw    $s5, 0x54($sp)
    lw    $s6, 0x58($sp)
    lw    $s7, 0x5c($sp)
    lw    $fp, 0x60($sp)
    jr    $ra
     addiu $sp, $sp, 0xa0

func_A4000880:
    addiu $sp, $sp, -0x20
    sw    $ra, 0x1c($sp)
    move  $t1, $zero
    move  $t3, $zero
    move  $t4, $zero
.LA4000894:
    slti  $k0, $t4, 0x40
    beql  $k0, $zero, .LA40008FC
     move  $v0, $zero
    jal   func_A400090C
     move  $a0, $t4
    blezl $v0, .LA40008CC
     slti  $k0, $t1, 0x50
    subu  $k0, $v0, $t1
    multu $k0, $t4
    move  $t1, $v0
    mflo  $k0
    addu  $t3, $t3, $k0
    nop
    slti  $k0, $t1, 0x50
.LA40008CC:
    bnez  $k0, .LA4000894
     addiu $t4, $t4, 1
    sll   $a0, $t3, 2
    subu  $a0, $a0, $t3
    sll   $a0, $a0, 2
    subu  $a0, $a0, $t3
    sll   $a0, $a0, 1
    jal   func_A4000980
     addiu $a0, $a0, -0x370
    b     .LA4000900
     lw    $ra, 0x1c($sp)
    move  $v0, $zero
.LA40008FC:
    lw    $ra, 0x1c($sp)
.LA4000900:
    addiu $sp, $sp, 0x20
    jr    $ra
     nop

func_A400090C:
    addiu $sp, $sp, -0x28
    sw    $ra, 0x1c($sp)
    move  $v0, $zero
    jal   func_A4000A40
     li    $a1, 2
    move  $fp, $zero
    li    $k0, -1
.LA4000928:
    sw    $k0, 4($s4)
    lw    $v1, 4($s4)
    sw    $k0, ($s4)
    sw    $k0, ($s4)
    move  $gp, $zero
    srl   $v1, $v1, 0x10
.LA4000940:
    andi  $k0, $v1, 1
    beql  $k0, $zero, .LA4000954
     addiu $gp, $gp, 1
    addiu $v0, $v0, 1
    addiu $gp, $gp, 1
.LA4000954:
    slti  $k0, $gp, 8
    bnez  $k0, .LA4000940
     srl   $v1, $v1, 1
    addiu $fp, $fp, 1
    slti  $k0, $fp, 0xa
    bnezl $k0, .LA4000928
     li    $k0, -1
    lw    $ra, 0x1c($sp)
    addiu $sp, $sp, 0x28
    jr    $ra
     nop

func_A4000980:
    addiu $sp, $sp, -0x28
    sw    $ra, 0x1c($sp)
    sw    $a0, 0x20($sp)
    sb    $zero, 0x27($sp)
    move  $t0, $zero
    move  $t2, $zero
    li    $t5, 51200
    move  $t6, $zero
    slti  $k0, $t6, 0x40
.LA40009A4:
    bnezl $k0, .LA40009B8
     move  $a0, $t6
    b     .LA4000A30
     move  $v0, $zero
    move  $a0, $t6
.LA40009B8:
    jal   func_A4000A40
     li    $a1, 1
    jal   func_A4000AD0
     addiu $a0, $sp, 0x27
    jal   func_A4000AD0
     addiu $a0, $sp, 0x27
    lbu   $k0, 0x27($sp)
    li    $k1, 800
    lw    $a0, 0x20($sp)
    multu $k0, $k1
    mflo  $t0
    subu  $k0, $t0, $a0
    bgezl $k0, .LA40009F8
     slt   $k1, $k0, $t5
    subu  $k0, $a0, $t0
    slt   $k1, $k0, $t5
.LA40009F8:
    beql  $k1, $zero, .LA4000A0C
     lw    $a0, 0x20($sp)
    move  $t5, $k0
    move  $t2, $t6
    lw    $a0, 0x20($sp)
.LA4000A0C:
    slt   $k1, $t0, $a0
    beql  $k1, $zero, .LA4000A2C
     addu  $v0, $t2, $t6
    addiu $t6, $t6, 1
    slti  $k1, $t6, 0x41
    bnezl $k1, .LA40009A4
     slti  $k0, $t6, 0x40
    addu  $v0, $t2, $t6
.LA4000A2C:
    srl   $v0, $v0, 1
.LA4000A30:
    lw    $ra, 0x1c($sp)
    addiu $sp, $sp, 0x28
    jr    $ra
     nop

func_A4000A40:
    addiu $sp, $sp, -0x28
    andi  $a0, $a0, 0xff
    li    $k1, 1
    xori  $a0, $a0, 0x3f
    sw    $ra, 0x1c($sp)
    bne   $a1, $k1, .LA4000A64
     lui   $t7, 0x4600
    lui   $k0, 0x8000
    or    $t7, $t7, $k0
.LA4000A64:
    andi  $k0, $a0, 1
    sll   $k0, $k0, 6
    or    $t7, $t7, $k0
    andi  $k0, $a0, 2
    sll   $k0, $k0, 0xd
    or    $t7, $t7, $k0
    andi  $k0, $a0, 4
    sll   $k0, $k0, 0x14
    or    $t7, $t7, $k0
    andi  $k0, $a0, 8
    sll   $k0, $k0, 4
    or    $t7, $t7, $k0
    andi  $k0, $a0, 0x10
    sll   $k0, $k0, 0xb
    or    $t7, $t7, $k0
    andi  $k0, $a0, 0x20
    sll   $k0, $k0, 0x12
    or    $t7, $t7, $k0
    li    $k1, 1
    bne   $a1, $k1, .LA4000AC0
     sw    $t7, ($s5)
    lui   $k0, %hi(PHYS_TO_K1|MI_MODE_REG)
    sw    $zero, %lo(PHYS_TO_K1|MI_MODE_REG)($k0)
.LA4000AC0:
    lw    $ra, 0x1c($sp)
    addiu $sp, $sp, 0x28
    jr    $ra
     nop

func_A4000AD0:
    addiu $sp, $sp, -0x28
    sw    $ra, 0x1c($sp)
    li    $k0, 0x2000
    lui   $k1, %hi(PHYS_TO_K1|MI_MODE_REG)
    sw    $k0, %lo(PHYS_TO_K1|MI_MODE_REG)($k1)
    move  $fp, $zero
    lw    $fp, ($s5)
    li    $k0, 0x1000
    sw    $k0, %lo(PHYS_TO_K1|MI_MODE_REG)($k1)
    li    $k1, 0x40
    and   $k1, $k1, $fp
    srl   $k1, $k1, 6
    move  $k0, $zero
    or    $k0, $k0, $k1
    li    $k1, 0x4000
    and   $k1, $k1, $fp
    srl   $k1, $k1, 0xd
    or    $k0, $k0, $k1
    li    $k1, 0x400000
    and   $k1, $k1, $fp
    srl   $k1, $k1, 0x14
    or    $k0, $k0, $k1
    li    $k1, 0x80
    and   $k1, $k1, $fp
    srl   $k1, $k1, 4
    or    $k0, $k0, $k1
    li    $k1, 0x8000
    and   $k1, $k1, $fp
    srl   $k1, $k1, 0xb
    or    $k0, $k0, $k1
    li    $k1, 0x800000
    and   $k1, $k1, $fp
    srl   $k1, $k1, 0x12
    or    $k0, $k0, $k1
    sb    $k0, ($a0)
    lw    $ra, 0x1c($sp)
    addiu $sp, $sp, 0x28
    jr    $ra
     nop
    nop

.endif

# 0xA4000B70-0xA4000FFF: IPL3 Font
glabel ipl3_font
.incbin "textures/raw/ipl3_font_00.ia1"
.incbin "textures/raw/ipl3_font_01.ia1"
.incbin "textures/raw/ipl3_font_02.ia1"
.incbin "textures/raw/ipl3_font_03.ia1"
.incbin "textures/raw/ipl3_font_04.ia1"
.incbin "textures/raw/ipl3_font_05.ia1"
.incbin "textures/raw/ipl3_font_06.ia1"
.incbin "textures/raw/ipl3_font_07.ia1"
.incbin "textures/raw/ipl3_font_08.ia1"
.incbin "textures/raw/ipl3_font_09.ia1"
.incbin "textures/raw/ipl3_font_10.ia1"
.incbin "textures/raw/ipl3_font_11.ia1"
.incbin "textures/raw/ipl3_font_12.ia1"
.incbin "textures/raw/ipl3_font_13.ia1"
.incbin "textures/raw/ipl3_font_14.ia1"
.incbin "textures/raw/ipl3_font_15.ia1"
.incbin "textures/raw/ipl3_font_16.ia1"
.incbin "textures/raw/ipl3_font_17.ia1"
.incbin "textures/raw/ipl3_font_18.ia1"
.incbin "textures/raw/ipl3_font_19.ia1"
.incbin "textures/raw/ipl3_font_20.ia1"
.incbin "textures/raw/ipl3_font_21.ia1"
.incbin "textures/raw/ipl3_font_22.ia1"
.incbin "textures/raw/ipl3_font_23.ia1"
.incbin "textures/raw/ipl3_font_24.ia1"
.incbin "textures/raw/ipl3_font_25.ia1"
.incbin "textures/raw/ipl3_font_26.ia1"
.incbin "textures/raw/ipl3_font_27.ia1"
.incbin "textures/raw/ipl3_font_28.ia1"
.incbin "textures/raw/ipl3_font_29.ia1"
.incbin "textures/raw/ipl3_font_30.ia1"
.incbin "textures/raw/ipl3_font_31.ia1"
.incbin "textures/raw/ipl3_font_32.ia1"
.incbin "textures/raw/ipl3_font_33.ia1"
.incbin "textures/raw/ipl3_font_34.ia1"
.incbin "textures/raw/ipl3_font_35.ia1"
.incbin "textures/raw/ipl3_font_36.ia1"
.incbin "textures/raw/ipl3_font_37.ia1"
.incbin "textures/raw/ipl3_font_38.ia1"
.incbin "textures/raw/ipl3_font_39.ia1"
.incbin "textures/raw/ipl3_font_40.ia1"
.incbin "textures/raw/ipl3_font_41.ia1"
.incbin "textures/raw/ipl3_font_42.ia1"
.incbin "textures/raw/ipl3_font_43.ia1"
.incbin "textures/raw/ipl3_font_44.ia1"
.incbin "textures/raw/ipl3_font_45.ia1"
.incbin "textures/raw/ipl3_font_46.ia1"
.incbin "textures/raw/ipl3_font_47.ia1"
.incbin "textures/raw/ipl3_font_48.ia1"
.incbin "textures/raw/ipl3_font_49.ia1"
.fill 0x12
