
function add_bullet(player, shooter, bullet_speed)
	angle = atan2(player.x - shooter.x, player.y - shooter.y)
	b_vx = cos(angle) * bullet_speed
	b_vy = sin(angle) * bullet_speed
	local bullet = {
		x = shooter.x,
		y = shooter.y,
		dx = b_vx,
		dy = b_vy,
		level = world.current_level
	}
	add(bullets, bullet)
end

function update_bullets()
	for b in all(bullets) do
		dust_fx(b.x, b.y, 1, particles.fire_fx, 1) 
		b.x += b.dx 
		b.y += b.dy
		if bullet_collide(player, b) then
			kill_player()
		end
		if fget(mget((b.x + 1) / 8, (b.y + 1) / 8), 5) then -- if bullet hits blocker cube
			del(bullets, b)
			death_fx(b.x, b.y, 3, particles.death_fx, 3)
		end
		if b.level != world.current_level then
			del(bullets, b)
		end
	end
end

function draw_bullets()
	for b in all(bullets) do 
		rectfill(b.x, b.y, b.x + 1, b.y + 1, 14)
		-- circfill(b.x, b.y, 1, 14)
	end
end

function draw_turrets()
	local level = world.current_level
	for turret in all(turrets.loc) do 
		if turret.active then 
			turrets.sp = 7
		else
			turrets.sp = 5
		end
		local t_x, t_y
		if level >= 9 then
			t_x = turret.x + (( level % 9) * 128)
			t_y = turret.y + 128
		else
			t_x = turret.x + (((level % 9) - 1) * 128)
			t_y = turret.y + ((ceil(level / 9) - 1) * 128)
		end
		if turret.level == level then
			spr(turrets.sp, t_x, t_y, 1, 1, false)
		end
	end
	if time() - turrets.anim > 2.25 then 
		turrets.anim = time() 
		for turret in all(turrets.loc) do 
			if turret.level == level and turret.active then
				local f_x, f_y
				if level >= 9 then
					f_x = turret.x + (( level % 9) * 128)
					f_y = turret.y + 128
				else
					f_x = turret.x + (((level % 9) - 1) * 128)
					f_y = turret.y + ((ceil(level / 9) - 1) * 128)
				end
				local coord = {
					x = f_x + 4,
					y = f_y + 4 -- center the bullet 
				}
				add_bullet(player, coord, 3)
				sfx(15)
			end
		end
	end
end