
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
		dust_fx(b.x, b.y, 2, particles.fire_fx, 1) 
		b.x += b.dx 
		b.y += b.dy
		if bullet_collide(player, b) then
			kill_player()
		end
		if b.y < game_camera.cam_y 
		or b.y > game_camera.cam_y + (world.level_size * world.current_row) then
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
		if turret.level == level then
			spr(turrets.sp, turret.x + ((level -1) * world.level_size), turret.y, 1, 1, false)
		end
	end
	if time() - turrets.anim > 1.5 then 
		turrets.anim = time() 
		for turret in all(turrets.loc) do 
			if turret.level == level and turret.active then
				local t_x = turret.x + ((level - 1) * world.level_size)
				local coord = {
					x = t_x + 4,
					y = turret.y + 4 -- center the bullet 
				}
				add_bullet(player, coord, 3)
				sfx(15)
			end
		end
	end
end