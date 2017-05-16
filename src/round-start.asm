roundstart:
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
    rts

txt_round:  @(ascii2pixcii "ROUND XX") 0
txt_ready:  @(ascii2pixcii "READY") 0
