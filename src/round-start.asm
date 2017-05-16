roundstart:
    ; Copy round number digits into round message.
    lda #score_char0
    sta @(+ txt_round_nn 7)
    lda level
l:  sec
    sbc #10
    bcc +n
    inc @(+ txt_round_nn 7)
    jmp -l
n:  clc
    adc #@(+ 10 (char-code #\0) (- score_char0 (char-code #\0)))
    sta @(+ txt_round_nn 8)

len_round   = 9
len_ready   = 5
ofs_round = @(+ (* 15 22) 5)
ofs_ready = @(+ (* 15 24) 6)
screen_round = @(+ screen ofs_round)
screen_ready = @(+ screen ofs_ready)
colors_round = @(+ colors ofs_round)
colors_ready = @(+ colors ofs_ready)
chars_round = @(quarter framechars)
chars_ready = @(+ chars_round len_round)
charset_round = @(+ charset (* 8 chars_round))
charset_ready = @(+ charset (* 8 chars_ready))

    ; Clear bitmaps
    ldx #@(-- (* 8 len_round))
l:  lda #0
    sta charset_round,x
    cpx #@(-- (* 8 len_ready))
    bcs +n
    sta charset_ready,x
n:  dex
    bpl -l

    ; Make bitmap chars for "ROUND XX".
    lda #<screen_round
    sta d
    lda #>screen_round
    sta @(++ d)
    ldx #5
    lda #chars_round
    jsr make_4x8_line

    ; Make bitmap chars for "READY".
    lda #<screen_ready
    sta d
    lda #>screen_ready
    sta @(++ d)
    ldx #3
    lda #chars_ready
    jsr make_4x8_line

    ; Make colors.
    ldx #len_round
    lda #white
l:  sta colors_round,x
    sta colors_ready,x
    dex
    bpl -l

    ; Print "ROUND XX".
    lda #@(low (-- txt_round_nn))
    sta s
    lda #@(high (-- txt_round_nn))
    sta @(++ s)
    lda #<charset_round
    sta d
    lda #>charset_round
    sta @(++ d)
    ldx #len_round
    ldy #1
    jsr print_string2

    lda #snd_round
    jsr play_sound

    ldx #130
l:  lda $9004
    lsr
    bne -l
n:  lda $9004
    lsr
    bne -n
    dex
    bne -l

    ; Print "READY".
    lda #@(low (-- txt_ready))
    sta s
    lda #@(high (-- txt_ready))
    sta @(++ s)
    lda #<charset_ready
    sta d
    lda #>charset_ready
    sta @(++ d)
    ldx #len_ready
    ldy #1
    jsr print_string2

    jsr wait_sound

    ; Remove message.
    ldx #5
    lda #0
l:  sta screen_round,x
    sta screen_ready,x
    dex
    bpl -l
    rts

make_4x8_line:
    ldy #0
l:  sta (d),y
    clc
    adc #1
    iny
    dex
    bne -l
    rts

txt_round_nn:   @(string4x8 "ROUND  XX")
txt_ready:      @(string4x8 "READY")
