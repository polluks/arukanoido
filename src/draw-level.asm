current_half:   0
bricks_in_line: 0

draw_level:
    lda #16
    sta bricks_in_line
    lda #0
    sta bricks_left
    sta scrx
    jsr fetch_brick
    sta scry
    jsr scrcoladdr
    jsr brick_inc

l:  jsr fetch_brick
    cmp #15
    beq +done
    tax
    lda @(-- brick_colors),x
    sta curcol
    txa
    cpx #0
    beq +n
    lda #bg_brick
    cpx #b_silver
    bcc +n
    cpx #b_golden
    bne +m
    dec bricks_left
    lda #bg_brick_special1
    jmp +n
m:  lda #bg_brick_special2
n:  jsr plot_brick
    jmp -l
    
done:
    rts

fetch_brick:
    dec bricks_in_line
    lda bricks_in_line
    and #%11111110
    bne +n
    lda #0
    ldx bricks_in_line
    bne -done
    ldx #15
    stx bricks_in_line
    jmp -done
n:  ldy #0
    lda (current_level),y
    ldx current_half
    bne +n
    lsr
    lsr
    lsr
    lsr
    inc current_half
    jmp +r
n:  and #$0f
    dec current_half
done:
    ldx #current_level

inc_zp:
    inc 0,x
    bne +r
    inc 1,x
r:  rts

plot_brick:
    cmp #0
    beq brick_inc
    ldy #0
    sta (scr),y
    lda curcol
    sta (col),y
    inc bricks_left
brick_inc:
    ldx #scr
    jsr inc_zp
    ldx #col
    jmp inc_zp

level_data: @+level-data+
