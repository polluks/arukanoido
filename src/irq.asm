frame_timer = @(- (/ 1108404 50) 18)

start_irq:
    lda #0
    sta is_running_game

l:  lda $9004
    bne -l

    lda #<irq
    sta $314
    lda #>irq
    sta $315

    ; Initialise VIA2 Timer 1.
    lda #<frame_timer
    sta $9124
    lda #>frame_timer
    sta $9125
    lda #%01000000  : free-running
    sta $912b
    lda #%11000000  ; IRQ enable
    sta $912e
    cli
    rts

irq:jsr $7053
    lda is_running_game
    beq +n
    jsr call_sprite_controllers
    lda #1
    sta has_moved_sprites
n:  lda #$7f
    sta $912d
    jmp $eb18
