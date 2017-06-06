roundintro:
l:  lda #0              ; Fetch joystick status.
    sta $9113
    lda $9111
    tax
    and #joy_fire
    beq +n
    txa
    and #joy_left
    bne -l

n:  rts

txt_round_intro:
    "THE ERA AND TIME OF" 1
    "THIS STORY IS UNKNOWN" 0
    "AFTER THE MOTHERSHIP" 1
    "\"ARKANOID\" WAS DESTROYED," 1
    "A SPACECRAFT \"VAUS\"" 1
    "SCRAMBLED AWAY FROM IT." 0
    "BUT ONLY TO BE" 1
    "TRAPPED IN SPACE WARPED" 1
    "BY SOMEONE........" 0
    0
