draw_level:
    lda #0
    sta scrx
    inc scrx
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
    lda @(-- brick_colors),x
    sta curcol
    lda #bg_brick
    cpx #0
    bne +n
    txa
n:  cpx #b_silver
    bcc +n
    cpx #b_golden
    bne +m
    dec bricks_left
    lda #bg_brick_special1
    jmp +n
m:  lda #bg_brick_special2
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
    sec     ; (Missing increment.)
    adc tmp
    sta current_level
    bcc +n
    inc @(++ current_level)
n:

    rts

plot_brick:
    cmp #0
    beq +n
    sta (scr),y
    lda curcol
    sta (col),y
    inc bricks_left
n:  iny
    rts
