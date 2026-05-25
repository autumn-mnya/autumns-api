-- Gravekeeper
ModCS.Npc.Act[80] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 64, 24, 88),
        ModCS.Rect.Create(24, 64, 48, 88),
        ModCS.Rect.Create(0, 64, 24, 88),
        ModCS.Rect.Create(48, 64, 72, 88),
        ModCS.Rect.Create(72, 64, 96, 88),
        ModCS.Rect.Create(96, 64, 120, 88),
        ModCS.Rect.Create(120, 64, 144, 88),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 88, 24, 112),
        ModCS.Rect.Create(24, 88, 48, 112),
        ModCS.Rect.Create(0, 88, 24, 112),
        ModCS.Rect.Create(48, 88, 72, 112),
        ModCS.Rect.Create(72, 88, 96, 112),
        ModCS.Rect.Create(96, 88, 120, 112),
        ModCS.Rect.Create(120, 88, 144, 112),
    }

    local hit = npc:GetHitbox()

    if (npc.act_no == 0) then
        npc:UnsetBit(5) -- Unset shootable bit
        npc.act_no = 1
        npc.damage = 0
        hit.front = 4
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0

        if (npc:TriggerBox(128, 48, 128, 32)) then
            npc.ani_wait = 0
            npc.act_no = 2
        end

        if (npc:IsHit()) then
            npc.ani_no = 1
            npc.ani_wait = 0
            npc.act_no = 2
            npc:UnsetBit(5) -- Unset shootable bit
        end

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 6) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 0
        end

        if (npc.x - 16 < npc.tgt_mc.x and npc.x + 16 > npc.tgt_mc.x) then
            hit.front = 18
            npc.act_wait = 0
            npc.act_no = 3
            npc:SetBit(5) -- Set shootable bit
            ModCS.Sound.Play(34)

            if (npc.direct == 0) then
                npc.xm = -2
            else
                npc.xm = 2
            end
        end

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
            npc.xm = -0.5
        else
            npc.direct = 2
            npc.xm = 0.5
        end
    elseif (npc.act_no == 3) then
        npc.xm = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_wait = 0
            npc.act_no = 4
            ModCS.Sound.Play(106)
        end

        npc.ani_no = 4
    elseif (npc.act_no == 4) then
        npc.damage = 10

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 2) then
            npc.act_wait = 0
            npc.act_no = 5
        end

        npc.ani_no = 5
    elseif (npc.act_no == 5) then
        npc.ani_no = 6

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 60) then
            npc.act_no = 0
        end
    end

    if (npc.xm < 0 and npc:TouchLeftWall()) then
        npc.xm = 0
    end

    if (npc.xm > 0 and npc:TouchRightWall()) then
        npc.xm = 0
    end

    npc.ym = npc.ym + 0.0625

    if (npc.xm > 2) then
        npc.xm = 2
    end

    if (npc.xm < -2) then
        npc.xm = -2
    end

    -- Pixel accidentally capped the xm again, here's a bug fix to use ym instead as probably intended
    -- the original behavior is commented out below

    -- Original games behavior, probably a bug.
    -- if (npc.ym > 2.998046875) then
    --     npc.xm = 2.998046875
    -- end

    -- if (npc.ym < -2.998046875) then
    --     npc.xm = -2.998046875
    -- end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    if (npc.ym < -2.998046875) then
        npc.ym = -2.998046875
    end

    npc:Move()

    npc:SetHitbox(hit)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Giant pignon
