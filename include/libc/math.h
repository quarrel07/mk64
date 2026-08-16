#ifndef MATH_H
#define MATH_H

#define M_PI 3.14159265358979323846

float sinf(float);
double sin(double);
float cosf(float);
double cos(double);

float sqrtf(float);
/* iQue inlines sqrt.s in most files (57 sites against the US ROM's 2), but not
   in src/audio/external.c, which calls libm sqrtf out of line. That file opts
   out by defining SQRTF_NOT_INTRINSIC ahead of its includes. */
#if defined(VERSION_CN) && !defined(SQRTF_NOT_INTRINSIC)
#pragma intrinsic (sqrtf)
#endif

#endif
