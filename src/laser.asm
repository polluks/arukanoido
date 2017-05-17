ctrl_laser:
    ; We check two collisions, on the left and the right, so we need this flag.
    lda #0              ; No brick hit.
    sta laser_has_hit
    sta was_golden

    lda sprites_y,x
    cmp #24
    bcc +n              ; Laser left the playfield.

    ; Check on collision on the left hand side.
    lda sprites_x,x
    ldy sprites_y,x
    jsr get_soft_collision
    bne +o              ; Nothing, try on the right…
    jsr hit_brick
    bcs +o              ; No brick hit.
    inc laser_has_hit

    ; Check on collision on the right hand side.
o:  lda sprites_x,x
    clc
    adc #7
    ldy sprites_y,x
    jsr get_soft_collision
    bne +m
    jsr hit_brick
    bcc +n              ; We hit a brick…

    ; Move laser up unless it hit a brick with its left.
m:  lda laser_has_hit
    ora was_golden
    bne +n
    lda #8
    jmp sprite_up

n:  jmp remove_sprite   ; Remove laser sprite.
