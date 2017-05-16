num_score_chars = 32
score_chars     = @(- (half num_chars) num_score_chars)
score_charset   = @(+ charset (* 8 score_chars))

make_score_screen:
    ; Clear charset.
    lda #0
    tax
l:  sta score_charset,x
    dex
    bne -l

    ; Make screen chars.
    ldx #@(* 2 screen_columns)
    ldy #0
    lda #score_chars
l:  sta screen,y
    clc
    adc #1
    iny
    dex
    bne -l

    ; Set colours.
    ldx #@(-- screen_columns)
l:  lda #2
    sta colors,x
    lda #1
    sta @(+ colors screen_columns),x
    dex
    bpl -l

txt_hiscore_charset = @(+ score_charset 40)

    ; Print "HIGH SCORE".
    ldx #$ff
    lda #<txt_hiscore_charset
    sta d
    lda #>txt_hiscore_charset
    sta @(++ d)
    lda #<txt_hiscore
    sta s
    lda #>txt_hiscore
    sta @(++ s)
    jmp print_string

score_charset0 = @(+ score_charset (* screen_columns 8))
score_charset1 = @(+ score_charset0 48)

display_score:
    ldx #num_score_digits
    lda #<score_charset0
    sta d
    lda #>score_charset0
    sta @(++ d)
    lda #<score
    sta s
    lda #>score
    sta @(++ s)
    jsr print_string

    ldx #num_score_digits
    lda #<score_charset1
    sta d
    lda #>score_charset1
    sta @(++ d)
    lda #<hiscore
    sta s
    lda #>hiscore
    sta @(++ s)

print_string:
    ldy #0
print_string2:
l:  tya
    lsr
    lda (s),y
    bmi +r
    php
    jsr print4x8
    plp
    bcc +n
    lda d
    clc
    adc #8
    sta d
    lda @(++ d)
    adc #0
    sta @(++ d)
n:  iny
    dex
    bne -l
r:  rts
