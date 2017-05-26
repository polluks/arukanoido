if @*shadowvic?*
    org $2000
end

if @(not *shadowvic?*)
relocated_start     = $2000
relocation_offset   = @(- relocated_start loaded_start)
loaded_end          = @(- relocated_end relocation_offset)
relocation_size     = @(- loaded_end loaded_start)
end

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
    ; as it's being moved up to make space for the VIC.
base_loaded_end = @(- loaded_end (low (-- relocation_size)))
base_relocated_end = @(- relocated_end (low (-- relocation_size)))
    lda #<base_loaded_end
    sta s
    lda #>base_loaded_end
    sta @(++ s)
    lda #<base_relocated_end
    sta d
    lda #>base_relocated_end
    sta @(++ d)
    ldx #@(low relocation_size)
    lda #@(high relocation_size)
    sta @(++ c)
    ldy #@(low (-- relocation_size))
l:  inc $900f
    lda (s),y
    sta (d),y
    dey
    cpy #255
    bne +n
    dec @(++ s)
    dec @(++ d)
n:
    dex
    cpx #255
    bne -l
    dec @(++ c)
    lda @(++ c)
    cmp #255
    bne -l
    jmp relocated_start
end

loaded_start:
if @(not *shadowvic?*)
    org relocated_start
end

music_player_size = @(length (fetch-file "sound-beamrider/MusicTester.prg"))
loaded_music_player_end = @(+ loaded_music_player (-- music_player_size))
music_player_end = @(+ music_player (-- music_player_size))

    ; Now relocate the music player.
base_loaded_music_player_end = @(- loaded_music_player_end (low (-- music_player_size)))
base_relocated_music_player_end = @(- music_player_end (low (-- music_player_size)))
    lda #<base_loaded_music_player_end
    sta s
    lda #>base_loaded_music_player_end
    sta @(++ s)
    lda #<base_relocated_music_player_end
    sta d
    lda #>base_relocated_music_player_end
    sta @(++ d)
    ldx #@(low music_player_size)
    lda #@(high music_player_size)
    sta @(++ c)
    ldy #@(low (-- music_player_size))
l:  inc $900f
    lda (s),y
    sta (d),y
    dey
    cpy #255
    bne +n
    dec @(++ s)
    dec @(++ d)
n:
    dex
    cpx #255
    bne -l
    dec @(++ c)
    lda @(++ c)
    cmp #255
    bne -l
 
    jmp start       ; Start the game…
