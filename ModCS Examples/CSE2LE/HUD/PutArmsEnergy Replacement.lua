-- Drop this into your main.lua or a "required" file, and it should just work. The original vanilla code will not run and instead the Lua version will.

local add_flash = 0

function ModCS.Player.HudExp()
    local rcPer = ModCS.Rect.Create(72, 48, 80, 56)
    local rcLv = ModCS.Rect.Create(80, 80, 96, 88)
    local rcNone = ModCS.Rect.Create(80, 48, 96, 56)

    if (ModCS.Arms.GetExpX() > 16) then
        ModCS.Arms.SetExpX(ModCS.Arms.GetExpX() - 2)
    end

    if (ModCS.Arms.GetExpX() < 16) then
        ModCS.Arms.SetExpX(ModCS.Arms.GetExpX() + 2)
    end

    -- Draw max ammo
    if (ModCS.Arms.GetCurrent().max_ammo ~= 0) then
        ModCS.PutNumber(ModCS.Arms.GetCurrent().ammo, ModCS.Arms.GetExpX() + 32, 16)
        ModCS.PutNumber(ModCS.Arms.GetCurrent().max_ammo, ModCS.Arms.GetExpX() + 32, 24)
    else
        ModCS.Rect.Put(rcNone, ModCS.PixelToScreenCoord(ModCS.Arms.GetExpX() + 48), ModCS.PixelToScreenCoord(16), 26)
        ModCS.Rect.Put(rcNone, ModCS.PixelToScreenCoord(ModCS.Arms.GetExpX() + 48), ModCS.PixelToScreenCoord(24), 26)
    end

    -- Draw experience and ammo
    if (ModCS.Player.shock / 2) % 2 ~= 0 then
        return
    end

    ModCS.Rect.Put(rcPer, ModCS.PixelToScreenCoord(ModCS.Arms.GetExpX() + 32), ModCS.PixelToScreenCoord(24), 26)
    ModCS.Rect.Put(rcLv, ModCS.PixelToScreenCoord(ModCS.Arms.GetExpX()), ModCS.PixelToScreenCoord(32), 26)
    ModCS.PutNumber(ModCS.Arms.GetCurrent().level, ModCS.Arms.GetExpX() - 8, 32)

    local rcExpBox = ModCS.Rect.Create(0, 72, 40, 80)
    local rcExpVal = ModCS.Rect.Create(0, 80, 0, 88)
    local rcExpMax = ModCS.Rect.Create(40, 72, 80, 80)
    local rcExpFlash = ModCS.Rect.Create(40, 80, 80, 88)

    local lv = ModCS.Arms.GetCurrent().level - 1

    -- When the player has no weapons, the default level is 0, which becomes -1.
    -- This code isn't in the vanilla game, but its a recommended major bug fix. So might as well.
    if (lv < 0) then
        lv = 0
    end

    local arms_code = ModCS.Arms.GetCurrent().id
    local exp_now = ModCS.Arms.GetCurrent().exp
    local curArmsLvs = ModCS.Arms.GetLevels(arms_code)
    local exp_next = curArmsLvs[lv+1]

    ModCS.Rect.Put(rcExpBox, ModCS.PixelToScreenCoord(ModCS.Arms.GetExpX() + 24), ModCS.PixelToScreenCoord(32), 26)

    if (lv == 2 and (exp_now == curArmsLvs[lv+1])) then
        ModCS.Rect.Put(rcExpMax, ModCS.PixelToScreenCoord(ModCS.Arms.GetExpX() + 24), ModCS.PixelToScreenCoord(32), 26)
    else
        if (exp_next ~= 0) then
            rcExpVal.right = rcExpVal.right + ((exp_now * 40) / exp_next)
        else
            rcExpVal.right = 0
        end

        ModCS.Rect.Put(rcExpVal, ModCS.PixelToScreenCoord(ModCS.Arms.GetExpX() + 24), ModCS.PixelToScreenCoord(32), 26)
    end

    add_flash = add_flash + 1

    if (ModCS.Player.exp_wait ~= 0 and (math.floor(add_flash / 2) % 2) ~= 0) then
        ModCS.Rect.Put(rcExpFlash, ModCS.PixelToScreenCoord(ModCS.Arms.GetExpX() + 24), ModCS.PixelToScreenCoord(32), 26)
    end
end
