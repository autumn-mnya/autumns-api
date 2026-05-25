-- Snake Level 1
ModCS.Bullet.Act[1] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.ani_no = ModCS.Game.Random(0, 2)
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -3
        elseif (bul.direct == 1) then
            bul.ym = -3
        elseif (bul.direct == 2) then
            bul.xm = 3
        elseif (bul.direct == 3) then
            bul.ym = 3
        end
    else
        bul:Move()
    end

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 0) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 3) then
        bul.ani_no = 0
    end

    local rcLeft = {
        ModCS.Rect.Create(136, 80, 152, 80),
        ModCS.Rect.Create(120, 80, 136, 96),
        ModCS.Rect.Create(136, 64, 152, 80),
        ModCS.Rect.Create(120, 64, 136, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(120, 64, 136, 80),
        ModCS.Rect.Create(136, 64, 152, 80),
        ModCS.Rect.Create(120, 80, 136, 96),
        ModCS.Rect.Create(136, 80, 152, 80),
    }

    if (bul.direct == 0) then
        bul:SetRect(rcLeft[bul.ani_no+1])
    else
        bul:SetRect(rcRight[bul.ani_no+1])
    end
end

-- Snake Level 2 & 3 code
local snake_inc = 0
local function SnakeBullet2(bul, level)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.ani_no = ModCS.Game.Random(0, 2)
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -1
        elseif (bul.direct == 1) then
            bul.ym = -1
        elseif (bul.direct == 2) then
            bul.xm = 1
        elseif (bul.direct == 3) then
            bul.ym = 1
        end

        snake_inc = snake_inc + 1

        if (bul.direct == 0 or bul.direct == 2) then
            if (snake_inc % 2 == 1) then
                bul.ym = 2
            else
                bul.ym = -2
            end
        elseif (bul.direct == 1 or bul.direct == 3) then
            if (snake_inc % 2 == 1) then
                bul.xm = 2
            else
                bul.xm = -2
            end
        end
    else
        if (bul.direct == 0) then
            bul.xm = bul.xm - 0.25
        elseif (bul.direct == 1) then
            bul.ym = bul.ym - 0.25
        elseif (bul.direct == 2) then
            bul.xm = bul.xm + 0.25
        elseif (bul.direct == 3) then
            bul.ym = bul.ym + 0.25
        end

        if (bul.direct == 0 or bul.direct == 2) then
            if (bul.count1 % 5 == 2) then
                if (bul.ym < 0) then
                    bul.ym = 2
                else
                    bul.ym = -2
                end
            end
        elseif (bul.direct == 1 or bul.direct == 3) then
            if (bul.count1 % 5 == 2) then
                if (bul.xm < 0) then
                    bul.xm = 2
                else
                    bul.xm = -2
                end
            end
        end

        bul:Move()
    end

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 0) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 2) then
        bul.ani_no = 0
    end

    local rect = {
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
        ModCS.Rect.Create(224, 16, 240, 32),
    }

    bul:SetRect(rect[bul.ani_no+1])

    if (level == 2) then
        ModCS.Npc.Spawn2(129, bul.x, bul.y, 0, -1, bul.ani_no)
    else
        ModCS.Npc.Spawn2(129, bul.x, bul.y, 0, -1, bul.ani_no + 3)
    end
end

-- Snake Level 2
ModCS.Bullet.Act[2] = function(bul)
    SnakeBullet2(bul, 2)
end

-- Snake Level 3
ModCS.Bullet.Act[3] = function(bul)
    SnakeBullet2(bul, 3)
end

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

-- Blade slashes
ModCS.Bullet.Act[23] = function(bul)
    if (bul.act_no == 0) then
        bul.act_no = 1
        bul.y = bul.y - 12

        if (bul.direct == 0) then
            bul.x = bul.x + 16
        else
            bul.x = bul.x - 16
        end
        -- Fallthrough
    end

    if (bul.act_no == 1) then
        bul.ani_wait = bul.ani_wait + 1
        if (bul.ani_wait > 2) then
            bul.ani_wait = 0
            bul.ani_no = bul.ani_no + 1
        end

        if (bul.direct == 0) then
            bul.x = bul.x - 2
        else
            bul.x = bul.x + 2
        end

        bul.y = bul.y + 2

        if (bul.ani_no == 1) then
            bul.damage = 2
        else
            bul.damage = 1
        end

        if (bul.ani_no > 4) then
            bul.cond = 0
            return
        end
    end

    local rcLeft = {
        ModCS.Rect.Create(0, 64, 24, 88),
        ModCS.Rect.Create(24, 64, 48, 88),
        ModCS.Rect.Create(48, 64, 72, 88),
        ModCS.Rect.Create(72, 64, 96, 88),
        ModCS.Rect.Create(96, 64, 120, 88),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 88, 24, 112),
        ModCS.Rect.Create(24, 88, 48, 112),
        ModCS.Rect.Create(48, 88, 72, 112),
        ModCS.Rect.Create(72, 88, 96, 112),
        ModCS.Rect.Create(96, 88, 120, 112),
    }

    if (bul.direct == 0) then
        bul:SetRect(rcLeft[bul.ani_no+1])
    else
        bul:SetRect(rcRight[bul.ani_no+1])
    end
