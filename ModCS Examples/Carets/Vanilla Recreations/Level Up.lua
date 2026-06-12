-- 'Level Up!'
ModCS.Caret.Act[10] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 56, 16),
        ModCS.Rect.Create(0, 16, 56, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 96, 56, 112),
        ModCS.Rect.Create(0, 112, 56, 128),
    }

    crt.ani_wait = crt.ani_wait + 1

    if (crt.direct == 0) then
        if (crt.ani_wait < 20) then
            crt.y = crt.y - 2
        end

        if (crt.ani_wait == 80) then
            crt.cond = 0
        end
    else
        if (crt.ani_wait < 20) then
            crt.y = crt.y - 1
        end

        if (crt.ani_wait == 80) then
            crt.cond = 0
        end
    end

    if (crt.direct == 0) then
        crt:SetRect(rcLeft[(math.floor(crt.ani_wait / 2) % 2)+1])
    else
        crt:SetRect(rcRight[(math.floor(crt.ani_wait / 2) % 2)+1])
    end
end
