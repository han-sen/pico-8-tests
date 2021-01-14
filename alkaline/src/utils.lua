-- UTILITY FUNCTIONS

function check_level()
	if player.y < 128 then 
		world.current_row = 1
		world.current_level = ceil(player.x / 128)
		game_camera.cam_x = (world.current_level - 1) * 128
		game_camera.cam_y = 128 * (world.current_row - 1)
	else
		world.current_row = 2
		world.current_level = ceil(player.x / 128) + 8
		game_camera.cam_x = (world.current_level - 9) * 128
		game_camera.cam_y = 128
	end
end

function check_solve() -- check if player has unlocked level
	local level = world.current_level
	local row = world.current_row
	if map_collide(player, "down", 3)
	or map_collide(player, "right", 3)
	or map_collide(player, "left", 3) then -- if they touch level key
		if not game_keys.loc[level].found then -- play sound
			local f_x = fountains.loc[level].x + ((level - 1) * 128) + 8
			local f_y = fountains.loc[level].y
			sfx(7)
			water_fx(f_x, f_y, 16, particles.bubble_fx, 16)
		end
		fountains.loc[level].active = true
		game_keys.loc[level].found = true
		for turret in all(turrets.loc) do 
			if turret.level == level then
				turret.active = true
			end
		end
	end
	if map_collide(player, 'down', 2) and fountains.loc[level].active then -- if solved and jumping into portal
		-- stop momentum
		player.dx = 0
		player.dy = 0
		local n_l, n_r
		if level == 8 then 
			n_l = 9
			n_r = 2
		elseif level == 9 then
			n_l = 10
			n_r = 2
		else
			n_l = level
			n_r = row
		end
		player.x = ((n_l % 9) * 128) + player.width
		player.y = (128 * (n_r - 1)) + 104 -- spawn two tiles up from botton
		game_camera.cam_x = flr(player.x/128)
		game_camera.cam_x = flr(player.y/128)
		bullets = {}
	end
end

function check_boost() -- check if on boost tile
	if map_collide(player, 'down', 4) then
		player.dy = -player.mdy
	end
end

function check_dmg() -- check if on enemy tile
	if map_collide(player, 'right', 1) 
	or map_collide(player, 'left', 1) then
		kill_player()
	end
end

function kill_player()
	game_camera.offset += 1
	sfx(14)
	add_ghost()
	player.sprite = 48
	player.dx = 0
	player.dy = 0
	-- sfx(8)
	death_fx(player.x, player.y, 16, particles.death_fx, 4)
	-- return player to starting position
	player.x = 8 + (128 * flr(player.x/128))
	player.y = 104 + (128 * (world.current_row - 1))
	-- reset key and portal and turrets
	fountains.loc[world.current_level].active = false
	game_keys.loc[world.current_level].found = false
	bullets = {}
	turrets.anim = 0
	for turret in all(turrets.loc) do 
			turret.active = false
	end
end

function roll_cam()
	if game_camera.offset == 0 then
		camera(game_camera.cam_x, game_camera.cam_y)
	else 
		screen_shake()
	end
end

function screen_shake()
	local fade = 0.75
	local offset_x = 8-rnd(16)
	local offset_y = 8-rnd(16)

	offset_x *= game_camera.offset
	offset_y *= game_camera.offset
	
	camera(game_camera.cam_x, offset_y + game_camera.cam_y)

	game_camera.offset *= fade

	if game_camera.offset < 0.05 then
		game_camera.offset = 0
	end
end

function add_ghost()
	local x = player.x
	local y = player.y
	local coord = { x = x, y = y }
	add(ghosts, coord) -- add new ghost
	-- cleanup old ghosts
	if #ghosts > 1 then
		del(ghosts, ghosts[1]) 
	end
end
