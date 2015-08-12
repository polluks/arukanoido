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

ball_directions_y:  @(ball-directions)
ball_directions_x = @(+ ball_directions_y (/ +degrees+ 4))

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
    rts

vaus_hit: 0

ball_width      = 3
ball_height     = 5

ctrl_ball:
;    jsr +c
;    jsr +c
    jsr +c
c:
    ; Test on collision with sprites.
    lda #ball_width
    sta collision_x_distance
    lda #ball_height
    sta collision_y_distance
    jsr find_hit
    bcs reset_vaus_hit

    ; Test on collision with Vaus.

    lda #@(+ 128 0)
    sta side_degrees
    lda sprites_l,y
    cmp #<vaus_left
    beq reflect_from_vaus

    lda #128
    sta side_degrees
    lda sprites_l,y
    cmp #<vaus_middle
    beq reflect_from_vaus

    lda #@(- 128 0)
    sta side_degrees
    lda sprites_l,y
    cmp #<vaus_right
    beq reflect_from_vaus

reset_vaus_hit:
    lda #0
    sta vaus_hit
    jmp no_hit

reflect_from_vaus:
    lda vaus_hit
    bne no_hit
    inc vaus_hit
    jmp reflect

no_hit:
    ; Bounce back downwards.
    lda #0
    sta side_degrees
    ldy sprites_x,x
    iny
    tya
    ldy sprites_y,x
    dey
    jsr get_soft_collision
    beq hit_brick

    ; Bounce back left.
    lda #64
    sta side_degrees
    lda sprites_x,x
    clc
    adc #ball_width
    ldy sprites_y,x
    iny
    iny
    iny
    jsr get_soft_collision
    beq hit_brick
    
    ; Bounce back upwards.
    lda #128
    sta side_degrees
    ldy sprites_x,x
    iny
    tya
    ldy sprites_y,x
    iny
    iny
    iny
    iny
    iny
    jsr get_soft_collision
    beq hit_brick
    
    ; Bounce back right.
    lda #192
    sta side_degrees
    ldy sprites_x,x
    dey
    tya
    ldy sprites_y,x
    iny
    iny
    iny
    jsr get_soft_collision
    bne traject_ball

hit_brick:
    lda (scr),y
    cmp #@(++ bg_brick_special4)
    bcs +n
    cmp #bg_brick_special1
    beq +y
    cmp #bg_brick
    bcc +n
    beq +y
    lda (scr),y
    sec
    sbc #1
    bne +w  ; jmp
y:  lda #0
w:  sta (scr),y
n:

reflect:
    ; Bounce back two steps in opposite direction.
    lda sprites_d,x
    clc
    adc #128
    sta sprites_d,x
    jsr traject_ball
    jsr traject_ball

    lda sprites_d,x
    clc
    adc #128
    sec
    sbc side_degrees
    jsr neg
    clc
    adc side_degrees
    clc
    adc #128

    ; Avoid bouncing infinitely horizontally.
    cmp #192
    bne +n
    lda #200
    bne +j
n:  cmp #64
    bne +j
    lda #56

j:  sta sprites_d,x

traject_ball:
    ldy sprites_d,x
    lda ball_directions_x,y
    clc
    bmi +m
    adc sprites_dx,x
    bmi +n
    inc sprites_x,x
    jmp +n

m:  adc sprites_dx,x
    bpl +n
    dec sprites_x,x

n:  sta sprites_dx,x

    ldy sprites_d,x
    lda ball_directions_y,y
    clc
    bmi +m
    adc sprites_dy,x
    bmi +n
    inc sprites_y,x
    jmp +n

m:  adc sprites_dy,x
    bpl +n
    dec sprites_y,x

n:  sta sprites_dy,x
    rts
