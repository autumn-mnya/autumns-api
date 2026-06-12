-- Drowned Quote
ModCS.Caret.Act[8] = function(crt)
    local rcLeft = ModCS.Rect.Create(16, 80, 32, 96)
    local rcRight = ModCS.Rect.Create(32, 80, 48, 96)

    if (crt.direct == 0) then
        crt:SetRect(rcLeft)
    else
        crt:SetRect(rcRight)
    end
end
