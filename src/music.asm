init_music = $799a
play_music = $7053
current_song = $702b
requested_song = $702d

snd_theme             = 1
snd_round             = 2
snd_power_up          = 3 ; ???
snd_game_over         = 4
snd_thrill            = 5 ; ???
snd_theme2            = 6
snd_reflection_low    = 7
snd_reflection_high   = 8
snd_reflection_silver = 9
snd_growing_vaus      = 14
snd_hit_distractor    = 15
snd_laser             = 16

sound_priorities:
    0
    2 ; 1: Theme
    2 ; 2: Round start
    1 ; 3: Power up
    2 ; 4: Game over
    1 ; 5: "thrill"
    2 ; 6: theme 2
    0 ; 7: bing
    0 ; 8: bing
    0 ; 9: bing
    1 ; 10: blip
    1 ; 11: closing door/thunder
    1 ; 12: ring
    1 ; 13: ring passing by
    1 ; 14: growing vaus
    1 ; 15: thud
    1 ; 16: shot
    1 ; 17: down and up

play_sound:
    sta tmp
    txa
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
    tax
    rts

loaded_music_player:
    @(fetch-file "sound.bin")
