-- Demon crown (opening)
ModCS.Npc.Act[300] = function(npc)
    local rc = ModCS.Rect.Create(192, 80, 208, 96)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 6
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait % 8 == 1) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_TINY_PARTICLES, npc.x + ModCS.Game.Random(-8, 8), npc.y + 8, 1)
    end

    npc:SetRect(rc)
end

-- Fish missile (Misery)
ModCS.Npc.Act[301] = function(npc)
    local dir = 0

    local rect = {
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(192, 0, 208, 16),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
        ModCS.Rect.Create(192, 16, 208, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.count1 = npc.direct
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.xm = ModCS.Triangle.GetCos(npc.count1) * 2
        npc.ym = ModCS.Triangle.GetSin(npc.count1) * 2

        npc:Move()

        dir = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)

        if (dir < npc.count1) then
            if (npc.count1 - dir < 0x80) then
                npc.count1 = npc.count1 - npc.count1
            else
                npc.count1 = npc.count1 + npc.count1
            end
        else
            if (dir - npc.count1 < 0x80) then
                npc.count1 = npc.count1 + 1
            else
                npc.count1 = npc.count1 - 1
            end
        end

        if (npc.count1 > 0xFF) then
            npc.count1 = npc.count1 - 0x100
        end

        if (npc.count1 < 0) then
            npc.count1 = npc.count1 + 0x100
        end
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x, npc.y, 4)
    end

    npc.ani_no = (npc.count1 + 0x10) / 0x20
    if (npc.ani_no > 7) then
        npc.ani_no = 7
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Camera focus marker
ModCS.Npc.Act[302] = function(npc)
    local map_boss = ModCS.Boss.GetByBufferIndex(0, true)

    if (npc.act_no == 10) then
        npc.x = npc.tgt_mc.x
        npc.y = npc.tgt_mc.y - 32
    elseif (npc.act_no == 20) then
        if (npc.direct == 0) then
            npc.x = npc.x - 2
        elseif (npc.direct == 1) then
            npc.y = npc.y - 2
        elseif (npc.direct == 2) then
            npc.x = npc.x + 2
        elseif (npc.direct == 3) then
            npc.y = npc.y + 2
        end

        npc.tgt_mc.x = npc.x
        npc.tgt_mc.y = npc.y
    elseif (npc.act_no == 30) then
        npc.x = npc.tgt_mc.x
        npc.y = npc.tgt_mc.y + 80
    elseif (npc.act_no == 100) then
        npc.act_no = 101

        if (npc.direct ~= 0) then
            local foundNpc = ModCS.Npc.GetByEvent(npc.direct)
            if (foundNpc ~= nil) then
                npc.pNpc = foundNpc
            else
                npc.cond = 0
            end
        else
            npc.pNpc = map_boss
        end
        -- Fallthrough
    end
    
    if (npc.act_no == 101) then
        npc.x = (npc.tgt_mc.x + npc.pNpc.x) / 2
        npc.y = (npc.tgt_mc.y + npc.pNpc.y) / 2
    end
end

-- Curly's machine gun
ModCS.Npc.Act[303] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(216, 152, 232, 168),
        ModCS.Rect.Create(232, 152, 248, 168),
    }

    local rcRight = {
        ModCS.Rect.Create(216, 168, 232, 184),
        ModCS.Rect.Create(232, 168, 248, 184),
    }

    if (npc.pNpc == nil) then
        return
    end

    -- Set position
    if (npc.pNpc.direct == 0) then
        npc.direct = 0
        npc.x = npc.pNpc.x - 8
    else
        npc.direct = 2
        npc.x = npc.pNpc.x + 8
    end

    npc.y = npc.pNpc.y

    -- Animation
    npc.ani_no = 0
    if (npc.pNpc.ani_no == 3 or npc.pNpc.ani_no == 5) then
        npc.y = npc.y - 1
    end

    -- Set framerect
    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Gaudi in hospital
ModCS.Npc.Act[304] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 176, 24, 192),
        ModCS.Rect.Create(24, 176, 48, 192),
        ModCS.Rect.Create(48, 176, 72, 192),
        ModCS.Rect.Create(72, 176, 96, 192),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 10
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
    elseif (npc.act_no == 10) then
        npc.ani_no = 1
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.ani_no = 2
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 10) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Small puppy
ModCS.Npc.Act[305] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(160, 144, 176, 160),
        ModCS.Rect.Create(176, 144, 192, 160),
    }

    local rcRight = {
        ModCS.Rect.Create(160, 160, 176, 176),
        ModCS.Rect.Create(176, 160, 192, 176),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 16
        npc.ani_wait = ModCS.Game.Random(0, 6)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 6) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Balrog (nurse)
