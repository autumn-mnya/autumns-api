-- Drop this into your main.lua or a "required" file, and it should just work. The original vanilla code will not run and instead the Lua version will.

local gCampTitleY = 0
local gCampActive = false
local invFlash = 0

--- Update the inventory cursor
function MoveCampCursor()
    local bChange = false

    local arms_num = 0
    local item_num = 0

    while (ModCS.Arms.GetByInvPos(arms_num + 1).id ~= 0) do
        arms_num = arms_num + 1
    end

    while (ModCS.Item.GetByInvPos(item_num + 1).id ~= 0) do
        item_num = item_num + 1
    end

    if (arms_num == 0 and item_num == 0) then
        return
    end

    if not gCampActive then -- Weapons
        if (ModCS.Key.Left()) then
            ModCS.Arms.SetCurrentInvPos(ModCS.Arms.GetCurrentInvPos() - 1)
            bChange = true
        end

        if (ModCS.Key.Right()) then
            ModCS.Arms.SetCurrentInvPos(ModCS.Arms.GetCurrentInvPos() + 1)
            bChange = true
        end

        if (ModCS.Key.Up() or ModCS.Key.Down()) then
            if (item_num ~= 0) then
                gCampActive = true
            end
            bChange = true
        end

        local pos = ModCS.Arms.GetCurrentInvPos()

        if (pos < 1) then
            ModCS.Arms.SetCurrentInvPos(arms_num)
        end

        if (pos > arms_num) then
            ModCS.Arms.SetCurrentInvPos(1)
        end
    else -- Items
        local pos = ModCS.Item.GetCurrentInvPos()

        if (ModCS.Key.Left()) then
            if ((pos - 1) % 6 == 0) then
                pos = pos + 5
            else
                pos = pos - 1
            end
            ModCS.Item.SetCurrentInvPos(pos)
            bChange = true
        end

        if (ModCS.Key.Right()) then
            if (pos == item_num) then
                pos = ((pos - 1) // 6) * 6 + 1
            elseif ((pos - 1) % 6 == 5) then
                pos = pos - 5
            else
                pos = pos + 1
            end

            ModCS.Item.SetCurrentInvPos(pos)
            bChange = true
        end

        if (ModCS.Key.Up()) then
            if ((pos - 1) // 6 == 0) then
                gCampActive = false
            else
                pos = pos - 6
                ModCS.Item.SetCurrentInvPos(pos)
            end
            bChange = true
        end

        if (ModCS.Key.Down()) then
            if ((pos - 1) // 6 == (item_num - 1) // 6) then
                gCampActive = false
            else
                pos = pos + 6
                ModCS.Item.SetCurrentInvPos(pos)
            end
            bChange = true
        end

        if (pos > item_num) then
            ModCS.Item.SetCurrentInvPos(item_num)
        end

        if (gCampActive and ModCS.Key.Ok()) then
            ModCS.Tsc.Run(6000 + ModCS.Item.GetByInvPos(ModCS.Item.GetCurrentInvPos()).id)
        end
    end

    if (bChange == true) then
        if (gCampActive == false) then
            -- Switch to a weapon
            ModCS.Sound.Play(4)

            if (arms_num ~= 0) then
                ModCS.Tsc.Run(1000 + ModCS.Arms.GetByInvPos(ModCS.Arms.GetCurrentInvPos()).id)
            else
                ModCS.Tsc.Run(1000)
            end
        else
            -- Switch to an item
            ModCS.Sound.Play(1)

            if (item_num ~= 0) then
                ModCS.Tsc.Run(5000 + ModCS.Item.GetByInvPos(ModCS.Item.GetCurrentInvPos()).id)
            else
                ModCS.Tsc.Run(5000)
            end
        end
    end
end

--- Draw the inventory
function PutCampObject()
    local i = 0

    -- Rect for the current weapon
    local rcArms = ModCS.Rect.Create(0, 0, 0, 0)
    
    -- Rect for the current item
    local rcItem = ModCS.Rect.Create(0, 0, 0, 0)

    -- Probably the rect for the slash
    local rcPer = ModCS.Rect.Create(72, 48, 80, 56)

    -- Rect for when there is no ammo (double dashes)
    local rcNone = ModCS.Rect.Create(80, 48, 96, 56)

    -- Rect for the "Lv" text!
    local rcLv = ModCS.Rect.Create(80, 80, 96, 88)

    -- Final rect drawn on the screen
    local rcView = ModCS.Rect.Create(0, 0, ModCS.GetWindowWidth(), ModCS.GetWindowHeight())

    -- Cursor rect array for weapons, element [2] being for when the cursor is flashing
    local rcCur1 = {
        ModCS.Rect.Create(0, 88, 40, 128),
        ModCS.Rect.Create(40, 88, 80, 128),
    }

    -- Cursor rect array for items, element [2] being for when the cursor is flashing
    local rcCur2 = {
        ModCS.Rect.Create(80, 88, 112, 104),
        ModCS.Rect.Create(80, 104, 112, 120),
    }

    local rcTitle1 = ModCS.Rect.Create(80, 48, 144, 56)
    local rcTitle2 = ModCS.Rect.Create(80, 56, 144, 64)
    local rcBoxTop = ModCS.Rect.Create(0, 0, 244, 8)
    local rcBoxBody = ModCS.Rect.Create(0, 8, 244, 16)
    local rcBoxBottom = ModCS.Rect.Create(0, 16, 244, 24)

    -- Draw box
    local centerX = ModCS.GetWindowWidth() / 2
    local centerY = ModCS.GetWindowHeight() / 2

    ModCS.Rect.Put(rcBoxTop, centerX - 122, centerY - 112, 26)

    for i = 1, 17 do
        ModCS.Rect.Put(rcBoxBody, centerX - 122, (centerY - 120) + ((i + 1) * 8), 26)
    end

    local i = 18 -- match vanilla behavior
    ModCS.Rect.Put(rcBoxBottom, centerX - 122, (centerY - 120) + ((i + 1) * 8), 26)

    -- Move titles
    if (gCampTitleY > centerY - 104) then
        gCampTitleY = gCampTitleY - 1
    end

    -- Draw titles
    ModCS.Rect.Put(rcTitle1, centerX - 112, gCampTitleY, 26)
    ModCS.Rect.Put(rcTitle2, centerX - 112, gCampTitleY + 52, 26)

    -- Draw arms cursor
    invFlash = invFlash + 1

    local flashFrame = ((invFlash // 2) % 2) + 1

    if (gCampActive == false) then
        ModCS.Rect.Put(rcCur1[flashFrame], ((ModCS.Arms.GetCurrentInvPos() - 1) * 40) + centerX - 112, centerY - 96, 26)
    else
        ModCS.Rect.Put(rcCur1[2], ((ModCS.Arms.GetCurrentInvPos() - 1) * 40) + centerX - 112, centerY - 96, 26)
    end

    -- Draw weapons
    for i = 0, 8 do
        local weapon = ModCS.Arms.GetByInvPos(i + 1)

        if (weapon.id == 0) then
            break -- Invalid weapon
        end

        local x = (i * 40) + centerX - 112
        local y = centerY

        -- icon rect
        local id = weapon.id
        rcArms.left = (id % 16) * 16
        rcArms.right = rcArms.left + 16
        rcArms.top = (math.floor(id / 16) * 16)
        rcArms.bottom = rcArms.top + 16

        -- draw icon + UI
        ModCS.Rect.Put(rcArms, x, y - 96, 12)
        ModCS.Rect.Put(rcPer,  x, y - 64, 26)
        ModCS.Rect.Put(rcLv,   x, y - 80, 26)

        ModCS.PutNumber(weapon.level, x, y - 80)

        -- ammo
        if (weapon.max_ammo ~= 0) then
            ModCS.PutNumber(weapon.ammo,     x, y - 72)
            ModCS.PutNumber(weapon.max_ammo, x, y - 64)
        else
            ModCS.Rect.Put(rcNone, (i * 40) + (ModCS.GetWindowWidth() - 192) / 2, y - 72, 26)
            ModCS.Rect.Put(rcNone, (i * 40) + (ModCS.GetWindowWidth() - 192) / 2, y - 64, 26)
        end
    end

    -- Draw items cursor
    local itemPos = ModCS.Item.GetCurrentInvPos()

    local itemCol = (itemPos - 1) % 6
    local itemRow = math.floor((itemPos - 1) / 6)

    local itemX = (itemCol * 32) + centerX - 112
    local itemY = (itemRow * 16) + centerY - 44

    if (gCampActive == true) then
        ModCS.Rect.Put(rcCur2[flashFrame], itemX, itemY, 26)
    else
        ModCS.Rect.Put(rcCur2[2], itemX, itemY, 26)
    end

    for i = 0, 32 do
        local item = ModCS.Item.GetByInvPos(i + 1)

        if (item.id == 0) then
            break -- Invalid item
        end

        -- Get rect for the next item
        local id = item.id
        rcItem.left = (id % 8) * 32
        rcItem.right = rcItem.left + 32
        rcItem.top = (math.floor(id / 8) * 16)
        rcItem.bottom = rcItem.top + 16

        local x = ((i % 6) * 32) + centerX - 112
        local y = (math.floor(i / 6) * 16) + centerY - 44

        ModCS.Rect.Put(rcItem, x, y, 8)
    end
end

function ModCS.Item.Inventory()
    local old_script_path = ModCS.Tsc.GetPath()

    local rcView = ModCS.Rect.Create(0, 0, ModCS.GetWindowWidth(), ModCS.GetWindowHeight())

    -- Load the inventory script
    ModCS.Tsc.Load("ArmsItem.tsc")

    gCampTitleY = (ModCS.GetWindowHeight() / 2) - 96
    gCampActive = false

    local arms_num = 0
    while (ModCS.Arms.GetByInvPos(arms_num + 1).id ~= 0) do
        arms_num = arms_num + 1
    end

    if (arms_num ~= 0) then
        ModCS.Tsc.Run(1000 + ModCS.Arms.GetByInvPos(ModCS.Arms.GetCurrentInvPos()).id)
     else
        ModCS.Tsc.Run(1000)
    end

    while true do
        ModCS.Key.GetTrg()

        if (ModCS.Key.Pause()) then
            local escape = ModCS.CallEscape()

            if (escape == 0) then
                return 0
            elseif (escape == 2) then
                return 2
            end
        end

        if (ModCS.Game.CanControl()) then
            MoveCampCursor()
        end

        local tscRun = ModCS.Tsc.ActMain()

        if (tscRun == 0) then
            return 0
        elseif (tscRun == 2) then
            return 2
        end

        ModCS.Rect.Put(rcView, 0, 0, 10) -- Draw screenshot
        PutCampObject()
        ModCS.Tsc.DrawMain()
        ModCS.PutFPS()

        if (gCampActive) then
            if (ModCS.Game.CanControl() and ModCS.Key.Cancel() or ModCS.Key.Item()) then
                ModCS.Tsc.Stop()
                break
            end
        else
            if (ModCS.Key.Ok() or ModCS.Key.Cancel() or ModCS.Key.Item()) then
                ModCS.Tsc.Stop()
                break
            end
        end

        if not (ModCS.SystemTask()) then
            return 0
        end
    end

    -- Resume original script
    ModCS.Tsc.Load2(old_script_path)
    ModCS.Arms.SetExpX(32)
    return 1
end
