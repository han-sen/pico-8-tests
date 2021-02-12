-- DRAW FUNCTIONS

function draw_text()
	if world.current_level == 1 then
		print("Jump in the fountain", game_camera.cam_x + 23, game_camera.cam_y + 2, 0)
		print("Jump in the fountain", game_camera.cam_x + 24, game_camera.cam_y + 3, 7)
		print("to start the trial", game_camera.cam_x + 27, game_camera.cam_y + 10, 0)
		print("to start the trial", game_camera.cam_x + 28, game_camera.cam_y + 11, 7)
	elseif world.current_level > 1 and world.current_level < 14 then 
		print("LV-"..world.current_level, game_camera.cam_x + 54, game_camera.cam_y, 7)
	elseif world.current_level == 14 then
		local minutes = flr(finish_time / 60)
		local seconds = flr(finish_time) % 60
		local f_time = minutes..":"..seconds
		print("victory", game_camera.cam_x + 50, game_camera.cam_y + 14, 12)
		print("DEATHS: "..death_count, game_camera.cam_x + 50, game_camera.cam_y + 64, 12)
		print("TIME: "..f_time, game_camera.cam_x + 50, game_camera.cam_y + 74, 12)
		print("press x to restart", game_camera.cam_x + 28, game_camera.cam_y + 96, 7)
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
	local k_x, k_y
	if level >= 9 then
		k_x = game_keys.loc[level].x + (( level % 9) * 128)
		k_y = game_keys.loc[level].y + 128
	else
		k_x = game_keys.loc[level].x + (((level % 9) - 1) * 128)
		k_y = game_keys.loc[level].y + ((ceil(level / 9) - 1) * 128)
	end
	if game_keys.loc[level] then
		if not game_keys.loc[level].found then
			spr(game_keys.sp, k_x, k_y, 1, 1, false)
		end
	end
end

function draw_fountains()
	local level = world.current_level
	local f_x, f_y
	if level >= 9 then
		f_x = fountains.loc[level].x + (( level % 9) * 128)
		f_y = fountains.loc[level].y + 128
	else
		f_x = fountains.loc[level].x + (((level % 9) - 1) * 128)
		f_y = fountains.loc[level].y + ((ceil(level / 9) - 1) * 128)
	end
	if fountains.loc[level] then
		if fountains.loc[level].active then
			spr(fountains.sp1, f_x, f_y, 1, 1, false)
			spr(fountains.sp2, f_x + 8, f_y, 1, 1, false)
		end
	end
end

function draw_player()
	spr(player.sprite,player.x,player.y, player.size, player.size, player.flipped)	
end

function draw_ghosts()
	if #ghosts > 0 then
		local ghost = ghosts[#ghosts] -- get most recent ghost
		spr(48, ghost.x, ghost.y, 1, 1, false)
	end
end

function draw_turbines() 
	local level = world.current_level
	for t in all(turbines.loc) do
		if t.level == level then -- only draw turbines on current level
			local f_x, f_y
			if level >= 9 then
				f_x = t.x + (( level % 9) * 128)
				f_y = t.y + 128
			else
				f_x = t.x + (((level % 9) - 1) * 128)
				f_y = t.y + ((ceil(level / 9) - 1) * 128)
			end
			spr(turbines.sp,f_x, f_y, 1, 1, false)
		end
	end
end
