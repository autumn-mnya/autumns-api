-- Bubbler Level 1
ModCS.Bullet.Act[19] = function(bul)
    if (bul:HitFlag(0x2FF)) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -3
        elseif (bul.direct == 2) then
            bul.xm = 3
        elseif (bul.direct == 1) then
            bul.ym = -3
        elseif (bul.direct == 3) then
            bul.ym = 3
        end
    end

    if (bul.direct == 0) then
        bul.xm = bul.xm + 0.08203125
    elseif (bul.direct == 2) then
        bul.xm = bul.xm - 0.08203125
    elseif (bul.direct == 1) then
        bul.ym = bul.ym + 0.08203125
    elseif (bul.direct == 3) then
        bul.ym = bul.ym - 0.08203125
    end

    bul:Move()

    bul.act_wait = bul.act_wait + 1
    if (bul.act_wait > 40) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, bul.x, bul.y, 0)
    end

    local rect = {
        ModCS.Rect.Create(192, 0, 200, 8),
        ModCS.Rect.Create(200, 0, 208, 8),
        ModCS.Rect.Create(208, 0, 216, 8),
        ModCS.Rect.Create(216, 0, 224, 8),
    }

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 3) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 3) then
        bul.ani_no = 3
    end

    bul:SetRect(rect[bul.ani_no+1])
end

-- Bubbler Level 2
ModCS.Bullet.Act[20] = function(bul)
    local bDelete = false

    if (bul.direct == 0 and bul:TouchLeftWall()) then
        bDelete = true
    end

    if (bul.direct == 2 and bul:TouchRightWall()) then
        bDelete = true
    end

    if (bul.direct == 1 and bul:TouchCeiling()) then
        bDelete = true
    end

    if (bul.direct == 3 and bul:TouchFloor()) then
        bDelete = true
    end

    if (bDelete) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -3
            bul.ym = ModCS.Game.Random2(-0.5, 0.5)
        elseif (bul.direct == 2) then
            bul.xm = 3
            bul.ym = ModCS.Game.Random2(-0.5, 0.5)
        elseif (bul.direct == 1) then
            bul.ym = -3
            bul.xm = ModCS.Game.Random2(-0.5, 0.5)
        elseif (bul.direct == 3) then
            bul.ym = 3
            bul.xm = ModCS.Game.Random2(-0.5, 0.5)
        end
    end

    if (bul.direct == 0) then
        bul.xm = bul.xm + 0.03125
    elseif (bul.direct == 2) then
        bul.xm = bul.xm - 0.03125
    elseif (bul.direct == 1) then
        bul.ym = bul.ym + 0.03125
    elseif (bul.direct == 3) then
        bul.ym = bul.ym - 0.03125
    end

    bul:Move()

    bul.act_wait = bul.act_wait + 1
    if (bul.act_wait > 60) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, bul.x, bul.y, 0)
    end

    local rect = {
        ModCS.Rect.Create(192, 8, 200, 16),
        ModCS.Rect.Create(200, 8, 208, 16),
        ModCS.Rect.Create(208, 8, 216, 16),
        ModCS.Rect.Create(216, 8, 224, 16),
    }

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 3) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 3) then
        bul.ani_no = 3
    end

    bul:SetRect(rect[bul.ani_no+1])
end

-- Bubbler Level 3
ModCS.Bullet.Act[21] = function(bul)
    local mychar = ModCS.Multiplayer.GetByID(bul.player_id)

    bul.act_wait = bul.act_wait + 1
    if (bul.act_wait > 100 or not ModCS.Key.ShootID(bul.player_id, true)) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, bul.x, bul.y, 0)
        ModCS.Sound.Play(100)

        if (mychar:IsLookingUp()) then
            ModCS.Bullet.Spawn(22, bul.x, bul.y, 1, bul.player_id)
        elseif (mychar:IsLookingDown()) then
            ModCS.Bullet.Spawn(22, bul.x, bul.y, 3, bul.player_id)
        else
            ModCS.Bullet.Spawn(22, bul.x, bul.y, mychar.direct, bul.player_id)
        end

        return
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = ModCS.Game.Random2(-2, -1)
            bul.ym = ModCS.Game.Random2(-4, 4) / 2
        elseif (bul.direct == 2) then
            bul.xm = ModCS.Game.Random2(1, 2)
            bul.ym = ModCS.Game.Random2(-4, 4) / 2
        elseif (bul.direct == 1) then
            bul.ym = ModCS.Game.Random2(-2, -1)
            bul.xm = ModCS.Game.Random2(-4, 4) / 2
        elseif (bul.direct == 3) then
            bul.ym = ModCS.Game.Random2(0.25, 0.5)
            bul.xm = ModCS.Game.Random2(-4, 4) / 2
        end
    end

    if (bul.x < mychar.x) then
        bul.xm = bul.xm + 0.0625
    end

    if (bul.x > mychar.x) then
        bul.xm = bul.xm - 0.0625
    end

    if (bul.y < mychar.y) then
        bul.ym = bul.ym + 0.0625
    end

    if (bul.y > mychar.y) then
        bul.ym = bul.ym - 0.0625
    end

    if (bul.xm < 0 and bul:TouchLeftWall()) then
        bul.xm = 2
    end

    if (bul.xm > 0 and bul:TouchRightWall()) then
        bul.xm = -2
    end

    if (bul.ym < 0 and bul:TouchCeiling()) then
        bul.ym = 2
    end

    if (bul.ym > 0 and bul:TouchFloor()) then
        bul.ym = -2
    end

    bul:Move()

    local rect = {
        ModCS.Rect.Create(240, 16, 248, 24),
        ModCS.Rect.Create(248, 16, 256, 24),
        ModCS.Rect.Create(240, 24, 248, 32),
        ModCS.Rect.Create(248, 24, 256, 32),
    }

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 3) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 3) then
        bul.ani_no = 3
    end

    bul:SetRect(rect[bul.ani_no+1])
end

-- Bubbler Level 3 Spines
ModCS.Bullet.Act[22] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count or bul:TouchFloor()) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -(ModCS.Game.Random2(10, 16) / 2)
        elseif (bul.direct == 1) then
            bul.ym = -(ModCS.Game.Random2(10, 16) / 2)
        elseif (bul.direct == 2) then
            bul.xm = ModCS.Game.Random2(10, 16) / 2
        elseif (bul.direct == 3) then
            bul.ym = ModCS.Game.Random2(10, 16) / 2
        end
    else
        bul:Move()
    end

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 1) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 1) then
        bul.ani_no = 0
    end

    local rcLeft = {
        ModCS.Rect.Create(224, 0, 232, 8),
        ModCS.Rect.Create(232, 0, 240, 8),
    }

    local rcRight = {
        ModCS.Rect.Create(224, 0, 232, 8),
        ModCS.Rect.Create(232, 0, 240, 8),
    }

    local rcDown = {
        ModCS.Rect.Create(224, 8, 232, 16),
        ModCS.Rect.Create(232, 8, 240, 16),
    }

    if (bul.direct == 0) then
        bul:SetRect(rcLeft[bul.ani_no+1])
    elseif (bul.direct == 1) then
        bul:SetRect(rcDown[bul.ani_no+1])
    elseif (bul.direct == 2) then
        bul:SetRect(rcRight[bul.ani_no+1])
    elseif (bul.direct == 3) then
        bul:SetRect(rcDown[bul.ani_no+1])
    end
end
