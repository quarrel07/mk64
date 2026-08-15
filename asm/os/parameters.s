
.ifdef VERSION_EU
.set NO_PARAM_NOPS, 1
.endif
.ifdef VERSION_JP
.set NO_PARAM_NOPS, 1
.endif

.ifdef NO_PARAM_NOPS
.macro gsymbol sym addr
.global \sym
.set \sym, \addr
.endm

.else

.macro gsymbol sym addr
.global \sym
.set \sym, \addr
nop
nop
.endm

.endif

.text
gsymbol osTvType 0x80000300
gsymbol osRomType 0x80000304
gsymbol osRomBase 0x80000308
gsymbol osResetType 0x8000030C
gsymbol osCiCId 0x80000310
gsymbol osVersion 0x80000314
gsymbol osMemSize 0x80000318
gsymbol osAppNmiBuffer 0x8000031C

.ifdef VERSION_CN
/* iQue kernel globals live in the boot-area page right after the standard
   parameters; absolute addresses (no text emitted), same map as sm64 cn */
.macro bbsymbol sym addr
.global \sym
.set \sym, \addr
.endm
bbsymbol __osBbEepromAddress 0x8000035C
bbsymbol __osBbEepromSize 0x80000360
bbsymbol __osBbFlashAddress 0x80000364
bbsymbol __osBbFlashSize 0x80000368
bbsymbol __osBbSramAddress 0x8000036C
bbsymbol __osBbSramSize 0x80000370
bbsymbol __osBbPakAddress 0x80000374
bbsymbol __osBbPakSize 0x80000384
bbsymbol __osBbIsBb 0x80000388
bbsymbol __osBbHackFlags 0x8000038C
.endif
