/**
 * @file code_8005D290.c
 * @brief The second half of code_80057C60.c, as iQue compiled it.
 *
 * On the cart everything from func_8005D290 down is its own object: the first
 * object's .text is padded to a 16-byte boundary and this one starts there.
 * Rather than copy four thousand lines, this compiles the same source with the
 * split point selected, so both halves stay one file to read and maintain.
 *
 * cn.v5 only - see the C_FILES filter in the Makefile.
 */

#define CODE_80057C60_TAIL 1
#include "code_80057C60.c"
