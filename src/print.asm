devcon_cursor_x:    0
devcon_cursor_y:    0
xpos:   0
ypos:   0

calcscr:
    rts

devcon_draw_char:
    ldy #0
    sty tmp2
    asl
    rol tmp2
    asl
    rol tmp2
    asl
    rol tmp2
    sta tmp
    lda tmp2
    ora #$20
    sta tmp2

    lda devcon_cursor_x
    asl
    asl
    sta xpos
    lda devcon_cursor_y
    asl
    asl
    asl
    sta ypos
    jsr calcscr

    lda devcon_cursor_x
    lsr
    bcs +n

    ldy #7
l:  lda (tmp),y
    asl
    asl
    asl
    asl
    ora (scr),y
    sta (scr),y
    dey
    bpl -l
    bmi +m

n:  ldy #7
l:  lda (tmp),y
    ora (scr),y
    sta (scr),y
    dey
    bpl -l

    rts