ModCS.Npc.Act[81] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(144, 64, 168, 88),
        ModCS.Rect.Create(168, 64, 192, 88),
        ModCS.Rect.Create(192, 64, 216, 88),
        ModCS.Rect.Create(216, 64, 240, 88),
        ModCS.Rect.Create(144, 64, 168, 88),
        ModCS.Rect.Create(240, 64, 264, 88),
    }

    local rcRight = {
        ModCS.Rect.Create(144, 88, 168, 112),
        ModCS.Rect.Create(168, 88, 192, 112),
        ModCS.Rect.Create(192, 88, 216, 112),
        ModCS.Rect.Create(216, 88, 240, 112),
        ModCS.Rect.Create(144, 88, 168, 112),
        ModCS.Rect.Create(240, 88, 264, 112),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.xm = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        local done = false

        if (ModCS.Game.Random(0, 100) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
            done = true
        end

        if not done and (ModCS.Game.Random(0, 150) == 1) then
            if (npc.direct == 0) then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end

        if not done and (ModCS.Game.Random(0, 150) == 1) then
            npc.act_no = 3
            npc.act_wait = 50
            npc.ani_no = 0
            done = true
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 3) then
        npc.act_no = 4
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 4) then
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait == 0) then
            npc.act_no = 0
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 2
        end

        if (npc:TouchLeftWall()) then
            npc.direct = 2
            npc.xm = 1
        end

        if (npc:TouchRightWall()) then
            npc.direct = 0
            npc.xm = -1
        end

        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end
    elseif (npc.act_no == 5) then
        if (npc:TouchFloor()) then
            npc.act_no = 0
        end
    end

    if (npc.act_no == 1 or npc.act_no == 2 or npc.act_no == 4) then
        if (npc:IsHit()) then
            npc.ym = -1
            npc.ani_no = 5
            npc.act_no = 5

            if (npc.x < npc.tgt_mc.x) then
                npc.xm = 0.5
            else
                npc.xm = -0.5
            end
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Misery (standing)
ModCS.Npc.Act[82] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 2
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 3
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 2
        end
    elseif (npc.act_no == 15) then
        npc.act_no = 16
        npc.act_wait = 0
        npc.ani_no = 4
        -- Fallthrough
    end

    if (npc.act_no == 16) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30) then
            ModCS.Sound.Play(21)
            ModCS.Npc.Spawn3(66, npc.x, npc.y - 16, 0, 0, 0, npc, 0)
        end

        if (npc.act_wait == 50) then
            npc.act_no = 14
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.ani_no = 0
        npc.ym = 0
        npc:SetBit(3) -- Ignore tile collision bit
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ym = npc.ym - 0.0625

        if (npc.y < -8) then
            npc.cond = 0
        end
    elseif (npc.act_no == 25) then
        npc.act_no = 26
        npc.act_wait = 0
        npc.ani_no = 5
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 26) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 7) then
            npc.ani_no = 5
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30) then
            ModCS.Sound.Play(101)
            ModCS.Flash.Spawn()
            npc.act_no = 27
            npc.ani_no = 7
        end
    elseif (npc.act_no == 27) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 50) then
            npc.act_no = 0
            npc.ani_no = 0
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.ani_no = 3
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 10) then
            npc.act_no = 32
            npc.ani_no = 4
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 32) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 100) then
            npc.act_no = 1
            npc.ani_no = 2
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 31
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc.ani_no = 4

        npc.act_wait = npc.act_wait + 1

        if (npc.act_wait == 30 or npc.act_wait == 40 or npc.act_wait == 50) then
            ModCS.Npc.Spawn2(11, npc.x + 8, npc.y - 8, 3, ModCS.Game.Random2(-1, 0), 0)
            ModCS.Sound.Play(33)
        end

        if (npc.act_wait > 50) then
            npc.act_no = 0
        end
    elseif (npc.act_no == 50) then
        npc.ani_no = 8
    end

    npc:Move()

    local rcLeft = {
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(96, 0, 112, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(208, 64, 224, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(80, 16, 96, 32),
        ModCS.Rect.Create(96, 16, 112, 32),
        ModCS.Rect.Create(112, 16, 128, 32),
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(208, 80, 224, 96),
    }

    if (npc.act_no == 11) then
        if (npc.ani_wait ~= 0) then
            npc.ani_wait = npc.ani_wait - 1
            npc.ani_no = 1
        else
            if (ModCS.Game.Random(0, 100) == 1) then
                npc.ani_wait = 30
            end

            npc.ani_no = 0
        end
    end

    if (npc.act_no == 14) then
        if (npc.ani_wait ~= 0) then
            npc.ani_wait = npc.ani_wait - 1
            npc.ani_no = 3
        else
            if (ModCS.Game.Random(0, 100) == 1) then
                npc.ani_wait = 30
            end

            npc.ani_no = 2
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Igor (cutscene)
ModCS.Npc.Act[83] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(40, 0, 80, 40),
        ModCS.Rect.Create(80, 0, 120, 40),
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(120, 0, 160, 40),
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(160, 0, 200, 40),
        ModCS.Rect.Create(200, 0, 240, 40),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 40, 40, 80),
        ModCS.Rect.Create(40, 40, 80, 80),
        ModCS.Rect.Create(80, 40, 120, 80),
        ModCS.Rect.Create(0, 40, 40, 80),
        ModCS.Rect.Create(120, 40, 160, 80),
        ModCS.Rect.Create(0, 40, 40, 80),
        ModCS.Rect.Create(160, 40, 200, 80),
        ModCS.Rect.Create(200, 40, 240, 80),
    }

    if (npc.act_no == 0) then
        npc.xm = 0
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    elseif (npc.act_no == 2) then
        npc.act_no = 3
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 3) then
        npc.ani_wait = npc.ani_wait + 1 
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end

        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end
    elseif (npc.act_no == 4) then
        npc.xm = 0
        npc.act_no = 5
        npc.act_wait = 0
        npc.ani_no = 6
        -- Fallthrough
    end

    if (npc.act_no == 5) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_wait = 0
            npc.act_no = 6
            npc.ani_no = 7
            ModCS.Sound.Play(70)
        end
    elseif (npc.act_no == 6) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 0
            npc.ani_no = 0
        end
    elseif (npc.act_no == 7) then
        npc.act_no = 1
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Basu projectile (Egg Corridor)
ModCS.Npc.Act[84] = function(npc)
    if (npc:TouchTile()) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(48, 48, 64, 64),
        ModCS.Rect.Create(64, 48, 80, 64),
        ModCS.Rect.Create(48, 64, 64, 80),
        ModCS.Rect.Create(64, 64, 80, 80),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 3) then
        npc.ani_no = 0
    end

    npc:SetRect(rect_left[npc.ani_no+1])

    npc.count1 = npc.count1 + 1
    if (npc.count1 > 300) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end
