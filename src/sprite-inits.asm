decorative   = 128
deadly       = 64
fg_collision = 32
catched_ball = 2
is_vaus      = 1

sprite_inits:

vaus_left_init:
64 @(* 29 8)    is_vaus @(+ multicolor white) <vaus_left <ctrl_vaus_left >ctrl_vaus_left 0

vaus_right_init:
72 @(* 29 8)    is_vaus @(+ multicolor white) <vaus_right <ctrl_vaus_right >ctrl_vaus_right 0

ball_init:
70 @(- (* 29 8) 5)   catched_ball white <ball <ctrl_ball >ctrl_ball 32

laser_init:
0 @(* 29 8)     0 white <laser <ctrl_laser >ctrl_laser 0

bonus_init:
0 0             0 @(+ multicolor blue)  <bonus_l <ctrl_bonus >ctrl_bonus 0

dummy_init:
0 0             decorative black        0 <ctrl_dummy >ctrl_dummy 0
