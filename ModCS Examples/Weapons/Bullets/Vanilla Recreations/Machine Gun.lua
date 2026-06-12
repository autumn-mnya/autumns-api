local function MachineGunBullet(bul, level)
    local move = 8

    local rect1 = {
        ModCS.Rect.Create(64, 0, 80, 16),
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(96, 0, 112, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
    }

    local rect2 = {
        ModCS.Rect.Create(64, 16, 80, 32),
        ModCS.Rect.Create(80, 16, 96, 32),
        ModCS.Rect.Create(96, 16, 112, 32),
        ModCS.Rect.Create(112, 16, 128, 32),
    }

    local rect3 = {
        ModCS.Rect.Create(64, 32, 80, 48),
        ModCS.Rect.Create(80, 32, 96, 48),
        ModCS.Rect.Create(96, 32, 112, 48),
        ModCS.Rect.Create(112, 32, 128, 48),
    }

    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -move
            bul.ym = ModCS.Game.Random2(-0.33203125, 0.33203125)
        elseif (bul.direct == 1) then
            bul.ym = -move
            bul.xm = ModCS.Game.Random2(-0.33203125, 0.33203125)
        elseif (bul.direct == 2) then
            bul.xm = move
            bul.ym = ModCS.Game.Random2(-0.33203125, 0.33203125)
        elseif (bul.direct == 3) then
            bul.ym = move
            bul.xm = ModCS.Game.Random2(-0.33203125, 0.33203125)
        end
    else
        bul:Move()

        if (level == 1) then
            bul:SetRect(rect1[bul.direct+1])
        elseif (level == 2) then
            bul:SetRect(rect2[bul.direct+1])

            if (bul.direct == 1 or bul.direct == 3) then
                ModCS.Npc.Spawn2(127, bul.x, bul.y, 0, 0, 1)
            else
                ModCS.Npc.Spawn2(127, bul.x, bul.y, 0, 0, 0)
            end
        elseif (level == 3) then
            bul:SetRect(rect3[bul.direct+1])
            ModCS.Npc.Spawn2(128, bul.x, bul.y, 0, 0, bul.direct)
        end
    end
end

-- Machine Gun Level 1
ModCS.Bullet.Act[10] = function(bul)
    MachineGunBullet(bul, 1)
end

-- Machine Gun Level 2
ModCS.Bullet.Act[11] = function(bul)
    MachineGunBullet(bul, 2)
end

-- Machine Gun Level 3
ModCS.Bullet.Act[12] = function(bul)
    MachineGunBullet(bul, 3)
end
