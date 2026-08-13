# Alignment padding: a second launch-build translation-unit boundary, three
# nop words on the cartridge between func_8005D1F4 and func_8005D290.

.section .text, "ax"

glabel pad_8005DE94
/* 05EA94 8005DE94 */ .word 0x00000000
/* 05EA98 8005DE98 */ .word 0x00000000
/* 05EA9C 8005DE9C */ .word 0x00000000
