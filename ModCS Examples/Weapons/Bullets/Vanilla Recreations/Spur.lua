local function SpurBullet(bul, level)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.damage ~= 0 and bul.life ~= 100) then
        bul.damage = 0
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -8
        elseif (bul.direct == 1) then
            bul.ym = -8
        elseif (bul.direct == 2) then
            bul.xm = 8
        elseif (bul.direct == 3) then
            bul.ym = 8
        end

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

    bul.damage = bul.life

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

    ModCS.Bullet.Spawn(39 + level, bul.x, bul.y, bul.direct, bul.player_id)
end

-- Spur Level 1
ModCS.Bullet.Act[37] = function(bul)
    SpurBullet(bul, 1)
end

-- Spur Level 2
ModCS.Bullet.Act[38] = function(bul)
    SpurBullet(bul, 2)
end

-- Spur Level 3
ModCS.Bullet.Act[39] = function(bul)
    SpurBullet(bul, 3)
end

local function SpurTailBullet(bul, level)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > 20) then
        bul.ani_no = bul.count1 - 20
    end

    if (bul.ani_no > 2) then
        bul.cond = 0
        return
    end

    if (bul.damage ~= 0 and bul.life ~= 100) then
        bul.damage = 0
    end

    local rc_h_lv1 = {
        ModCS.Rect.Create(192, 32, 200, 40),
        ModCS.Rect.Create(200, 32, 208, 40),
        ModCS.Rect.Create(208, 32, 216, 40),
    }

    local rc_v_lv1 = {
        ModCS.Rect.Create(192, 40, 200, 48),
        ModCS.Rect.Create(200, 40, 208, 48),
        ModCS.Rect.Create(208, 40, 216, 48),
    }

    local rc_h_lv2 = {
        ModCS.Rect.Create(216, 32, 224, 40),
        ModCS.Rect.Create(224, 32, 232, 40),
        ModCS.Rect.Create(232, 32, 240, 40),
    }

    local rc_v_lv2 = {
        ModCS.Rect.Create(216, 40, 224, 48),
        ModCS.Rect.Create(224, 40, 232, 48),
        ModCS.Rect.Create(232, 40, 240, 48),
    }

    local rc_h_lv3 = {
        ModCS.Rect.Create(240, 32, 248, 40),
        ModCS.Rect.Create(248, 32, 256, 40),
        ModCS.Rect.Create(256, 32, 264, 40),
    }

    local rc_v_lv3 = {
        ModCS.Rect.Create(240, 32, 248, 40),
        ModCS.Rect.Create(248, 32, 256, 40),
        ModCS.Rect.Create(256, 32, 264, 40),
    }

    if (level == 1) then
        if (bul.direct == 0 or bul.direct == 2) then
            bul:SetRect(rc_h_lv1[bul.ani_no+1])
        else
            bul:SetRect(rc_v_lv1[bul.ani_no+1])
        end
    elseif (level == 2) then
        if (bul.direct == 0 or bul.direct == 2) then
            bul:SetRect(rc_h_lv2[bul.ani_no+1])
        else
            bul:SetRect(rc_v_lv2[bul.ani_no+1])
        end
    elseif (level == 3) then
        if (bul.direct == 0 or bul.direct == 2) then
            bul:SetRect(rc_h_lv3[bul.ani_no+1])
        else
            bul:SetRect(rc_v_lv3[bul.ani_no+1])
        end
    end
end

-- Spur Tail Level 1
ModCS.Bullet.Act[40] = function(bul)
    SpurTailBullet(bul, 1)
end

-- Spur Tail Level 2
ModCS.Bullet.Act[41] = function(bul)
    SpurTailBullet(bul, 2)
end

-- Spur Tail Level 3
ModCS.Bullet.Act[42] = function(bul)
    SpurTailBullet(bul, 3)
end
