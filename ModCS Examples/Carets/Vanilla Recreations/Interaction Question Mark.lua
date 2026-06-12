-- The '?' that appears when you press the down key
ModCS.Caret.Act[9] = function(crt)
    local rcLeft = ModCS.Rect.Create(0, 80, 16, 96)
    local rcRight = ModCS.Rect.Create(48, 64, 64, 80)

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait < 5) then
        crt.y = crt.y - 4
    end

    if (crt.ani_wait == 32) then
        crt.cond = 0
    end

    if (crt.direct == 0) then
        crt:SetRect(rcLeft)
    else
        crt:SetRect(rcRight)
    end
end
