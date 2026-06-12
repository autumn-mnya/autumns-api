-- Tiny version of the projectile dissipation effect
ModCS.Caret.Act[15] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(0, 72, 8, 80),
        ModCS.Rect.Create(8, 72, 16, 80),
        ModCS.Rect.Create(16, 72, 24, 80),
        ModCS.Rect.Create(24, 72, 32, 80),
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

    crt:SetRect(rcLeft[crt.ani_no+1])
end
