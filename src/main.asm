start:
    jsr init_hiscore

game_over:
    ldx #0
    nop
l:  lda #0
    sta 0,x
    cpx #81
    bcs +n
    ; Copy digits from character ROM.
    lda @(-- (+ charset_locase (* 8 #x30))),x
    sta @(-- (+ charset (* 8 score_char0))),x
n:  dex
    bne -l

    ; Prepare paddle auto–detection.
    lda $9008
    sta old_paddle_value

    lda #default_num_lifes
    sta lifes
    lda #0
    sta level
    jsr init_score

    ; Set pointer to first level data.
    lda #<level_data
    sta current_level
    lda #>level_data
    sta @(++ current_level)

next_level:
    inc level
    lda level
    cmp #33
    beq game_over

    ; Clear screen.
    ldx #0
l:  lda #0
    sta screen,x
    sta @(+ 256 screen),x
    lda #@(+ multicolor white)
    sta colors,x
    sta @(+ 256 colors),x
    dex
    bne -l

    jsr draw_level
    jsr display_score

    ; Draw top border without connectors.
    ldx #13
    lda #bg_top_1
l:  sta @(+ screen 30),x
    dex
    bne -l

    ; Draw top border connectors.
    lda #bg_top_2
    sta @(+ screen 30 3),x
    sta @(+ screen 30 10),x
    lda #bg_top_3
    sta @(+ screen 30 4),x
    sta @(+ screen 30 11),x

    ; Draw corners.
    lda #bg_corner_left
    sta @(+ screen 30)
    lda #bg_corner_right
    sta @(+ screen 30 14)
    
    ; Draw sides.
    lda #0
    sta scrx
    lda #3
    sta scry
a:  ldx #5
    lda #bg_side
l:  pha
    lda scry
    cmp #32
    beq +done
    jsr scrcoladdr
    pla
    sta (scr),y
    ldy #14
    sta (scr),y
    clc
    adc #1
    inc scry
    dex
    bne -l
    jmp -a

done:
    pla

retry:
    ldx #$ff
    txs

    jsr clean_sprites

    lda #0
    sta reflections_on_top
    sta reflections_since_last_vaus_hit

    ; Empty sprite slots.
    ldx #@(- num_sprites 3)
l:  jsr remove_sprite
    dex
    bpl -l

    ; Make player sprite.
    ldx #@(- num_sprites 1)
    ldy #@(- vaus_left_init sprite_inits)
    jsr replace_sprite 
    ldx #@(- num_sprites 2)
    ldy #@(- vaus_right_init sprite_inits)
    jsr replace_sprite 

    lda #70
    sta ball_init
    lda #@(- (* 29 8) 5)
    sta @(+ ball_init 1)
    lda #default_ball_direction
    sta @(+ ball_init 7)
    ldx #@(- num_sprites 3)
    stx caught_ball
    ldy #@(- ball_init sprite_inits)
    jsr replace_sprite 

    lda #default_ball_speed
    sta ball_speed
    lda #0
    sta mode
    lda #1
    sta balls

    jsr draw_lifes

    ; Initialize sprite frame.
    lda #0
    sta spriteframe
    ora #first_sprite_char
    sta next_sprite_char
    jsr draw_sprites

    ldx #@(* 26 8)
l:  lda @(-- (+ charset_upcase 8)),x
    sta $15ff,x
    dex
    bne -l

    lda #48
    sta @(+ txt_round 6)
    lda level
l:  sec
    sbc #10
    bcc +n
    inc @(+ txt_round 6)
    jmp -l
n:  clc
    adc #@(+ 10 #\0)
    sta @(+ txt_round 7)

    ldx #0
l:  lda txt_round,x
    beq +n
    bmi +k
    sta @(+ screen (* 25 15) 4),x
    lda #white
    sta @(+ colors (* 25 15) 4),x
k:  inx
    jmp -l
n:

    ldx #0
l:  lda txt_ready,x
    beq +n
    bmi +k
    sta @(+ screen (* 26 15) 5),x
    lda #white
    sta @(+ colors (* 26 15) 5),x
k:  inx
    jmp -l
n:

    ldx #150
l:  lda $9004
    bne -l
m:  lda $9004
    beq -m
    dex
    bne -l

    ldx #8
    lda #0
l:  sta @(-- (+ screen (* 25 15) 4)),x
    sta @(-- (+ screen (* 26 15) 5)),x
    dex
    bne -l

mainloop:
    lda bricks_left
    bne +n
    jmp next_level
n:

    jsr random      ; Improve randomness.

    lda mode
    cmp #mode_disruption
    beq +n
l:  lda $9004
    bne -l
n:

    ; Toggle sprite frame.
    lda spriteframe
    eor #framemask
    sta spriteframe
    ora #first_sprite_char
    sta next_sprite_char

    ; Call the functions that control sprite behaviour.
n:  ldx #@(-- num_sprites)
l1: lda sprites_fh,x
    sta @(+ +m1 2)
    lda sprites_fl,x
    sta @(++ +m1)
    stx call_controllers_x
    lda #8
    sta collision_x_distance
    sta collision_y_distance
m1: jsr $1234
    ldx call_controllers_x
n1: dex
    bpl -l1

    jsr draw_sprites

    jmp mainloop

draw_lifes:
    lda #1
    sta scrx
    lda #31
    sta scry
    lda lifes
    sta tmp
l:  dec tmp
    beq +n
    jsr scrcoladdr
    lda #bg_minivaus
    sta (scr),y
    lda #@(+ multicolor white)
    sta (col),y
    inc scrx
    jmp -l
n:  jsr scrcoladdr
    lda #0
    sta (scr),y
    rts

txt_round:
    @(ascii2pixcii "ROUND XX") 0
txt_ready:
    @(ascii2pixcii "READY") 0
