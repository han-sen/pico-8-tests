pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
local player
local heart
local score

function _init()
	score = 0
    player = {
        x = 10,
        y = 10,
		speed = 1.5,
		width = 8,
		height = 8,
		is_collecting = false,
		draw=function(self)
			spr(1, self.x,self.y)
		end,
		update=function(self)
			if btn(1) then 
				self.x += self.speed 
			end
			if btn(0) then
				self.x -= self.speed  
			end
			if btn(3) then 
				self.y += self.speed 
			end
			if btn(2) then
				self.y -= self.speed 
			end
		end,
		check_for_collision=function(self,heart)
			local player_top = self.y 
			local player_bottom = self.y + self.height
			local player_left = self.x 
			local player_right = self.x + self.width

			local heart_top = heart.y 
			local heart_bottom = heart.y + heart.height
			local heart_left = heart.x 
			local heart_right = heart.x + heart.width
		
			return player_left < heart_left and heart_left < player_right and player_top < heart_top and heart_top < player_bottom
		end
	}
	heart = {
        x = 50,
		y = 50,
		width = 8,
		height = 8,
		is_collected=false,
		draw=function(self) 
			spr(2, self.x,self.y)
		end,
	}
end

function _update()
	player:update()
	player:check_for_collision(heart)
end

function _draw()
	cls()
	if not heart.is_collected then
		heart:draw()
	end
	player:draw()
	print(player.is_collecting,10,10, 3)
	print(player:check_for_collision(heart),20,20, 4)

end

__gfx__
00000000007aa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007aaaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007007a0a0aa90080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000aaaaaaa908e8880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000a0aaa0a90888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700aa000a990088800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000aaaaa900008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000aaa9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000012054150541505417054180501805018050180501705016050160501505013050120501205011050100501005011050110501205013050140501605018050190501b0501e0551f0551f0551f0551d055
0010000000000192501a2501c2501c2501d2501d2501d2501d2501c2501b250172500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
