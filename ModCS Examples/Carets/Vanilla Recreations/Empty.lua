-- 'Empty!'
ModCS.Caret.Act[16] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(104, 96, 144, 104),
        ModCS.Rect.Create(104, 104, 144, 112),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait < 10) then
        crt.y = crt.y - 2
    end

    if (crt.ani_wait == 40) then
        crt.cond = 0
    end

    crt:SetRect(rcLeft[(math.floor(crt.ani_wait / 2) % 2)+1])
end
