# JP 1.0-only leaf, absent from us, both EU revisions and JP 1.1.
# Reached from camera_start_cinematic_shot's switch (case 10); zeroes a run
# of camera globals and sets one to 1.0f. Its absence was the 0x40 the
# accounting wrongly attributed to func_800188F4.
#
# Emitted as literal words, not yet relocated, like its neighbors.

.section .text, "ax"

glabel func_80019068
/* 019C68 80019068 */ .word 0x44800000
/* 019C6C 8001906C */ .word 0x3C018016
/* 019C70 80019070 */ .word 0xE420207C
/* 019C74 80019074 */ .word 0x3C018016
/* 019C78 80019078 */ .word 0xE4202080
/* 019C7C 8001907C */ .word 0x3C013F80
/* 019C80 80019080 */ .word 0x44812000
/* 019C84 80019084 */ .word 0x3C018016
/* 019C88 80019088 */ .word 0xE4242084
/* 019C8C 8001908C */ .word 0x3C018016
/* 019C90 80019090 */ .word 0xE4202088
/* 019C94 80019094 */ .word 0x3C018016
/* 019C98 80019098 */ .word 0xE420208C
/* 019C9C 8001909C */ .word 0x3C018016
/* 019CA0 800190A0 */ .word 0x03E00008
/* 019CA4 800190A4 */ .word 0xE42020A0
