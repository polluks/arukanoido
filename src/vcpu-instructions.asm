; Call system function without argument mapping.
apply:
    lda (bcp),y
    tax
    dex
    jsr inc_bcp
    lda syscall_vectors_l,x
    sta @(+ 1 +mod_call)
    lda syscall_vectors_h,x
    sta @(+ 2 +mod_call)
mod_call:
    jmp $ffff
