-- Broken (unknown and unused)
ModCS.Caret.Act[14] = function(crt)
	-- These rects are invalid.
	-- However, notably, there are 5 unused 40x40 sprites at the bottom of Caret.pbm.
	-- Perhaps those were originally at these coordinates.
    local rect = {
        ModCS.Rect.Create(0, 96, 40, 136),
        ModCS.Rect.Create(40, 96, 80, 136),
        ModCS.Rect.Create(80, 96, 120, 136),
        ModCS.Rect.Create(120, 96, 160, 136),
        ModCS.Rect.Create(160, 96, 200, 136),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 1) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 4) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rect[crt.ani_no+1])
end
