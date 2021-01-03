pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
--strayhorn
--by Mike Hansen

x=64
y=64

function _update()
 if (btn(0)) then x-=1 end
 if (btn(1)) then x+=1 end
 if (btn(2)) then y-=1 end
 if (btn(3)) then y+=1 end
end

function _draw()
 rectfill(0,0,127,127,5)
 circfill(x,y,7,14)
end
-->8
--fountains
fountains = {
    anim = 0,
    sp1 = 25,
    sp2 = 26,
    loc = {
        {
            level = 1,
            x = 96,
            y = 104,
            active = true
        },
        {
            level = 2,
            x = 80,
            y = 48,
            active = false
        },
        {
            level = 3,
            x = 16,
            y = 24,
            active = false
        },
        {
            level = 4,
            x = 64,
            y = 80,
            active = false
        },
        {
            level = 5,
            x = 64,
            y = 112,
            active = false
        },
        {
            level = 6,
            x = 88,
            y = 112,
            active = false
        }
    }
}
-->8
--game_keys
game_keys = {
    sp = 21,
    loc = {
        {
            level = 1,
            x = 0,
            y = 0,
            found = true
        },
        {
            level = 2,
            x = 96,
            y = 80,
            found = false
        },
        {
            level = 3,
            x = 96,
            y = 80,
            found = false
        },
        {
            level = 4,
            x = 120,
            y = 56,
            found = false
        },
        {
            level = 5,
            x = 88,
            y = 32,
            found = false
        },
        {
            level = 6,
            x = 40,
            y = 32,
            found = false
        }
    },
    anim = 0
}
-->8
--player
player = {
    x = 10 + (128 * 5),
    y = 90,
    sprite = 64,
    size = 1,
    width = 8,
    height = 8,
    flipped = false,
    dx = 0,
    dy = 0,
    mdx = 2,
    mdy = 5.25,
    acc = 0.5,
    accy = 3.5,
    anim = 0,
    running = false,
    jumping = false,
    falling = false,
    landed = false
}

