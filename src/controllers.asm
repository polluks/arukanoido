paddle_xlat: @(paddle-xlat)

wait:
l:  lda #0
    sta $9113
    lda $9111
    and #joy_fire
    bne -l
l:  lda #0
    sta $9113
    lda $9111
    and #joy_fire
    beq -l
    rts

ctrl_vaus_left:
    lda #0              ; Fetch joystick status.
    sta $9113
    lda $9111
    sta joystick_status

    lda is_using_paddle
    bne +p

    ; Check if paddle is being used.
    lda $9008
    cmp old_paddle_value
    beq joy             ; Nope…
    lda #1              ; Yes, lock the joystick.
    sta is_using_paddle

p:  ldy $9008
    lda paddle_xlat,y
    sec
    sbc sprites_x,x
    sta tmp2
    jsr sprite_right

    ; Move caught ball relative to Vaus.
    lda caught_ball
    bmi +n
    stx tmp
    tax
    lda tmp2
    jsr sprite_right
    ldx tmp

n:  lda joystick_status
    and #joy_left
    beq do_fire
    bne no_fire

joy:
    ; Joystick left.
n:  lda joystick_status
    and #joy_left
    bne +n
    lda sprites_x,x
    cmp #9
    bcc +n
    lda #2
    jsr sprite_left

    lda caught_ball
    bmi +r
    stx tmp
    tax
    lda #2
    jsr sprite_left
    ldx tmp
r:  rts

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

    lda caught_ball
    bmi +r
    stx tmp
    tax
    lda #2
    jsr sprite_right
    ldx tmp
r:

    lda joystick_status
    and #joy_fire
    bne no_fire

do_fire:
    lda #255
    sta caught_ball

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
ctrl_dummy:
    rts

ctrl_vaus_right:
    lda @(+ sprites_x (- num_sprites 1))
    clc
    adc #8
    sta sprites_x,x
    rts

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
