start:
    ldx #0
    lda #0
l:  sta 0,x
    dex
    bne -l

    ; Set to first level.
    lda #<level_data
    sta current_level
    lda #>level_data
    sta @(++ current_level)

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

    ; Draw top border without connectors.
    ldx #13
    lda #bg_top_1
l:  sta @(+ screen 30),x
    sta @(+ screen 30 (* 29 15)),x
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

    ; Empty sprite slots.
    ldx #@(- num_sprites 3)
l:  jsr remove_sprite
    dex
    bpl -l

    ; Make player sprite.
    ldx #@(- num_sprites 1)
    ldy #@(- player_left_init sprite_inits)
    jsr replace_sprite 
    ldx #@(- num_sprites 2)
    ldy #@(- player_right_init sprite_inits)
    jsr replace_sprite 
    ldx #@(- num_sprites 3)
    ldy #@(- ball_init sprite_inits)
    jsr replace_sprite 

mainloop:
l:  lda $9004
    bne -l

    ; Initialize sprite frame.
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
m1: jsr $1234
    ldx call_controllers_x
n1: dex
    bpl -l1

    jsr draw_sprites

    jmp mainloop
