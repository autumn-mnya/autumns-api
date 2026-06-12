-- Exhaust (used by the Booster and hoverbike)
ModCS.Caret.Act[7] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(56, 0, 64, 8),
        ModCS.Rect.Create(64, 0, 72, 8),
        ModCS.Rect.Create(72, 0, 80, 8),
        ModCS.Rect.Create(80, 0, 88, 8),
        ModCS.Rect.Create(88, 0, 96, 8),
        ModCS.Rect.Create(96, 0, 104, 8),
        ModCS.Rect.Create(104, 0, 112, 8),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 1) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 6) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rcLeft[crt.ani_no+1])

    if (crt.direct == 0) then
        crt.x = crt.x - 2
    elseif (crt.direct == 1) then
        crt.y = crt.y - 2
    elseif (crt.direct == 2) then
        crt.x = crt.x + 2
    elseif (crt.direct == 3) then
        crt.y = crt.y + 2
    end
end