ModCS.Npc.Act[306] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(240, 96, 280, 128),
        ModCS.Rect.Create(280, 96, 320, 128),
    }

    local rcRight = {
        ModCS.Rect.Create(160, 152, 200, 184),
        ModCS.Rect.Create(200, 152, 240, 184),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.y = npc.y + 4
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Caged Santa
ModCS.Npc.Act[307] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
    }

    if (npc.act_no == 0) then
        npc.x = npc.x + 1
        npc.y = npc.y - 2
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 160) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 12) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    end

    if (npc.tgt_mc.x < npc.x) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Stumpy
ModCS.Npc.Act[308] = function(npc)
    local deg = 0

    local rcLeft = {
        ModCS.Rect.Create(128, 112, 144, 128),
        ModCS.Rect.Create(144, 112, 160, 128),
    }

    local rcRight = {
        ModCS.Rect.Create(128, 128, 144, 144),
        ModCS.Rect.Create(144, 128, 160, 144),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TriggerBox(240, 192, 240, 192)) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        npc.xm2 = 0
        npc.ym2 = 0

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 20
        end

        npc.ani_wait = npc.ani_wait + 1

        if (npc.act_wait > 1) then
            npc.ani_wait = 0

            if (npc.act_wait > 1) then
                npc.ani_wait = 0

                npc.ani_no = npc.ani_no + 1
                if (npc.ani_no > 1) then
                    npc.ani_no = 0
                end
            end

            if not npc:TriggerBox(320, 240, 320, 240) then
                npc.act_no = 0
            end
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0

        deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
        deg = deg + ModCS.Game.Random(-3, 3)
        npc.ym2 = ModCS.Triangle.GetSin(deg) * 2
        npc.xm2 = ModCS.Triangle.GetCos(deg) * 2

        if (npc.xm2 < 0) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        if (npc.xm2 < 0 and npc:TouchLeftWall()) then
            npc.direct = 2
            npc.xm2 = npc.xm2 * -1
        end

        if (npc.xm2 > 0 and npc:TouchRightWall()) then
            npc.direct = 0
            npc.xm2 = npc.xm2 * -1
        end

        if (npc.ym2 < 0 and npc:TouchCeiling()) then
            npc.ym2 = npc.ym2 * -1
        end

        if (npc.ym2 > 0 and npc:TouchFloor()) then
            npc.ym2 = npc.ym2 * -1
        end

        if (npc:TouchWater()) then
            npc.ym2 = -1
        end

        npc:Move2()

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 10
        end

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Bute
ModCS.Npc.Act[309] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.direct == 0) then
            if (npc.tgt_mc.x > npc.x - 288 and npc.tgt_mc.x < npc.x - 272) then
                npc.act_no = 10
            end
        else
            if (npc.tgt_mc.x < npc.x + 288 and npc.tgt_mc.x > npc.x + 272) then
                npc.act_no = 10
            end
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc:SetBit(5) -- Set shootable bit
        npc.damage = 5
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.direct == 0) then
            npc.xm2 = npc.xm2 - 0.03125
        else
            npc.xm2 = npc.xm2 + 0.03125
        end

        if (npc.y > npc.tgt_mc.y) then
            npc.ym2 = npc.ym2 - 0.03125
        else
            npc.ym2 = npc.ym2 + 0.03125
        end

        if (npc.xm2 < 0 and npc:TouchLeftWall()) then
            npc.xm2 = npc.xm2 * -1
        end

        if (npc.xm2 > 0 and npc:TouchRightWall()) then
            npc.xm2 = npc.xm2 * -1
        end

        if (npc.ym2 < 0 and npc:TouchCeiling()) then
            npc.ym2 = npc.ym2 * -1
        end

        if (npc.ym2 > 0 and npc:TouchFloor()) then
            npc.ym2 = npc.ym2 * -1
        end

        if (npc.xm2 < -2.998046875) then
            npc.xm2 = -2.998046875
        end

        if (npc.xm2 > 2.998046875) then
            npc.xm2 = 2.998046875
        end

        if (npc.ym2 < -2.998046875) then
            npc.ym2 = -2.998046875
        end

        if (npc.ym2 > 2.998046875) then
            npc.ym2 = 2.998046875
        end

        npc:Move2()

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    if (npc.act_no > 1) then
        if (npc.direct == 0) then
            npc:SetRect(rcLeft[npc.ani_no+1])
        else
            npc:SetRect(rcRight[npc.ani_no+1])
        end
    end

    if (npc.life <= 996) then
        npc.id = 316
        npc.act_no = 0
    end
