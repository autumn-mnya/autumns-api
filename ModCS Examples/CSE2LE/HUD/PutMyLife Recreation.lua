-- Drop this into your main.lua or a "required" file, and it should just work. The original vanilla code will not run and instead the Lua version will.

function ModCS.Player.HudLife()
    local rcCase = ModCS.Rect.Create(0, 40, 232, 48)
    local rcLife = ModCS.Rect.Create(0, 24, 232, 32)
    local rcBr = ModCS.Rect.Create(0, 32, 232, 40)

    if (ModCS.Player.shock / 2) % 2 ~= 0 then
        return
    end

    if (ModCS.Player.lifeBr < ModCS.Player.life) then
        ModCS.Player.lifeBr = ModCS.Player.life
    end

    if (ModCS.Player.lifeBr > ModCS.Player.life) then
        ModCS.Player.lifeBr_count = ModCS.Player.lifeBr_count + 1
        if (ModCS.Player.lifeBr_count > 15) then -- This for some reason has to be Half the amount the vanilla game uses to be the correct speed?
            ModCS.Player.lifeBr = ModCS.Player.lifeBr - 1
        end
    else
        ModCS.Player.lifeBr_count = 0
    end

    -- Draw bar
    rcCase.right = 64
    rcLife.right = ((ModCS.Player.life * 40) / ModCS.Player.max_life) - 1
    rcBr.right = ((ModCS.Player.lifeBr * 40) / ModCS.Player.max_life) - 1

    ModCS.Rect.Put(rcCase, 16, 40, 26)
    ModCS.Rect.Put(rcBr, 40, 40, 26)
    ModCS.Rect.Put(rcLife, 40, 40, 26)
    ModCS.PutNumber(ModCS.Player.lifeBr, 8, 40)
end
