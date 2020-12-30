pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

-- *** FLAG TABLE ***
-- 0 Floor / Walls
-- 1 Enemy / Obstacle
-- 2 Portals
-- 3 Keys
-- 4 Boost tiles

function _init()
	player = {
		x = 10,
		y = 90,
		sprite = 64,
		size = 1,
		width = 8,
		height = 8,
		flipped = false,
		dx = 0,
		dy = 0,
		mdx = 2,
		mdy = 5,
		acc = 0.5,
		accy = 3.5,
		anim = 0,
		running = false,
		jumping = false,
		falling = false,
		landed = false
	}
	game_keys = {
		sp = 21,
		loc = {
			{
				x = 0,
				y = 0,
				found = true
			},
			{
				x = 96,
				y = 80,
				found = false
			},
			{
				x = 96,
				y = 80,
				found = false
			}
		},
		anim = 0
	}
	fountains = {
		sp1 = 25,
		sp2 = 26,
		loc = {
			{
				x = 96,
				y = 104,
				active = true
			},
			{
				x = 80,
				y = 48,
				active = false
			},
			{
				x = 16,
				y = 24,
				active = false
			}
		}
	}
	game_camera = {
		cam_x = 128,
		cam_y = 0
	}
	world = {
		gravity = 0.3,
		friction = 0.75,
		current_level = 1,
		level_size = 128,
		map_start = 0,
		map_end = 128
	}
end

function _update()
	check_level()
	check_solve()
	-- check_dmg()
	player_update()
	check_boost()
	player_animate()
	game_key_animate()
	camera(128 * (world.current_level - 1), game_camera.cam_y)
end

function _draw()
	cls()
	map(0, 0)
	draw_game_key()
	draw_fountains()
	draw_player()
	draw_debug()
end

-- DEBUG OUTPUT
function draw_debug()
	print(world.current_level, 128 * (world.current_level - 1), 10)
	print(fountains.loc[world.current_level].active, 128 * (world.current_level - 1), 20)
	print(player.dy, 128 * (world.current_level - 1), 30)
end

-- UTILITY FUNCTIONS

function check_level()
	world.current_level = ceil(player.x / 128)
end

function check_solve() -- check if player has unlocked level
	local level = world.current_level
	if map_collide(player, "down", 3)
	or map_collide(player, "right", 3)
	or map_collide(player, "left", 3) then -- if they touch level key
		if not game_keys.loc[level].found then -- play sound
			sfx(7)
		end
		fountains.loc[level].active = true
		game_keys.loc[level].found = true
	end
	if map_collide(player, 'down', 2) then -- if jumping into portal
		player.x = (world.current_level * world.level_size) + 1
		game_camera.cam_x = world.current_level * world.level_size
	end
end

function check_boost() -- check if on boost tile
	if map_collide(player, 'down', 4) then
		player.dy = -player.mdy
	end
end

function check_dmg() -- check if on enemy tile
	if map_collide(player, 'right', 1) then
		player.sprite = 48
		player.dx = 0
		player.dy = 0
		player.x = 10,
		player.y = 90,
	end
end
 
function game_key_animate()
	if time() - game_keys.anim > 0.3 then
		game_keys.anim = time()
		game_keys.sp += 1
		if game_keys.sp > 24 then
			game_keys.sp = 21
		end
	end
end

function draw_game_key()
	local level = world.current_level
	if not game_keys.loc[level].found then
		local g_x = game_keys.loc[level].x + ((level - 1) * 128)
		local g_y = game_keys.loc[level].y
		spr(game_keys.sp, g_x, g_y, 1, 1, false)
	end
end

function draw_fountains()
	local level = world.current_level
	if fountains.loc[level].active then
		local g_x = fountains.loc[level].x + ((level - 1) * 128)
		local g_y = fountains.loc[level].y
		spr(fountains.sp1, g_x, g_y, 1, 1, false)
		spr(fountains.sp2, g_x + 8, g_y, 1, 1, false)
	end
end

function player_update()
	player.dy += world.gravity
	player.dx *= world.friction
	-- -- velocity cap check to add a ceiling to boosts
	if player.dy > player.mdy then
		player.dy = player.mdy
	elseif player.dy < -player.mdy then
		player.dy = -player.mdy
	end
	-- player controls
	if btn(0) then -- left
		player.dx -= player.acc
		player.running = true
		player.flipped = true
	end
	if btn(1) then -- right
		player.dx += player.acc
		player.running = true
		player.flipped = false
	end
	if  btnp(2) and player.landed then -- if jump was pressed and not in the air
		player.dy -= player.accy
		player.landed = false
	end
	if not btn(0) and not btn(1) and not btnp(2) then
		player.running = false
	end
	-- check for collisions
	-- y axis
	if player.dy > 0 then -- falling
		player.falling = true
		player.landed = false
		player.jumping = false
		check_boost()
		if map_collide(player, "down", 0) then 
			player.landed = true
			player.falling = false
			player.dy = 0
			player.y -= ((player.y + player.height + 1) % 8) - 1-- fallback to prevent getting stuck
		end
	elseif player.dy < 0 then -- jumping
		player.jumping = true
		if map_collide(player, "up", 0) then
			player.dy = 0
			player.dx += player.accy
		end
	end
	-- x axis
	if player.dx < 0 then 
		if map_collide(player, "left", 0) then
			player.dx = 0
		end
	elseif player.dx > 0 then 
		if map_collide(player, 'right', 0) then
			player.dx = 0
		end
	end
	-- update the player position
	player.x += player.dx 
	player.y += player.dy 
	-- limit player to screen edges
	if player.x <= world.map_start then
		player.x = world.map_start + 1
	end