end

-- Bute (with sword)
ModCS.Npc.Act[310] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(32, 0, 56, 16),
        ModCS.Rect.Create(56, 0, 80, 16),
        ModCS.Rect.Create(80, 0, 104, 16),
        ModCS.Rect.Create(104, 0, 128, 16),
        ModCS.Rect.Create(128, 0, 152, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(32, 16, 56, 32),
        ModCS.Rect.Create(56, 16, 80, 32),
        ModCS.Rect.Create(80, 16, 104, 32),
        ModCS.Rect.Create(104, 16, 128, 32),
        ModCS.Rect.Create(128, 16, 152, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc:UnsetBit(5) -- Unset shootable bit
        npc:SetBit(2) -- Set invulnerable bit
        npc.damage = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.ani_no = 0

        if (npc:TriggerBox(128, 128, 128, 16)) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.xm = 0
        npc.act_no = 11
        npc.act_wait = 0
        npc:UnsetBit(5) -- Unset shootable bit
        npc:SetBit(2) -- Set invulnerable bit
        npc.damage = 0
        npc.ani_no = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        npc:UnsetBit(2) -- Unset invulnerable bit
        npc:SetBit(5) -- Set shootable bit
        npc.damage = 0

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 10
        end

        if (npc.x < npc.tgt_mc.x + 40 and npc.x > npc.tgt_mc.x - 40) then
            npc.ym = -1.5
            npc.xm = npc.xm / 2
            npc.ani_no = 2
            npc.act_no = 30
            ModCS.Sound.Play(30)
        end
    elseif (npc.act_no == 30) then
        if (npc.ym > -0.25) then
            npc.act_no = 31
            npc.ani_wait = 0
            npc.ani_no = 3
            npc.damage = 9
        end
    elseif (npc.act_no == 31) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = 4
        end

        if (npc:TouchFloor()) then
            npc.act_no = 32
            npc.act_wait = 0
            npc.xm = 0
            npc.damage = 3
        end
    elseif (npc.act_no == 32) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 10
            npc.damage = 0
        end
    end

    npc.ym = npc.ym + 0.0625

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    if (npc.life <= 996) then
        npc.id = 316
        npc.act_no = 0
    end
end

-- Bute archer
ModCS.Npc.Act[311] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 32, 24, 56),
        ModCS.Rect.Create(24, 32, 48, 56),
        ModCS.Rect.Create(48, 32, 72, 56),
        ModCS.Rect.Create(72, 32, 96, 56),
        ModCS.Rect.Create(96, 32, 120, 56),
        ModCS.Rect.Create(120, 32, 144, 56),
        ModCS.Rect.Create(144, 32, 168, 56),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 56, 24, 80),
        ModCS.Rect.Create(24, 56, 48, 80),
        ModCS.Rect.Create(48, 56, 72, 80),
        ModCS.Rect.Create(72, 56, 96, 80),
        ModCS.Rect.Create(96, 56, 120, 80),
        ModCS.Rect.Create(120, 56, 144, 80),
        ModCS.Rect.Create(144, 56, 168, 80),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.direct == 0) then
            if (npc:TriggerBox(320, 160, 0, 160)) then
                npc.act_no = 10
            end
        else
            if (npc:TriggerBox(0, 160, 320, 160)) then
                npc.act_no = 10
            end
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.tgt_mc.x > npc.x - 224 and npc.tgt_mc.x < npc.x + 224 and npc.tgt_mc.y > npc.y - 8) then
            npc.ani_no = 1
            npc.count1 = 0
        else
            npc.ani_no = 4
            npc.count1 = 1
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        if (npc.count1 == 0) then
            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 2) then
                npc.ani_no = 1
            end
        else
            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 5) then
                npc.ani_no = 4
            end
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 30
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0

        if (npc.count1 == 0) then
            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(312, npc.x, npc.y, -3, 0, 0)
            else
                ModCS.Npc.Spawn2(312, npc.x, npc.y, 3, 0, 2)
            end

            npc.ani_no = 3
        else
            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(312, npc.x, npc.y, -3, -3, 0)
            else
                ModCS.Npc.Spawn2(312, npc.x, npc.y, 3, -3, 2)
            end

            npc.ani_no = 6
        end
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 40
            npc.act_wait = ModCS.Game.Random(0, 100)
        end
    elseif (npc.act_no == 40) then
        npc.ani_no = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 150) then
            npc.act_no = 10
        end

        if not (npc:TriggerBox(352, 240, 352, 240)) then
            npc.act_no = 40
            npc.act_wait = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    if (npc.life <= 992) then
        npc.id = 316
        npc.act_no = 0
    end
