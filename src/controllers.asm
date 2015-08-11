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
    clc
    adc #4
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
    lda #2
    jmp sprite_left

    ; Joystick right.
n:  lda #0          ;Fetch rest of joystick status.
    sta $9122
    lda $9120
    bmi ctrl_dummy
    lda sprites_x,x
    cmp #@(* (- screen_columns 3) 8)
    bcs ctrl_dummy
    lda #2
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
    lda #8
    jmp sprite_up
n:  jmp remove_sprite

ball_directions_x:  @(ball-directions-x)
ball_directions_y:  @(ball-directions-y)

ball_reflected: 0
px: 0
py: 0
side_degrees: 0

get_soft_collision:
    lsr
    lsr
    lsr
    sta scrx
    tya
    lsr
    lsr
    lsr
    sta scry
    jsr scrcoladdr
    lda (scr),y
    and #foreground
    cmp #foreground
    bne +n
    lda #0
n:  rts

ctrl_ball:
    lda ball_reflected
    beq +n
    dec ball_reflected
    jmp no_collision

n: 
;    lda sprites_d,x
;    clc
;    adc #64
;    bpl other_side

    ; Bounce downwards.
    lda #0
    sta side_degrees
    lda sprites_x,x
    clc
    adc #1
    ldy sprites_y,x
    dey
    jsr get_soft_collision
    beq reflect

    ; Bounce left.
    lda #64
    sta side_degrees
    lda sprites_x,x
    sec
    sbc #1
    ldy sprites_y,x
    iny
    iny
    iny
    jsr get_soft_collision
    beq reflect
    
    ; Bounce upwards.
    lda #128
    sta side_degrees
    lda sprites_x,x
    clc
    adc #1
    ldy sprites_y,x
    iny
    iny
    iny
    iny
    iny
    jsr get_soft_collision
    beq reflect
    
    ; Bounce right.
    lda #192
    sta side_degrees
    lda sprites_x,x
    clc
    adc #4
    ldy sprites_y,x
    iny
    iny
    iny
    jsr get_soft_collision
    bne no_collision

reflect:
    lda sprites_d,x
    sec
    sbc side_degrees
    jsr neg
    clc
    adc side_degrees
    sta sprites_d,x

no_collision:
    ldy sprites_d,x
    lda ball_directions_x,y
    clc
    adc sprites_x,x
    sta sprites_x,x
    lda ball_directions_y,y
    clc
    adc sprites_y,x
    sta sprites_y,x
    rts
