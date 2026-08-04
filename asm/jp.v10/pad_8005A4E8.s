# Alignment padding: the launch build starts a new translation unit here,
# so its linker 16-aligned the next function. Two nop words on the cartridge
# between render_hud_4p_multi and func_80059820.

.section .text, "ax"

glabel pad_8005A4E8
/* 05B0E8 8005A4E8 */ .word 0x00000000
/* 05B0EC 8005A4EC */ .word 0x00000000
