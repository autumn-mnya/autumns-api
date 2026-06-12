local missile_inc = 0
local function MissileBullet(bul, level)
    local mychar = ModCS.Multiplayer.GetByID(bul.player_id) -- CSE2LE multiplayer compat, in freeware it just is the same as ModCS.Player

    local bHit = false

    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.life ~= 10) then
        bHit = true
    end

    if (bul.direct == 0 and bul:TouchLeftWall()) then
        bHit = true
    end

    if (bul.direct == 2 and bul:TouchRightWall()) then
        bHit = true
    end

    if (bul.direct == 1 and bul:TouchCeiling()) then
        bHit = true
    end

    if (bul.direct == 3 and bul:TouchFloor()) then
        bHit = true
    end

    if (bul.direct == 0 and bul:TouchTopSlopeLeft()) then
        bHit = true
    end

    if (bul.direct == 0 and bul:TouchBottomSlopeLeft()) then
        bHit = true
    end

    if (bul.direct == 2 and bul:TouchTopSlopeRight()) then
        bHit = true
    end

    if (bul.direct == 2 and bul:TouchBottomSlopeRight()) then
        bHit = true
    end

    if (bHit) then
        ModCS.Bullet.Spawn(level + 15, bul.x, bul.y, 0, bul.player_id)
        bul.cond = 0
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0 or bul.direct == 2) then
            bul.tgt_y = bul.y
        elseif (bul.direct == 1 or bul.direct == 3) then
            bul.tgt_x = bul.x
        end

        if (level == 3) then
            if (bul.direct == 0 or bul.direct == 2) then
                if (bul.y > mychar.y) then
                    bul.ym = 0.5
                else
                    bul.ym = -0.5
                end

                bul.xm = ModCS.Game.Random2(-1, 1)
            elseif (bul.direct == 1 or bul.direct == 3) then
                if (bul.x > mychar.x) then
                    bul.xm = 0.5
                else
                    bul.xm = -0.5
                end

                bul.ym = ModCS.Game.Random2(-1, 1)
            end

            missile_inc = missile_inc + 1
            if (missile_inc % 3 == 0) then
                bul.ani_no = 0x80
            elseif (missile_inc % 3 == 1) then
                bul.ani_no = 0x40
            elseif (missile_inc % 3 == 2) then
                bul.ani_no = 0x33
            end
        else
            bul.ani_no = 0x80
        end
        -- Fallthrough
    end

    if (bul.act_no == 1) then
        if (bul.direct == 0) then
            bul.xm = bul.xm + -(bul.ani_no/512)
        elseif (bul.direct == 1) then
            bul.ym = bul.ym + -(bul.ani_no/512)
        elseif (bul.direct == 2) then
            bul.xm = bul.xm + (bul.ani_no/512)
        elseif (bul.direct == 3) then
            bul.ym = bul.ym + (bul.ani_no/512)
        end

        if (level == 3) then
            if (bul.direct == 0 or bul.direct == 2) then
                if (bul.y < bul.tgt_y) then
                    bul.ym = bul.ym + 0.0625
                else
                    bul.ym = bul.ym - 0.0625
                end
            elseif (bul.direct == 1 or bul.direct == 3) then
                if (bul.x < bul.tgt_x) then
                    bul.xm = bul.xm + 0.0625
                else
                    bul.xm = bul.xm - 0.0625
                end
            end
        end

        if (bul.xm < -5) then
            bul.xm = -5
        end

        if (bul.xm > 5) then
            bul.xm = 5
        end

        if (bul.ym < -5) then
            bul.ym = -5
        end

        if (bul.ym > 5) then
            bul.ym = 5
        end

        bul:Move()
    end

    bul.count2 = bul.count2 + 1
    if (bul.count2 > 2) then
        bul.count2 = 0

        if (bul.direct == 0) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, bul.x + 8, bul.y, 2)
        elseif (bul.direct == 1) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, bul.x, bul.y + 8, 3)
        elseif (bul.direct == 2) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, bul.x - 8, bul.y, 0)
        elseif (bul.direct == 3) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, bul.x, bul.y - 8, 1)
        end
    end

    local rect1 = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(32, 0, 48, 16),
        ModCS.Rect.Create(48, 0, 64, 16),
    }

    local rect2 = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
        ModCS.Rect.Create(48, 16, 64, 32),
    }

    local rect3 = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
        ModCS.Rect.Create(32, 32, 48, 48),
        ModCS.Rect.Create(48, 32, 64, 48),
    }

    if (level == 1) then
        bul:SetRect(rect1[bul.direct+1])
    elseif (level == 2) then
        bul:SetRect(rect2[bul.direct+1])
    elseif (level == 3) then
        bul:SetRect(rect3[bul.direct+1])
    end
end

-- Missile Launcher Level 1
ModCS.Bullet.Act[13] = function(bul)
    MissileBullet(bul, 1)
end

-- Missile Launcher Level 2
ModCS.Bullet.Act[14] = function(bul)
    MissileBullet(bul, 2)
end

-- Missile Launcher Level 3
ModCS.Bullet.Act[15] = function(bul)
    MissileBullet(bul, 3)
end

local function MissileBomb(bul, level)
    if (bul.act_no == 0) then
        bul.act_no = 1

        if (level == 1) then
            bul.act_wait = 10
        elseif (level == 2) then
            bul.act_wait = 15
        elseif (level == 3) then
            bul.act_wait = 5
        end

        ModCS.Sound.Play(44)
        -- Fallthrough
    end

    if (bul.act_no == 1) then
        if (level == 1) then
            if (bul.act_wait % 3 == 0) then
                ModCS.Npc.Explode(bul.x + ModCS.Game.Random(-16, 16), bul.y + ModCS.Game.Random(-16, 16), bul.enemyhit_x, 2, 1)
            end
        elseif (level == 2) then
            if (bul.act_wait % 3 == 0) then
                ModCS.Npc.Explode(bul.x + ModCS.Game.Random(-32, 32), bul.y + ModCS.Game.Random(-32, 32), bul.enemyhit_x, 2, 1)
            end
        elseif (level == 3) then
            if (bul.act_wait % 3 == 0) then
                ModCS.Npc.Explode(bul.x + ModCS.Game.Random(-40, 40), bul.y + ModCS.Game.Random(-40, 40), bul.enemyhit_x, 2, 1)
            end
        end

        bul.act_wait = bul.act_wait - 1
        if (bul.act_wait < 0) then
            bul.cond = 0
        end
    end
end

-- Missile Explosion Level 1
ModCS.Bullet.Act[16] = function(bul)
    MissileBomb(bul, 1)
end

-- Missile Explosion Level 2
ModCS.Bullet.Act[17] = function(bul)
    MissileBomb(bul, 2)
end

-- Missile Explosion Level 3
ModCS.Bullet.Act[18] = function(bul)
    MissileBomb(bul, 3)
end