end

-- Terminal
ModCS.Npc.Act[85] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(256, 96, 272, 120),
        ModCS.Rect.Create(256, 96, 272, 120),
        ModCS.Rect.Create(272, 96, 288, 120),
    }

    local rcRight = {
        ModCS.Rect.Create(256, 96, 272, 120),
        ModCS.Rect.Create(288, 96, 304, 120),
        ModCS.Rect.Create(304, 96, 320, 120),
    }

    if (npc.act_no == 0) then
        npc.ani_no = 0

        if (npc:TriggerBox(8, 8, 16, 8)) then
            ModCS.Sound.Play(43)
            npc.act_no = 1
        end
    elseif (npc.act_no == 1) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Missile
ModCS.Npc.Act[86] = function(npc)
    local rect1 = {
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
    }

    local rect3 = {
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(16, 112, 32, 128),
    }

    local rcLast = ModCS.Rect.Create(16, 0, 32, 16)

    local rcNo = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.direct == 0) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    if (ModCS.Back.type == ModCS.Const.BACKGROUND_TYPE_AUTOSCROLL or ModCS.Back.type == ModCS.Const.BACKGROUND_TYPE_CLOUDS_WINDY) then
        if (npc.act_no == 0) then
            npc.act_no = 1
            npc.ym = ModCS.Game.Random2(-0.0625, 0.0625)
            npc.xm = ModCS.Game.Random2(0.248046875, 0.5)
        end

        npc.xm = npc.xm - 0.015625

        -- Despawn if close to edge of map
        -- Might wanna make this below 0, but thats inaccurate
        if (npc.x < 80) then
            npc.cond = 0
        end

        -- the original code does this, which is probably a bug.
        -- instead of limiting the npcs xm, pixel may have accidentally limited the npcs x position instead.
        -- if (npc.x < -3) then
        --     npc.x = -3
        -- end

        -- Limit speed
        if (npc.xm < -3) then
            npc.xm = -3
        end

        if (npc:TouchLeftWall()) then
            npc.xm = 0.5
        end

        if (npc:TouchCeiling()) then
            npc.ym = 0.125
        end

        if (npc:TouchFloor()) then
            npc.ym = -0.125
        end

        npc:Move()
    end

    if (npc.exp == 1) then
        npc:SetRect(rect1[npc.ani_no+1])
    end

    if (npc.exp == 3) then
        npc:SetRect(rect3[npc.ani_no+1])
    end

    if (npc.direct == 0) then
        npc.count1 = npc.count1 + 1
    end

    if (npc.count1 > 550) then
        npc.cond = 0
    end

    if (npc.count1 > 500 and (math.floor(npc.count1 / 2) % 2 == 1)) then
        npc:SetRect(rcNo)
    end

    if (npc.count1 > 547) then
        npc:SetRect(rcLast)
    end
