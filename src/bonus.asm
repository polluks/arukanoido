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
    lda #0
    sta mode
    lda sprites_l,x
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
    beq +n
    dec ball_speed
n:  rts

apply_bonus_b:
    rts

apply_bonus_d:
    ; Remove bonuses.
    stx tmp
    ldx #@(- num_sprites 2)
l:  lda sprites_i,x
    and #is_bonus
    beq +n
    jsr remove_sprite
    dex
    bpl -l
n:

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
    ldy #@(- ball_init sprite_inits)
    lda sprites_d,y
    clc
    adc #8
    pha
    sta @(+ ball_init 7)
    ldy #@(- ball_init sprite_inits)
    jsr add_sprite
    pla
    sec
    sbc #8
    sta @(+ ball_init 7)
    ldy #@(- ball_init sprite_inits)
    jsr add_sprite
    
    inc balls
    inc balls
    lda #mode_disruption
    sta mode
    rts

apply_bonus_p:
    inc lifes
    jmp draw_lifes
