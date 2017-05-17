scores:     0 0 0 0 0 5 0
score_50:   0 0 0 0 0 6 0
score_60:   0 0 0 0 0 7 0
score_70:   0 0 0 0 0 8 0
score_80:   0 0 0 0 0 9 0
score_90:   0 0 0 0 1 0 0
score_100:  0 0 0 0 1 1 0
score_110:  0 0 0 0 1 2 0
score_120:

; Mapping colour RAM values to scores.
; (When the plan was to make this unexpanded.)
color_scores:
    0
    @(- score_50 scores)    ; 1 white
    @(- score_90 scores)    ; 2 red
    @(- score_70 scores)    ; 3 cyan
    @(- score_110 scores)   ; 4 purple
    @(- score_80 scores)    ; 5 green
    @(- score_100 scores)   ; 6 blue
    @(- score_120 scores)   ; 7 yellow
    0 0 0 0 0 0 0
    @(- score_60 scores)    ; 15 orange
