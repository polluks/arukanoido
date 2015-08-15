bonus_probability = %11

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
    dec balls
    bne +c
    dec lifes
    beq +o
    jmp retry
o:  jmp start
n:  rts
c:  lda balls
    cmp #1
    bne +r
    lda #0
    sta mode
r:  jmp remove_sprite

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
