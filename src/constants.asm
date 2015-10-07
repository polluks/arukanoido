; VIC settings

screen       = $1000
charset      = $1400
colors       = $9400

; Screen/char settings

screen_columns  = 15
screen_rows     = 32
screen_width    = @(* screen_columns 8)
screen_height   = @(* screen_rows 8)

; Charset settings

num_chars           = 128
charsetsize         = @(* num_chars 8)

; Sprite/frame settings

num_sprites         = 16
charsetmask         = @(-- num_chars)
framesize           = @(half charsetsize)
framemask           = @(half num_chars)
framechars          = @(half num_chars)
first_sprite_char   = 1
foreground          = @(+ (half framechars) (quarter framechars))

; Game settings

default_num_lifes       = 3
default_ball_speed      = 7
default_ball_direction  = 16
ball_width              = 3
ball_height             = 5
bonus_probability       = %11
vaus_edge_distraction   = 8

; Score settings

num_score_digits    = 7
score_char0         = foreground
score_on_screen     = @(+ screen screen_columns)
hiscore_on_screen   = @(+ score_on_screen num_score_digits 1)
