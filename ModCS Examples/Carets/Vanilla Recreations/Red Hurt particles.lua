-- Red hurt particles (used by bosses and invisible hidden pickups)
ModCS.Caret.Act[11] = function(crt)
    local deg = 0

    if (crt.act_no == 0) then
        crt.act_no = 1
        deg = ModCS.Game.Random(0, 0xFF)
        crt.xm = ModCS.Triangle.GetCos(deg) * 2
        crt.ym = ModCS.Triangle.GetSin(deg) * 2
    end

    crt:Move()

    local rcRight = {
        ModCS.Rect.Create(56, 8, 64, 16),
        ModCS.Rect.Create(64, 8, 72, 16),
        ModCS.Rect.Create(72, 8, 80, 16),
        ModCS.Rect.Create(80, 8, 88, 16),
        ModCS.Rect.Create(88, 8, 96, 16),
        ModCS.Rect.Create(96, 8, 104, 16),
        ModCS.Rect.Create(104, 8, 112, 16),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 2) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 6) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rcRight[crt.ani_no+1])
end
