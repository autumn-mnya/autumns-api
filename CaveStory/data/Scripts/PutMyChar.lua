function ModCS.Player.Put()
    local viewbox = ModCS.Player.GetViewbox()

    if not ModCS.Player.CheckCond(0x80) or (ModCS.Player.CheckCond(2)) then
        return
    end

    -- Draw weapon
    local arms_offset_y = 0
    local code = ModCS.Arms.GetCurrent().id

    local left = (code % 13) * 24
    local right = left + 24
    local top = math.floor(code / 13) * 96
    local bottom = top + 16

    -- If the player is facing right
    if (ModCS.Player.direct == 2) then
        top = top + 16
        bottom = bottom + 16
    end

    -- If the player is facing up
    if (ModCS.Player.up == true) then
        arms_offset_y = -4
        top = top + 32
        bottom = bottom + 32
    elseif (ModCS.Player.down == true) then -- facing down
        arms_offset_y = 4
        top = top + 64
        bottom = bottom + 64
    end

    if (ModCS.Player.ani_no == 1 or ModCS.Player.ani_no == 3 or ModCS.Player.ani_no == 6 or ModCS.Player.ani_no == 8) then
        top = top + 1
    end

    ModCS.Player.SetArmsRect(left, top, right, bottom)

    local view_front = viewbox.front / 0x200
    local view_top   = viewbox.top   / 0x200

    -- Get the XY position to draw the players weapon at, with the players viewbox and camera position (and arms offset!)
    local armsX = (ModCS.Player.x - view_front) - ModCS.Camera.GetXPos()
    local armsY = (ModCS.Player.y - view_top) - ModCS.Camera.GetYPos() + arms_offset_y

    if (ModCS.Player.direct == 0) then
        armsX = armsX - 8
    end

    ModCS.Rect.Put(ModCS.Player.GetArmsRect(), armsX - 7, armsY - 7, 11)

    -- If I-Frames exist, occasisonally make the player blink.
    if (ModCS.Player.shock / 2) % 2 ~= 0 then
        return
    end

    -- Draw player
    local rect = ModCS.Player.GetRect()

    -- If mimiga mask is equipped, add 32px to the rects top and bottom. (Shift it down 32px)
    if (ModCS.Player.HasEquipped(64)) then
        rect.top = rect.top + 32
        rect.bottom = rect.bottom + 32
    end

    -- Get the XY positon to draw the player at, with its viewbox and camera position
    local charX = (ModCS.Player.x - view_front) - ModCS.Camera.GetXPos()
    local charY = (ModCS.Player.y - view_top) - ModCS.Camera.GetYPos()

    ModCS.Rect.Put(rect, charX - 7, charY - 7, 16)

    -- Bubble
    local rcBubble = {
        ModCS.Rect.Create(56, 96, 80, 120),
        ModCS.Rect.Create(80, 96, 104, 120)
    }

    ModCS.Player.bubble = (ModCS.Player.bubble + 1) % 4
    local frame = math.floor(ModCS.Player.bubble / 2) + 1

    -- Draw player's bubble on screen
    if (ModCS.Player.HasEquipped(0x10)) and ModCS.Player.TouchWater() then
        ModCS.Rect.Put(rcBubble[frame], ModCS.Player.x - 11 - ModCS.Camera.GetXPos(), ModCS.Player.y - 11 - ModCS.Camera.GetYPos(), 19)
    elseif (ModCS.Player.unit == 1) then
        ModCS.Rect.Put(rcBubble[frame], ModCS.Player.x - 11 - ModCS.Camera.GetXPos(), ModCS.Player.y - 11 - ModCS.Camera.GetYPos(), 19)
    end
end