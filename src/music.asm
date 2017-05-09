init_music = $799a
play_music = $7053
current_song = $702b
requested_song = $702d

snd_test              = 3
snd_theme             = 1
snd_round             = 2
snd_extend            = 3
snd_game_over         = 4
snd_doh_round         = 5
snd_hiscore           = 6
snd_reflection_low    = 7
snd_reflection_high   = 8
snd_reflection_silver = 9
snd_catched_ball      = 10
snd_miss              = 11
snd_coin              = 11
snd_twelve            = 12
snd_thirteen          = 13
snd_growing_vaus      = 14
snd_hit_distractor    = 15
snd_laser             = 16
snd_seventeen         = 17

sound_priorities:
    0 ; no sound
    2 ; 1
    2 ; 2
    1 ; 3
    2 ; 4
    2 ; 5
    2 ; 6
    0 ; 7
    0 ; 8
    0 ; 9
    0 ; 10
    2 ; 11
    1 ; 12
    1 ; 13
    2 ; 14
    1 ; 15
    2 ; 16
    1 ; 17

play_sound:
    sta tmp
    txa
    pha
    tya
    pha
    ldx tmp
    ldy current_song
    lda sound_priorities,y
    cmp sound_priorities,x
    beq +m
    bcs +n
m:  lda tmp
    sta requested_song
n:  pla
    tay
    pla
    tax
    rts

wait_sound:
    jsr random              ; Avoid CRTC hsync sine wave wobble.
    lda requested_song
    bne wait_sound
    rts

loaded_music_player:
    @(fetch-file "sound.bin")
