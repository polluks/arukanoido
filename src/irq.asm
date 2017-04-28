frame_timer = @(/ 1108404 50)

start_irq:
    lda #<irq
    sta $314
    lda #>irq
    sta $315

    ; Initialise VIA2 Timer 1.
    ldx #@<frame_timer
    sta $9124
    ldx #@>frame_timer
    sta $9125
    lda #%00000000  ; One-shot mode.
    sta $912b
    lda #%11000000  ; IRQ enable
    sta $912e
    cli
    rts

irq:lda #@>frame_timer
    sta $9125
    jsr $7053
    lda #$7f
    sta $912d
    jmp $eb18
