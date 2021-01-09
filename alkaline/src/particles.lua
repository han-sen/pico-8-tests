-- PARTICLE SYSTEM

particles = { -- color tables
    death_fx = {8,2,5}, 
    dust_fx = {6,5},
    wind_fx = {6,5},
    bubble_fx = {12,1},
    fire_fx = {8,2,0},
    fire_fx_xl = {8,8,2}
}

function add_fx(x,y,die,dx,dy,grav,grow,shrink,r,c_t)
    local fx = {
        x = x,
        y = y,
        t = 0,
        die = die,
        dx = dx,
        dy = dy,
        grav = grav,
        grow = grow,
        shrink = shrink,
        r = r,
        c = 0,
        c_t = c_t -- color table
    }
    add(effects,fx)
end

function update_fx()
    for fx in all(effects) do
        -- set particle lifetime
        fx.t += 1
		if fx.t > fx.die then 
			del(effects,fx) 
		end
        -- move through color array based on lifetime
        if fx.t / fx.die < 1 / #fx.c_t then
            fx.c = fx.c_t[1]
        elseif fx.t / fx.die < 2 / #fx.c_t then
            fx.c = fx.c_t[2]
        elseif fx.t / fx.die < 3 / #fx.c_t then
            fx.c = fx.c_t[3]
        else
            fx.c = fx.c_t[4]
        end
        -- apply physics
        if fx.grav then fx.dy += .5 end
        if fx.grow then fx.r += .1 end
        if fx.shrink then fx.r -= .1 end
        -- update 
        fx.x += fx.dx
        fx.y += fx.dy
    end
end

function draw_fx()
	for fx in all(effects) do
        --draw pixel for size 1, draw circle for larger
        if fx.r <= 1 then
            pset(fx.x,fx.y,fx.c)
        else
            circfill(fx.x,fx.y,fx.r,fx.c)
        end
    end
end

-- player death effect
function death_fx(x,y,w,c_t,num)
    for i=0, num do
        --settings
        add_fx(
            x+rnd(w)-w/2,  -- x
            y+rnd(w)-w/2,  -- y
            30+rnd(10),-- die
            0,         -- dx
            -.5,       -- dy
            false,     -- gravity
            false,     -- grow
            true,      -- shrink
            3,         -- radius
            c_t    -- color_table
        )
    end
end

-- fountain activation
function water_fx(x,y,w,c_t,num)
    for i=0, num do
        --settings
        add_fx(
            x+rnd(w)-w/2,  -- x
            y+rnd(w)-w/2,  -- y
            20+rnd(10),-- die
            -0.25 + rnd(1)/2,         -- dx
            0.125,       -- dy
            false,     -- gravity
            true,     -- grow
            false,      -- shrink
            1,         -- radius
            c_t    -- color_table
        )
    end
end

-- kick dust fx
function dust_fx(x,y,w,c_t, num)
	for i=0, num do
        --settings
        add_fx(
            x+rnd(w)-w/2,  -- x
            y+rnd(w)-w/2,  -- y
            6+rnd(10),-- die
            -0.25,         -- dx
            -0.25,       -- dy
            false,     -- gravity
            false,     -- grow
            true,      -- shrink
            1,         -- radius
            c_t    -- color_table
        )
    end
end

function wind_fx(x,y,w,c_t, num)
	for i=0, num do
        add_fx(
            x+rnd(w)-w/2,
            y+rnd(w)-w/2,
            8+rnd(10),
            -0.25 + rnd(0.5),        
            -0.5,       
            false,    
            false,     
            true,      
            2,         
            c_t  
        )
    end
end

function bubble_fx(x,y,w,c_t,num)
	for i=0, num do
        add_fx(
            x+rnd(w)-w/2,
            y+rnd(2),
            40+rnd(10),
            -0.125 + (rnd(1)/4),        
            -0.25,       
            false,    
            false,     
            true,      
            flr(rnd(3)),         
            c_t  
        )
    end
end

function fire_fx(x,y,w,c_t,num)
	for i=0, num do
        add_fx(
            x+rnd(w)-w/2,
            y+rnd(2),
            40+rnd(10),
            -0.125 + (rnd(1)/4),        
            -0.5,       
            false,    
            true,     
            false,      
            flr(rnd(3)),         
            c_t  
        )
    end
end