decorative   = 128
deadly       = 64
fg_collision = 32
t_scout      = @(+ deadly 1)
t_sniper     = @(+ deadly 2)

sprite_inits:
player_init:
    128 240 0   white <vaus_left <ctrl_vaus >ctrl_vaus 0
dummy_init:
    0 0 0       0 0 <ctrl_dummy >ctrl_dummy
