vaus_middle =   2
vaus_right =    3
ball =          4
laser =         5
bonus_laser =   6

    fill @(- 256 (low *pc*))

sprite_gfx:
vaus_left:
    %00011111
    %00101010
    %00011111
    %11011111
    %11011111
    %00010000
    %00011111
    %00010000

vaus_middle:
    %11111111
    %10101010
    %11111111
    %11111111
    %11111111
    %00000000
    %11111111
    %00000000

vaus_right:
    %11110100
    %10101000
    %11110100
    %11110111
    %11110111
    %00000100
    %11110100
    %00000100

ball:
    %01000000
    %11100000
    %11100000
    %11100000
    %01000000
    %00000000
    %00000000
    %00000000

laser:
    %11000011
    %10000001
    %11000011
    %10000001
    %11000011
    %10000001
    %11000011
    %10000001

bonus_gfx_start:
bonus_l:
    %00010100
    %01010101
    %01100101
    %01100101
    %01100101
    %01100101
    %01101001
    %00010100

bonus_e:
    %00101000
    %10101010
    %10111110
    %10111010
    %10111110
    %10111010
    %10111110
    %00101000

bonus_c:
    %00101000
    %10101010
    %10111110
    %10111010
    %10111010
    %10111010
    %10111110
    %00101000

bonus_s:
    %00101000
    %10101010
    %10111110
    %10111010
    %10111110
    %10101110
    %10111110
    %00101000

bonus_b:
    %00101000
    %10101010
    %10111110
    %10111110
    %10111010
    %10111110
    %10111110
    %00101000

bonus_d:
    %00101000
    %10101010
    %10011010
    %10010110
    %10010110
    %10010110
    %10011010
    %00101000

bonus_p:
    %00101000
    %10101010
    %10010110
    %10010110
    %10010110
    %10011010
    %10011010
    %00101000
bonus_gfx_end:

sprite_gfx_end:
