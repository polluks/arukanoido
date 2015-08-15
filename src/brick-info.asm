b_white = 1
b_orange = 2
b_cyan = 3
b_green = 4
b_red = 5
b_blue = 6
b_purple = 7
b_yellow = 8
b_silver = 9
b_gold = 10

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
