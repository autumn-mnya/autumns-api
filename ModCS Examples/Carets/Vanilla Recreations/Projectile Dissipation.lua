-- Projectile dissipation
ModCS.Caret.Act[2] = function(crt)
    local rect_left = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
        ModCS.Rect.Create(32, 32, 48, 48),
        ModCS.Rect.Create(48, 32, 64, 48),
    }

    local rect_right = {
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(192, 0, 208, 16),
        ModCS.Rect.Create(208, 0, 224, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
    }

    local rect_up = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(32, 32, 48, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
    }

    if (crt.direct == 0) then -- left
        crt.ym = crt.ym - 0.03125
        crt:Move()

        crt.ani_wait = crt.ani_wait + 1
        if (crt.ani_wait > 5) then
            crt.ani_wait = 0
            crt.ani_no = crt.ani_no + 1
        end

        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end

        crt:SetRect(rect_left[crt.ani_no+1])
    elseif (crt.direct == 2) then -- right
        crt.ani_wait = crt.ani_wait + 1
        if (crt.ani_wait > 2) then
            crt.ani_wait = 0
            crt.ani_no = crt.ani_no + 1
        end

        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end

        crt:SetRect(rect_right[crt.ani_no+1])
    elseif (crt.direct == 1) then -- up
        crt.ani_wait = crt.ani_wait + 1
        crt:SetRect(rect_up[(math.floor(crt.ani_wait / 2) % 3)+1])

        if (crt.ani_wait > 24) then
            crt.cond = 0
        end
    end
end