end

-- Bute arrow projectile
ModCS.Npc.Act[312] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 160, 16, 176),
        ModCS.Rect.Create(16, 160, 32, 176),
        ModCS.Rect.Create(32, 160, 48, 176),
        ModCS.Rect.Create(48, 160, 64, 176),
        ModCS.Rect.Create(64, 160, 80, 176),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 176, 16, 192),
        ModCS.Rect.Create(16, 176, 32, 192),
        ModCS.Rect.Create(32, 176, 48, 192),
        ModCS.Rect.Create(48, 176, 64, 192),
        ModCS.Rect.Create(64, 176, 80, 192),
    }

    if (npc.act_no > 0 and npc.act_no < 20 and npc:TouchTile()) then
        npc.act_no = 20
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = 0

        if (npc.xm < 0) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.ym < 0) then
            npc.ani_no = 0
        else
            npc.ani_no = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1

        if (npc.act_wait == 4) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        if (npc.act_wait > 10) then
            npc.act_no = 10
        end
    end

    if (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_wait = 0
        npc.xm = 3 * npc.xm / 4
        npc.ym = 3 * npc.ym / 4
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.ym = npc.ym + 0.0625

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 10) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 4
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        npc.xm = 0
        npc.ym = 0
        npc.damage = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 30
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.cond = 0
            return
        end
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    if (npc.act_no == 31) then
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc:SetRect(ModCS.Rect.Create(0, 0, 0, 0))
        end
    end
end