end

-- Falling spike that deals 127 damage
ModCS.Bullet.Act[24] = function(bul)
    local rc = ModCS.Rect.Create(0, 0, 0, 0)

    bul.act_wait = bul.act_wait + 1
    if (bul.act_wait > 2) then
        bul.cond = 0
    end

    bul:SetRect(rc)
end

local super_missile_inc = 0
local function SuperMissileBullet(bul, level)
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
        ModCS.Bullet.Spawn(level + 30, bul.x, bul.y, 0, bul.player_id)
        bul.cond = 0
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0 or bul.direct == 2) then
            bul.tgt_y = bul.y
            bul.enemyhit_x = 8
            bul.blockhit_x = 8
        elseif (bul.direct == 1 or bul.direct == 3) then
            bul.tgt_x = bul.x
            bul.enemyhit_y = 8
            bul.blockhit_y = 8
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

            super_missile_inc = super_missile_inc + 1
            if (super_missile_inc % 3 == 0) then
                bul.ani_no = 0x200
            elseif (super_missile_inc % 3 == 1) then
                bul.ani_no = 0x100
            elseif (super_missile_inc % 3 == 2) then
                bul.ani_no = 0xAA
            end
        else
            bul.ani_no = 0x200
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
                    bul.ym = bul.ym + 0.125
                else
                    bul.ym = bul.ym - 0.125
                end
            elseif (bul.direct == 1 or bul.direct == 3) then
                if (bul.x < bul.tgt_x) then
                    bul.xm = bul.xm + 0.125
                else
                    bul.xm = bul.xm - 0.125
                end
            end
        end

        if (bul.xm < -10) then
            bul.xm = -10
        end

        if (bul.xm > 10) then
            bul.xm = 10
        end

        if (bul.ym < -10) then
            bul.ym = -10
        end

        if (bul.ym > 10) then
            bul.ym = 10
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
        ModCS.Rect.Create(120, 96, 136, 112),
        ModCS.Rect.Create(136, 96, 152, 112),
        ModCS.Rect.Create(152, 96, 168, 112),
        ModCS.Rect.Create(168, 96, 184, 112),
    }

    local rect2 = {
        ModCS.Rect.Create(184, 96, 200, 112),
        ModCS.Rect.Create(200, 96, 216, 112),
        ModCS.Rect.Create(216, 96, 232, 112),
        ModCS.Rect.Create(232, 96, 248, 112),
    }

    if (level == 1) then
        bul:SetRect(rect1[bul.direct+1])
    elseif (level == 2) then
        bul:SetRect(rect2[bul.direct+1])
    elseif (level == 3) then
        bul:SetRect(rect1[bul.direct+1])
    end
end

-- Super Missile Launcher Level 1
ModCS.Bullet.Act[28] = function(bul)
    SuperMissileBullet(bul, 1)
end

-- Super Missile Launcher Level 2
ModCS.Bullet.Act[29] = function(bul)
    SuperMissileBullet(bul, 2)
end

-- Super Missile Launcher Level 3
ModCS.Bullet.Act[30] = function(bul)
    SuperMissileBullet(bul, 3)
end

local function SuperMissileBomb(bul, level)
    if (bul.act_no == 0) then
        bul.act_no = 1

        if (level == 1) then
            bul.act_wait = 10
        elseif (level == 2) then
            bul.act_wait = 14
        elseif (level == 3) then
            bul.act_wait = 6
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

-- Super Missile Explosion Level 1
ModCS.Bullet.Act[31] = function(bul)
    SuperMissileBomb(bul, 1)
end

-- Super Missile Explosion Level 2
ModCS.Bullet.Act[32] = function(bul)
    SuperMissileBomb(bul, 2)
end

-- Super Missile Explosion Level 3
ModCS.Bullet.Act[33] = function(bul)
    SuperMissileBomb(bul, 3)
end

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

-- Curly's Nemesis (Same as normal Nemesis lv1)
ModCS.Bullet.Act[43] = function(bul)
    NemesisBullet(bul, 1)
end

-- Screen-nuke that kills all enemies
ModCS.Bullet.Act[44] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        return
    end

    bul.damage = 10000
    bul.enemyhit_x = 1600
    bul.enemyhit_y = 1600
end

-- Whimsical Star
ModCS.Bullet.Act[45] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
    end
end