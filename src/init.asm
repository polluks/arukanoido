main:
    lda #20     ; Horizontal screen origin.
    sta $9000
    lda #21     ; Vertical screen origin.
    sta $9001
    lda #15     ; Number of columns.
    sta $9002
    lda #@(* 32 2) ; Number of rows.
    sta $9003
    lda #@(+ vic_screen_1e00 vic_charset_1000)
    sta $9005
    lda #@(+ reverse red)  ; Screen and border color.
    sta $900f

forever:jmp forever
    rts