-- Ma Pignon
ModCS.Npc.Act[313] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(192, 0, 208, 16),
        ModCS.Rect.Create(208, 0, 224, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
        ModCS.Rect.Create(240, 0, 256, 16),
        ModCS.Rect.Create(256, 0, 272, 16),
        ModCS.Rect.Create(272, 0, 288, 16),
        ModCS.Rect.Create(288, 0, 304, 16),
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(304, 0, 320, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
        ModCS.Rect.Create(224, 16, 240, 32),
        ModCS.Rect.Create(240, 16, 256, 32),
        ModCS.Rect.Create(256, 16, 272, 32),
        ModCS.Rect.Create(272, 16, 288, 32),
        ModCS.Rect.Create(288, 16, 304, 32),
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
        ModCS.Rect.Create(304, 16, 320, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.y = npc.y + 4
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ym = npc.ym + 0.125

        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end

        if (npc.x - 32 < npc.tgt_mc.x and npc.x + 32 > npc.tgt_mc.x) then
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
    elseif (npc.act_no == 100) then
        npc.act_no = 110
        npc.act_wait = 0
        npc.count1 = 0
        npc:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (npc.act_no == 110) then
        npc.damage = 1

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.ani_no = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            npc.act_wait = 0
            npc.act_no = 120

            npc.count2 = npc.count2 + 1
            if (npc.count2 > 12) then
                npc.count2 = 0
                npc.act_no = 300
            end
        end
    elseif (npc.act_no == 120) then
        npc.ani_no = 2
        
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            npc.act_no = 130
            npc.ani_no = 3
            npc.xm = 2 * ModCS.Game.Random2(-1, 1)
            npc.ym = -4
            ModCS.Sound.Play(30)
            npc.count1 = npc.count1 + 1
        end
    elseif (npc.act_no == 130) then
        npc.ym = npc.ym + 0.25

        if (npc.y > 128) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.xm = npc.xm * -1
        end

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.xm = npc.xm * - 1
        end

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.ym < -1) then
            npc.ani_no = 3
        elseif (npc.ym > 1) then
            npc.ani_no = 4
        else
            npc.ani_no = 0
        end

        if (npc:TouchFloor()) then
            npc.act_no = 140
            npc.act_wait = 0
            npc.ani_no = 2
            npc.xm = 0
        end

        if (npc.count1 > 4 and npc.tgt_mc.y < npc.y + 4) then
            npc.act_no = 200
            npc.act_wait = 0
            npc.xm = 0
            npc.ym = 0
        end
    elseif (npc.act_no == 140) then
        npc.ani_no = 2

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            npc.act_no = 110
        end
    elseif (npc.act_no == 200) then
        npc.ani_no = 5

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 210
            npc.ani_no = 6

            if (npc.direct == 0) then
                npc.xm = -2.998046875
            else
                npc.xm = 2.998046875
            end

            ModCS.Sound.Play(25)
            npc:UnsetBit(5) -- Unset shootable bit
            npc:SetBit(2) -- Set invulnerable bit
            npc.damage = 10
        end
    elseif (npc.act_no == 210) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 7) then
            npc.ani_no = 6
        end

        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.act_no = 220
        end

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.act_no = 220
        end
    elseif (npc.act_no == 220) then
        npc.act_no = 221
        npc.act_wait = 0
        ModCS.Camera.SetQuake(16)
        ModCS.Sound.Play(26)
        npc.damage = 4
        -- Fallthrough
    end

    if (npc.act_no == 221) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 7) then
            npc.ani_no = 6
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 6 == 0) then
            ModCS.Npc.Spawn2(314, ModCS.Game.Random(4, 16) * 0x10, 0x10, 0, 0, 0)
        end

        if (npc.act_wait > 30) then
            npc.count1 = 0
            npc.act_no = 130
            npc:SetBit(5) -- Set shootable bit
            npc:UnsetBit(2) -- Unset invulnerable bit
            npc.damage = 3
        end
    elseif (npc.act_no == 300) then
        npc.act_no = 301
        npc.ani_no = 9

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 301) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 11) then
            npc.ani_no = 9
        end

        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end

        if (npc.tgt_mc.x > npc.x - 4 and npc.tgt_mc.x < npc.x + 4) then
            npc.act_no = 310
            npc.act_wait = 0
            npc.ani_no = 2
            npc.xm = 0
        end
    elseif (npc.act_no == 310) then
        npc.ani_no = 2

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            npc.act_no = 320
            npc.ani_no = 12
            npc.ym = -4
            ModCS.Sound.Play(25)
            npc:SetBit(3) -- Set ignore tile collision bit
            npc:UnsetBit(5) -- Unset shootable bit
            npc:SetBit(2) -- Set invulnerable bit
            npc.damage = 10
        end
    elseif (npc.act_no == 320) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 13) then
            npc.ani_no = 12
        end

        if (npc.y < 16) then
            npc.act_no = 330
        end
    elseif (npc.act_no == 330) then
        npc.ym = 0
        npc.act_no = 331
        npc.act_wait = 0
        ModCS.Camera.SetQuake(16)
        ModCS.Sound.Play(26)
        -- Fallthrough
    end

    if (npc.act_no == 331) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 13) then
            npc.ani_no = 12
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 6 == 0) then
            ModCS.Npc.Spawn2(315, ModCS.Game.Random(4, 16) * 0x10, 0, 0, 0, 0)
        end

        if (npc.act_wait > 30) then
            npc.count1 = 0
            npc.act_no = 130
            npc:SetBit(5) -- Set shootable bit
            npc:UnsetBit(2) -- Unset invulnerable bit
            npc.damage = 3
        end
    elseif (npc.act_no == 500) then
        npc:UnsetBit(5) -- Unset shootable bit
        npc.act_no = 501
        npc.act_wait = 0
        npc.ani_no = 9
        npc.tgt_x = npc.x
        npc.damage = 0
        ModCS.Npc.KillEveryID(315, true)
        -- Fallthrough
    end

    if (npc.act_no == 501) then
        npc.ym = npc.ym + 0.0625

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 2 == 1) then
            npc.x = npc.tgt_x
        else
            npc.x = npc.tgt_x + 1
        end
    end

    if npc.act_no > 100 and npc.act_no < 500 and npc.act_no ~= 210 and npc.act_no ~= 320 then
        local bullets = {13, 14, 15, 16, 17, 18, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33}
        local active = false

        for _, id in ipairs(bullets) do
            if ModCS.Bullet.IsActive(id) then
                active = true
                break
            end
        end

        if active then
            npc:UnsetBit(5)
            npc:SetBit(2)
        else
            npc:SetBit(5)
            npc:UnsetBit(2)
        end
    end

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

