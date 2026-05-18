-- Drop this into your main.lua or a "required" file, and it should just work. The original vanilla code will not run and instead the Lua version will.

function ModCS.Player.HudAir()
    local x = (ModCS.GetWindowWidth() / 2) - 40
    local y = (ModCS.GetWindowHeight() / 2) - 16

    local rcAir = {
        ModCS.Rect.Create(112, 72, 144, 80),
        ModCS.Rect.Create(112, 80, 144, 88),
    }

    -- Don't display when air tank equipped
    if (ModCS.Player.HasEquipped(0x10)) then
        return
    end

    if (ModCS.Player.air_get ~= 0) then
        -- Draw how much air is left
        if (ModCS.Player.air_get % 6 < 4) then
            ModCS.PutNumber(ModCS.Player.air, x + 32, y)
        end

        -- Draw "AIR" text
        if (ModCS.Player.air_real % 30 > 10) then
            ModCS.Rect.Put(rcAir[1], ModCS.PixelToScreenCoord(x), ModCS.PixelToScreenCoord(y), 26)
        else
            ModCS.Rect.Put(rcAir[2], ModCS.PixelToScreenCoord(x), ModCS.PixelToScreenCoord(y), 26)
        end
    end
end
