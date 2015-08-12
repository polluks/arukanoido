draw_level:
    lda #0
    sta scrx
    tay
    lda (current_level),y
    iny
    sty tmp
    sta scry
    jsr scrcoladdr

l:  tya
    pha
    ldy tmp
    lda (current_level),y
    beq +done
    inc tmp
    pha
    and #15
    tax
    lda brick_colors,x
    sta curcol
    lda #bg_brick
    cpx #8
    bcc +n
    lda #bg_brick_special1
n:  sta @(++ +l2)
    pla
    lsr
    lsr
    lsr
    lsr
    tax
    pla
    tay
l2: lda #bg_brick
    jsr plot_brick
    dex
    bne -l2
    beq -l
    
done:
    pla
    lda current_level
    clc
    adc tmp
    sta current_level
    bcc +n
    inc @(++ current_level)
n:

    ; Correct border colors.
    ldy #0
l:  lda #@(+ multicolor white)
    sta (col),y
    tya
    clc
    adc #14
    bcs +r
    tay
    lda #@(+ multicolor white)
    sta (col),y
    iny
    bne -l

r:  rts

plot_brick:
    sta (scr),y
    lda curcol
    sta (col),y
    iny
    rts
