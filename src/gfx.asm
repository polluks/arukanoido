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
