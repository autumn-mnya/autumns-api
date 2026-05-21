-- Shovel Brigade
ModCS.Npc.Act[220] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 64, 16, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
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

-- Shovel Brigade (walking)
ModCS.Npc.Act[221] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 64, 16, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
        ModCS.Rect.Create(32, 64, 48, 80),
        ModCS.Rect.Create(0, 64, 16, 80),
        ModCS.Rect.Create(48, 64, 64, 80),
        ModCS.Rect.Create(0, 64, 16, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(48, 80, 64, 96),
        ModCS.Rect.Create(0, 80, 16, 96),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.xm = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 60) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end

        if (ModCS.Game.Random(0, 60) == 1) then
            npc.act_no = 10
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = ModCS.Game.Random(0, 16)
        npc.ani_no = 2
        npc.ani_wait = 0

        if (ModCS.Game.Random(0, 9) % 2 == 1) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.direct == 0 and npc:TouchLeftWall()) then
            npc.direct = 2
        elseif (npc.direct == 2 and npc:TouchRightWall()) then
            npc.direct = 0
        end

        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 32) then
            npc.act_no = 0
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

-- Prison bars
ModCS.Npc.Act[222] = function(npc)
    local rc = ModCS.Rect.Create(96, 168, 112, 200)

    if (npc.act_no == 0) then
        npc.act_no = npc.act_no + 1
        npc.y = npc.y - 8
    end

    npc:SetRect(rc)
end

-- Momorin
ModCS.Npc.Act[223] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(80, 192, 96, 216),
        ModCS.Rect.Create(96, 192, 112, 216),
        ModCS.Rect.Create(112, 192, 128, 216),
    }

    local rcRight = {
        ModCS.Rect.Create(80, 216, 96, 240),
        ModCS.Rect.Create(96, 216, 112, 240),
        ModCS.Rect.Create(112, 216, 128, 240),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 160) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.act_no = 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 12) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 3) then
        npc.ani_no = 2
    end

    if (npc.act_no < 2 and npc.tgt_mc.y < npc.y + 16 and npc.tgt_mc.y > npc.y - 16) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Chie
ModCS.Npc.Act[224] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(112, 32, 128, 48),
        ModCS.Rect.Create(128, 32, 144, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(128, 48, 144, 64),
    }

    if (npc.act_no == 0) then
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

    if (npc.act_no < 2 and npc.tgt_mc.y < npc.y + 16 and npc.tgt_mc.y > npc.y - 16) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Megane
ModCS.Npc.Act[225] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(64, 64, 80, 80),
        ModCS.Rect.Create(80, 64, 96, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(64, 80, 80, 96),
        ModCS.Rect.Create(80, 80, 96, 96),
    }

    if (npc.act_no == 0) then
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

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Kanpachi
ModCS.Npc.Act[226] = function(npc)
    local rcRight = {
        ModCS.Rect.Create(256, 56, 272, 80),
        ModCS.Rect.Create(272, 56, 288, 80),
        ModCS.Rect.Create(288, 56, 304, 80),
        ModCS.Rect.Create(256, 56, 272, 80),
        ModCS.Rect.Create(304, 56, 320, 80),
        ModCS.Rect.Create(256, 56, 272, 80),
        ModCS.Rect.Create(240, 56, 256, 80),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.xm = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 60) == 1) then
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
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.xm = 1

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end

        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 20) then
        npc.xm = 0
        npc.ani_no = 6
    end

    npc.ym = npc.ym + 0.0625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rcRight[npc.ani_no+1])
end

-- Bucket
ModCS.Npc.Act[227] = function(npc)
    local rc = ModCS.Rect.Create(208, 32, 224, 48)
    npc:SetRect(rc)
end

-- Droll (guard)
ModCS.Npc.Act[228] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 32, 40),
        ModCS.Rect.Create(32, 0, 64, 40),
        ModCS.Rect.Create(64, 0, 96, 40),
        ModCS.Rect.Create(96, 0, 128, 40),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 40, 32, 80),
        ModCS.Rect.Create(32, 40, 64, 80),
        ModCS.Rect.Create(64, 40, 96, 80),
        ModCS.Rect.Create(96, 40, 128, 80),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.xm = 0
        npc.act_no = 2
        npc.ani_no = 0
        -- Fallthrough
    end

    if (npc.act_no == 2) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 50) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 2
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 12
            npc.ani_no = 3
            npc.ym = -3

            if (npc.direct == 0) then
                npc.xm = -1
            else
                npc.xm = 1
            end
        end
    elseif (npc.act_no == 12) then
        if (npc:TouchFloor()) then
            npc.ani_no = 2
            npc.act_no = 13
            npc.act_wait = 0
        end
    elseif (npc.act_no == 13) then
        npc.xm = npc.xm / 2

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 1
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

