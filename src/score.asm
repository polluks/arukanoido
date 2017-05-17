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
    @(- score_50 scores)    ; 1 white
    @(- score_90 scores)    ; 2 red
    @(- score_70 scores)    ; 3 cyan
    @(- score_110 scores)   ; 4 purple
    @(- score_80 scores)    ; 5 green
    @(- score_100 scores)   ; 6 blue
    @(- score_120 scores)   ; 7 yellow
    0 0 0 0 0 0 0
    @(- score_60 scores)    ; 15 orange

score: @(maptimes [identity 0] num_score_digits)

init_score:
    0
    c_setmb <score >score num_score_digits score_char0
    0
    rts

init_hiscore:
    0
    c_setmb <hiscore >hiscore num_score_digits score_char0
    0
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
