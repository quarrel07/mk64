# iQue body, transcribed from the cart (0x800D31B0): standard libultra
# TLB wipe (entries 30..0), absent from the retail mk64 link. Called by the
# cn osInitialize between the vector setup and osMapTLBRdb.
.set noat
.set noreorder
.include "macros.inc"
.ifdef VERSION_CN
.section .text, "ax"
.balign 16
glabel osUnmapTLBAll
    mfc0  $t0, $10
    addiu $t1, $zero, 30
    lui   $t2, 0x8000
    mtc0  $t2, $10
    mtc0  $zero, $2
    mtc0  $zero, $3
.Lloop:
    mtc0  $t1, $0
    nop
    tlbwi
    nop
    nop
    addi  $t1, $t1, -1
    bgez  $t1, .Lloop
     nop
    mtc0  $t0, $10
    jr    $ra
     nop
.endif
