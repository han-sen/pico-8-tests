pico-8 cartridge // http://www.pico-8.com
version 29
__lua__

-- paddle 
local padx = 52 
local pady = 122 
local padw = 24 
local padh = 4

-- ball 
local ballx = 64 
local bally = 64 
local ballsize = 3 
local ballxdir = 5 
local ballydir = -3

function movepaddle() if btn (0) then
    padx-=3
    elseif btn(1) then
        padx+=3 
    end
end
    
function _update() 
    movepaddle()
    bounceball()
    moveball()
end

function _draw()
    rectfill(0,0, 128,128, 3) -- clear the screen
    -- draw the paddle
    rectfill(padx,pady, padx+padw,pady+padh, 15) 
    -- draw the ball
    spr(1, ballx,bally)   
end

function moveball() 
    ballx += ballxdir 
    bally += ballydir
end

function bounceball() -- left
    if ballx < ballsize then 
        ballxdir = -ballxdir
        sfx(0) 
    end
    -- right
    if ballx > 128-ballsize then 
        ballxdir = -ballxdir
        sfx(0) 
    end
    -- top
    if bally < ballsize then
         ballydir = -ballydir
        sfx(0) 
    end
    -- hit paddle
    if ballx>=padx and ballx<=padx+padw and bally>pady then
        sfx(0)
        ballydir = -ballydir 
    end
    -- hit bottom
    if bally>128 then
        sfx(3)
        bally=24 
    end
end
__gfx__
00000000007776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000776776760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000776776760000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007776000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000