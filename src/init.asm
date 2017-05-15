if @*shadowvic?*
    org $2000
end

relocated_start = @(+ charset 3840)
relocation_offset = @(- relocated_start loaded_start)
loaded_end = @(- relocated_end relocation_offset)

music_player_size = @(length (fetch-file "sound-beamrider/MusicTester.prg"))
loaded_music_player_end = @(+ loaded_music_player (-- music_player_size))
music_player_end = @(+ music_player (-- music_player_size))

main:
    sei
    lda #$7f
    sta $912e       ; Disable and acknowledge interrupts.
    sta $912d
    sta $911e       ; Disable restore key NMIs.

    ; Blank screen.
    lda #0
    sta $9002

if @(not *shadowvic?*)
    ; Relocate loaded data by copying it to the right position backwards
    ; as it's beeing moved up to make space for the VIC.
    lda #<loaded_end
    sta s
    lda #>loaded_end
    sta @(++ s)
    lda #<relocated_end
    sta d
    lda #>relocated_end
    sta @(++ d)
    ldy #0
l:  lda (s),y
    sta (d),y
    ldx #s
    jsr dec_zp
    ldx #d
    jsr dec_zp
    inc $900f
    lda s
    cmp #@(low (-- loaded_start))
    bne -l
    lda @(++ s)
    cmp #@(high (-- loaded_start))
    bne -l
    jmp relocated_start

; Decrement zero page word X.
dec_zp:
    dec 0,x
    pha
    lda 0,x
    cmp #255
    bne +n
    dec 1,x
n:  pla
    rts
end

loaded_start:
if @(not *shadowvic?*)
    org relocated_start
end

    ; Now relocate the music player.
    lda #<loaded_music_player_end
    sta s
    lda #>loaded_music_player_end
    sta @(++ s)
    lda #<music_player_end
    sta d
    lda #>music_player_end
    sta @(++ d)
    ldx #<music_player_size
    lda #@(++ (high music_player_size))
    sta @(++ c)

copy_backwards:
    ldy #0
l2: lda (s),y
    sta (d),y
    inc $900f
    dec s
    lda s
    cmp #$ff
    beq m2
n2: dec d
    lda d
    cmp #$ff
    beq j2
q2: dex
    bne l2
    dec @(++ c)
    bne l2

    stx $900f
    jmp start       ; Start the game…

m2: dec @(++ s)
    jmp n2

j2: dec @(++ d)
    jmp q2
