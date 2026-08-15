.set noreorder # don't insert nops after branches
.set gp=64

.include "macros.inc"


.section .text, "ax"



.ifdef VERSION_CN
# iQue body (via sm64's matched cn libultra asm); pseudo-ops may use $at
.set at
glabel __osDisableInt
    la    $t2, __OSGlobalIntMask
    lw    $t3, ($t2)
    andi  $t3, $t3, 0x0000ff00
    mfc0  $t0, $12
    and   $t1, $t0, ~0x00000001
    mtc0  $t1, $12
    andi  $v0, $t0, 0x00000001
    lw    $t0, ($t2)
    andi  $t0, $t0, 0x0000ff00
    beq   $t0, $t3, .Lret
     lui   $t2, %hi(__osRunningThread)
    addiu $t2, %lo(__osRunningThread)
    lw    $t1, 0x118($t2)
    andi  $t2, $t1, 0x0000ff00
    and   $t2, $t2, $t0
    and   $t1, $t1, ~0x0000ff00
    or    $t1, $t1, $t2
    and   $t1, $t1, ~0x00000001
    mtc0  $t1, $12
    nop
    nop
.Lret:
    jr    $ra
     nop
.set noat
.else
glabel __osDisableInt
  mfc0  $t0, C0_SR
  and   $t1, $t0, ~SR_IE
  mtc0  $t1, C0_SR
  andi  $v0, $t0, SR_IE
  nop
  jr    $ra
   nop


.endif