end

-- Heart
ModCS.Npc.Act[87] = function(npc)
    local rect2 = {
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(48, 80, 64, 96),
    }

    local rect6 = {
        ModCS.Rect.Create(64, 80, 80, 96),
        ModCS.Rect.Create(80, 80, 96, 96),
    }

    local rcLast = ModCS.Rect.Create(16, 0, 32, 16)

    local rcNo = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.direct == 0) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    if (ModCS.Back.type == ModCS.Const.BACKGROUND_TYPE_AUTOSCROLL or ModCS.Back.type == ModCS.Const.BACKGROUND_TYPE_CLOUDS_WINDY) then
        if (npc.act_no == 0) then
            npc.act_no = 1
            npc.ym = ModCS.Game.Random2(-0.0625, 0.0625)
            npc.xm = ModCS.Game.Random2(0.248046875, 0.5)
        end

        npc.xm = npc.xm - 0.015625

        -- Despawn if close to edge of map
        -- Might wanna make this below 0, but thats inaccurate
        if (npc.x < 80) then
            npc.cond = 0
        end

        -- the original code does this, which is probably a bug.
        -- instead of limiting the npcs xm, pixel may have accidentally limited the npcs x position instead.
        -- if (npc.x < -3) then
        --     npc.x = -3
        -- end

        -- Limit speed
        if (npc.xm < -3) then
            npc.xm = -3
        end

        if (npc:TouchLeftWall()) then
            npc.xm = 0.5
        end

        if (npc:TouchCeiling()) then
            npc.ym = 0.125
        end

        if (npc:TouchFloor()) then
            npc.ym = -0.125
        end

        npc:Move()
    end

    if (npc.exp == 2) then
        npc:SetRect(rect2[npc.ani_no+1])
    end

    if (npc.exp == 6) then
        npc:SetRect(rect6[npc.ani_no+1])
    end

    if (npc.direct == 0) then
        npc.count1 = npc.count1 + 1
    end

    if (npc.count1 > 550) then
        npc.cond = 0
    end

    if (npc.count1 > 500 and (math.floor(npc.count1 / 2) % 2 == 1)) then
        npc:SetRect(rcNo)
    end

    if (npc.count1 > 547) then
        npc:SetRect(rcLast)
    end
end