-- Red Flowers (sprouts)
ModCS.Npc.Act[229] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 96, 48, 112),
        ModCS.Rect.Create(0, 112, 48, 128),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 16
    end

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
    else
        npc:SetRect(rc[2])
    end
end

-- Red Flowers (blooming)
ModCS.Npc.Act[230] = function(npc)
    local rc = {
        ModCS.Rect.Create(48, 96, 96, 128),
        ModCS.Rect.Create(96, 96, 144, 128),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.x = npc.x - 16
        npc.y = npc.y - 16
    end

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
    else
        npc:SetRect(rc[2])
    end
end

-- Rocket
ModCS.Npc.Act[231] = function(npc)
    local i = 0
    
    local rc = {
        ModCS.Rect.Create(176, 32, 208, 48),
        ModCS.Rect.Create(176, 48, 208, 64),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        npc.ym = npc.ym + 0.015625

        if (npc:TouchFloor()) then
            if (npc.act_wait < 10) then
                npc.act_no = 12
            else
                npc.act_no = 1
            end
        end
    elseif (npc.act_no == 12) then
        npc:UnsetBit(13) -- Unset interactable bit
        npc.act_no = 13
        npc.act_wait = 0
        npc.ani_no = 1
        for i = 0, 9 do
            ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-16, 16), npc.y + ModCS.Game.Random(-8, 8), 0, 0, 0)
            ModCS.Sound.Play(12)
        end
        -- Fallthrough
    end

    if (npc.act_no == 13) then
        npc.ym = npc.ym - 0.015625

        npc.act_wait = npc.act_wait + 1

        if (npc.act_wait % 2 == 0) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x - 10, npc.y + 8, 0)
        end

        if (npc.act_wait % 2 == 1) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x + 10, npc.y + 8, 0)
        end

        if (npc.act_wait % 4 == 1) then
            ModCS.Sound.Play(34)
        end

        if (npc:TouchCeiling() or npc.tgt_mc:TouchCeiling() or npc.act_wait > 450) then
            if (npc:TouchCeiling() or npc.tgt_mc:TouchCeiling()) then
                npc.ym = 0
            end

            npc.act_no = 15

            for i = 0, 5 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-16, 16), npc.y + ModCS.Game.Random(-8, 8), 0, 0, 0)
                ModCS.Sound.Play(12)
            end
        end
    elseif (npc.act_no == 15) then
        npc.ym = npc.ym + 0.015625
        npc.act_wait = npc.act_wait + 1

        if (npc.ym < 0) then
            if (act.act_wait % 8 == 0) then
                ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x - 10, npc.y + 8, 0)
            end

            if (npc.act_wait % 8 == 4) then
                ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x + 10, npc.y + 8, 0)
            end

            if (npc.act_wait % 16 == 1) then
                ModCS.Sound.Play(34)
            end
        end

        if (npc:TouchFloor()) then
            npc:SetBit(13) -- Set interactable bit
            npc.act_no = 1
            npc.ani_no = 0
        end
    end

    if (npc.ym < -2.998046875) then
        npc.ym = -2.998046875
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Orangebell
ModCS.Npc.Act[232] = function(npc)
    local i = 0

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.ym = 1

        for i = 0, 7 do
            ModCS.Npc.Spawn3(233, npc.x, npc.y, 0, 0, npc.direct, npc)
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.direct = 2
        end

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.direct = 0
        end

        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.015625
        else
            npc.ym = npc.ym - 0.015625
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end
    end

    npc:Move()

    local rcLeft = {
        ModCS.Rect.Create(128, 0, 160, 32),
        ModCS.Rect.Create(160, 0, 192, 32),
        ModCS.Rect.Create(192, 0, 224, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(128, 32, 160, 64),
        ModCS.Rect.Create(160, 32, 192, 64),
        ModCS.Rect.Create(192, 32, 224, 64),
    }

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Orangebell bat
ModCS.Npc.Act[233] = function(npc)
    local deg = 0

    if (npc.act_no == 0) then
        npc.act_no = 1

        deg = ModCS.Game.Random(0, 0xFF)
        npc.xm = ModCS.Triangle.GetCos(deg)
        deg = ModCS.Game.Random(0, 0xFF)
        npc.ym = ModCS.Triangle.GetSin(deg)

        npc.count1 = 120
        npc.count2 = ModCS.Game.Random(-0x20, 0x20)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        local done = false
        if (npc.pNpc ~= nil and npc.pNpc.id == 232) then
            npc.tgt_x = npc.pNpc.x
            npc.tgt_y = npc.pNpc.y
            npc.direct = npc.pNpc.direct
        end

        if (npc.tgt_x < npc.x) then
            npc.xm = npc.xm - 0.015625
        end

        if (npc.tgt_x > npc.x) then
            npc.xm = npc.xm + 0.015625
        end

        if (npc.tgt_y + npc.count2 < npc.y) then
            npc.ym = npc.ym - 0.0625
        end

        if (npc.tgt_y + npc.count2 > npc.y) then
            npc.ym = npc.ym + 0.0625
        end

        if (npc.xm > 2) then
            npc.xm = 2
        end

        if (npc.xm < -2) then
            npc.xm = -2
        end

        if (npc.ym > 2) then
            npc.ym = 2
        end

        if (npc.ym < -2) then
            npc.ym = -2
        end

        if (npc.count1 < 120) then
            npc.count1 = npc.count1 + 1
            done = true
        end

        if not done then
            if (npc:TriggerBox(8, 0, 8, 176)) then
                npc.xm = npc.xm / 4
                npc.ym = 0
                npc.act_no = 3
                npc:UnsetBit(3) -- Unset ignore tile collision bit
            end
        end
    elseif (npc.act_no == 3) then
        npc.ym = npc.ym + 0.125

        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        if (npc:TouchFloor()) then
            npc.ym = 0
            npc.xm = npc.xm * 2
            npc.count1 = 0
            npc.act_no = 1
            npc:SetBit(3) -- Set ignore tile collision bit
        end
    end

    npc:Move()

    local rcLeft = {
        ModCS.Rect.Create(256, 0, 272, 16),
        ModCS.Rect.Create(272, 0, 288, 16),
        ModCS.Rect.Create(288, 0, 304, 16),
        ModCS.Rect.Create(304, 0, 320, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(256, 16, 272, 32),
        ModCS.Rect.Create(272, 16, 288, 32),
        ModCS.Rect.Create(288, 16, 304, 32),
        ModCS.Rect.Create(304, 16, 320, 32),
    }

    if (npc.act_no == 3) then
        npc.ani_no = 3
    else
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Red Flowers (picked)
ModCS.Npc.Act[234] = function(npc)
    local rc = {
        ModCS.Rect.Create(144, 96, 192, 112),
        ModCS.Rect.Create(144, 112, 192, 128),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 16
    end

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
    else
        npc:SetRect(rc[2])
    end
end

-- Midorin
ModCS.Npc.Act[235] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(192, 96, 208, 112),
        ModCS.Rect.Create(208, 96, 224, 112),
        ModCS.Rect.Create(224, 96, 240, 112),
        ModCS.Rect.Create(192, 96, 208, 112),
    }

    local rcRight = {
        ModCS.Rect.Create(192, 112, 208, 128),
        ModCS.Rect.Create(208, 112, 224, 128),
        ModCS.Rect.Create(224, 112, 240, 128),
        ModCS.Rect.Create(192, 112, 208, 128),
    }

    local hit = npc:GetHitbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.xm = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 30) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end

        if (ModCS.Game.Random(0, 30) == 1) then
            npc.act_no = 10
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = ModCS.Game.Random(0, 16)
        npc.ani_no = 2
        npc.ani_wait = 0

        if (ModCS.Game.Random(0, 9) % 2) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.direct == 0 and npc:TouchLeftWall()) then
            npc.direct = 2
        elseif (npc.direct == 2 and npc:TouchRightWall()) then
            npc.direct = 0
        end

        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 64) then
            npc.act_no = 0
        end
    end

    npc.ym = npc.ym + 0.0625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.ani_no == 2) then
        hit.top = 5
    else
        hit.top = 4
    end

    npc:SetHitbox(hit)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Gunfish
