lifes_on_screen = @(+ (* 31 15) 1 screen)
lifes_on_colors = @(+ (* 31 15) 1 colors)

draw_lifes:
    txa
    pha
    ldx lifes
    dex
    cpx #13
    bcs +n
    lda #0
    sta lifes_on_screen,x
l:  cpx #14
    bcs +n
    cpx #0
    beq +done
    lda #bg_minivaus
    sta @(-- lifes_on_screen),x
    lda #@(+ multicolor white)
    sta @(-- lifes_on_colors),x
n:  dex
    jmp -l
done:
    pla
    tax
    rts
