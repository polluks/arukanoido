start:
    jsr init_hiscore
if @*preshifted-sprites?*
    jsr preshift_sprites
end
    jmp +n

game_over:
    lda #0
    sta is_running_game

    ; Play "game over" tune.
    lda #4
    sta $702d
    lda #0
    sta $702e
    jmp +m

n:  jsr $799a
    jsr start_irq
    lda #1
    sta $702d
m:

if @(not *shadowvic?*)
    lda #<gfx_title
    sta s
    lda #>gfx_title
    sta @(++ s)
    jsr mg_display


l:  lda #0              ; Fetch joystick status.
    sta $9113
    lda $9111
    tax
    and #joy_fire
    beq +n
    txa
    and #joy_left
    bne -l
n:
end

    jsr init_game_mode

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

    ; Init draw_level.
    lda #0
    sta current_half

next_level:
    lda #0
    sta is_running_game
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

    lda #0
    sta is_running_game
    sta reflections_on_top
    sta reflections_since_last_vaus_hit
    sta sfx_reflection

    jsr clear_sprites

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
    lda #16
    sta vaus_width

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

    ; Temporarily copy the upcase alphabet into the unused
    ; sprite frame.
    ldx #@(* 26 8)
l:  lda @(-- (+ charset_upcase 8)),x
    sta @(-- frame_b),x
    dex
    bne -l

    ; Copy round number digits into round message.
    lda #score_char0
    sta @(+ txt_round 6)
    lda level
l:  sec
    sbc #10
    bcc +n
    inc @(+ txt_round 6)
    jmp -l
n:  clc
    adc #@(+ 10 (char-code #\0) (- score_char0 (char-code #\0)))
    sta @(+ txt_round 7)

    ; Print "ROUND XX".
    ldx #0
l:  lda txt_round,x
    beq +n
if @(== num_chars 256)
    cmp #255
    beq +k
end
if @(== num_chars 128)
    bmi +k
end
    sta @(+ screen (* 25 15) 4),x
    lda #white
    sta @(+ colors (* 25 15) 4),x
k:  inx
    jmp -l
n:

    ; Print "READY".
    ldx #0
l:  lda txt_ready,x
    beq +n
if @(== num_chars 256)
    cmp #255
    beq +k
end
if @(== num_chars 128)
    bmi +k
end
    sta @(+ screen (* 26 15) 5),x
    lda #white
    sta @(+ colors (* 26 15) 5),x
k:  inx
    jmp -l
n:

    ; Play "get ready" tune.
    lda #2
    sta $702d
    lda #0
    sta $702e

    ; Wait for three seconds.
    ldx #150
l:
if @(not *shadowvic?*)
    lda $9004
    bne -l
m:  lda $9004
    beq -m
end
if @*shadowvic?*
    $22 $02
end
    dex
    bne -l

    ldx #8
    lda #0
l:  sta @(-- (+ screen (* 25 15) 4)),x
    sta @(-- (+ screen (* 26 15) 5)),x
    dex
    bne -l

    lda #1
    sta is_running_game

mainloop:
    lda bricks_left
    bne +n
    jmp next_level
n:  lda is_running_game
    bne +n
poke_unlimited:
    dec lifes
    beq +o
    jmp retry                                                                                                
o:  jmp game_over
n:

    jsr random      ; Improve randomness.

if @*shadowvic?*
   $22 $02
end

    ; Toggle sprite frame.
    lda spriteframe
    eor #framemask
    sta spriteframe
    ora #first_sprite_char
    sta next_sprite_char

n:  lda has_moved_sprites
    beq -n
    lda #0
    sta has_moved_sprites
    jsr draw_sprites
    jmp mainloop

call_sprite_controllers:
    ; Call the functions that control sprite behaviour.
    ldx #@(-- num_sprites)
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
    rts

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

init_game_mode:
    ; Clear character 0.
    ldx #7
    lda #0
l:  sta charset,x
    dex
    bpl -l

    ; Copy background characters to charset.
    ldx #@(- gfx_background_end gfx_background)
l:  lda @(-- gfx_background),x
    sta @(-- (+ charset (* bg_start 8))),x
    dex
    bne -l

    lda $ede4
    cmp #$0c
    beq +p
    lda #12     ; Horizontal screen origin.
    sta $9000
    lda #5      ; Vertical screen origin.
    sta $9001
    jmp +n
p:  lda #20     ; Horizontal screen origin.
    sta $9000
    lda #21     ; Vertical screen origin.
    sta $9001
n:  lda #15     ; Number of columns.
    sta $9002
    lda #@(* 32 2) ; Number of rows.
    sta $9003
    lda #@(+ vic_screen_1000 vic_charset_1400)
    sta $9005
    lda #@(* light_cyan 16) ; Auxiliary color.
    sta $900e
    lda #@(+ reverse red)   ; Screen and border color.
    sta $900f

    ldx #0
l:  lda #0
    sta 0,x
    cpx #81
    bcs +n
    ; Copy digits from character ROM.
    lda @(-- (+ charset_locase (* 8 #x30))),x
    sta @(-- scorechars),x
n:  dex
    bne -l

    rts
