#include "libultra_internal.h"

#ifndef VERSION_CN /* absent on the iQue cart (dead code dropped) */
void guTranslateF(float m[4][4], float x, float y, float z) {
    guMtxIdentF(m);
    m[3][0] = x;
    m[3][1] = y;
    m[3][2] = z;
}

#endif
#ifndef VERSION_CN /* iQue uses the asm body in guTranslate_cn.s */
void guTranslate(Mtx* m, float x, float y, float z) {
    float mf[4][4];
    guTranslateF(mf, x, y, z);
    guMtxF2L(mf, m);
}
#endif
