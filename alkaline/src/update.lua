-- UPDATE FUNCTIONS

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

function player_update()
	player.dy += world.gravity
	player.dx *= world.friction
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
		player.landed = false
		player.dy -= player.accy
		sfx(12)
		dust_fx(player.x, player.y + player.height, 4, particles.dust_fx, 4)
	end
	if btnp(5) then -- reset
		run()
		state = 'menu'
		player.x = 8
		player.y = 104
    end
	if not btn(0) and not btn(1) and not btnp(2) then
		player.running = false
	end
	-- check for collisions
	-- y axis
	if map_collide(player, "down", 0) then 
		player.landed = true
	end
	-- check for boost tiles
	if map_collide(player, 'down', 4) then
		player.dy = -player.mdy
		dust_fx(player.x, player.y + player.height, 4, particles.dust_fx, 4)
		sfx(17)
	end
	if player.dy > 0 then -- falling
		player.falling = true
		player.landed = false
		player.jumping = false
		if map_collide(player, "down", 0) then 
			player.landed = true
			player.falling = false
			player.dy = 0
			player.y -= ((player.y + player.height + 1) % 8) - 1-- fallback to prevent getting stuck
		end
	elseif player.dy < 0 then -- jumping
		player.jumping = true
		player.landed = false
		if map_collide(player, "up", 0) then
			player.dy = 0
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
	-- -- velocity cap check to add a ceiling to boosts
	if player.dy > player.mdy then
		player.dy = player.mdy
	elseif player.dy < -player.mdy then
		player.dy = -player.mdy
	elseif player.dx > player.mdx then
		player.dx = player.mdx
	elseif player.dx < -player.mdx then
		player.dx = -player.mdx
	end
	-- update the player position
	player.x += player.dx 
	player.y += player.dy 
	-- limit player to map edges
	if player.x >= 1024 - player.width then
		player.x = 1024 - player.width - 1
	end
end

function run_turbines()
	local level = world.current_level
	if time() - turbines.anim > 0.5 then
		turbines.anim = time()
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
				local x = f_x + 4 -- emit from middle of sprite
				local y = f_y
				wind_fx(x, y, 2, particles.wind_fx, 2)
			end
		end
	end
end

function run_flames()
	local level = world.current_level
	if time() - flames.anim > 0.25 then
		flames.anim = time()
		for t in all(flames.loc) do
			if t.level == level then -- only draw turbines on current level
				local f_x, f_y
				if level == 9 then
					f_x = t.x
					f_y = t.y + 128
				elseif level == 10 then
					f_x = t.x + 128
					f_y = t.y + 128
				else
					f_x = t.x + (((level % 9) - 1) * 128)
					f_y = t.y + ((ceil(level / 9) - 1) * 128)
				end
				local p_x = f_x + 8 -- emit from middle of sprite
				local p_y = f_y + 8
				fire_fx(p_x, p_y, 8, particles.fire_fx, 4)
			end
		end
	end
end

function animate_turbines()
	if time() - turbines.sp_anim > 0.125 then
		turbines.sp_anim = time()
		turbines.sp += 1
		if turbines.sp > 99 then
			turbines.sp = 96
		end
	end	
end

function animate_fountains()
	if time() - fountains.anim > 0.9 then
		fountains.anim = time()
		for f in all(fountains.loc) do
			if f.level == world.current_level 
			and f.active then -- only draw active fountains
				local x, y
				if world.current_level == 10 then
					x = f.x + 128 + 8
					y = f.y + 128
				else
					x = f.x + (world.level_size * (f.level - 1)) + 8 -- emit from middle of sprite
					y = f.y 
				end
				bubble_fx(x, y, 8, particles.bubble_fx, 2)
			end
		end
	end	
end
