laser_has_hit: 0

ctrl_laser:
    lda #0
    sta laser_has_hit
    lda sprites_y,x
    cmp #24
    bcc +n
    lda sprites_x,x
    ldy sprites_y,x
    jsr get_soft_collision
    bne +o
    jsr hit_brick
    bcs +o
    inc laser_has_hit
o:  lda sprites_x,x
    clc
    adc #7
    ldy sprites_y,x
    jsr get_soft_collision
    bne +m
    jsr hit_brick
    bcc +n
    lda laser_has_hit
    bne +n
m:  lda #8
    jmp sprite_up
n:  jmp remove_sprite
