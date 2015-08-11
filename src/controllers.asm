ctrl_vaus_left:
    lda #0              ; Fetch joystick status.
    sta $9113
    lda $9111
    tay
    and #joy_fire
    bne no_fire

    lda is_firing
    beq fire
    dec is_firing
    bne no_fire

fire:
    lda #9
    sta is_firing
    tya
    pha
    lda sprites_x,x
    sta laser_init
    ldy #@(- laser_init sprite_inits)
    jsr add_sprite
    pla
    tay

no_fire:

    ; Joystick left.
n:  tya
    and #joy_left
    bne +n
    lda sprites_x,x
    cmp #9
    bcc +n
    lda #1
    jmp sprite_left

    ; Joystick right.
n:  lda #0          ;Fetch rest of joystick status.
    sta $9122
    lda $9120
    bmi ctrl_dummy
    lda sprites_x,x
    cmp #@(* (- screen_columns 3) 8)
    bcs ctrl_dummy
    lda #1
    jmp sprite_right

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
    lda #4
    jmp sprite_up
n:  jmp remove_sprite
