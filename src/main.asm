start:
    ; Clear screen.
    lda #0
    tax
l:  sta screen,x
    sta @(+ 256 screen),x
    dex
    bne -l
    ; Draw border.
    ; Unpack bricks.

forever:
    jmp forever
