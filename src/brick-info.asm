b_white = 0
b_orange = 1
b_cyan = 2
b_green = 3
b_red = 4
b_blue = 5
b_purple = 6
b_yellow = 7
b_silver = 8
b_gold = 9

;; Future compression scheme

; Set number of repititions for next brick.
b_run_length = 8

; Copy window someplace else on the screen.
; Existing bricks aren't cleared.
;
; Bit 0 tells to reverse the X axis, bit 1 tells to reverse the Y axis.
; The next two nibbles contain the destination.
b_run_copy = %1100

brick_colors:
    white
    orange
    cyan
    green
    red
    blue
    purple
    yellow
    white
    yellow

brick_scores:
    50
    60
    70
    80
    90
    100
    110
    120