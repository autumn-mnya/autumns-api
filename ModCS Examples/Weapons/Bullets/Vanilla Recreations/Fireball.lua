local function FireballBullet(bul, level)
    local mychar = ModCS.Multiplayer.GetByID(bul.player_id) -- CSE2LE multiplayer compat, in freeware it just is the same as ModCS.Player

    local bBreak = false

    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.direct == 0 and bul:TouchLeftWall()) then
        bul.direct = 2
    end

    if (bul.direct == 2 and bul:TouchRightWall()) then
        bul.direct = 0
    end

    if (bBreak) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, bul.x, bul.y, 0)
        ModCS.Sound.Play(28)
        return
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -2
        elseif (bul.direct == 1) then
            bul.xm = mychar.xm

            if (mychar.xm < 0) then
                bul.direct = 0
            else
                bul.direct = 2
            end

            if (mychar.direct == 0) then
                bul.xm = bul.xm - 0.25
            else
                bul.xm = bul.xm + 0.25
            end

            bul.ym = -2.998046875
        elseif (bul.direct == 2) then
            bul.xm = 2
        elseif (bul.direct == 3) then
            bul.xm = mychar.xm

            if (mychar.xm < 0) then
                bul.direct = 0
            else
                bul.direct = 2
            end

            bul.ym = 2.998046875
        end
    else
        if (bul:TouchFloor()) then
            bul.ym = -2
        elseif (bul:TouchLeftWall()) then
            bul.xm = 2
        elseif (bul:TouchRightWall()) then
            bul.xm = -2
        end

        bul.ym = bul.ym + 0.166015625
        if (bul.ym > 1.998046875) then
            bul.ym = 1.998046875
        end

        bul:Move()

        if (bul:HitFlag(0xD)) then
            ModCS.Sound.Play(34)
        end
    end

    local rect_left1 = {
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
    }

    local rect_right1 = {
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
    }

    local rect_left2 = {
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
        ModCS.Rect.Create(224, 16, 240, 32),
    }

    local rect_right2 = {
        ModCS.Rect.Create(224, 16, 240, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
        ModCS.Rect.Create(192, 16, 208, 32),
    }

    bul.ani_no = bul.ani_no + 1

    if (level == 1) then
        if (bul.ani_no > 3) then
            bul.ani_no = 0
        end

        if (bul.direct == 0) then
            bul:SetRect(rect_left1[bul.ani_no+1])
        else
            bul:SetRect(rect_right1[bul.ani_no+1])
        end
    else
        if (bul.ani_no > 2) then
            bul.ani_no = 0
        end

        if (bul.direct == 0) then
            bul:SetRect(rect_left2[bul.ani_no+1])
        else
            bul:SetRect(rect_right2[bul.ani_no+1])
        end

        if (level == 2) then
            ModCS.Npc.Spawn2(129, bul.x, bul.y, 0, -1, bul.ani_no)
        else
            ModCS.Npc.Spawn2(129, bul.x, bul.y, 0, -1, bul.ani_no + 3)
        end
    end
end

-- Fireball Level 1
ModCS.Bullet.Act[7] = function(bul)
    FireballBullet(bul, 1)
end

-- Fireball Level 2
ModCS.Bullet.Act[8] = function(bul)
    FireballBullet(bul, 2)
end

-- Fireball Level 3
ModCS.Bullet.Act[9] = function(bul)
    FireballBullet(bul, 3)
end
