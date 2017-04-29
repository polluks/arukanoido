; Fixed addresses

preshifted_sprites  = $6000
music_player        = $7000

; VIC settings

screen       = $1000
charset      = $1400
colors       = $9400

; Screen settings

screen_columns  = 15
screen_rows     = 32
screen_width    = @(* screen_columns 8)
screen_height   = @(* screen_rows 8)

; Charset settings

num_chars           = 256
charsetsize         = @(* num_chars 8)

; Sprite/frame settings

num_sprites         = 16
charsetmask         = @(-- num_chars)
framesize           = @(half charsetsize)
framemask           = @(half num_chars)
framechars          = @(half num_chars)
first_sprite_char   = 1
foreground          = @(+ (half framechars) (quarter framechars))
frame_a             = charset
frame_b             = @(+ charset framesize)

; Game settings

default_num_lifes       = 3
default_ball_speed      = 7
default_ball_direction  = 144
ball_width              = 3
double_ball_width       = @(* 2 ball_width)
ball_height             = 5
bonus_probability       = %11
vaus_edge_distraction   = 16

; Score settings

num_score_digits    = 7
score_char0         = foreground
scorechars          = @(+ charset (* 8 score_char0))
score_on_screen     = @(+ screen screen_columns)
hiscore_on_screen   = @(+ score_on_screen num_score_digits 1)
