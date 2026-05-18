-- Drop this into your main.lua or a "required" file, and it should just work. The original vanilla code will not run and instead the Lua version will.

function ModCS.Player.Put()
    local viewbox = ModCS.Player.GetViewbox()

    viewbox.back = viewbox.back * 512
    viewbox.front = viewbox.front * 512
    viewbox.bottom = viewbox.bottom * 512
    viewbox.top = viewbox.top * 512

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
    if (ModCS.Player.up == 1) then
        arms_offset_y = -4
        top = top + 32
        bottom = bottom + 32
    elseif (ModCS.Player.down == 1) then -- facing down
        arms_offset_y = 4
        top = top + 64
        bottom = bottom + 64
    end

    if (ModCS.Player.ani_no == 1 or ModCS.Player.ani_no == 3 or ModCS.Player.ani_no == 6 or ModCS.Player.ani_no == 8) then
        top = top + 1
    end

    ModCS.Player.SetArmsRect(left, top, right, bottom)

    if (ModCS.Player.direct == 0) then
        ModCS.Rect.Put(ModCS.Player.GetArmsRect(),
        ModCS.SubpixelToScreenCoord(ModCS.Player.x_cs - viewbox.front) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealXPos()) - ModCS.PixelToScreenCoord(8),
        ModCS.SubpixelToScreenCoord(ModCS.Player.y_cs - viewbox.top) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealYPos()) + ModCS.PixelToScreenCoord(arms_offset_y),
        11)
    else
        ModCS.Rect.Put(ModCS.Player.GetArmsRect(),
        ModCS.SubpixelToScreenCoord(ModCS.Player.x_cs - viewbox.front) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealXPos()),
        ModCS.SubpixelToScreenCoord(ModCS.Player.y_cs - viewbox.top) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealYPos()) + ModCS.PixelToScreenCoord(arms_offset_y),
        11)
    end

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

    ModCS.Rect.Put(rect,
    ModCS.SubpixelToScreenCoord(ModCS.Player.x_cs - viewbox.front) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealXPos()),
    ModCS.SubpixelToScreenCoord(ModCS.Player.y_cs - viewbox.top) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealYPos()),
    16)

    -- Bubble
    local rcBubble = {
        ModCS.Rect.Create(56, 96, 80, 120),
        ModCS.Rect.Create(80, 96, 104, 120)
    }

    ModCS.Player.bubble = (ModCS.Player.bubble + 1) % 4
    local frame = math.floor(ModCS.Player.bubble / 2) + 1

    -- Draw player's bubble on screen
    if (ModCS.Player.HasEquipped(0x10)) and ModCS.Player.TouchWater() then
        ModCS.Rect.Put(rcBubble[frame],
        ModCS.SubpixelToScreenCoord(ModCS.Player.x_cs) - ModCS.PixelToScreenCoord(12) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealXPos()),
        ModCS.SubpixelToScreenCoord(ModCS.Player.y_cs) - ModCS.PixelToScreenCoord(12) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealYPos()),
        19)
    elseif (ModCS.Player.unit == 1) then
        ModCS.Rect.Put(rcBubble[frame],
        ModCS.SubpixelToScreenCoord(ModCS.Player.x_cs) - ModCS.PixelToScreenCoord(12) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealXPos()),
        ModCS.SubpixelToScreenCoord(ModCS.Player.y_cs) - ModCS.PixelToScreenCoord(12) - ModCS.SubpixelToScreenCoord(ModCS.Camera.GetRealYPos()),
        19)
    end
end