-- Ma Pignon rock
ModCS.Npc.Act[314] = function(npc)
    local rc = {
        ModCS.Rect.Create(64, 64, 80, 80),
        ModCS.Rect.Create(80, 64, 96, 80),
        ModCS.Rect.Create(96, 64, 112, 80),
    }

    if (npc.act_no == 0) then
        npc.count2 = 0
        npc.act_no = 100
        npc:SetBit(2) -- Set invulnerable bit
        npc.ani_no = ModCS.Game.Random(0, 2)
        -- Fallthrough
    end

    if (npc.act_no == 100) then
        npc.ym = npc.ym + 0.125

        if (npc.y > 128) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        if (npc:TouchFloor()) then
            local i = 0

            npc.ym = -1
            npc.act_no = 110
            npc:SetBit(3) -- Set ignore tile collision bit
            ModCS.Sound.Play(12)
            ModCS.Camera.SetQuake(10)

            for i = 0, 1 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + 16, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end
    elseif (npc.act_no == 110) then
        npc.ym = npc.ym + 0.125

        if (npc.y > (ModCS.Map.GetHeight() * 0x10) + (2 * 0x10)) then
            npc.cond = 0
            return
        end
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 6) then
        npc.ani_wait = npc.ani_wait + 1
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    if (npc.tgt_mc.y > npc.y) then
        npc.damage = 10
    else
        npc.damage = 0
    end

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ma Pignon clone
ModCS.Npc.Act[315] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(192, 0, 208, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
        ModCS.Rect.Create(192, 16, 208, 32),
    }

    if (npc.act_no == 0) then
        npc.ani_no = 3
        npc.ym = npc.ym + 0.25

        if (npc.y > 128) then
            npc.act_no = 130
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end
    elseif (npc.act_no == 100) then
        npc.act_no = 110
        npc.act_wait = 0
        npc.count1 = 0
        npc:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (npc.act_no == 110) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        
        npc.ani_no = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            npc.act_wait = 0
            npc.act_no = 120
        end
    elseif (npc.act_no == 120) then
        npc.ani_no = 1

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            npc.act_no = 130
            npc.ani_no = 3
            npc.xm = 2 * ModCS.Game.Random2(-1, 1)
            npc.ym = -4
            ModCS.Sound.Play(30)
        end
    elseif (npc.act_no == 130) then
        npc.ym = npc.ym + 0.25

        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.xm = npc.xm * -1
        end

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.xm = npc.xm * -1
        end

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.ym < -1) then
            npc.ani_no = 2
        elseif (npc.ym > 1) then
            npc.ani_no = 0
        else
            npc.ani_no = 3
        end

        if (npc:TouchFloor()) then
            npc.act_no = 140
            npc.act_wait = 0
            npc.ani_no = 1
            npc.xm = 0
        end
    elseif (npc.act_no == 140) then
        npc.ani_no = 1
        
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            npc.act_no = 110
            npc:SetBit(5) -- Set shootable bit
        end
    end

    if (npc.act_no > 100) then
        local bullets = {13, 14, 15, 16, 17, 18, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33}
        local active = false

        for _, id in ipairs(bullets) do
            if ModCS.Bullet.IsActive(id) then
                active = true
                break
            end
        end

        if active then
            npc:UnsetBit(5)
            npc:SetBit(2)
        else
            npc:SetBit(5)
            npc:UnsetBit(2)
        end
    end

    npc.count2 = npc.count2 + 1
    if (npc.count2 > 300) then
        npc:Vanish()
    else
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
end

