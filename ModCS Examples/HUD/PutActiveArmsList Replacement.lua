function ModCS.Player.HudArms()
    local rect = ModCS.Rect.Create(0, 0, 0, 16)

    local arms_num = 0
    while (ModCS.Arms.GetByInvPos(arms_num + 1).id ~= 0) do
        arms_num = arms_num + 1
    end

    if (arms_num == 0) then
        return
    end

    local selected = ModCS.Arms.GetCurrentInvPos() - 1

    for a = 0, arms_num - 1 do
        -- Get X position to draw at
        local x = ((a - selected) * 16) + ModCS.Arms.GetExpX()

        if (x < 8) then
            x = x + 48 + (arms_num * 16)
        elseif (x >= 24) then
            x = x + 48
        end

        if (x >= 72 + ((arms_num - 1) * 16)) then
            x = x - 48 - (arms_num * 16)
        end

        if (x < 72 and x >= 24) then
            x = x - 48
        end

        local arm = ModCS.Arms.GetByInvPos(a + 1)
        local code = arm.id

        -- Draw icon
        rect.left = code * 16
        rect.right = rect.left + 16

        ModCS.Rect.Put(rect, x, 16, 12)
    end
end
