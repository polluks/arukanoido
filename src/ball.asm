ctrl_ball:
    lda caught_ball
    bpl +r

    ; Call the ball controller ball_speed times.
    ldy ball_speed
l:  tya
    pha
    jsr ctrl_ball_subpixel
    lda sprites_fl,x
    cmp #<ctrl_ball
    bne +e
    pla
    tay
    dey
    bne -l
r:  rts
e:  pla
    rts

ctrl_ball_subpixel:
    ; Test on collision with sprites.
;    lda #8 ;ball_width
;    sta collision_x_distance
;    lda #ball_height
;    sta collision_y_distance
;    jsr find_hit
;    bcs no_vaus_hit

    ; Test on collision with Vaus.
    lda sprites_y,x
    cmp #@(- vaus_y (-- ball_height))
    bcc no_vaus_hit
    cmp #@(+ vaus_y 8)
    bcs no_vaus_hit

    lda @(+ sprites_x (-- num_sprites))
    sec
    sbc #ball_width
    cmp sprites_x,x
    bcs no_vaus_hit

    lda @(+ sprites_x (-- num_sprites))
    clc
    adc vaus_width
    cmp sprites_x,x
    bcc no_vaus_hit
    
    ; Calculate reflection from Vaus.
    lda vaus_width
    clc
    adc #ball_width
    lsr
    sta tmp
    lda sprites_x,x
    sec
    sbc @(+ sprites_x (-- num_sprites))
    adc #ball_width
    sbc tmp
    jsr neg
    asl
    sta side_degrees

    ; Avoid going straight up.
    jsr abs
    cmp #$04
    bcs +n
    lda side_degrees
    bmi +m
    lda #$04
    jmp +j
m:  lda #$f8
j:  sta side_degrees
n:

    lda #0
    sta sprites_d,x
    lda #@(- vaus_y ball_height)
    sta sprites_y,x

    lda #0
    sta reflections_since_last_vaus_hit
    lda mode
    cmp #mode_catching
    bne +n

    ; Catch ball.
    stx caught_ball
    lda #<ball_caught
    sta sprites_l,x
    lda #@(* 28 8)
    sta sprites_y,x
    jsr apply_reflection
    lda #snd_caught_ball
    jmp play_sound

n:  jmp apply_reflection

m:  jsr correct_trajectory
    jmp move_ball

no_vaus_hit:
    ; Reflect ball.
    lda #0
    sta side_degrees
    sta has_collision
    sta has_hit_brick

    jsr reflect
    lda has_collision
    beq -m
    lda has_hit_brick
    beq hit_solid

    lda #0
    sta reflections_since_last_vaus_hit

    ; Make bonus.
    lda mode
    cmp #mode_disruption    ; No bonuses in disruption mode.
    beq apply_reflection

    jsr random
    and #bonus_probability
    bne apply_reflection

    lda scrx
    asl
    asl
    asl
    sta @(+ bonus_init sprite_init_x)
    lda scry
    asl
    asl
    asl
    sta @(+ bonus_init sprite_init_y)
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
    sta @(+ bonus_init sprite_init_gfx_l)
    pla
    sta @(+ bonus_init sprite_init_data)
    tay
    lda bonus_colors,y
    sta @(+ bonus_init sprite_init_color)
    ldy #@(- bonus_init sprite_inits)
    jsr add_sprite
    jmp apply_reflection

hit_solid:
    inc reflections_since_last_vaus_hit

apply_reflection:
    ; Play reflection sound.
    lda snd_reflection
    bne +n
    lda sfx_reflection
    and #1
    clc
    adc #snd_reflection_low
    sta snd_reflection
n:  inc sfx_reflection

    ; Increase ball speed every 8th time it hit the top border.
    lda sprites_y,x
    cmp #@(+ 2 (* 3 8))
    bcs +n
    inc reflections_on_top
    lda reflections_on_top
    and #%1111
    bne +n
    inc ball_speed
n:
    lda sprites_d,x     ; Get degrees.
    sec
    sbc side_degrees    ; Rotate back to zero degrees.
    jsr neg             ; Get opposite deviation from general direction.
    clc
    adc side_degrees    ; Rotate back to original axis.
    clc
    adc #128            ; Rotate to opposite direction.
    sta sprites_d,x

move_ball:
    jsr ball_step

    ; Deal with lost ball.
    lda sprites_y,x
    cmp #@(- (* 8 screen_rows) 4)
    bcc play_reflection_sound

    dec balls
    bne still_balls_left

    lda #0
    sta is_running_game
    lda #snd_miss
    jmp play_sound

still_balls_left:
    lda balls
    cmp #1
    bne +r
    lda #0              ; Reset from disruption bonus.
    sta mode
r:  jsr remove_sprite

play_reflection_sound:
    lda snd_reflection
    beq +n
    ldx #0
    stx snd_reflection
    jmp play_sound
n:  rts

correct_trajectory:
    lda reflections_since_last_vaus_hit
    cmp #8
    bcc +r
    lda sprites_d,x
    and #%00100000
    bne +n
    lda sprites_d,x
    clc
    adc #8
    sta sprites_d,x
    rts
n:  lda sprites_d,x
    sec
    sbc #8
    sta sprites_d,x
r:  rts

ball_step:
    jsr ball_step2

ball_step2:
    ; Move on X axis.
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

    ; Move on Y axis.
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
    rts
