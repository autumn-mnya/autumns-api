-- Shoot
ModCS.Caret.Act[3] = function(crt)
    local rect = {
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
        ModCS.Rect.Create(32, 48, 48, 64),
        ModCS.Rect.Create(48, 48, 64, 64),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 2) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rect[crt.ani_no+1])
end