ModCS.Npc.Act[236] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(128, 64, 152, 88),
        ModCS.Rect.Create(152, 64, 176, 88),
        ModCS.Rect.Create(176, 64, 200, 88),
        ModCS.Rect.Create(200, 64, 224, 88),
        ModCS.Rect.Create(224, 64, 248, 88),
        ModCS.Rect.Create(248, 64, 272, 88),
    }

    local rcRight = {
        ModCS.Rect.Create(128, 88, 152, 112),
        ModCS.Rect.Create(152, 88, 176, 112),
        ModCS.Rect.Create(176, 88, 200, 112),
        ModCS.Rect.Create(200, 88, 224, 112),
        ModCS.Rect.Create(224, 88, 248, 112),
        ModCS.Rect.Create(248, 88, 272, 112),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = ModCS.Game.Random(0, 50)
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.ym = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc.ym = 1
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then
        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        if (npc:TriggerBox(128, 160, 128, 32)) then
            npc.act_wait = npc.act_wait + 1
        end

        if (npc.act_wait > 80) then
            npc.act_no = 10
            npc.act_wait = 0
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_wait = 0
            npc.act_no = 20
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end
    elseif (npc.act_no == 20) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 60) then
            npc.act_wait = 0
            npc.act_no = 2
        end

        if (npc.act_wait % 10 == 3) then
            ModCS.Sound.Play(39)

            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(237, npc.x - 8, npc.y - 8, -2, -2, 0)
            else
                ModCS.Npc.Spawn2(237, npc.x + 8, npc.y - 8, 2, -2, 0)
            end
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 4
        end
    end

    if (npc.y < npc.tgt_y) then
        npc.ym = npc.ym + 0.03125
    else
        npc.ym = npc.ym - 0.03125
    end

    if (npc.ym > 0.5) then
        npc.ym = 0.5
    end

    if (npc.ym < -0.5) then
        npc.ym = -0.5
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Gunfish projectile
ModCS.Npc.Act[237] = function(npc)
    local rc = ModCS.Rect.Create(312, 32, 320, 40)

    local i = 0
    local bHit = false

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        bHit = false

        npc.act_wait = npc.act_wait + 1

        if (npc:TouchTile()) then
            bHit = true
        end

        if (npc.act_wait > 10 and npc:TouchWater()) then
            bHit = true
        end

        if (bHit) then
            for i = 0, 4 do
                ModCS.Caret.Spawn(ModCS.Const.CARET_BUBBLE, npc.x, npc.y, 0)
            end

            ModCS.Sound.Play(21)
            npc.cond = 0
            return
        end
    end

    npc.ym = npc.ym + 0.0625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rc)
