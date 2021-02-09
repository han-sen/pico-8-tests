function update_menu()
    if btnp(5) then
        -- music(3)
        state = "playing"
    end
    fire_fx(64, 112, 8, {8, 2, 1}, 2)
    update_fx()
end

function draw_menu()
    cls()
    map(112, 16)
    draw_fx()
    -- rect(0, 0, 127, 127, 1) -- bg color
    -- rectfill(0, 60, 127, 80, 1) -- text bar
    print("press x to start / restart", 12, 84, 7)
end
