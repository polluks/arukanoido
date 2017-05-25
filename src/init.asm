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
prg_size = @(+ (- loaded_end loaded_start) #x100)
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
    ldx #<prg_size
    lda #>prg_size
    sta @(++ c)
    ldy #0
l:  lda (s),y
    sta (d),y
    dey
    cpy #255
    bne +n
    dec @(++ s)
    dec @(++ d)
n:  inc $900f
    dex
    bne -l
    dec @(++ c)
    bne -l
    jmp relocated_start
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
l:  lda (s),y
    sta (d),y
    inc $900f
    dey
    cpy #$ff
    beq +n
q:  dex
    bne -l
    dec @(++ c)
    bne -l

    stx $900f
    jmp start       ; Start the game…

n:  dec @(++ s)
    dec @(++ d)
    jmp -q

