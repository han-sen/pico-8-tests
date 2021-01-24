function update_menu()
    if btnp(5) then
        -- music(3)
        state = "playing"
    end
end

function draw_menu()
    cls()
    rectfill(0, 0, 128, 128, 1) -- bg color
    rectfill(0, 60, 128, 80, 0) -- text bar
    print("press x to start / restart", 12, 68, 7)
end
