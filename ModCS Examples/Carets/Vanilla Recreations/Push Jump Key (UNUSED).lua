-- 'PUSH JUMP KEY' (unused)
ModCS.Caret.Act[17] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(0, 144, 144, 152),
        ModCS.Rect.Create(0, 0, 0, 0)
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait >= 40) then
        crt.ani_wait = 0
    end

    if (crt.ani_wait < 30) then
        crt:SetRect(rcLeft[1])
    else
        crt:SetRect(rcLeft[2])
    end
end
