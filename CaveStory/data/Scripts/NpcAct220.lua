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

-- Gunfish

-- Gunfish projectile

-- Press (sideways)

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