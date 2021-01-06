pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

-- *** FLAG TABLE ***
-- 0 Floor / Walls
-- 1 Enemy / Obstacle
-- 2 Portals
-- 3 Keys
-- 4 Boost tiles

#include src/player.lua
#include src/game_keys.lua
#include src/fountains.lua
#include src/turbines.lua
#include src/utils.lua
#include src/hazards.lua
#include src/collisions.lua
#include src/particles.lua
#include src/bullets.lua
#include src/update.lua
#include src/draw.lua

function _init()
	-- music(3)
	player = player
	game_keys = game_keys
	fountains = fountains
	turbines = turbines
	flames = flames
	turrets = turrets
	game_camera = {
		cam_x = 0,
		cam_y = 0,
		offset = 0
	}
	world = {
		gravity = 0.3,
		friction = 0.75,
		current_level = 1,
		current_row = 1,
		level_size = 128,
		map_start = 0,
		map_end = 128,
	}
	effects = {}
	particles = {
		death_fx = {8,2,5}, -- color arrays
		dust_fx = {6,5},
		wind_fx = {6,5},
		bubble_fx = {12,1},
		fire_fx = {8,2,0},
		fire_fx_xl = {8,8,2}
	}
	bullets = {}
	ghosts = {}
end

function _update()
    check_level()
    check_solve()
	check_dmg()
	check_boost()
	player_update()
	player_animate()
    update_bullets()
	run_turbines()
	animate_turbines()
    run_flames()
    animate_fountains()
    game_key_animate()
    update_fx()
end

function _draw()
	cls()
	map(0, 0)
	draw_ghosts()
	draw_game_key()
	draw_fountains()
	draw_turbines()
	draw_turrets()
	draw_player()
	draw_bullets()
	draw_fx()
	roll_cam()
	draw_debug()
end

