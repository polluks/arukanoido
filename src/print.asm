; d: Destination
; A: char
; C: 0: left half, 1: right half
print4x8:
    stx p_x
    sty p_y
    php

    ldy #0
    sty tmp2
    asl
    rol tmp2
    asl
    rol tmp2
    asl
    rol tmp2
    clc
    adc #<charset4x8
    sta tmp
    lda tmp2
    adc #>charset4x8
    sta tmp2

    plp
    bcs +n

    ldy #7
l:  lda (tmp),y
    asl
    asl
    asl
    asl
    sta (d),y
    dey
    bpl -l
    bmi +r

n:  ldy #7
l:  lda (tmp),y
    ora (d),y
    sta (d),y
    dey
    bpl -l

r:  ldx p_x
    ldy p_y
    rts
