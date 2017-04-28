draw_sprites:
    ldx #@(-- num_sprites)
l:  sei
    lda sprites_i,x
    bmi +n

    lda #0
    sta foreground_collision
    jsr draw_sprite
    lda foreground_collision
    ora sprites_i,x
    sta sprites_i,x

    ; Remove remaining chars of sprites in old frame.
n:  lda sprites_i,x
    and #decorative
    beq +j
    cmp #$ff
    beq +n
j:  lda sprites_ox,x
    sta scrx                ; (upper left)
    lda sprites_oy,x
    sta scry
    jsr scraddr_clear_char
    inc scrx                ; (upper right)
    jsr clear_char
    dec scrx                ; (bottom left)
    inc scry
    jsr scraddr_clear_char
    inc scrx                ; (bottom right)
    jsr clear_char

    lda sprites_i,x
    and #decorative
    beq +m
    lda #$ff
    bne +k

    ; Save current position as old one.
m:  jsr xpixel_to_char
    sta sprites_ox,x
    lda sprites_y,x
    jsr pixel_to_char
k:  sta sprites_oy,x

    cli

    dex
    bpl -l
    rts

xpixel_to_char:
    lda sprites_x,x
pixel_to_char:
    lsr
    lsr
    lsr
    rts
