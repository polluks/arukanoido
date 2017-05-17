bonus_colors:
    @(+ multicolor yellow)
    @(+ multicolor blue)
    @(+ multicolor green)
    @(+ multicolor yellow)
    @(+ multicolor purple)
    @(+ multicolor cyan)
    @(+ multicolor white)

ctrl_bonus:
    lda sprites_y,x
    beq +r
    jsr find_hit
    bcs +m
    lda sprites_i,y
    and #is_vaus
    beq +m
    lda mode
    lda #0
    sta mode
    lda caught_ball
    bmi +n
    lda #255
    sta caught_ball
    lda #snd_reflection_low
    jsr play_sound
    lda #0
    sta sfx_reflection
n:  lda sprites_l,x
    sec
    sbc #bonus_l
    lsr
    lsr
    lsr
    tay
    lda bonus_funs_l,y
    sta @(+ +selfmod 1)
    lda bonus_funs_h,y
    sta @(+ +selfmod 2)
selfmod:
    jsr $1234
r:  jmp remove_sprite
    
m:  lda #1
    jmp sprite_down

bonus_funs_l:
    <apply_bonus_l
    <apply_bonus_e
    <apply_bonus_c
    <apply_bonus_s
    <apply_bonus_b
    <apply_bonus_d
    <apply_bonus_p

bonus_funs_h:
    >apply_bonus_l
    >apply_bonus_e
    >apply_bonus_c
    >apply_bonus_s
    >apply_bonus_b
    >apply_bonus_d
    >apply_bonus_p

apply_bonus_l:
    lda #mode_laser
    sta mode
    rts

apply_bonus_e:
    rts

apply_bonus_c:
    lda #mode_catching
    sta mode
    rts

apply_bonus_s:
    lda ball_speed
    cmp #5
    bcs +n
    sec
    sbc #2
    sta ball_speed
    bcc +n
    rts
n:  lda #5
    sta ball_speed
    rts

apply_bonus_b:
    inc mode_break
    lda #14
    sta scrx
    lda #28
    sta scry
l:  jsr scrcoladdr
    lda #0
    sta (scr),y
    inc scry
    lda scry
    cmp #31
    bne -l
    rts

apply_bonus_d:
    ; Remove bonuses.
    stx tmp
    ldx #@(- num_sprites 2)
l:  lda sprites_i,x
    and #is_bonus
    beq +n
    jsr remove_sprite
n:  dex
    bpl -l
    ldx tmp

    ldy #@(- num_sprites 2) ; Find ball.
l:  lda sprites_l,y
    cmp #<ball
    beq +f
    dey
    bpl -l

f:  lda #0
    sta @(+ ball_init 2)
    lda sprites_x,y
    sta ball_init
    lda sprites_y,y
    sta @(+ ball_init 1)
    lda sprites_d,y
    pha
    ldy #@(- ball_init sprite_inits)
    clc
    adc #16
    sta @(+ ball_init 7)
    ldy #@(- ball_init sprite_inits)
    jsr add_sprite
    pla
    sec
    sbc #16
    sta @(+ ball_init 7)
    ldy #@(- ball_init sprite_inits)
    jsr add_sprite
    
    inc balls
    inc balls
    lda #mode_disruption
    sta mode
    rts

apply_bonus_p:
    lda #snd_bonus_life
    jsr play_sound
    inc lifes
    jmp draw_lifes

rotate_bonus:
    sta s
    stx @(++ s)
    ldy #6
    lda (s),y
    pha
    dey
l:  lda (s),y
    iny
    sta (s),y
    dey
    dey
    bne -l
    pla
    iny
    sta (s),y
r:  rts

rotate_bonuses:
    lda framecounter
    lsr
    bcc -r
    lsr
    bcc +n
    lsr
    bcc +m
    lda #<bonus_l
    ldx #>bonus_l
    jsr rotate_bonus
    lda #<bonus_e
    ldx #>bonus_e
    jmp rotate_bonus
m:  lda #<bonus_c
    ldx #>bonus_c
    jsr rotate_bonus
    lda #<bonus_s
    ldx #>bonus_s
    jmp rotate_bonus
n:  lsr
    bcc +m
    lda #<bonus_b
    ldx #>bonus_b
    jsr rotate_bonus
    lda #<bonus_d
    ldx #>bonus_d
    jmp rotate_bonus
m:  lda #<bonus_p
    ldx #>bonus_p
    jmp rotate_bonus
