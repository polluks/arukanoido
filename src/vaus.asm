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
    sec
    sbc old_paddle_value
    jsr abs
    and #%11111000
    beq joy             ; Nope…
    lda #1              ; Yes, lock the joystick.
    sta is_using_paddle

p:  ldy $9008
    lda paddle_xlat,y
    cmp #@(* (- screen_columns 3) 8)
    bcc +n
    ldy mode
    cpy #mode_break
    bne +m
    lda #0
    sta bricks_left
    rts
m:  lda #@(* (- screen_columns 3) 8)
n:  sec
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
    bne +f

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
    jmp +r

f:  jmp no_fire

    ; Joystick right.
n:  lda #0          ;Fetch rest of joystick status.
    sta $9122
    lda $9120
    bmi +r
    lda sprites_x,x
    cmp #@(* (- screen_columns 3) 8)
    bcs handle_break_mode
    lda #2
    jsr sprite_right

    lda caught_ball
    bmi +r
    stx tmp
    tax
    lda #2
    jsr sprite_right
    ldx tmp

r:  lda joystick_status
    and #joy_fire
    bne no_fire

do_fire:
    lda caught_ball
    bmi +n
    lda #snd_reflection_low
    jsr play_sound
n:  lda #255
    sta caught_ball

    lda mode
    cmp #mode_laser
    bne no_fire

    lda is_firing
    beq fire
    dec is_firing
    bne no_fire

fire:
    lda #snd_laser
    jsr play_sound
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

handle_break_mode:
    lda mode
    cmp #mode_break
    bne +n
    lda #0
    sta bricks_left
n:  rts

ctrl_vaus_right:
    lda @(+ sprites_x (- num_sprites 1))
    clc
    adc #8
    sta sprites_x,x
    rts