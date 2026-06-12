local function NemesisBullet(bul, level)
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.act_no = 1
        bul.count1 = 0

        if (bul.direct == 0) then
            bul.xm = -8
        elseif (bul.direct == 1) then
            bul.ym = -8
        elseif (bul.direct == 2) then
            bul.xm = 8
        elseif (bul.direct == 3) then
            bul.ym = 8
        end

        if (level == 3) then
            bul.xm = bul.xm / 3
            bul.ym = bul.ym / 3
        end
    else
        if (level == 1 and bul.count1 % 4 == 1) then
            if (bul.direct == 0) then
                ModCS.Npc.Spawn2(4, bul.x, bul.y, -1, ModCS.Game.Random2(-1, 1), 2)
            elseif (bul.direct == 1) then
                ModCS.Npc.Spawn2(4, bul.x, bul.y, ModCS.Game.Random2(-1, 1), -1, 2)
            elseif (bul.direct == 2) then
                ModCS.Npc.Spawn2(4, bul.x, bul.y, 1, ModCS.Game.Random2(-1, 1), 2)
            elseif (bul.direct == 3) then
                ModCS.Npc.Spawn2(4, bul.x, bul.y, ModCS.Game.Random2(-1, 1), 1, 2)
            end
        end

        bul:Move()
    end

    bul.ani_no = bul.ani_no + 1
    if (bul.ani_no > 1) then
        bul.ani_no = 0
    end

    local rcL = {
        ModCS.Rect.Create(0, 112, 32, 128),
        ModCS.Rect.Create(0, 128, 32, 144),
    }

    local rcU = {
        ModCS.Rect.Create(32, 112, 48, 144),
        ModCS.Rect.Create(48, 112, 64, 144),
    }

    local rcR = {
        ModCS.Rect.Create(64, 112, 96, 128),
        ModCS.Rect.Create(64, 128, 96, 144),
    }

    local rcD = {
        ModCS.Rect.Create(96, 112, 112, 144),
        ModCS.Rect.Create(112, 112, 128, 144),
    }

    if (bul.direct == 0) then
        rect = rcL[bul.ani_no+1]
    elseif (bul.direct == 1) then
        rect = rcU[bul.ani_no+1]
    elseif (bul.direct == 2) then
        rect = rcR[bul.ani_no+1]
    elseif (bul.direct == 3) then
        rect = rcD[bul.ani_no+1]
    end

    rect.top = rect.top + ((level - 1) / 2) * 32
    rect.bottom = rect.bottom + ((level - 1) / 2) * 32
    rect.left = rect.left + ((level - 1) % 2) * 128
    rect.right = rect.right + ((level - 1) % 2) * 128

    bul:SetRect(rect)
end

-- Nemesis Level 1
ModCS.Bullet.Act[34] = function(bul)
    NemesisBullet(bul, 1)
end

-- Nemesis Level 2
ModCS.Bullet.Act[35] = function(bul)
    NemesisBullet(bul, 2)
end

-- Nemesis Level 3
ModCS.Bullet.Act[36] = function(bul)
    NemesisBullet(bul, 3)
end

-- Curly's Nemesis (Same as normal Nemesis lv1)
ModCS.Bullet.Act[43] = function(bul)
    NemesisBullet(bul, 1)
end
