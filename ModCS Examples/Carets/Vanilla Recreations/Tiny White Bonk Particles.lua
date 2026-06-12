-- Particles used when Quote jumps into the ceiling, and also used by the Demon Crown and Ballo's puppy
ModCS.Caret.Act[13] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(56, 24, 64, 32),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    if (crt.act_no == 0) then
        crt.act_no = 1

        if (crt.direct == 0) then
            crt.xm = ModCS.Game.Random2(-3, 3)
            crt.ym = ModCS.Game.Random2(-1, 1)
        elseif (crt.direct == 1) then
            crt.ym = ModCS.Game.Random(-3, -1)
        end
    end

    if (crt.direct == 0) then
        crt.xm = (crt.xm * 4) / 5
        crt.ym = (crt.ym * 4) / 5
    end

    crt:Move()

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 20) then
        crt.cond = 0
    end

    crt:SetRect(rcLeft[(math.floor(crt.ani_wait / 2) % 2)+1])

    if (crt.direct == 4) then
        crt.x = crt.x - 4
    end
end