-- Igor (boss)
ModCS.Npc.Act[88] = function(npc)
    local i
    local deg
    local xm
    local ym

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(40, 0, 80, 40),
        ModCS.Rect.Create(80, 0, 120, 40),
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(120, 0, 160, 40),
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(160, 0, 200, 40),
        ModCS.Rect.Create(200, 0, 240, 40),
        ModCS.Rect.Create(0, 80, 40, 120),
        ModCS.Rect.Create(40, 80, 80, 120),
        ModCS.Rect.Create(240, 0, 280, 40),
        ModCS.Rect.Create(280, 0, 320, 40),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 40, 40, 80),
        ModCS.Rect.Create(40, 40, 80, 80),
        ModCS.Rect.Create(80, 40, 120, 80),
        ModCS.Rect.Create(0, 40, 40, 80),
        ModCS.Rect.Create(120, 40, 160, 80),
        ModCS.Rect.Create(0, 40, 40, 80),
        ModCS.Rect.Create(160, 40, 200, 80),
        ModCS.Rect.Create(200, 40, 240, 80),
        ModCS.Rect.Create(120, 80, 160, 120),
        ModCS.Rect.Create(160, 80, 200, 120),
        ModCS.Rect.Create(240, 40, 280, 80),
        ModCS.Rect.Create(280, 40, 320, 80),
    }

    local hit = npc:GetHitbox()

    if (npc.act_no == 0) then
        npc.xm = 0
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then
        npc.act_no = 3
        npc.act_wait = 0
        npc.ani_no = 2
        npc.ani_wait = 0

        npc.count1 = npc.count1 + 1
        if (npc.count1 < 3 or npc.life > 150) then
            npc.count2 = 0

            if (npc.tgt_mc.x < npc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        else
            npc.count2 = 1

            if (npc.tgt_mc.x < npc.x) then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end
        -- Fallthrough
    end

    if (npc.act_no == 3) then
        local done = false

        npc.act_wait = npc.act_wait + 1

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end

        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end

        if (npc.count2 ~= 0) then
            if (npc.act_wait > 16) then
                npc.act_no = 9
                npc.xm = 0
                npc.ani_no = 10
                done = true
            end
        elseif not done and (npc.act_wait > 50) then -- Start jump state
            npc.ani_no = 8
            npc.ym = -2
            npc.act_no = 7
            npc.act_wait = 0
            npc.xm = (npc.xm * 3) / 2
            npc.damage = 2
            done = true
        elseif not done then -- Go to punch player state if close enough
            if (npc.direct == 0) then
                if (npc.x - 24 < npc.tgt_mc.x) then
                    npc.act_no = 4
                end
            else
                if (npc.x + 24 > npc.tgt_mc.x) then
                    npc.act_no = 4
                end
            end
        end
    elseif (npc.act_no == 4) then
        npc.xm = 0
        npc.act_no = 5
        npc.act_wait = 0
        npc.ani_no = 6
        -- Fallthrough
    end

    if (npc.act_no == 5) then -- Punch player
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 12) then
            npc.act_wait = 0
            npc.act_no = 6
            npc.ani_no = 7
            ModCS.Sound.Play(70)
            npc.damage = 5
            hit.front = 24
            hit.top = 1
        end
    elseif (npc.act_no == 6) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 0
            npc.ani_no = 0
            npc.damage = 0
            hit.front = 8
            hit.top = 16
        end
    elseif (npc.act_no == 7) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 1) then -- Wait a frame or two, as ModCS Lua is inaccurate and instantly checks TouchFloor() otherwise
            if (npc:TouchFloor()) then
                npc.act_wait = 0
                npc.act_no = 8
                npc.ani_no = 9
                ModCS.Sound.Play(26)
                ModCS.Camera.SetQuake(30)
                npc.damage = 0

                for i = 0, 3 do
                    ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
                end
            end
        end
    elseif (npc.act_no == 8) then
        npc.xm = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 0
            npc.ani_no = 0
            npc.damage = 0
        end
    elseif (npc.act_no == 9) then
        npc.act_no = 10
        npc.act_wait = 0

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100 and (npc.act_wait % 6 == 1)) then
            if (npc.direct == 0) then
                deg = 0x88
            else
                deg = 0xF8
            end

            deg = deg + ModCS.Game.Random(-0x10, 0x10)
            ym = ModCS.Triangle.GetSin(deg) * 3
            xm = ModCS.Triangle.GetCos(deg) * 3
            ModCS.Npc.Spawn2(11, npc.x, npc.y + 4, xm, ym, 0)
            ModCS.Sound.Play(12)
        end

        if (npc.act_wait > 50 and (math.floor(npc.act_wait / 2) % 2 == 1)) then
            npc.ani_no = 11
        else
            npc.ani_no = 10
        end

        if (npc.act_wait > 132) then
            npc.act_no = 0
            npc.ani_no = 0
            npc.count1 = 0
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:SetHitbox(hit)

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Igor (defeated)
ModCS.Npc.Act[89] = function(npc)
    local i

    local rcLeft = {
        ModCS.Rect.Create(80, 80, 120, 120),
        ModCS.Rect.Create(240, 80, 264, 104),
        ModCS.Rect.Create(264, 80, 288, 104),
        ModCS.Rect.Create(288, 80, 312, 104),
    }

    local rcRight = {
        ModCS.Rect.Create(200, 80, 240, 120),
        ModCS.Rect.Create(240, 104, 264, 128),
        ModCS.Rect.Create(264, 104, 288, 128),
        ModCS.Rect.Create(288, 104, 312, 128),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        ModCS.Sound.Play(72)

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_wait = 0
            npc.act_no = 2
        end

        if (npc.direct == 0) then
            rect = rcLeft[1]
        else
            rect = rcRight[1]
        end

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            rect.left = rect.left - 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1 and npc.act_wait < 100) then
            npc.ani_no = 0
            view.back = 20
            view.front = 20
            view.top = 20
        else
            npc.ani_no = 1
            view.back = 12
            view.front = 12
            view.top = 8
        end

        if (npc.act_wait > 150) then
            npc.act_wait = 0
            npc.act_no = 3
            npc.ani_no = 1
        end

        if (npc.act_wait % 9 == 0) then
            ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        if (npc.direct == 0) then
            rect = rcLeft[npc.ani_no+1]
        else
            rect = rcRight[npc.ani_no+1]
        end
    elseif (npc.act_no == 3) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 50) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no == 3) then
            npc.act_no = 4
        end

        if (npc.direct == 0) then
            rect = rcLeft[npc.ani_no+1]
        else
            rect = rcRight[npc.ani_no+1]
        end
    elseif (npc.act_no == 4) then -- Not in original code, but needed for accuracy
        if (npc.direct == 0) then
            rect = rcLeft[npc.ani_no+1]
        else
            rect = rcRight[npc.ani_no+1]
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:SetViewbox(view)
    npc:Move()
    npc:SetRect(rect)
