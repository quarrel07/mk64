#ifdef VERSION_CN
/* iQue compiles this file with EGCS (see Makefile for the opt level); this
   arm is the byte-exact body, via sm64's matched cn libultra */
#include "libultra_internal.h"

void guRotateF(float m[4][4], float a, float x, float y, float z) {
    static f32 pi_180 = GU_PI / 180.0f;
    f32 sin_a;
    f32 cos_a;
    f32 ab;
    f32 bc;
    f32 ca;
    f32 t;
#ifdef VERSION_CN
    f32 xs;
    f32 ys;
    f32 zs;
#else
    f32 xx, yy, zz;
#endif

    guNormalize(&x, &y, &z);

    a = a * pi_180;

    sin_a = sinf(a);
    cos_a = cosf(a);
    t = 1 - cos_a;

    ab = x * y * t;
    bc = y * z * t;
    ca = z * x * t;

    guMtxIdentF(m);

    // TODO: Merge IDO/GCC
#ifdef VERSION_CN
    xs = x * sin_a;
    t = x * x;
    m[0][0] = t + cos_a * (1 - t);
    m[2][1] = bc - xs;
    m[1][2] = bc + xs;

    ys = y * sin_a;
    t = y * y;
    m[1][1] = t + cos_a * (1 - t);
    m[2][0] = ca + ys;
    m[0][2] = ca - ys;

    zs = z * sin_a;
    t = z * z;
    m[2][2] = t + cos_a * (1 - t);
    m[1][0] = ab - zs;
    m[0][1] = ab + zs;
#else
    xx = x * x;
    m[0][0] = xx + cos_a * (1 - xx);
    m[2][1] = bc - (x * sin_a);
    m[1][2] = bc + (x * sin_a);

    yy = y * y;
    m[1][1] = yy + cos_a * (1 - yy);
    m[2][0] = ca + (y * sin_a);
    m[0][2] = ca - (y * sin_a);

    zz = z * z;
    m[2][2] = zz + cos_a * (1 - zz);
    m[1][0] = ab - (z * sin_a);
    m[0][1] = ab + (z * sin_a);
#endif
}

void guRotate(Mtx *m, float a, float x, float y, float z) {
    float mf[4][4];
    guRotateF(mf, a, x, y, z);
    guMtxF2L(mf, m);
}
#else
#include "libultra_internal.h"

void guRotateF(float m[4][4], float a, float x, float y, float z) {
    float sin_a;
    float cos_a;
    float sp2c;
    float sp28;
    float sp24;
    float xx, yy, zz;
    static float D_80365D70 = GU_PI / 180;

    guNormalize(&x, &y, &z);

    a = a * D_80365D70;

    sin_a = sinf(a);
    cos_a = cosf(a);

    sp2c = x * y * (1 - cos_a);
    sp28 = y * z * (1 - cos_a);
    sp24 = z * x * (1 - cos_a);

    guMtxIdentF(m);
    xx = x * x;
    m[0][0] = (1 - xx) * cos_a + xx;
    m[2][1] = sp28 - x * sin_a;
    m[1][2] = sp28 + x * sin_a;
    yy = y * y;
    m[1][1] = (1 - yy) * cos_a + yy;
    m[2][0] = sp24 + y * sin_a;
    m[0][2] = sp24 - y * sin_a;
    zz = z * z;
    m[2][2] = (1 - zz) * cos_a + zz;
    m[1][0] = sp2c - z * sin_a;
    m[0][1] = sp2c + z * sin_a;
}

void guRotate(Mtx* m, float a, float x, float y, float z) {
    float mf[4][4];
    guRotateF(mf, a, x, y, z);
    guMtxF2L(mf, m);
}
#endif
