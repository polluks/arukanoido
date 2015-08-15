num_chars    = 128
num_sprites  = 16
screen_columns = 15
screen_rows = 32
screen_width = @(* screen_columns 8)
screen_height = @(* screen_rows 8)

charset      = $1000
screen       = $1e00
colors       = $9600

charsetsize         = @(* num_chars 8)
charsetmask         = @(-- num_chars)
framesize           = @(half charsetsize)
framemask           = @(half num_chars)
framechars          = @(half num_chars)

num_score_digits = 8

first_sprite_char   = 1
num_trailing_foreground_chars  = 2

; First char of scrolling terrain.
foreground          = @(+ (half framechars) (quarter framechars))

; First char of score digits.
score_char0         = foreground

    org 0
    data

s:                    0 0 ; Source pointer.
d:                    0 0 ; Destination pointer.
scr:                  0 0 ; Screen pointer.
col:                  0 0 ; Colour RAM pointer.
scrx:                 8   ; X position.
scry:                 0   ; Y position.
curcol:               0   ; Character colour.

last_random_value:    0   ; Random number generator's last returned value.

framecounter:         0   ; Current frame number relative to start of game.
framecounter_high:    0

next_sprite_char:     0   ; Next free character for sprites.
sprite_shift_y:       0   ; Number of character line where sprite starts.
sprite_data_top:      0   ; Start of sprite data in upper chars.
sprite_data_bottom:   0   ; Start of sprite data in lower chars.
sprite_height_top:    0   ; Number of sprite lines in upper chars.
spriteframe:          0   ; Character offset into lower or upper half of charset.
sprite_rr:            0   ; Round-robin sprite allocation index.
foreground_collision: 0   ; Set if a sprite collision has been detected.

joystick_status:      0

lifes:                0
balls:                0

ball_speed:           0
is_firing:            0 ; Laser interval countdown.
old_paddle_value:     0
is_using_paddle:      0

mode_laser = 1
mode_catching = 2
mode_disruption = 3
mode:                 0

current_level:        0 0

collision_y_distance: 0
collision_x_distance: 0

; Temporaries.
tmp:                  0
tmp2:
distance_x:           0 ; Sprite collision X distance.
tmp3:
distance_y:           0 ; Sprite collision Y distance.

; Temporary stores for index registers.
add_sprite_x:         0
add_sprite_y:         0
draw_sprite_x:        0
call_controllers_x:   0

sprites_x:  fill num_sprites  ; X positions.
sprites_y:  fill num_sprites  ; Y positions.
sprites_i:  fill num_sprites  ; Flags.
                              ; 7 = decorative
                              ; 6 = deadly
                              ; 5 = foreground collision
                              ; 4 = bullet Y step
                              ; 3 = bullet increment X
                              ; 2 = bullet increment Y
                              ; 1-0 = 01 sniper 10 scout
sprites_c:  fill num_sprites  ; Colors.
sprites_l:  fill num_sprites  ; Low character addresses.
sprites_fl: fill num_sprites  ; Function controlling the sprite (low).
sprites_fh: fill num_sprites  ; Function controlling the sprite (high).
sprites_d:  fill num_sprites  ; Whatever the controllers want.
sprites_dx: fill num_sprites ; Whatever the controllers want.
sprites_dy: fill num_sprites ; Whatever the controllers want.
sprites_ox: fill num_sprites  ; Former X positions for cleaning up.
sprites_oy: fill num_sprites  ; Former Y positions for cleaning up.

    org $f8

hiscore:    fill num_score_digits

@(check-zeropage-size)

    end
