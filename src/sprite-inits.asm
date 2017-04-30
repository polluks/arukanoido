is_inactive  = 128
was_cleared  = 64
fg_collision = 32
still_touches_vaus = 16
is_bonus     = 2
is_vaus      = 1

vaus_y = @(* 29 8)
multiwhite = @(+ multicolor white)

sprite_inits:
vaus_left_init:  64 vaus_y is_vaus     multiwhite <vaus_left  <ctrl_vaus_left >ctrl_vaus_left 0
vaus_right_init: 72 vaus_y is_vaus     multiwhite <vaus_right <ctrl_vaus_right >ctrl_vaus_right 0
ball_init:       70 0      0           white      <ball       <ctrl_ball >ctrl_ball 0
laser_init:      0 vaus_y  0           white      <laser      <ctrl_laser >ctrl_laser 0
bonus_init:      0 0       is_bonus    black      <bonus_l    <ctrl_bonus >ctrl_bonus 0
dummy_init:      0 0       is_inactive black      0           <ctrl_dummy >ctrl_dummy 0
sprite_inits_end:
