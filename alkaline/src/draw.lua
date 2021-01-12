-- DRAW FUNCTIONS
 
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
	if game_keys.loc[level] then
		if not game_keys.loc[level].found then
			
			local g_x = game_keys.loc[level].x + (((level % 9) - 1) * 128)
			local g_y = game_keys.loc[level].y + ((ceil(level / 9) - 1) * 128)
			spr(game_keys.sp, g_x, g_y, 1, 1, false)
		end
	end
end

function draw_fountains()
	local level = world.current_level
	if fountains.loc[level] then
		if fountains.loc[level].active then
			local g_x = fountains.loc[level].x + (((level % 9) - 1) * 128)
			local g_y = fountains.loc[level].y + ((ceil(level / 9) - 1) * 128)
			spr(fountains.sp1, g_x, g_y, 1, 1, false)
			spr(fountains.sp2, g_x + 8, g_y, 1, 1, false)
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
			spr(turbines.sp, t.x + (((level % 9) - 1) * 128), t.y + ((ceil(level / 9) - 1) * 128), 1, 1, false)
		end
	end
end
