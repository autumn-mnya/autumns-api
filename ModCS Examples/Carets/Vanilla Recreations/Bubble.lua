-- Bubble
ModCS.Caret.Act[1] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(0, 64, 8, 72),
        ModCS.Rect.Create(8, 64, 16, 72),
        ModCS.Rect.Create(16, 64, 24, 72),
        ModCS.Rect.Create(24, 64, 32, 72),
    }

    local rcRight = {
        ModCS.Rect.Create(64, 24, 72, 32),
        ModCS.Rect.Create(72, 24, 80, 32),
        ModCS.Rect.Create(80, 24, 88, 32),
        ModCS.Rect.Create(88, 24, 96, 32),
    }

    if (crt.act_no == 0) then
        crt.act_no = 1
        crt.xm = ModCS.Game.Random2(-2, 2)
        crt.ym = ModCS.Game.Random2(-2, 0)
    end

    crt.ym = crt.ym + 0.125
    crt:Move()

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 5) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end
    end

    if (crt.direct == 0) then
        crt:SetRect(rcLeft[crt.ani_no+1])
    else
        crt:SetRect(rcRight[crt.ani_no+1])
    end
end
