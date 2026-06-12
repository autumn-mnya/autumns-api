-- Snake after-image? This doesn't seem to be used.
ModCS.Caret.Act[4] = function(crt)
    local rect = {
        -- Left
        ModCS.Rect.Create(64, 32, 80, 48),
        ModCS.Rect.Create(80, 32, 96, 48),
        ModCS.Rect.Create(96, 32, 112, 48),
        -- Up
        ModCS.Rect.Create(64, 48, 80, 64),
        ModCS.Rect.Create(80, 48, 96, 64),
        ModCS.Rect.Create(96, 48, 112, 64),
        -- Right
        ModCS.Rect.Create(64, 64, 80, 80),
        ModCS.Rect.Create(80, 64, 96, 80),
        ModCS.Rect.Create(96, 64, 112, 80),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 1) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 2) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rect[((crt.direct * 3) + crt.ani_no)+1])
end

-- There is no ModCS.Caret.Act[6], however, in the original games function table, Snake after-image appears there.
ModCS.Caret.Act[6] = ModCS.Caret.Act[4]
