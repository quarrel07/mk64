#include "libultra_internal.h"

#ifndef VERSION_CN /* absent on the iQue cart (dead code dropped) */
void guScaleF(float mf[4][4], float x, float y, float z) {
    guMtxIdentF(mf);
    mf[0][0] = x;
    mf[1][1] = y;
    mf[2][2] = z;
    mf[3][3] = 1.0;
}

#endif
#ifndef VERSION_CN /* iQue uses the asm body in guScale_cn.s */
void guScale(Mtx* m, float x, float y, float z) {
    float mf[4][4];
    guScaleF(mf, x, y, z);
    guMtxF2L(mf, m);
}
#endif