end

function player_animate()
	if player.jumping then 
		player.sprite = 68
	elseif player.falling then
		player.sprite = 69
	elseif player.running then
		if time() - player.anim > 0.3 then
			player.anim = time()
			player.sprite += 1
			if player.sprite > 66 then
				player.sprite = 65
			end
		end
	else -- idle animation
		if time() - player.anim > 0.6 then
			player.anim = time()
			player.sprite += 1
			if player.sprite > 76 or player.sprite < 73 then
				player.sprite = 73
			end
		end
	end
end

function draw_player()
	spr(player.sprite,player.x,player.y, player.size, player.size, player.flipped)	
end

function map_collide(obj, dir, flag)
	local x1, x2, y1, y2 = 0
	-- append invisible rectangle to character, position based on current direction
	if dir == 'left' then
		x1 = obj.x - 1
		y1 = obj.y
		x2 = obj.x
		y2 = obj.y + obj.height - 1
	elseif dir == 'right' then
		x1 = obj.x + obj.width
		y1 = obj.y 
		x2 = obj.x + obj.width + 1
		y2 = obj.y + obj.height - 1
	elseif dir == 'up' then
		x1 = obj.x + obj.width
		y1 = obj.y - 1
		x2 = obj.x + obj.width - 1
		y2 = obj.y 
	elseif dir == 'down' then
		x1 = obj.x + 1
		y1 = obj.y + obj.height
		x2 = obj.x + obj.width - 1
		y2 = obj.y + obj.height + 1
	end
	-- convert pixel size to tile size
	-- x1 /= 8
	-- x2 /= 8
	-- y1 /= 8
	-- y2 /= 8
	-- check each corner of rect for collision with flagged tiles
	if fget(mget(x1/8, y1/8),flag)
	or fget(mget(x1/8, y2/8),flag)
	or fget(mget(x2/8, y1/8),flag)
	or fget(mget(x2/8, y2/8),flag) then
		return true
	else
		return false
	end
	
end

