-- Drop this into your main.lua or a "required" file, and it should just work. The original vanilla code will not run and instead the Lua version will.

function WriteMiniMapLine(line)
    local x = 0
    local a = 0

    local rcLevel = {
        ModCS.Rect.Create(240, 24, 241, 25),
        ModCS.Rect.Create(241, 24, 242, 25),
        ModCS.Rect.Create(242, 24, 243, 25),
        ModCS.Rect.Create(243, 24, 244, 25),
    }

    for x = 0, ModCS.Map.GetWidth()-1 do
        a = ModCS.Map.GetAttribute(x, line)

        -- Yes Cave Story does this
        if (a == 0) then
            ModCS.Rect.Put(rcLevel[1], x, line, 26, 9)
        elseif (a == 68  or
		         a == 1   or
		         a == 64  or
		         a == 128 or
		         a == 129 or
		         a == 130 or
		         a == 131 or
		         a == 81  or
		         a == 82  or
		         a == 85  or
		         a == 86  or
		         a == 2   or
		         a == 96  or
		         a == 113 or
		         a == 114 or
		         a == 117 or
		         a == 118 or
		         a == 160 or
		         a == 161 or
		         a == 162 or
		         a == 163) then
			ModCS.Rect.Put(rcLevel[2], x, line, 26, 9)
		elseif (a == 67  or
		         a == 99  or
		         a == 80  or
		         a == 83  or
		         a == 84  or
		         a == 87  or
		         a == 96  or	-- This is already listed above, so this part of the expression is always false
		         a == 112 or
		         a == 115 or
		         a == 116 or
		         a == 119) then
			ModCS.Rect.Put(rcLevel[3], x, line, 26, 9)
		else
			ModCS.Rect.Put(rcLevel[4], x, line, 26, 9)
        end
    end
end

function ModCS.MiniMap.Act()
    local black_color = ModCS.Color.Create(0, 0, 0)
    local f = 0
    local line = 0

    local rcView = ModCS.Rect.Create(0, 0, 0, 0)
    local rcMiniMap = ModCS.Rect.Create(0, 0, 0, 0)

    local my_x = 0
    local my_y = 0
    local my_wait = 0
    local my_rect = ModCS.Rect.Create(0, 57, 1, 58)

    my_x = (ModCS.Player.x + 8) / 16
    my_y = (ModCS.Player.y + 8) / 16

    -- Map open animation
    for f = 0, 8 do
        ModCS.Key.GetTrg()

        if (ModCS.Key.Pause()) then
            local result = ModCS.CallEscape()

            if (result == 0) then
                return 0
            elseif (result == 2) then
                return 2
            end
        end

        ModCS.Rect.Put(ModCS.GetGameRect(), 0, 0, 10, true)

        rcView.left = (ModCS.GetWindowWidth() / 2) - (((ModCS.Map.GetWidth() * f) / 8) / 2)
        rcView.right = (ModCS.GetWindowWidth() / 2) + (((ModCS.Map.GetWidth() * f) / 8) / 2)
        rcView.top = (ModCS.GetWindowHeight() / 2) - (((ModCS.Map.GetHeight() * f) / 8) / 2)
        rcView.bottom = (ModCS.GetWindowHeight() / 2) + (((ModCS.Map.GetHeight() * f) / 8) / 2)

        ModCS.Map.PutName(true)
        ModCS.Color.Box(black_color, rcView)

        ModCS.PutFPS()
        if not (ModCS.SystemTask()) then
            return 0
        end
    end

    rcMiniMap.left = 0
    rcMiniMap.right = ModCS.Map.GetWidth()
    rcMiniMap.top = 0
    rcMiniMap.bottom = ModCS.Map.GetHeight()

    rcView.left = rcView.left - 1
    rcView.right = rcView.left + ModCS.Map.GetWidth() + 2
    rcView.top = rcView.top - 1
    rcView.bottom = rcView.top + ModCS.Map.GetHeight() + 2
    ModCS.Color.Box(black_color, rcMiniMap, 9)

    line = 0
    my_wait = 0

    -- Draw map tiles
    while true do
        ModCS.Key.GetTrg()

        if (ModCS.Key.Ok() or ModCS.Key.Cancel()) then
            break
        end

        if (ModCS.Key.Pause()) then
            local result = ModCS.CallEscape()

            if (result == 0) then
                return 0
            elseif (result == 2) then
                return 2
            end
        end

        ModCS.Rect.Put(ModCS.GetGameRect(), 0, 0, 10, true)
        ModCS.Color.Box(black_color, rcView)

        if (line < ModCS.Map.GetHeight()) then
            WriteMiniMapLine(line)
            line = line + 1
        end
        -- I guess Pixel duplicated this block of code because he
        -- wanted the minimap to draw faster?
        if (line < ModCS.Map.GetHeight()) then
            WriteMiniMapLine(line)
            line = line + 1
        end

        ModCS.Rect.Put(rcMiniMap, rcView.left + 1, rcView.top + 1, 9)

        ModCS.Map.PutName(true)

        my_wait = my_wait + 1
        if (math.floor(my_wait / 8) % 2) ~= 0 then
            ModCS.Rect.Put(my_rect, my_x + rcView.left + 1, my_y + rcView.top + 1, 26)
        end

        ModCS.PutFPS()

        if not (ModCS.SystemTask()) then
            return 0
        end
    end

    -- Closing map
    for f = 8, -1, -1 do
        ModCS.Key.GetTrg()

        if (ModCS.Key.Pause()) then
            local result = ModCS.CallEscape()

            if (result == 0) then
                return 0
            elseif (result == 2) then
                return 2
            end
        end

        ModCS.Rect.Put(ModCS.GetGameRect(), 0, 0, 10, true)

        rcView.left = (ModCS.GetWindowWidth() / 2) - (((ModCS.Map.GetWidth() * f) / 8) / 2)
        rcView.right = (ModCS.GetWindowWidth() / 2) + (((ModCS.Map.GetHeight() * f) / 8) / 2)
        rcView.top = (ModCS.GetWindowHeight() / 2) - (((ModCS.Map.GetHeight() * f) / 8) / 2)
        rcView.bottom = (ModCS.GetWindowHeight() / 2) + (((ModCS.Map.GetHeight() * f) / 8) / 2)

        ModCS.Map.PutName(true)
        ModCS.Color.Box(black_color, rcView)

        ModCS.PutFPS()
        if not (ModCS.SystemTask()) then
            return 0
        end
    end

    return 1
end
