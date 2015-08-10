start:
    ; Clear screen.
    ldx #0
l:  lda #0
    sta screen,x
    sta @(+ 256 screen),x
    lda #white
    sta colors,x
    sta @(+ 256 colors),x
    dex
    bne -l

    ; Draw border.
    ; Unpack bricks.

forever:
    jmp forever
