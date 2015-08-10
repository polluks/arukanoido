main:
    lda #@(+ vic_screen_1e00 vic_charset_1000)
    sta $9005
    lda #@(+ reverse red)  ; Screen and border color.
    sta $900f
    rts
