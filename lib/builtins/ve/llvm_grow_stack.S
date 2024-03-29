// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.

#include "../assembly.h"

// grow_stack routine
// This routine is VE specific
// https://www.nec.com/en/global/prod/hpc/aurora/document/VE-ABI_v1.1.pdf

// destroy %s62 and %s63 only

#ifdef __ve__

.text
.p2align        4
DEFINE_COMPILERRT_FUNCTION(__llvm_grow_stack)
        lea             %s62, 15(%s0)           # (s0 + 15) / 16 * 16
        and             %s62, -16, %s62
        subu.l          %sp, %sp, %s62          # sp -= alloca size
        brge.l.t        %sp, %sl, 1f
        ld              %s63, 0x18(,%tp)        # load param area
        lea             %s62, 0x13b             # syscall # of grow
        shm.l           %s62, 0x0(%s63)         # stored at addr:0
        shm.l           %sl, 0x8(%s63)          # old limit at addr:8
        shm.l           %sp, 0x10(%s63)         # new limit at addr:16
        monc
1:
        b.l             (,%lr)
END_COMPILERRT_FUNCTION(__llvm_grow_stack)

#endif // __ve__
