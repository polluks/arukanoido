c_setzw=1
c_setsd=2
c_clrmb=3
c_apply=4
syscall_vectors_l: <setzw <setsd <clrmb <apply
syscall_vectors_h: >setzw >setsd >clrmb >apply
syscall_args_l: <args_setzw <args_setsd <args_clrmb <args_apply
syscall_args_h: >args_setzw >args_setsd >args_clrmb >args_apply
args_setzw: 3 a0 a1 a2
args_setsd: 4 a0 a1 a2 a3
args_clrmb: 3 a0 a1 a2
args_apply: 0
