decorative   = 128
deadly       = 64
fg_collision = 32

sprite_inits:

player_left_init:
64 @(* 29 8)    0 @(+ multicolor white) <vaus_left <ctrl_vaus_left >ctrl_vaus_left 0

player_right_init:
72 @(* 29 8)    0 @(+ multicolor white) <vaus_right <ctrl_vaus_right >ctrl_vaus_right 0

ball_init:
70 @(- (* 29 8) 4)   0 white <ball <ctrl_ball >ctrl_ball @(* +degrees+ 0.45)

laser_init:
0 @(* 29 8)     0 white                 <laser <ctrl_laser >ctrl_laser 0

dummy_init:
0 0             decorative black        0 <ctrl_dummy >ctrl_dummy 0
