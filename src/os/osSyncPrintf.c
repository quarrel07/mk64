#include "libultra_internal.h"
#include "libc/stdarg.h"
#include "printf.h"

// These funcs defined in is_debug.c
#ifndef DEBUG

#ifdef VERSION_CN
/* iQue stubbed the whole printf path, dropping the ANSI formatter subtree
   (_Printf/_Litob/_Ldtob/string/ldiv) from the link. Three functions: the
   prout callback is not varargs so it compiles to a bare jr $ra (cart
   0x800CBE60), then the two empty varargs bodies at 0x800CBE68 (the one the
   five call sites reach) and 0x800CBE7C. */
char* proutSyncPrintf(UNUSED char* arg0, UNUSED const char* arg1, UNUSED size_t size) {
}

void rmonPrintf(UNUSED const char* fmt, ...) {
}

void osSyncPrintf(UNUSED const char* fmt, ...) {
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