-- DEBUG OUTPUT
function draw_debug()
	-- print(world.current_level, 128 * (world.current_level - 1), 0)
	-- print(fountains.loc[world.current_level].active, 128 * (world.current_level - 1), 20)
	-- print(player.dx, 128 * (world.current_level - 1), 30)
	-- print(#ghosts, 128 * (world.current_level - 1), 30)
	-- print(#bullets, 128 * (world.current_level - 1), 30)
end

__gfx__
00000000000000000000000000111100000000000000000000000000000000000008800000288200101110101110101101101010000000001010010111111111
00000000000000000000000010000001005555000055550000555500000000000080080002888820100100001001000101010110000000000111111010010011
0070070000000000000000001100000105066050050660500526625000155100008888002800e082010100111101001101101010000000001100001110100111
000770000000000000000000101000010560065005600650056e8650012662100802808088000088010010111100101000100100000000000010010011001111
00077000000000000000000011010001056006500560065005688650056e86500866568088888888111000011010010100011000000001000010010010010101
0070070000000000000000001000000105066050050660500526625005688650008508002880e882011000010110000100000000000000000100001010111001
00000000000000000000000010001001005555000055550000555500012662100880288008088080100011001000110000000000000000000101101011110001
00000000000000010000000110000001000000000000000000000000001551000800008000288200101101111010000100000000000000001010010111111111
00010111666666666661661600000000000000000000c0000c000700000000c000071000000000000c0001001011110100000000000000011000000010100101
11010101555555556616616600001110011100000c0ccc00000cc100000ccc00000ccc00000c0000ccc000000111111000001100000000000000000001111110
011101010000010111111111000000111100000000c6c6c000c6c6c000c6c6c000c6c6c0000000100c00c0001100001100000000000000000000000011000011
01011101000001011010101000001110011100000666666006666660066666600666666000000000000000001010010100100001001111000011110001000010
01110111000001010010001000101111111101000616616006166160061661600616616005676666666666501010010100100001011000101110011000111100
11010111000001010000101011111010010111110566661005666610056666100566661000566666666665001100001100100001110000111000001100000000
01110101000001010000100001100111111001100060060000600600006006000060060000055666666550000101101000100001100000000000000100000000
10011111000001010000000011001018810100110000000000000000000000000000000000000555555000001011110100100001100110000001100100000000
00000000000800210000000000001110d11100000100011100111000001000010001000110111100001111011010010000100101000100000000100000000000
00000000000022100001000000000011110000001011100011000100011000001101001001111110011111100111111001111110000000000000000001111110
00800080080000210000000000000110011000001000100001000010111110100101111011000011110000111100001001000011000000011000000001000011
80080800008211110000000000001011110100001000010001000001010011101100011010100101101001010010010000100100100000111100000100100100
02022200000221000000000000011110011110001000010000100001011011000100110010100101101001010010010000100100111111100111111100100100
02012102008211110001000000111001100111001100001000100001001011000111110011000011110000110100001001000010011000000000011001000010
21211120080000200000000011110010010011110100001000010001010101100101010001011010010110100101101001011010000000000000000001011010
10110101000002010000000000100100001001001100010000010001000100110110111110111101101111011010010000100101000000000000000010100101
00ddd000777777707777777077710110711177701000010000100001100011010111100000010111111010006000000611112211777777700101011001111011
00dddd00766666607666666076661110116166601000010000100001011011010100110110001111111100010600006018122121766666601010100001001100
000d0d0d766666607666666076661610111666601000110000100011001001110100011101011110011110100060060088282210766666600101100001000111
d0ddddd0766666607666666076666160616666601101111001100111001001011100011000111100001111000056c00008828120766666601111000011000110
0ddddd00766666607666666076666610166666600111001111011110011111111110110000001110011100000051600008882100766666601010000011101100
000dd000766666107666666076666660766666600111000111001110111100100011111000000111111000000565560000888200566666601000000000111110
0000ddd0766661107666666076666660766666600110000110001100010110010001101100000011110000005600006000080000556666600000000000011011
0000000d000000000000000000000000000000000000000100001000100011011001000000000001100000006000000600000000000000000000000010010101
0d01c0d00d01c0d00d01c0d0000000000d01c0d0000000000d01c0d00d01c0d00d01c0d00d01c0d000000000000000000d01c0d0000000000000000000000000
0d5111d00d5111d00d5111d00d01c0d00d5111d00d01c0d00d5111d00d5111d00d5111d00d5111d00d0c00d00d00c0d00d5111d0000000000000000000000000
0015150000151500001515000d5111d0001515000d5111d0001515000015150000151500001515000d1111d00d1111d000151500000000000000000000000000
00566600005666000056660000551500005666000055150000566600005666000056660000566600005151000015150000566600000000000000000000000000
08011180080111800801118000166600080111800016660008011180080111800801118008011180006665000056660008011180000000000000000000000000
0f1111f000f111000f1111f008f1118ff011110008f1118f0f1111f000f111000f1111f00f1111f008011180080111800f1111f0000000000000000000000000
008008000008020000200800001111000080080000111100008008000008020000200800008008000f1111f00f1111f000800800000000000000000000000000
00800800000802000020080000800800080080000080080000200800000802000020080000800800008008000080080000800800000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01000010010000100100001001000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7cc007cc07000070cc700cc70c0000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06000060060000600600006006000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
77666666776666667766666677666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
07766660077666600776666007766660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00500500005005000050050000500500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600600006006000060060000600600000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000666666000000000000000000011110000000000000001111110000010100000000000000000000000000000000000000000000000000000000000000000
00062662266260000001000000000110001000000000000000111100000001010000000000000000000000000000000000000000000000000000000000000000
00666015510666000000000000001101100100000000000001111110000000100000000000000000000000000000000000000000000000000000000000000000
06261100001162600000000000011011110010000000000011111111000001010000000000000000000000000000000000000000000000000000000000000000
02611100001116200000000000110111011001000000000001111110000000000000000000000000000000000000000000000000000000000000000000000000
66111111111111660008000001101110101100100001100000111100000000000000000000000000000000000000000000000000000000000000000000000000
06610101101016600000000011011111010110010010010000011000000000000000000000000000000000000000000000000000000000000000000000000000
01001110011100100000000011111111001001110100001000000000000000000000000000000000000000000000000000000000000000000000000000000000
06610101101016600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66111111111111660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62611100001116260000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06661100001166600001100000011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666010010666600011100000111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00662661166266000111100000111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00026666666620000111100001111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0008040000000000000001010000000100010100000808080800000100000000020200000000000000000000000000000001010101000000000000000200000100000000000000000000000000000000000000000000000000000000000000001000000010000000000000000000000000000000000000000000000000000000
0000020000000000000000000000000002020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0e0e0e0e0e0e0e0e0e0e2222222222220a0a0a0a0a0a0a0a0a0a0a0a0a0a0a1b000013140000000000000000000000000a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a3c3c3c3c3c3c3c3c3c3c3c3c3c3c0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a00000000000013393a14000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b1f0000000000000000000000001f1b0000393a0000000000000000000022220a0a22222222222222222222222222220a00003432330022220034323300000a000000000000000000000000000000000a0500000000000000000000292a000a00000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b00000000000000000000000000001b002200002200000000000000002222220a0a00222200000000002222220022220a00000000000022220000000000000a000000000000000000000000000000000a3e00000000000000000022393a220a00000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b0000000000000000002b2c0000001b202202022200000000000000000022220a3c00220000343300000022000000220a00000000000022220000000000000a000000000000000000000000000000000a00000022220000000000220000220a00000000000000000000000000000000
0e2b130e0e0e0e142c0e2222222222221b000000000000000022393a2200000a0a0a0a0a0a20000000000000000000000a0000000000033100000000000000220a00000000000022220000010000000a000000000000000000000000000000000a00002222222200000000220202220a00000000000000000000000000000000
0e0e0e050e0e050e0e0e2222222222221b00000000000000222200002222001b00000000000a000000000000000000000a0000000064030a0a0a0a00000000000a00000033323122223332310000000a000000000000000000000000000000000a00000022220000000000340a0a330a00000000000000120000000b0b000000
0e0e0e0e1d1e0e0e0e0e2222222222221b00000020200000222202022222001b0000000000000a0000200000000000000a000000210a0a000000000a0a0000000a000000000000808100000a00000b0a0000000d0d0d0d0d0d0d0d0f000000000a00000000000000120012000000000a2020000000000000000000373f000000
0e0e0e0e2d2e0e0e0e0e2222222222221b0000000a0a0a0a0a0a0a0a0a0a0a1b000022220000006400343232330000000a000000210a0000272800000a0000010a00640000000090910000370a00000a0000000d0d0d0d0d0d0f0d0d000001000a00000000000000000000000100000a12121212000000010000003c3c000000
0e0e0e0e0e0e0e0e0e0e2222222222221b00000000000000000000000000001b002222222200000300000000000000000a000000000a002937382a000a0000030a000c00000000000000000a380a000a0000000d0d0d0d0d0d121212121212120a00640000000000000000000a00000a00000000000000000000000000000000
0e0e25260e0e25260e0e2222222222221b00000000000000000000000000001b000022220000000300000000000000000a640000000a00221f1f22000a0000030a000000000000000000001c001c000a0000000d0d640d0d0d0d0d0d000000000a00000000000000000000000a00000a000000000000000f0f200000000b0b00
0e0e35360e0e35360e0e220e292a0e220a640a0a0a0a0a0a000000000100201b000000000000000300000000010000640a0a0000000a002202022200000000030a000000000000000000001c001c000a0000000d0d3f0d0d0d0d0d0d000000000a0a1b1b0f0000000f0f00000a64000a000000000000000e0e3e000000373f00
0e0e0e0e0e0e0e0e0e0e220e393a0e2200000000000000000a0000000a0a0a0a0000000000003432330000000034330a0a000000000a003432323300000000030a000000006400000000001c001c000a0000000d0d3f0d0d0d0d0d0d000000000a0000000000000000000f200a00000a000000000000000f0f000000003c3c00
0e0e0e0e0e0e0e0e0e0e220e00000e22000000000000000000000034330a0a0a000000000000000300000000000000030a000000000a000000000000000000030a000000000c00000000001c001c000a0000000d0d3f3f0d0d0d0d0d0d0d00000a000000000000000000000f0a00000a000000000000000e0e00000000000000
0e0e0e0e0e0e0e0e0e0e220e02020e22000000000000000000003432310a0a0a000000006400000300006400000000030a000000000a202020202020640000030a000000330000850000851c001c000a0000000d643f383f0d0d0d00000d00000a0000000a80810a000000000000000a000000000000000f0f00000000000000
111211121112111211121112111211120a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000c00000300000c00000000030a000000640a0a0a0a0a0a0a0a0a0a0a0a000034310000860202861c001c200a0000000d3f3f383f200d0d02020d00000a00000f3f90913f0f0000000000000a0a0a00006000000e0e00000000000000
0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a202020202020202020202020200a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a11111111111111111111111111110a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0b12123412121212331212121264120b0b3800000c00000f0f00000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003c3c3c3c3c3c3c3c3c3c3c3c3c3c3c3c
__sfx__
011800000f0130f00014603000000d01300000146030a0000d0130000014605000000a0130000013605000000f0130f00012603000000d0130000012603126050f0130000012605000000a023000001261512615
011800000f0230f00014613000000d02300000146130a0000d0230000014615000000a0230000013615000000f0230f00012613000000d0330000012613126150f0230000012615000000a023000001261512615
001800000870508735040050c03508304083050700400c0500725004000274510300057550e745077450c031083050875503c0503c0509005070350875008500085050754502c050305508405073050575400c05
001a0000325040b5040d50509504085052c5042f504205041c50111514115041c5152c5002e5003350035500355043550436504365041c5012172422714217141d7111b5141e5141d51427501275041d50100504
011a000004407137040f7041370404400054001370406600056000c7400f704137040360003605036050460004407137040f704137041770019700187001970004407137040f70413704137000c7340c7040c704
011e00082152422514215141d5111b5141e5141d5141d511000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002150422504215041d5011b504
01180000040300c0300a0300903000000000000000000000040000c0000a0000900000000000000000000000040300c0300a0400903000000000000000000000040000c0000a0000900000000000000000000000
000900001811104035210342402000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001e7510a414000010175100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011800200015403155061350215506155081450a1550575200000057500000005000057000575000000000000015203152061550214406155081550a145057520000008750000000000000000087500000000000
01300000000000000000000000001f7550000000000000002075100000167550000000000000000e755000000f700000002475500000000001b7541b7071b755000001f75500000000001b755000000e75300000
011800001334515345173051330515345173451330515345173051334515345173051734517345173451330515305173451734515305133451334515305173451730517345133451534513305173451730515045
001800001e7110000019005160050e0001b0001300014000000000000000000000000000000000000000000000000000000000010701107011570115701107010f70100000000000000000000000000000000000
01180000157000c003000000000000000000000000000000000000000000000000000000000000157100c0130000000000000000000000000000000000000000000000000000000000000000000000157100c013
011000002112310615000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000a41400001017510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
013000000d5140e4140e4240f5240f41410514115140c2141152411414105140f5240e3240d5140d5140e3140f5241121412514125241242412414125140f3140f42410314145241551415514142141152411324
__music__
03 41024344
02 01020344
03 494a000a
03 06010f0d

