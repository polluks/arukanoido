ball_directions_x:  @(ball-directions-x)
ball_directions_y:  @(ball-directions-y)

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
    cmp #bg_minivaus    ; Ignore miniature Vaus displaying # of lifes.
    beq +n
    and #foreground
    cmp #foreground
r:  rts
n:  lda #1
    rts

ctrl_ball:
    lda caught_ball
    bpl -r

    ; Correct X position if too far of to the left.
    lda sprites_x,x
    cmp #8
    bcs +n
    lda #8
    sta sprites_x,x
n:

    ; Correct X position if too far of to the right.
    lda sprites_x,x
    cmp #@(- (* 14 8) ball_width)
    bcc +n
    lda #@(- (* 14 8) ball_width)
    sta sprites_x,x
n:

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
;    lda #8 ;ball_width
;    sta collision_x_distance
;    lda #ball_height
;    sta collision_y_distance
;    jsr find_hit
;    bcs reset_vaus_hit

    ; Test on collision with Vaus.
    lda sprites_y,x
    cmp #@(- vaus_y (-- ball_height))
    bcc reset_vaus_hit
    cmp #@(+ vaus_y (- 8 (-- ball_height)))
    bcs reset_vaus_hit

    lda @(+ sprites_x (-- num_sprites))
    sta tmp
    lda sprites_x,x
    cmp tmp
    bcc reset_vaus_hit

    lda tmp
    clc
    adc #16
    sta tmp
    lda sprites_x,x
    cmp tmp
    bcs reset_vaus_hit
    
    lda tmp
    sec
    sbc #8
    sec
    sbc sprites_x,x
    jsr neg
    asl
    clc
    adc #@(+ 128 ball_width)

    sta side_degrees
    jmp reflect_from_vaus

reset_vaus_hit:
    lda #0
    sta vaus_hit
    jmp no_hit

reflect_from_vaus:
    lda mode
    cmp #mode_catching
    bne +n

    ; Catch ball.
    stx caught_ball
    lda sprites_d,x
    clc
    adc #64
    and #127
    ora #128
    sec
    sbc #64
    sta sprites_d,x
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
    bcs reflect         ; Not a brick.

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
    ; Traject on X axis.
    ldy sprites_d,x
    lda ball_directions_x,y
    bmi +m
    lda sprites_dx,x
    clc
    adc ball_directions_x,y
    bcc +n
    inc sprites_x,x
    jmp +n

m:  jsr neg
    sta tmp
    lda sprites_dx,x
    sec
    sbc tmp
    bcs +n
    dec sprites_x,x

n:  sta sprites_dx,x

    ; Traject on Y axis.
    lda ball_directions_y,y
    bmi +m
    lda sprites_dy,x
    clc
    adc ball_directions_y,y
    bcc +n
    inc sprites_y,x
    jmp +n

m:  jsr neg
    sta tmp
    lda sprites_dy,x
    sec
    sbc tmp
    bcs +n
    dec sprites_y,x

n:  sta sprites_dy,x

    ; Deal with lost ball.
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
    lda #0              ; Reset from disruption bonus.
    sta mode
r:  jmp remove_sprite

hit_brick:
    ; Check brick type.
    ldy scrx
    lda (scr),y
    cmp #@(++ bg_brick_special4)
    bcs +r
    cmp #bg_brick_special1
    beq check_golden_brick
    cmp #bg_brick
    bcc +r
    beq remove_brick

    ; Degrade silver brick.
    lda (scr),y
    sec
    sbc #1
    jmp modify_brick

check_golden_brick:
    lda (col),y
    and #$0f
    cmp #yellow
    beq +r
remove_brick:
    dec bricks_left
    lda #0
modify_brick:
    sta (scr),y
    clc
    rts
r:  sec
    rts
