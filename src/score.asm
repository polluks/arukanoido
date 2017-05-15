scores:
    0 0 0 0 0 5 0
score_50:
    0 0 0 0 0 6 0
score_60:
    0 0 0 0 0 7 0
score_70:
    0 0 0 0 0 8 0
score_80:
    0 0 0 0 0 9 0
score_90:
    0 0 0 0 1 0 0
score_100:
    0 0 0 0 1 1 0
score_110:
    0 0 0 0 1 2 0
score_120:

color_scores:
    0
    @(- score_50 scores)
    @(- score_90 scores)
    @(- score_70 scores)
    @(- score_110 scores)
    @(- score_80 scores)
    @(- score_100 scores)
    @(- score_120 scores)
    @(- score_60 scores)

score: @(maptimes [identity 0] num_score_digits)

init_score:
    ldx #@(-- num_score_digits)
l:  lda #score_char0
    sta score,x
    dex
    bpl -l
    rts

init_hiscore:
    ldx #@(-- num_score_digits)
l:  lda #score_char0
    sta hiscore,x
    dex
    bpl -l
    rts

display_score:
    ldx #@(-- num_score_digits)
l:  lda score,x
    sta score_on_screen,x
    lda #white
    sta @(+ (- score_on_screen screen) colors),x
    lda hiscore,x
    sta hiscore_on_screen,x
    lda #white
    sta @(+ (- hiscore_on_screen screen) colors),x
    dex
    bpl -l
    rts

add_to_score:
    txa
    pha
    tya
    pha

    ldx #@(-- num_score_digits)
    clc
l:  lda score,x
    adc @(-- scores),y
    cmp #@(+ score_char0 10)
    bcc +n
    cpx #@(- num_score_digits 4)
    bne +j
    pha
    txa
    pha
    jsr apply_bonus_p
    pla
    tax
    pla
j:  sec
    sbc #10
n:  sta score,x
    dey
    dex
    bpl -l

    ; Compare score with hiscore.
    inx
    ldy #@(-- num_score_digits)
loop:
    lda score,x
    cmp hiscore,x
    beq +next
    bcc +done

    ; Copy score to highscore.
new_hiscore:
    ldx #@(-- num_score_digits)
l:  lda score,x
    sta hiscore,x
    dex
    bpl -l

next:
    inx
    dey
    bpl -loop

done:
    jsr display_score
    pla
    tay
    pla
    tax
    rts
