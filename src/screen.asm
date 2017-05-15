; Calculate line address in screen and colour memory.
scrcoladdr:
    ldy scry
    lda line_addresses,y
    sta scr
    sta col
    cpy #@(++ (/ 256 screen_columns))
    lda #@(half (high screen))
    rol
    sta @(++ scr)
    and #1
    ora #>colors
    sta @(++ col)
    ldy scrx
    rts

; Clear screen.
clear_screen:
    ldx #0
l:  lda #0
    sta screen,x
    sta @(+ 256 screen),x
    lda #@(+ multicolor white)
    sta colors,x
    sta @(+ 256 colors),x
    dex
    bne -l
    rts