end

-- Press (sideways)
ModCS.Npc.Act[238] = function(npc)
    local i = 0

    local rc = {
        ModCS.Rect.Create(184, 200, 208, 216),
        ModCS.Rect.Create(208, 200, 232, 216),
        ModCS.Rect.Create(232, 200, 256, 216),
    }

    local hit = npc:GetHitbox()
    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        view.front = 16
        view.back = 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.direct == 0 and npc:TriggerBox(192, 4, 0, 8)) then
            npc.act_no = 10
            npc.act_wait = 0
            npc.ani_no = 2
        end

        if (npc.direct == 2 and npc:TriggerBox(0, 4, 192, 8)) then
            npc.act_no = 10
            npc.act_wait = 0
            npc.ani_no = 2
        end
    elseif (npc.act_no == 10) then
        npc.damage = 0x7F

        if (npc.direct == 0) then
            npc.x = npc.x - 6
        else
            npc.x = npc.x + 6
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 8) then
            npc.act_no = 20
            npc.act_wait = 0

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-16, 16), npc.y + ModCS.Game.Random(-8, 8), 0, 0, 0)
                ModCS.Sound.Play(12)
            end
        end
    elseif (npc.act_no == 20) then
        npc.damage = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_wait = 0
            npc.act_no = 30
        end
    elseif (npc.act_no == 30) then
        npc.damage = 0
        npc.ani_no = 1

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 12) then
            npc.act_no = 1
            npc.act_wait = 0
            npc.ani_no = 0
        end

        if (npc.direct == 0) then
            npc.x = npc.x + 4
        else
            npc.x = npc.x - 4
        end
    end

    if (npc.direct == 0 and npc.tgt_mc.x < npc.x) then
        hit.back = 16
    elseif (npc.direct == 2 and npc.tgt_mc.x > npc.x) then
        hit.back = 16
    else
        hit.back = 8
    end

    npc:SetViewbox(view)
    npc:SetHitbox(hit)
    npc:SetRect(rc[npc.ani_no+1])
end

-- Cage bars
ModCS.Npc.Act[239] = function(npc)
    local rcLeft = ModCS.Rect.Create(192, 48, 256, 80)
    local rcRight = ModCS.Rect.Create(96, 112, 144, 144)
    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        
        if (npc.direct == 0) then
            npc.x = npc.x + 8
            npc.y = npc.y + 16
        else
            view.front = 24
            view.back = 24
            view.top = 8
            view.back = 24
        end
    end

    npc:SetViewbox(view)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight)
    end
end