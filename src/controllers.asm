bonus_probability = %11

ctrl_vaus_left:
    lda #0              ; Fetch joystick status.
    sta $9113
    lda $9111
    sta joystick_status

    and #joy_fire
    bne no_fire
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
    cmp #bg_minivaus
    beq +n
    and #foreground
    cmp #foreground
r:  rts
n:  lda #1
    rts

vaus_hit: 0

vaus_edge_distraction = 16
ball_width      = 3
ball_height     = 5

ctrl_ball:
    lda sprites_i,x
    and #catched_ball
    bne -r
    ldy ball_speed
l:  tya
    pha
    jsr +c
    pla
    tay
    dey
    bne -l
    rts

c:
    ; Test on collision with sprites.
    lda #ball_width
    sta collision_x_distance
    lda #ball_height
    sta collision_y_distance
    jsr find_hit
    bcs reset_vaus_hit

    ; Test on collision with Vaus.

    lda #@(- 128 vaus_edge_distraction)
    sta side_degrees
    lda sprites_l,y
    cmp #<vaus_left
    beq reflect_from_vaus

    lda #128
    sta side_degrees
    lda sprites_l,y
    cmp #<vaus_middle
    beq reflect_from_vaus

    lda #@(+ 128 vaus_edge_distraction)
    sta side_degrees
    lda sprites_l,y
    cmp #<vaus_right
    beq reflect_from_vaus

reset_vaus_hit:
    lda #0
    sta vaus_hit
    jmp no_hit

reflect_from_vaus:
    lda mode
    cmp #mode_catching
    bne +n
    lda sprites_i,x
    ora #catched_ball
    sta sprites_i,x
    jmp reflect
n:  lda vaus_hit
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
    bne +n
    inc sprites_y,x
    jmp +h
n:

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
    bne +n
    dec sprites_x,x
    jmp +h
n:
    
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
    bne +n
    dec sprites_y,x
    jmp +h
n:
    
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
    inc sprites_x,x

h:  jsr hit_brick
    bcs reflect

    ; Make bonus.
    lda mode
    cmp #mode_disruption    ; No bonuses in disruption mode.
    beq reflect

    jsr random
    and #bonus_probability
    bne reflect

    lda scrx
    asl
    asl
    asl
    sta bonus_init
    lda scry
    asl
    asl
    asl
    sta @(++ bonus_init)
a:  jsr random
    and #%111
    cmp #%111
    beq -a      ; Only seven bonuses available.
    pha
    asl
    asl
    asl
    clc
    adc #<bonus_l
    sta @(+ bonus_init 4)
    pla
    tay
    lda bonus_colors,y
    sta @(+ bonus_init 3)
    ldy #@(- bonus_init sprite_inits)
    jsr add_sprite

reflect:
    lda sprites_d,x     ; Get degrees.
    sec
    sbc side_degrees    ; Rotate back to zero degrees.
    jsr neg             ; Get absolute deviation.
    clc
    adc side_degrees    ; Rotate back to original axis.
    clc
    adc #128            ; Rotate to opposite direction.
    sta sprites_d,x

traject_ball:
    ldy sprites_d,x
    lda ball_directions_x,y
    clc
    bmi +m
    adc sprites_dx,x
    bcc +n
    inc sprites_x,x
    jmp +n

m:  adc sprites_dx,x
    bcc +n
    dec sprites_x,x

n:  sta sprites_dx,x

    ldy sprites_d,x
    lda ball_directions_y,y
    clc
    bmi +m
    adc sprites_dy,x
    bcc +n
    inc sprites_y,x
    jmp +n

m:  adc sprites_dy,x
    bcc +n
    dec sprites_y,x

n:  sta sprites_dy,x

    lda sprites_y,x
    bne +n
    dec lifes
    beq +o
    jmp retry
o:  jmp start
n:  rts

hit_brick:
    ; Check brick type.
    ldy scrx
    lda (scr),y
    cmp #@(++ bg_brick_special4)
    bcs +r
    cmp #bg_brick_special1
    beq remove_brick
    cmp #bg_brick
    bcc +r
    beq remove_brick

    ; Degrade special brick.
    lda (scr),y
    sec
    sbc #1
    jmp modify_brick

remove_brick:
    lda #0
modify_brick:
    sta (scr),y
    clc
    rts
r:  sec
    rts