__gfx__
000000000000000000000000d0111100000000000000000000000000000000000008800000288200101110100000000000000000000000001010010100000000
00000000000000000000000010000001005555000000000000555500000000000080080002888820100100000000000000000000000000000111111000000000
0070070000000000000000001100000105066050005555000526625000555500008888002800e082010100110000000000000000000000001100001100000000
000770000000000000000000101000010560065005066050056e8650052662500802808088000088010010110000000000000000000000000010010000000000
00077000000000000000000011010001056006500560065005688650056e86500866568088888888111000010000000000000000000001000010010000000000
0070070000000000000000001000000105066050056006500526625005688650008508002880e882011000010000000000000000000000000100001000000000
00000000000000000000000010001001005555000506605000555500052662500880288008088080100011000000000000000000000000000101101000000000
00000000000000000000000110000001000000000055550000000000005555000800008000288200101101110000000000000000000000001010010100000000
00010111666666666666666600000000000000000000c0000c000700000000c000071000000000000c0001001011110100000000000000011000000010100101
11010101555555555555555500001110011100000c0ccc00000cc100000ccc00000ccc00000c0000ccc000000111111000001100000000000000000001111110
011101010000010100000000000000111100000000c6c6c000c6c6c000c6c6c000c6c6c0000000100c00c0001100001100000000000000000000000011000011
01011101000001010000000000001110011100000666666006666660066666600666666000000000000000001010010100100001001111000011110001000010
01110111000001010000000000101111111101000616616006166160061661600616616005676666666666501010010100100001011000101110011000111100
11010111000001010000000011111010010111110566661005666610056666100566661000566666666665001100001100100001110000111000001100000000
01110101000001010000000001100111111001100060060000600600006006000060060000055666666550000101101000100001100000000000000100000000
10011111000001010000000011001018810100110000000000000000000000000000000000000555555000001011110100100001100110000001100100000000
00000000000000000000000000001110d11100000100011100111000000000000000000010111100001111011010010000100101000100000000100000000000
00000000000000000001000000000011110000001011100011000100000000000000000001111110011111100111111001111110000000000000000001111110
00800080000000000000000000000110011000001000100001000010000000000000000011000011110000111100001001000011000000011000000001000011
80080800000000000000000000001011110100001000010001000001000000000000000010100101101001010010010000100100100000111100000100100100
02022200000000000000000000011110011110001000010000100001000000000000000010100101101001010010010000100100111111100111111100100100
02012102000000000001000000111001100111001100001000100001000000000000000011000011110000110100001001000010011000000000011001000010
21211120000000000000000011110010010011110100001000010001000000000000000001011010010110100101101001011010000000000000000001011010
10110101000000000000000000100100001001001100010000010001000000000000000010111101101111011010010000100101000000000000000010100101
00666000777777707777777077710110600000061000010000100001000000000000000000010111111010000000000000000000000000000000000000000000
00666600766666607666666076661110060000601000010000100001000000000000000010001111111100010000000000000000000000000000000000000000
00060606766666607666161076661610006006001000110000100011000000000000000001011110011110100000000000000000000000000000000000000000
606666607666666076666160766661600056c0001101111001100111000000000000000000111100001111000000000000000000000000000000000000000000
06666600766666607666661076666610005160000111001111011110000000000000000000001110011100000000000000000000000000000000000000000000
00066000766666107666666076666660056556000111000111001110000000000000000000000111111000000000000000000000000000000000000000000000
00006660766661107666666076666660560000600110000110001100000000000000000000000011110000000000000000000000000000000000000000000000
00000006000000000000000000000000600000060000000100001000000000000000000000000001100000000000000000000000000000000000000000000000
0d01c0d00d01c0d00d01c0d0000000000d01c0d0000000000d01c0d00d01c0d00d01c0d00d01c0d000000000000000000d01c0d0000000000000000000000000
0d5111d00d5111d00d5111d00d01c0d00d5111d00d01c0d00d5111d00d5111d00d5111d00d5111d00d0c00d00d00c0d00d5111d0000000000000000000000000
0015150000151500001515000d5111d0001515000d5111d0001515000015150000151500001515000d1111d00d1111d000151500000000000000000000000000
00566600005666000056660000551500005666000055150000566600005666000056660000566600005151000015150000566600000000000000000000000000
08011180080111800801118000166600080111800016660008011180080111800801118008011180006665000056660008011180000000000000000000000000
0f1111f000f111000f1111f008f1118ff011110008f1118f0f1111f000f111000f1111f00f1111f008011180080111800f1111f0000000000000000000000000
008008000008020000200800001111000080080000111100008008000008020000200800008008000f1111f00f1111f000800800000000000000000000000000
00800800000802000020080000800800080080000080080000800800000802000020080000800800008008000080080000800800000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
16666661000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c0000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ccc00ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06660060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
66666666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0008040000000000000001000000000000010100000808080800000100000000020000000000000000000000000000000001010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0e0e0e0e0e0e0e0e0e0e2222222222220a0a0a0a0a0a0a0a0a0a0a0a0a0a0a1b000013140000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b1f0000000000000000000000001f1b0000393a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b00000000000000000000000000001b002200002200000000000000002222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b0000000000000000002b2c0000001b202202022200000000000000000022220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e2b130e0e0e0e142c0e2222222222221b000000000000000022393a2200000a0a0a0a0a0a20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e050e0e050e0e0e2222222222221b00000000000000222200002222001b00000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e1d1e0e0e0e0e2222222222221b00000020200000222202022222001b0000000000000a0000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e2d2e0e0e0e0e2222222222221b0000000a0a0a0a0a0a0a0a0a0a0a1b000022220000006000323232330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e2222222222221b00000000000000000000000000001b002222222200000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e25260e0e25260e0e2222222222221b61000000000000000000000000001b000022220000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e35360e0e35360e0e220e292a0e220a600a0a0a0a0a0a000000000100201b000000000000000300000000010000600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e220e393a0e2200000000000000000a0000000a0a0a0a000000000000323233000000003233030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e220e00000e22000000000000000000000032330a0a0a000000000000000300000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e220e02020e22000000000000000000003232310a0a0a000000006000000300006000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
111211121112111211121112111211120a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000300000000000000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a202020202020202020202020200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011c00000f0330f00014613000000d03300000146130a0000d0430000014615000000a0330000013615000000f0230f00012613000000d0330000012613126150f0230000012615000000a033000001261512615
001c00000870508735040050c03508304083050700400c0500725004000274510300057550e745077450c031083050875503c0503c0509005070350875008500085050754502c050305508405073050575400c05
001c0000325040b5040d50509504085052c5042f504205041c50111514115041c5152c5002e5003350035500355043550436504365041c5012172422714217141d7111b5141e5141d51427501275041d50100504
011c000004407137040f7041370404400054001370406600056000c7400f704137040360003605036050460004407137040f704137041770019700187001970004407137040f70413704137000c7340c7040c704
011e00002152422514215141d5111b5141e5141d5141d511000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000002150422504215041d5011b504
00100000040500c0500a0500905000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0009000018421057351f7502344000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
03 01024304
02 01020344

