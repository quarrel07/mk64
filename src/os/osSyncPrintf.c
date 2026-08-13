#include "libultra_internal.h"
#include "libc/stdarg.h"
#include "printf.h"

// These funcs defined in is_debug.c
#ifndef DEBUG

#ifdef VERSION_CN
/* iQue stubbed both printfs to empty varargs bodies (cart 0x800cbe54/68:
   just the four-register vararg homing and jr $ra), which drops the whole
   ANSI formatter subtree (_Printf/_Litob/_Ldtob/string/ldiv) from the link */
void osSyncPrintf(UNUSED const char* fmt, ...) {
}

void rmonPrintf(UNUSED const char* fmt, ...) {
}
#else
char* osSyncPrintf(UNUSED char* arg0, UNUSED const char* arg1, UNUSED size_t size) {
    // ifdef'd formatting code?
    return (char*) (1);
}

void rmonPrintf(const char* fmt, ...) {
    va_list args;
    va_start(args, fmt);
    _Printf(osSyncPrintf, NULL, fmt, args);
    va_end(args);
}
#endif

#endif // DEBUG
