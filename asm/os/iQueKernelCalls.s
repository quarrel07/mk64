# iQue OS kernel-call stubs: each loads a call number and reads the MI
# secure-kernel exception register, which traps into the iQue OS. The cart
# carries the full block (ids 0x00-0x14) at 0x800CFBB0..0x800CFDFC, right
# after __osDevMgrMain. Mirrors sm64's lib/asm/iQueKernelCalls.s.
.ifdef VERSION_CN

.set noat
.set noreorder

.macro skcall label, num
.global \label
\label:
    li    $v0, \num
    lui   $t0, 0xA430
    ori   $t0, $t0, 0x0014
    lw    $t1, ($t0)
    nop
    jr    $ra
     nop
.endm

.section .text, "ax"

skcall skGetId, 0x0
skcall skLaunchSetup, 0x1
skcall skLaunch, 0x2
skcall skRecryptListValid, 0x3
skcall skRecryptBegin, 0x4
skcall skRecryptData, 0x5
skcall skRecryptComputeState, 0x6
skcall skRecryptEnd, 0x7
skcall skSignHash, 0x8
skcall skVerifyHash, 0x9
skcall skGetConsumption, 0xa
skcall skAdvanceTicketWindow, 0xb
skcall skSetLimit, 0xc
skcall skExit, 0xd
skcall skKeepAlive, 0xe

# developer calls
skcall sk0f, 0x0f
skcall sk10, 0x10
skcall sk11, 0x11
skcall sk12, 0x12
skcall sk13, 0x13
skcall sk14, 0x14

.endif
