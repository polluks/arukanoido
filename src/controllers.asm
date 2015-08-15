bonus_probability = %11

ctrl_vaus_left:
    lda #0              ; Fetch joystick status.
    sta $9113
    lda $9111
    sta joystick_status

    lda $9008
    cmp old_paddle_value
    bne paddle_change
    lda is_using_paddle
    bne paddle_fire
    beq joy

paddle_change:
    sta is_using_paddle
    jsr neg
    lsr
    and #%11111110
    cmp #8
    bcs +n
    lda #8
n:  cmp #@(- (* 14 8) 16)
    bcc +n
    lda #@(- (* 14 8) 16)
n:  sec
    sbc sprites_x,x
    sta tmp2
    jsr sprite_right

    stx tmp
    ldx #@(-- num_sprites)
l:  lda sprites_i,x
    and #catched_ball
    beq +n
    lda tmp2
    jsr sprite_right
n:  dex
    bpl -l
r:  ldx tmp

paddle_fire:
    lda joystick_status
    and #joy_left
    beq do_fire

joy:
    lda joystick_status

    and #joy_fire
    bne no_fire
do_fire:
    ; XXX only one catched ball
    ldy #@(- num_sprites 2)
l:  lda sprites_i,y
    and #%11111101
    sta sprites_i,y
    dey
    bpl -l

    lda mode
    cmp #mode_laser
    bne no_fire

    lda is_firing
    beq fire
    dec is_firing
    bne no_fire

fire:
    lda #9
    sta is_firing
    lda sprites_x,x
    clc
    adc #4
    sta laser_init
    ldy #@(- laser_init sprite_inits)
    jsr add_sprite

no_fire:
    ; Joystick left.
n:  lda joystick_status
    and #joy_left
    bne +n
    lda sprites_x,x
    cmp #9
    bcc +n
    lda #2
    jsr sprite_left

    stx tmp
    ldx #@(-- num_sprites)
l:  lda sprites_i,x
    and #catched_ball
    jsr sprite_left
    dex
    bpl -l
r:  ldx tmp
    rts

    ; Joystick right.
n:  lda #0          ;Fetch rest of joystick status.
    sta $9122
    lda $9120
    bmi ctrl_dummy
    lda sprites_x,x
    cmp #@(* (- screen_columns 3) 8)
    bcs ctrl_dummy
    lda #2
    jsr sprite_right

    stx tmp
    ldx #@(-- num_sprites)
l:  lda sprites_i,x
    and #catched_ball
    jsr sprite_right
    dex
    bpl -l

ctrl_dummy:
    rts

ctrl_vaus_right:
    lda @(+ sprites_x (- num_sprites 1))
    clc
    adc #8
    sta sprites_x,x
    rts

ctrl_laser:
    lda sprites_y,x
    cmp #24
    bcc +n
    lda sprites_x,x
    ldy sprites_y,x
    jsr get_soft_collision
    bne +o
    jsr hit_brick
    bcc +n
o:  lda sprites_x,x
    clc
    adc #7
    ldy sprites_y,x
    jsr get_soft_collision
    bne +m
    jsr hit_brick
    bcc +n
m:  lda #8
m:  lda #8
    jmp sprite_up
n:  jmp remove_sprite
