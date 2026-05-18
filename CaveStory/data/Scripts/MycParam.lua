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
        ModCS.Rect.Put(rcNone, ModCS.Arms.GetExpX() + 48, 16, 26)
        ModCS.Rect.Put(rcNone, ModCS.Arms.GetExpX() + 48, 24, 26)
    end

    -- Draw experience and ammo
    if (ModCS.Player.shock / 2) % 2 ~= 0 then
        return
    end

    ModCS.Rect.Put(rcPer, ModCS.Arms.GetExpX() + 32, 24, 26)
    ModCS.Rect.Put(rcLv, ModCS.Arms.GetExpX(), 32, 26)
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

    ModCS.Rect.Put(rcExpBox, ModCS.Arms.GetExpX() + 24, 32, 26)

    if (lv == 2 and (exp_now == curArmsLvs[lv+1])) then
        ModCS.Rect.Put(rcExpMax, ModCS.Arms.GetExpX() + 24, 32, 26)
    else
        if (exp_next ~= 0) then
            rcExpVal.right = rcExpVal.right + ((exp_now * 40) / exp_next)
        else
            rcExpVal.right = 0
        end

        ModCS.Rect.Put(rcExpVal, ModCS.Arms.GetExpX() + 24, 32, 26)
    end

    add_flash = add_flash + 1

    if (ModCS.Player.exp_wait ~= 0 and (math.floor(add_flash / 2) % 2) ~= 0) then
        ModCS.Rect.Put(rcExpFlash, ModCS.Arms.GetExpX() + 24, 32, 26)
    end
end

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
            ModCS.Rect.Put(rcAir[1], x, y, 26)
        else
            ModCS.Rect.Put(rcAir[2], x, y, 26)
        end
    end
end

function ModCS.Player.HudArms()
    local rect = ModCS.Rect.Create(0, 0, 0, 16)

    local arms_num = 0
    while (ModCS.Arms.GetByInvPos(arms_num + 1).id ~= 0) do
        arms_num = arms_num + 1
    end

    if (arms_num == 0) then
        return
    end

    local selected = ModCS.Arms.GetCurrentInvPos() - 1

    for a = 0, arms_num - 1 do
        -- Get X position to draw at
        local x = ((a - selected) * 16) + ModCS.Arms.GetExpX()

        if (x < 8) then
            x = x + 48 + (arms_num * 16)
        elseif (x >= 24) then
            x = x + 48
        end

        if (x >= 72 + ((arms_num - 1) * 16)) then
            x = x - 48 - (arms_num * 16)
        end

        if (x < 72 and x >= 24) then
            x = x - 48
        end

        local arm = ModCS.Arms.GetByInvPos(a + 1)
        local code = arm.id

        -- Draw icon
        rect.left = code * 16
        rect.right = rect.left + 16

        ModCS.Rect.Put(rect, x, 16, 12)
    end
end