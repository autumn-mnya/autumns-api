-- Drop this into your main.lua or a "required" file, and it should just work. The original vanilla code will not run and instead the Lua version will.

function ModCS.Game.Pause()
    local rc = ModCS.Rect.Create(0, 128, 208, 144)
    local rcView = ModCS.Rect.Create(0, 0, ModCS.GetWindowWidth(), ModCS.GetWindowHeight())
    local backColor = ModCS.Color.Create(0, 0, 0)

    while true do
        -- Get pressed keys
        ModCS.Key.GetTrg()

        if (ModCS.Key.Pause()) then
            ModCS.Key.ClearKeyTrg()
            return 0
        end

        if (ModCS.Key.F1()) then
            ModCS.Key.ClearKeyTrg()
            return 1
        end

        if (ModCS.Key.F2()) then
            ModCS.Key.ClearKeyTrg()
            return 2
        end

        -- Draw screen
        ModCS.Color.Box(backColor, rcView)
        ModCS.Rect.Put(rc, ModCS.PixelToScreenCoord((ModCS.GetWindowWidth() / 2) - 104), ModCS.PixelToScreenCoord((ModCS.GetWindowHeight() / 2) - 8), 26)
        ModCS.PutFPS()

        if not (ModCS.SystemTask()) then
            -- Quit if the window is closed
            ModCS.Key.ClearKeyTrg()
            return 0
        end
    end

    return 0
end
