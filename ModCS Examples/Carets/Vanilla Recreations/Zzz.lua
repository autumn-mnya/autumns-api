-- 'Zzz' - snoring
ModCS.Caret.Act[5] = function(crt)
    local rect = {
        ModCS.Rect.Create(32, 64, 40, 72),
        ModCS.Rect.Create(32, 72, 40, 80),
        ModCS.Rect.Create(40, 64, 48, 72),
        ModCS.Rect.Create(40, 72, 48, 80),
        ModCS.Rect.Create(40, 64, 48, 72),
        ModCS.Rect.Create(40, 72, 48, 80),
        ModCS.Rect.Create(40, 64, 48, 72),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 4) then
        crt.ani_wait = 0
        crt.ani_no = crt.ani_no + 1
    end

    if (crt.ani_no > 6) then
        crt.cond = 0
        return
    end

    crt.x = crt.x + 0.25
    crt.y = crt.y + 0.25

    crt:SetRect(rect[crt.ani_no+1])
end
