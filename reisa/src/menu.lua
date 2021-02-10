function update_menu()
    if btnp(5) then
        -- music(3)
        state = "playing"
    end
    fire_fx(64, 112, 8, {8, 2, 1}, 2)
    if time() - world.menu_anim_1 > 1.3 then
        world.menu_anim_1 = time()
        bubble_fx(32, 24, 8, particles.bubble_fx, 1)
        bubble_fx(96, 24, 8, particles.bubble_fx, 1)
    end
    if time() - world.menu_anim_2 > 2.6 then
        world.menu_anim_2 = time()
        bubble_fx(64, 24, 8, particles.bubble_fx, 1)
    end
    update_fx()
end

function draw_menu()
    cls()
    map(112, 16)
    draw_fx()
    print("press x to start / restart", 13, 85, 0)
    print("press x to start / restart", 12, 84, 7)
end
