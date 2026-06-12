-- Missile Launcher explosion flash
ModCS.Caret.Act[12] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(112, 0, 144, 32),
        ModCS.Rect.Create(144, 0, 176, 32),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 2) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 1) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rcLeft[crt.ani_no+1])
end
