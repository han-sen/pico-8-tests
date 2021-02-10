-- Collision functions

function bullet_collide(player, b) -- player, bullet
    if
        (b.x > player.x and b.x < player.x + player.width and b.y > player.y and b.y < player.y + player.height) or
            (b.x + 1 > player.x and b.x + 1 < player.x + player.width and b.y + 1 > player.y and
                b.y + 1 < player.y + player.height)
     then
        turrets.anim = 0
        return true
    end
end

function map_collide(obj, dir, flag)
    local x1, x2, y1, y2 = 0
    -- append invisible rectangle to character, position based on current direction
    -- this simulates checking the 'next frame' of players movement
    if dir == "left" then
        x1 = obj.x - 1
        y1 = obj.y
        x2 = obj.x
        y2 = obj.y + obj.height - 1
    elseif dir == "right" then
        x1 = obj.x + obj.width
        y1 = obj.y
        x2 = obj.x + obj.width + 1
        y2 = obj.y + obj.height - 1
    elseif dir == "up" then
        x1 = obj.x + obj.width - 1
        y1 = obj.y - 1
        x2 = obj.x + obj.width - 1
        y2 = obj.y
    elseif dir == "down" then
        x1 = obj.x + 1
        y1 = obj.y + obj.height
        x2 = obj.x + obj.width - 1
        y2 = obj.y + obj.height + 1
    end
    -- convert pixel size to tile size
    -- check each corner of rect for collision with flagged tiles
    if
        fget(mget(x1 / 8, y1 / 8), flag) or fget(mget(x1 / 8, y2 / 8), flag) or fget(mget(x2 / 8, y1 / 8), flag) or
            fget(mget(x2 / 8, y2 / 8), flag)
     then
        return true
    else
        return false
    end
end
