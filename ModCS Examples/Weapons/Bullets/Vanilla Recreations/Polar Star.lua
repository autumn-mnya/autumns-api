local function PolarStarBullet(bul, level)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        -- Set speed
        if (bul.direct == 0) then
            bul.xm = -8
        elseif (bul.direct == 1) then
            bul.ym = -8
        elseif (bul.direct == 2) then
            bul.xm = 8
        elseif (bul.direct == 3) then
            bul.ym = 8
        end

        -- Set hitbox
        if (level == 1) then
            if (bul.direct == 0) then
                bul.enemyhit_y = 2
            elseif (bul.direct == 1) then
                bul.enemyhit_x = 2
            elseif (bul.direct == 2) then
                bul.enemyhit_y = 2
            elseif (bul.direct == 3) then
                bul.enemyhit_x = 2
            end
        elseif (level == 2) then
            if (bul.direct == 0) then
                bul.enemyhit_y = 4
            elseif (bul.direct == 1) then
                bul.enemyhit_x = 4
            elseif (bul.direct == 2) then
                bul.enemyhit_y = 4
            elseif (bul.direct == 3) then
                bul.enemyhit_x = 4
            end
        end
    else
        bul:Move()
    end

    local rect1 = {
        ModCS.Rect.Create(128, 32, 144, 48),
        ModCS.Rect.Create(144, 32, 160, 48),
    }

    local rect2 = {
        ModCS.Rect.Create(160, 32, 176, 48),
        ModCS.Rect.Create(176, 32, 192, 48),
    }

    local rect3 = {
        ModCS.Rect.Create(128, 48, 144, 64),
        ModCS.Rect.Create(144, 48, 160, 64),
    }

    -- Set framerect
    if (level == 1) then
        if (bul.direct == 1 or bul.direct == 3) then
            bul:SetRect(rect1[2])
        else
            bul:SetRect(rect1[1])
        end
    elseif (level == 2) then
        if (bul.direct == 1 or bul.direct == 3) then
            bul:SetRect(rect2[2])
        else
            bul:SetRect(rect2[1])
        end
    elseif (level == 3) then
        if (bul.direct == 1 or bul.direct == 3) then
            bul:SetRect(rect3[2])
        else
            bul:SetRect(rect3[1])
        end
    end
end

-- Polar Star Level 1
ModCS.Bullet.Act[4] = function(bul)
    PolarStarBullet(bul, 1)
end

-- Polar Star Level 2
ModCS.Bullet.Act[5] = function(bul)
    PolarStarBullet(bul, 2)
end

-- Polar Star Level 3
ModCS.Bullet.Act[6] = function(bul)
    PolarStarBullet(bul, 3)
end
