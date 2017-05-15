clear_data:
    lda #0
    tax
l:  cpx #@(-- current_song)
    bcc +n
    sta 0,x
n:  sta 200,x
    dex
    bne -l
    rts

start:
    ldx #$ff
    txs

if @*preshifted-sprites?*
    jsr preshift_sprites
end
    jsr clear_data
    jsr init_hiscore
    jsr init_music
    jsr start_irq
    lda #snd_bonus_life ; Tell that the tape has finished loading.
    jsr play_sound
    jsr wait_sound
    jmp restart

game_over:
    lda #0
    sta is_running_game

    lda #snd_game_over
    jsr play_sound
    jsr wait_sound
    lda #snd_hiscore
    jsr play_sound

restart:
    jsr clear_data

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

    lda #snd_coin
    jsr play_sound
    jsr wait_sound
    lda #snd_theme
    jsr play_sound
    jsr wait_sound

    jsr init_game_mode

    ; Prepare paddle auto–detection.
    lda #0
    sta is_using_paddle
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

    jsr clear_screen
    jsr draw_level
    jsr draw_walls
    jsr display_score

retry:
    lda #0
    sta is_running_game
    sta reflections_on_top
    sta reflections_since_last_vaus_hit
    sta sfx_reflection
    sta is_firing

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

    jsr draw_walls      ; Freshen up after mode_break.
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

    lda #snd_round
    jsr play_sound
    jsr wait_sound

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
    beq +m
    bmi +m
    lda is_running_game
    bne +n
    jsr wait_sound
poke_unlimited:
    dec lifes
    beq +o
    jmp retry
m:  jmp next_level
o:  jmp game_over

n:  jsr random      ; Improve randomness. Avoid CRTC hsync sine wave wobble.

if @*shadowvic?*
   $22 $02
end

    ; Toggle sprite frame.
    lda spriteframe
    eor #framemask
    sta spriteframe
    ora #first_sprite_char
    sta next_sprite_char

n:  jsr random
    lda has_moved_sprites
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

lifes_on_screen = @(+ (* 31 15) 1 screen)
lifes_on_colors = @(+ (* 31 15) 1 colors)

draw_lifes:
    txa
    pha
    ldx lifes
    cpx #13
    bcs +n
    lda #0
    sta lifes_on_screen,x
l:  cpx #13
    bcs +n
    cpx #0
    beq +done
    lda #bg_minivaus
    sta @(-- lifes_on_screen),x
    lda #@(+ multicolor white)
    sta @(-- lifes_on_colors),x
n:  dex
    jmp -l
done:
    pla
    tax
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
    lda $900e
    and #$0f
    ora #@(* light_cyan 16) ; Auxiliary color.
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