-- Bute (dead)
ModCS.Npc.Act[316] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(248, 32, 272, 56),
        ModCS.Rect.Create(272, 32, 296, 56),
        ModCS.Rect.Create(296, 32, 320, 56),
    }

    local rcRight = {
        ModCS.Rect.Create(248, 56, 272, 80),
        ModCS.Rect.Create(272, 56, 296, 80),
        ModCS.Rect.Create(296, 56, 320, 80),
    }

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc:UnsetBit(5) -- Unset shootable bit
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        npc.damage = 0
        npc.act_no = 1
        npc.ani_no = 0
        view.front = 12
        view.back = 12
        view.top = 12
        npc.ym = -1

        if (npc.direct == 0) then
            npc.xm = 0.5
        else
            npc.xm = -0.5
        end

        ModCS.Sound.Play(50)
    elseif (npc.act_no == 1) then
        if (npc:TouchFloor()) then
            npc.ani_no = 1
            npc.ani_wait = 0
            npc.act_no = 2
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.xm = 8 * npc.xm / 9

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc:KillOnNextFrame()
        end
    end

    npc.ym = npc.ym + 0.0625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    npc:SetViewbox(view)
end

-- Mesa
ModCS.Npc.Act[317] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 80, 32, 120),
        ModCS.Rect.Create(32, 80, 64, 120),
        ModCS.Rect.Create(64, 80, 96, 120),
        ModCS.Rect.Create(96, 80, 128, 120),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 120, 32, 160),
        ModCS.Rect.Create(32, 120, 64, 160),
        ModCS.Rect.Create(64, 120, 96, 160),
        ModCS.Rect.Create(96, 120, 128, 160),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 8
        npc.tgt_x = npc.x
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.xm = 0
        npc.act_no = 2
        npc.ani_no = 0
        npc.count1 = 0
        -- Fallthrough
    end

    if (npc.act_no == 2) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 40) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.count1 = npc.count1 + 1
        if (npc:TriggerBox(320, 160, 320, 160) and npc.count1 > 50) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        npc.ani_no = 2
        ModCS.Npc.Spawn3(319, npc.x, npc.y, 0, 0, 0, npc)
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_wait = 0
            npc.act_no = 12
            npc.ani_no = 3
            ModCS.Sound.Play(39)
        end
    elseif (npc.act_no == 12) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 1
        end
    end

    npc.ym = npc.ym + 0.166015625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    if (npc.life <= 936) then
        npc.id = 318
        npc.act_no = 0
    end
end

-- Mesa (dead)
ModCS.Npc.Act[318] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(224, 80, 256, 120),
        ModCS.Rect.Create(256, 80, 288, 120),
        ModCS.Rect.Create(288, 80, 320, 120),
    }

    local rcRight = {
        ModCS.Rect.Create(224, 120, 256, 160),
        ModCS.Rect.Create(256, 120, 288, 160),
        ModCS.Rect.Create(288, 120, 320, 160),
    }

    if (npc.act_no == 0) then
        npc:UnsetBit(5) -- Unset shootable bit
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        npc:UnsetBit(0) -- Unset 'solid soft' bit
        npc.damage = 0
        npc.act_no = 1
        npc.ani_no = 0
        npc.ym = -1

        if (npc.direct == 0) then
            npc.xm = 0.125
        else
            npc.xm = -0.125
        end

        ModCS.Sound.Play(54)
    elseif (npc.act_no == 1) then
        if (npc:TouchFloor()) then
            npc.ani_no = 1
            npc.ani_wait = 0
            npc.act_no = 2
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.xm = 8 * npc.xm / 9

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc:KillOnNextFrame()
        end
    end

    npc.ym = npc.ym + 0.0625
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

-- Mesa block
ModCS.Npc.Act[319] = function(npc)
    local rc = {
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(96, 80, 112, 96),
    }

    if (npc.act_no == 0) then
        npc.y = npc.pNpc.y + 10

        if (npc.pNpc.direct == 0) then
            npc.x = npc.pNpc.x + 7
        else
            npc.x = npc.pNpc.x - 7
        end

        if (npc.pNpc.id == 318) then
            ModCS.Npc.Explode(npc.x, npc.y, 0, 3)
            npc.cond = 0
            return
        end

        if (npc.pNpc.ani_no ~= 2) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ym = -2
            npc.y = npc.pNpc.y - 4

            if (npc.pNpc.direct == 0) then
                npc.xm = -2
            else
                npc.xm = 2
            end
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 4) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        npc.ym = npc.ym + 0.08203125
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()

        if (npc:TouchFloor()) then
            ModCS.Sound.Play(12)
            ModCS.Npc.Explode(npc.x, npc.y, 0, 3)
            npc.cond = 0
        end
    end

    npc.ani_no = npc.ani_no + 1
    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    npc:SetRect(rc[npc.ani_no+1])
end