end

-- Background
ModCS.Npc.Act[90] = function(npc)
    local rect = ModCS.Rect.Create(280, 80, 296, 104)
    npc:SetRect(rect)
end

-- Cage
ModCS.Npc.Act[91] = function(npc)
    local rect = ModCS.Rect.Create(96, 88, 128, 112)

    if (npc.act_no == 0) then
        npc.act_no = npc.act_no + 1
        npc.y = npc.y + 16
    end

    npc:SetRect(rect)
end

-- Sue at PC
ModCS.Npc.Act[92] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(272, 216, 288, 240),
        ModCS.Rect.Create(288, 216, 304, 240),
        ModCS.Rect.Create(304, 216, 320, 240),
    }

    if (npc.act_no == 0) then
        npc.x = npc.x - 4
        npc.y = npc.y + 16
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (ModCS.Game.Random(0, 80) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end

        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 3
            npc.act_wait = 0
            npc.ani_no = 2
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_no = 3
            npc.act_wait = 0
            npc.ani_no = 2
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 80) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    end

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Chaco
ModCS.Npc.Act[93] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(32, 32, 48, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(32, 32, 48, 48),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end

        if (npc:TriggerBox(32, 32, 32, 16)) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 3) then
        npc.act_no = 4
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 4) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end

        if (npc.direct == 0) then
            npc.x = npc.x - 1
        else
            npc.x = npc.x + 1
        end
    elseif (npc.act_no == 10) then
        npc.ani_no = 6

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 200) then
            npc.act_wait = 0
            ModCS.Caret.Spawn(ModCS.Const.CARET_ZZZ, npc.x, npc.y, 0)
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Kulala
ModCS.Npc.Act[94] = function(npc)
    local rect = {
        ModCS.Rect.Create(272, 0, 320, 24),
        ModCS.Rect.Create(272, 24, 320, 48),
        ModCS.Rect.Create(272, 48, 320, 72),
        ModCS.Rect.Create(272, 72, 320, 96),
        ModCS.Rect.Create(272, 96, 320, 120),
    }

    if (npc.act_no == 0) then
        npc.ani_no = 4

        if (npc:IsHit()) then
            npc.ani_no = 0
            npc.act_no = 10
            npc.act_wait = 0
        end
    elseif (npc.act_no == 10) then
        npc:SetBit(5) -- Set shootable bit
        npc:UnsetBit(2) -- Unset invulnerable bit

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_wait = 0
            npc.ani_wait = 0
            npc.act_no = 11
        end
    elseif (npc.act_no == 11) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.act_no = 12
            npc.ani_no = 3
        end
    elseif (npc.act_no == 12) then
        npc.ym = -0.666015625

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_wait = 0
            npc.act_no = 10
            npc.ani_no = 0
        end
    elseif (npc.act_no == 20) then
        npc.xm = npc.xm / 2
        npc.ym = npc.ym + 0.0625

        if not npc:IsHit() then
            npc.act_wait = 30
            npc.act_no = 10
            npc.ani_no = 0
        end
    end

    if (npc:IsHit()) then
        npc.count2 = npc.count2 + 1
        if (npc.count2 > 12) then
            npc.act_no = 20
            npc.ani_no = 4
            npc:UnsetBit(5) -- Unset shootable bit
            npc:SetBit(2) -- Set invulnerable bit
        end
    else
        npc.count2 = 0
    end

    if (npc.act_no >= 10) then
        if (npc:TouchLeftWall()) then
            npc.count1 = 50
            npc.direct = 2
        end

        if (npc:TouchRightWall()) then
            npc.count1 = 50
            npc.direct = 0
        end

        if (npc.count1 ~= 0) then
            npc.count1 = npc.count1 - 1

            if (npc.direct == 0) then
                npc.xm = npc.xm - 0.25
            else
                npc.xm = npc.xm + 0.25
            end
        else
            npc.count1 = 50

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end

        npc.ym = npc.ym + 0.03125

        if (npc:TouchFloor()) then
            npc.ym = -2
        end
    end

    if (npc.xm > 0.5) then
        npc.xm = 0.5
    end

    if (npc.xm < -0.5) then
        npc.xm = -0.5
    end

    if (npc.ym > 1.5) then
        npc.ym = 1.5
    end

    if (npc.ym < -1.5) then
        npc.ym = -1.5
    end

    npc:Move()

    npc:SetRect(rect[npc.ani_no+1])
