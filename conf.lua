function love.conf(t)

    -- https://love2d.org/wiki/Config_Files

    t.window.width = 1200
    t.window.height = 900

    t.modules.joystick = false
    t.modules.physics = false

    t.console = false

    t.window.title = "Tentacle Wars - Remake"
    t.window.icon = nil 

    t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number)

    t.window.vsync = 0                  -- Vertical sync mode (number) - 0 = disables, 1 enabled
end