end

-- Jelly
ModCS.Npc.Act[95] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(208, 64, 224, 80),
        ModCS.Rect.Create(224, 64, 240, 80),
        ModCS.Rect.Create(240, 64, 256, 80),
        ModCS.Rect.Create(256, 64, 272, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(208, 80, 224, 96),
        ModCS.Rect.Create(224, 80, 240, 96),
        ModCS.Rect.Create(240, 80, 256, 96),
        ModCS.Rect.Create(256, 80, 272, 96),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = ModCS.Game.Random(0, 50)
        npc.tgt_y = npc.y
        npc.tgt_x = npc.x

        if (npc.direct == 0) then
            npc.xm = 1
        else
            npc.xm = -1
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        local done = false
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait > 0) then
            done = true
        end

        if not done then
            npc.act_no = 10
        end
        -- Falthrough
    end

    if (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_wait = 0
            npc.ani_wait = 0
            npc.act_no = 11
        end
    elseif (npc.act_no == 11) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no == 2) then
            if (npc.direct == 0) then
                npc.xm = npc.xm - 0.5
            else
                npc.xm = npc.xm + 0.5
            end

            npc.ym = npc.ym - 1
        end

        if (npc.ani_no > 2) then
            npc.act_no = 12
            npc.ani_no = 3
        end
    elseif (npc.act_no == 12) then
        npc.act_wait = npc.act_wait + 1
        
        if (npc.y > npc.tgt_y and npc.act_wait > 10) then
            npc.act_wait = 0
            npc.act_no = 10
            npc.ani_no = 0
        end
    end

    if (npc.x > npc.tgt_x) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    if (npc:TouchLeftWall()) then
        npc.count1 = 50
        npc.direct = 2
    end

    if (npc:TouchRightWall()) then
        npc.count1 = 50
        npc.direct = 0
    end

    npc.ym = npc.ym + 0.0625

    if (npc:TouchFloor()) then
        npc.ym = -2
    end

    if (npc.xm > 0.5) then
        npc.xm = 0.5
    end

    if (npc.xm < -0.5) then
        npc.xm = -0.5
    end

    if (npc.ym > 1) then
        npc.ym = 1
    end

    if (npc.ym < -1) then
        npc.ym = -1
    end

    if (npc:IsHit()) then
        npc.x = npc.x + (npc.xm / 2)
        npc.y = npc.y + (npc.ym / 2)
    else
        npc:Move()
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Fan (left)
ModCS.Npc.Act[96] = function(npc)
    local i = 1

    local rc = {
        ModCS.Rect.Create(272, 120, 288, 136),
        ModCS.Rect.Create(288, 120, 304, 136),
        ModCS.Rect.Create(304, 120, 320, 136),
    }

    if (npc.act_no == 0) then
        if (npc.direct == 2) then
            npc.act_no = 2
        else
            npc.act_no = 1
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end

        if npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120) then
            if (ModCS.Game.Random(0, 5) == 1) then
                ModCS.Npc.Spawn2(199, npc.x, npc.y + ModCS.Game.Random(-8, 8), 0, 0, 0)
            end
        end

        -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or npc.tgt_mc
        -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
        -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
        -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
        for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
            local mychar = ModCS.Multiplayer.GetByID(i)
            if (mychar:IsPlaying()) then
                if (mychar.y < npc.y + 8 and mychar.y > npc.y - 8 and mychar.x < npc.x and mychar.x > npc.x - 96) then
                    mychar.xm = mychar.xm - 0.265625
                    mychar.SetCond(0x20)
                end
            end
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Fan (up)
ModCS.Npc.Act[97] = function(npc)
    local i = 1

    local rc = {
        ModCS.Rect.Create(272, 136, 288, 152),
        ModCS.Rect.Create(288, 136, 304, 152),
        ModCS.Rect.Create(304, 136, 320, 152),
    }

    if (npc.act_no == 0) then
        if (npc.direct == 2) then
            npc.act_no = 2
        else
            npc.act_no = 1
        end

        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end

        if npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120) then
            if (ModCS.Game.Random(0, 5) == 1) then
                ModCS.Npc.Spawn2(199, npc.x + ModCS.Game.Random(-8, 8), npc.y, 0, 0, 1)
            end
        end

        -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or npc.tgt_mc
        -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
        -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
        -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
        for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
            local mychar = ModCS.Multiplayer.GetByID(i)
            if (mychar:IsPlaying()) then
                if (mychar.x < npc.x + 8 and mychar.x > npc.x - 8 and mychar.y < npc.y and mychar.y > npc.y - 96) then
                    mychar.ym = mychar.ym - 0.265625
                end
            end
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Fan (right)
ModCS.Npc.Act[98] = function(npc)
    local i = 1

    local rc = {
        ModCS.Rect.Create(272, 152, 288, 168),
        ModCS.Rect.Create(288, 152, 304, 168),
        ModCS.Rect.Create(304, 152, 320, 168),
    }

    if (npc.act_no == 0) then
        if (npc.direct == 2) then
            npc.act_no = 2
        else
            npc.act_no = 1
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end

        if npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120) then
            if (ModCS.Game.Random(0, 5) == 1) then
                ModCS.Npc.Spawn2(199, npc.x, npc.y + ModCS.Game.Random(-8, 8), 0, 0, 2)
            end
        end

        -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or npc.tgt_mc
        -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
        -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
        -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
        for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
            local mychar = ModCS.Multiplayer.GetByID(i)
            if (mychar:IsPlaying()) then
                if (mychar.y < npc.y + 8 and mychar.y > npc.y - 8 and mychar.x < npc.x + 96 and mychar.x > npc.x) then
                    mychar.xm = mychar.xm + 0.265625
                    mychar.SetCond(0x20)
                end
            end
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Fan (down)
ModCS.Npc.Act[99] = function(npc)
    local i = 1

    local rc = {
        ModCS.Rect.Create(272, 168, 288, 184),
        ModCS.Rect.Create(288, 168, 304, 184),
        ModCS.Rect.Create(304, 168, 320, 184),
    }

    if (npc.act_no == 0) then
        if (npc.direct == 2) then
            npc.act_no = 2
        else
            npc.act_no = 1
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end

        if npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120) then
            if (ModCS.Game.Random(0, 5) == 1) then
                ModCS.Npc.Spawn2(199, npc.x + ModCS.Game.Random(-8, 8), npc.y, 0, 0, 3)
            end
        end

        -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or npc.tgt_mc
        -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
        -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
        -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
        for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
            local mychar = ModCS.Multiplayer.GetByID(i)
            if (mychar:IsPlaying()) then
                if (mychar.x < npc.x + 8 and mychar.x > npc.x - 8 and mychar.y < npc.y + 96 and mychar.y > npc.y) then
                    mychar.ym = mychar.ym + 0.265625
                end
            end
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end