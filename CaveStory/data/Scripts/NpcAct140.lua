-- Toroko (frenzied)
ModCS.Npc.Act[140] = function(npc)
    local i = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 32, 32),
        ModCS.Rect.Create(32, 0, 64, 32),
        ModCS.Rect.Create(64, 0, 96, 32),
        ModCS.Rect.Create(96, 0, 128, 32),
        ModCS.Rect.Create(128, 0, 160, 32),
        ModCS.Rect.Create(160, 0, 192, 32),
        ModCS.Rect.Create(192, 0, 224, 32),
        ModCS.Rect.Create(224, 0, 256, 32),
        ModCS.Rect.Create(0, 64, 32, 96),
        ModCS.Rect.Create(32, 64, 64, 96),
        ModCS.Rect.Create(64, 64, 96, 96),
        ModCS.Rect.Create(96, 64, 128, 96),
        ModCS.Rect.Create(128, 64, 160, 96),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 32, 32, 64),
        ModCS.Rect.Create(32, 32, 64, 64),
        ModCS.Rect.Create(64, 32, 96, 64),
        ModCS.Rect.Create(96, 32, 128, 64),
        ModCS.Rect.Create(128, 32, 160, 64),
        ModCS.Rect.Create(160, 32, 192, 64),
        ModCS.Rect.Create(192, 32, 224, 64),
        ModCS.Rect.Create(224, 32, 256, 64),
        ModCS.Rect.Create(0, 96, 32, 128),
        ModCS.Rect.Create(32, 96, 64, 128),
        ModCS.Rect.Create(64, 96, 96, 128),
        ModCS.Rect.Create(96, 96, 128, 128),
        ModCS.Rect.Create(128, 96, 160, 128),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 9
        npc.act_wait = 0
        npc:UnsetBit(13) -- Unset interactable bit
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 8
        end
    elseif (npc.act_no == 2) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 10) then
            npc.ani_no = 9
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 3
            npc.act_wait = 0
            npc.ani_no = 0
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 10
            npc:SetBit(5) -- Set shootable bit
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.act_wait = ModCS.Game.Random(20, 130)
        npc.xm = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then -- Idle, get ready to jump
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (ModCS.Arms.CountBullet(6) ~= 0 or ModCS.Arms.CountBullet(3) > 3) then -- If missiles on screen, or more than 3 fireballs, skip to jump act
            npc.act_no = 20
        end

        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            if ((ModCS.Game.Random(0, 99) % 2) ~= 0) then
                npc.act_no = 20
            else
                npc.act_no = 50
            end
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.ani_no = 2
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then -- Jump
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 22
            npc.act_wait = 0
            npc.ani_no = 3
            npc.ym = -2.998046875

            if (npc.direct == 0) then
                npc.xm = -1
            else
                npc.xm = 1
            end
        end
    elseif (npc.act_no == 22) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 23
            npc.act_wait = 0
            npc.ani_no = 6
            ModCS.Npc.Spawn3(141, 0, 0, 0, 0, 0, npc)
        end
    elseif (npc.act_no == 23) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 24
            npc.act_wait = 0
            npc.ani_no = 7
        end

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    elseif (npc.act_no == 24) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3) then
            npc.act_no = 25
            npc.ani_no = 3
        end
    elseif (npc.act_no == 25) then
        if (npc:TouchFloor()) then
            npc.act_no = 26
            npc.act_wait = 0
            npc.ani_no = 2
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(20)
        end
    elseif (npc.act_no == 26) then
        npc.xm = (npc.xm * 8) / 9

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 10
            npc.ani_no = 0
        end
    elseif (npc.act_no == 50) then -- Ground throw
        npc.act_no = 51
        npc.act_wait = 0
        npc.ani_no = 4
        ModCS.Npc.Spawn3(141, 0, 0, 0, 0, 0, npc)
        -- Fallthrough
    end

    if (npc.act_no == 51) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 52
            npc.act_wait = 0
            npc.ani_no = 5
        end

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    elseif (npc.act_no == 52) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3) then
            npc.act_no = 10
            npc.ani_no = 0
        end
    elseif (npc.act_no == 100) then
        npc.ani_no = 3
        npc.act_no = 101
        npc:UnsetBit(5) -- Unset shootable bit
        npc.damage = 0

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end
    elseif (npc.act_no == 101) then
        if (npc:TouchFloor()) then
            npc.act_no = 102
            npc.act_wait = 0
            npc.ani_no = 2
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(20)
        end
    elseif (npc.act_no == 102) then
        npc.xm = (npc.xm * 8) / 9

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 103
            npc.act_wait = 0
            npc.ani_no = 10
        end
    elseif (npc.act_no == 103) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.ani_no = 9
            npc.act_no = 104
            npc.act_wait = 0
        end
    elseif (npc.act_no == 104) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 10) then
            npc.ani_no = 9
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_wait = 0
            npc.ani_no = 9
            npc.act_no = 105
        end
    elseif (npc.act_no == 105) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_wait = 0
            npc.act_no = 106
            npc.ani_no = 11
        end
    elseif (npc.act_no == 106) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 50) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 12) then
            npc.ani_no = 12
        end
    elseif (npc.act_no == 140) then
        npc.act_no = 141
        npc.act_wait = 0
        npc.ani_no = 12
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 141) then -- Death
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 13) then
            npc.ani_no = 12
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end

            npc.cond = 0
        end
    end

    if (npc.act_no > 100 and npc.act_no < 105 and (npc.act_wait % 9) == 0) then
        ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
    end

    npc.ym = npc.ym + 0.0625

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    if (npc.ym < -2.998046875) then
        npc.ym = -2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Toroko block projectile
ModCS.Npc.Act[141] = function(npc)
    local i = 0
    local deg = 0

    local rect = {
        ModCS.Rect.Create(288, 32, 304, 48),
        ModCS.Rect.Create(304, 32, 320, 48),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.pNpc.direct == 0) then
            npc.x = npc.pNpc.x + 10
        else
            npc.x = npc.pNpc.x - 10
        end

        npc.y = npc.pNpc.y - 8

        if (npc.pNpc.act_no == 24 or npc.pNpc.act_no == 52) then
            npc.act_no = 10

            if (npc.pNpc.direct == 0) then
                npc.x = npc.pNpc.x - 16
            else
                npc.x = npc.pNpc.x + 16
            end

            npc.y = npc.pNpc.y

            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
            npc.ym = ModCS.Triangle.GetSin(deg) * 4
            npc.xm = ModCS.Triangle.GetCos(deg) * 4
            ModCS.Sound.Play(39)
        end
    elseif (npc.act_no == 10) then
        if (npc:TouchSurface()) then -- Hit wall, ceiling, or floor
            npc.act_no = 20
            npc.act_wait = 0
            ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
            ModCS.Sound.Play(12)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-1, 1), ModCS.Game.Random2(-1, 1), 0)
            end
        end

        npc:Move()
    elseif (npc.act_no == 20) then
        npc:Move()

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-1, 1), ModCS.Game.Random2(-1, 1), 0)
            end

            npc.id = 142 -- Change to flower cub npc
            npc.ani_no = 0
            npc.act_no = 20
            npc.xm = 0
            npc:UnsetBit(2) -- Unset invulnerable bit
            npc:SetBit(5) -- Set shootable bit
            npc.damage = 1
        end
    end

    npc.ani_no = npc.ani_no + 1
    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Flower Cub
ModCS.Npc.Act[142] = function(npc)
    local rect = {
        ModCS.Rect.Create(0, 128, 16, 144),
        ModCS.Rect.Create(16, 128, 32, 144),
        ModCS.Rect.Create(32, 128, 48, 144),
        ModCS.Rect.Create(48, 128, 64, 144),
        ModCS.Rect.Create(64, 128, 80, 144),
    }

    if (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 0
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 12
            npc.ani_no = 1
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 12) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 8) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no == 3) then
            npc.act_no = 20
            npc.ym = -1

            if (npc.tgt_mc.x < npc.x) then
                npc.xm = -1
            else
                npc.xm = 1
            end
        end
    elseif (npc.act_no == 20) then
        if (npc.ym > -0.25) then
            npc.ani_no = 4
        else
            npc.ani_no = 3
        end

        if (npc:TouchFloor()) then
            npc.ani_no = 2
            npc.act_no = 21
            npc.act_wait = 0
            npc.xm = 0
            ModCS.Sound.Play(23)
        end
    elseif (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 10
            npc.ani_no = 0
        end
    end

    npc.ym = npc.ym + 0.125

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    if (npc.ym < -2.998046875) then
        npc.ym = -2.998046875
    end

    npc:Move()

    npc:SetRect(rect[npc.ani_no+1])
end

-- Jenka (collapsed)
ModCS.Npc.Act[143] = function(npc)
    local rcLeft = ModCS.Rect.Create(208, 32, 224, 48)
    local rcRight = ModCS.Rect.Create(208, 48, 224, 64)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight)
    end
end

-- Toroko (teleporting in)
ModCS.Npc.Act[144] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 64, 16, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
        ModCS.Rect.Create(32, 64, 48, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
        ModCS.Rect.Create(128, 64, 144, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(128, 80, 144, 96),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.tgt_x = npc.x
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 64) then
            npc.act_no = 2
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end

        if (npc:TouchFloor()) then
            npc.act_no = 4
            npc.act_wait = 0
            npc.ani_no = 4
            ModCS.Sound.Play(23)
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 12
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 12) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 11
            npc.ani_no = 0
        end
    end

    if (npc.act_no > 1) then
        npc.ym = npc.ym + 0.0625

        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()
    end

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 1) then
        rect.bottom = rect.top + (npc.act_wait / 4)

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x
        else
            npc.x = npc.tgt_x + 1
        end
    end

    npc:SetRect(rect)
end

-- King's sword
ModCS.Npc.Act[145] = function(npc)
    local rcLeft = ModCS.Rect.Create(96, 32, 112, 48)
    local rcRight = ModCS.Rect.Create(112, 32, 128, 48)

    if (npc.act_no == 0) then
        if (npc.pNpc.count2 == 0) then
            if (npc.pNpc.direct == 0) then
                npc.direct = 0
            else
                npc.direct = 2
                end
            else
            if (npc.pNpc.direct == 0) then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end

        if (npc.direct == 0) then
            npc.x = npc.pNpc.x - 10
        else
            npc.x = npc.pNpc.x + 10
        end

        npc.y = npc.pNpc.y
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight)
    end
end

-- Lightning
ModCS.Npc.Act[146] = function(npc)
    local rect = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(256, 0, 272, 240),
        ModCS.Rect.Create(272, 0, 288, 240),
        ModCS.Rect.Create(288, 0, 304, 240),
        ModCS.Rect.Create(304, 0, 320, 240),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 2) then
            ModCS.Flash.Spawn()
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 2
            ModCS.Sound.Play(101)
        end
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no == 2) then
            npc.damage = 10
        end

        if (npc.ani_no > 4) then
            ModCS.Npc.Explode(npc.x, npc.y, 8, 8)
            npc.cond = 0
            return
        end
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Critter (purple)
ModCS.Npc.Act[147] = function(npc)
    local xm = 0
    local ym = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(16, 96, 32, 112),
        ModCS.Rect.Create(32, 96, 48, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
        ModCS.Rect.Create(64, 96, 80, 112),
        ModCS.Rect.Create(80, 96, 96, 112),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(16, 112, 32, 128),
        ModCS.Rect.Create(32, 112, 48, 128),
        ModCS.Rect.Create(48, 112, 64, 128),
        ModCS.Rect.Create(64, 112, 80, 128),
        ModCS.Rect.Create(80, 112, 96, 128),
    }

    if (npc.act_no == 0) then
        npc.y = npc.y + 3
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.act_wait >= 8 and npc:TriggerBox(96, 96, 96, 32)) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            npc.ani_no = 1
        else
            if (npc.act_wait < 8) then
                npc.act_wait = npc.act_wait + 1
            end

            npc.ani_no = 0
        end

        if (npc:IsHit()) then
            npc.act_no = 2
            npc.ani_no = 0
            npc.act_wait = 0
        end

        if (npc.act_wait >= 8 and npc:TriggerBox(48, 96, 48, 32)) then
            npc.act_no = 2
            npc.ani_no = 0
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 3
            npc.ani_no = 2
            npc.ym = -2.998046875
            ModCS.Sound.Play(30)

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 3) then
        if (npc.ym > 0.5) then
            npc.tgt_y = npc.y
            npc.act_no = 4
            npc.ani_no = 3
            npc.act_wait = 0
        end
    elseif (npc.act_no == 4) then
        local done = false
        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        npc.act_wait = npc.act_wait + 1

        if ((npc:TouchLeftWall() or npc:TouchRightWall() or npc:TouchCeiling()) or npc.act_wait > 60) then
            npc.damage = 3
            npc.act_no = 5
            npc.ani_no = 2
            done = true
        end

        if not done then
            if (npc.act_wait % 4 == 1) then
                ModCS.Sound.Play(109)
            end

            if (npc:TouchFloor()) then
                npc.ym = -1
            end

            -- Shoot projectile
            if (npc.act_wait % 30 == 6) then
                deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
                deg = deg + ModCS.Game.Random(-6, 6)
                ym = ModCS.Triangle.GetSin(deg) * 3
                xm = ModCS.Triangle.GetCos(deg) * 3

                ModCS.Npc.Spawn2(148, npc.x, npc.y, xm, ym, 0)
                ModCS.Sound.Play(39)
            end

            npc.ani_wait = npc.ani_wait + 1
            if (npc.ani_wait > 0) then
                npc.ani_wait = 0
                npc.ani_no = npc.ani_no + 1
            end

            if (npc.ani_no > 5) then
                npc.ani_no = 3
            end
        end
    elseif (npc.act_no == 5) then
        if (npc:TouchFloor()) then
            npc.damage = 2
            npc.xm = 0
            npc.act_wait = 0
            npc.ani_no = 0
            npc.act_no = 1
            ModCS.Sound.Play(23)
        end
    end

    if (npc.act_no ~= 4) then
        npc.ym = npc.ym + 0.0625
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end
    else
        if (npc.y > npc.tgt_y) then
            npc.ym = npc.ym - 0.03125
        else
            npc.ym = npc.ym + 0.03125
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        if (npc.xm > 1) then
            npc.xm = 1
        end

        if (npc.xm < -1) then
            npc.xm = -1
        end
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Purple Critter's projectile
ModCS.Npc.Act[148] = function(npc)
    if (npc:TouchTile()) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(96, 96, 104, 104),
        ModCS.Rect.Create(104, 96, 112, 104),
    }

    npc:SetRect(rect_left[npc.ani_no+1])

    npc.count1 = npc.count1 + 1
    if (npc.count1 > 300) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end
end

-- Moving block (horizontal)
ModCS.Npc.Act[149] = function(npc)
    local i = 0

    if (npc.act_no == 0) then
        npc.x = npc.x + 8
        npc.y = npc.y + 8

        if (npc.direct == 0) then
            npc.act_no = 10
        else
            npc.act_no = 20
        end

        npc.xm = 0
        npc.ym = 0

        npc:SetBit(6) -- Set solid (tile-like) bit
    elseif (npc.act_no == 10) then
        npc:UnsetBit(7) -- Unset "bottom and top not damaging player" bit
        npc.damage = 0
        if (npc.tgt_mc.x < npc.x + 25 and npc.tgt_mc.x > npc.x - (25 * 0x10) and npc.tgt_mc.y < npc.y + 25 and npc.tgt_mc.y > npc.y - 25) then
            npc.act_no = 11
            npc.act_wait = 0
        end
    elseif (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 10 == 6) then
            ModCS.Sound.Play(107)
        end

        if (npc:TouchLeftWall()) then
            npc.xm = 0
            npc.direct = 2
            npc.act_no = 20
            ModCS.Camera.SetQuake(10)
            ModCS.Sound.Play(26)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x - 16, npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end

        if (npc.tgt_mc:TouchLeftWall()) then
            npc:SetBit(7) -- Set "bottom and top not damaging player" bit
            npc.damage = 100
        else
            npc:UnsetBit(7) -- Unset "bottom and top not damaging player" bit
            npc.damage = 0
        end

        npc.xm = npc.xm - 0.0625
    elseif (npc.act_no == 20) then
        npc:UnsetBit(7) -- Unset "bottom and top not damaging player" bit
        npc.damage = 0

        if (npc.tgt_mc.x > npc.x - 25 and npc.tgt_mc.x < npc.x + (25 * 0x10) and npc.tgt_mc.y < npc.y + 25 and npc.tgt_mc.y > npc.y - 25) then
            npc.act_no = 21
            npc.act_wait = 0
        end
    elseif (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 10 == 6) then
            ModCS.Sound.Play(107)
        end

        if (npc:TouchRightWall()) then
            npc.xm = 0
            npc.direct = 0
            npc.act_no = 10
            ModCS.Camera.SetQuake(10)
            ModCS.Sound.Play(26)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + 16, npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end

        if (npc.tgt_mc.TouchRightWall()) then
            npc:SetBit(7) -- Set "bottom and top not damaging player" bit
            npc.damage = 100
        else
            npc:UnsetBit(7) -- Unset "bottom and top not damaging player" bit
            npc.damage = 0
        end

        npc.xm = npc.xm + 0.0625
    end

    if (npc.xm > 1) then
        npc.xm = 1
    end

    if (npc.xm < -1) then
        npc.xm = -1
    end

    npc:Move()

    local rect = ModCS.Rect.Create(16, 0, 48, 32)
    npc:SetRect(rect)
end

-- Quote
ModCS.Npc.Act[150] = function(npc)
    local i = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(48, 0, 64, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(32, 0, 48, 16),
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(112, 16, 128, 32),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0

        if (npc.direct > 10) then
            npc.x = npc.tgt_mc.x
            npc.y = npc.tgt_mc.y
            npc.direct = npc.direct - 10
        end
    elseif (npc.act_no == 2) then
        npc.ani_no = 1
    elseif (npc.act_no == 10) then
        npc.act_no = 11

        for i = 0, 3 do
            ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        ModCS.Sound.Play(71)
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.ani_no = 2
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 64
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait == 0) then
            npc.cond = 0
        end
    elseif (npc.act_no == 50) then
        npc.act_no = 51
        npc.ani_no = 3
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 51) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 6) then
            npc.ani_no = 3
        end

        if (npc.direct == 0) then
            npc.x = npc.x - 1
        else
            npc.x = npc.x + 1
        end
    elseif (npc.act_no == 60) then
        npc.act_no = 61
        npc.ani_no = 7
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        -- Fallthrough
    end

    if (npc.act_no == 61) then
        npc.tgt_y = npc.tgt_y + 0.5
        npc.x = npc.tgt_x + ModCS.Game.Random(-1, 1)
        npc.y = npc.tgt_y + ModCS.Game.Random(-1, 1)
    elseif (npc.act_no == 70) then
        npc.act_no = 71
        npc.act_wait = 0
        npc.ani_no = 3
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 71) then
        if (npc.direct == 0) then
            npc.x = npc.x + 0.5
        else
            npc.x = npc.x - 0.5
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 8) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 6) then
            npc.ani_no = 3
        end
    elseif (npc.act_no == 80) then
        npc.ani_no = 8
    elseif (npc.act_no == 99 or npc.act_no == 100) then
        npc.act_no = 101
        npc.ani_no = 3
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 101) then
        npc.ym = npc.ym + 0.125
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        if (npc:TouchFloor()) then
            npc.ym = 0
            npc.act_no = 102
        end

        npc:Move()
    elseif (npc.act_no == 102) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 8) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 6) then
            npc.ani_no = 3
        end
    end

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 21) then
        rect.bottom = rect.top + (npc.act_wait / 4)

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            rect.left = rect.left + 1
        end
    end

    -- Use a different sprite if the player is wearing the Mimiga Mask
    if (ModCS.Player.HasEquipped(ModCS.Const.EQUIP_MIMIGA_MASK)) then
        rect.top = rect.top + 32
        rect.bottom = rect.bottom + 32
    end

    npc:SetRect(rect)
end

-- Blue robot (standing)
ModCS.Npc.Act[151] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(192, 0, 208, 16),
        ModCS.Rect.Create(208, 0, 224, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 100) == 0) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 16) then
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

-- Shutter stuck
ModCS.Npc.Act[152] = function(npc)
    local rc = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        if (npc.direct == 2) then
            npc.y = npc.y + 16
        end

        npc.act_no = 1
    end

    npc:SetRect(rc)
end

-- Gaudi
ModCS.Npc.Act[153] = function(npc)
    local rcKitL = {
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(24, 0, 48, 24),
        ModCS.Rect.Create(48, 0, 72, 24),
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(72, 0, 96, 24),
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(96, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 144, 24),
        ModCS.Rect.Create(144, 0, 168, 24),
        ModCS.Rect.Create(168, 0, 192, 24),
        ModCS.Rect.Create(192, 0, 216, 24),
        ModCS.Rect.Create(216, 0, 240, 24),
        ModCS.Rect.Create(240, 0, 264, 24),
        ModCS.Rect.Create(264, 0, 288, 24),
        ModCS.Rect.Create(0, 48, 24, 72),
        ModCS.Rect.Create(24, 48, 48, 72),
        ModCS.Rect.Create(48, 48, 72, 72),
        ModCS.Rect.Create(72, 48, 96, 72),
        ModCS.Rect.Create(288, 0, 312, 24),
        ModCS.Rect.Create(24, 48, 48, 72),
        ModCS.Rect.Create(96, 48, 120, 72),
    }

    local rcKitR = {
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(24, 24, 48, 48),
        ModCS.Rect.Create(48, 24, 72, 48),
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(72, 24, 96, 48),
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(96, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 144, 48),
        ModCS.Rect.Create(144, 24, 168, 48),
        ModCS.Rect.Create(168, 24, 192, 48),
        ModCS.Rect.Create(192, 24, 216, 48),
        ModCS.Rect.Create(216, 24, 240, 48),
        ModCS.Rect.Create(240, 24, 264, 48),
        ModCS.Rect.Create(264, 24, 288, 48),
        ModCS.Rect.Create(0, 72, 24, 96),
        ModCS.Rect.Create(24, 72, 48, 96),
        ModCS.Rect.Create(48, 72, 72, 96),
        ModCS.Rect.Create(72, 72, 96, 96),
        ModCS.Rect.Create(288, 24, 312, 48),
        ModCS.Rect.Create(24, 72, 48, 96),
        ModCS.Rect.Create(96, 72, 120, 96),
    }

    if not (npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120)) then
        return
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.xm = 0
        npc.ani_no = 0
        npc.y = npc.y + 3
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 100) == 1) then
            npc.act_no = 2
            npc.ani_no = 1
            npc.act_wait = 0
        end

        if (ModCS.Game.Random(0, 100) == 1) then
            if (npc.direct == 0) then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end

        if (ModCS.Game.Random(0, 100) == 1) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = ModCS.Game.Random(25, 100)
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
    elseif (npc.act_no == 11) then
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

        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc.act_no = 1
            npc.ani_no = 0
            npc.xm = 0
        end

        if (npc.direct == 0 and npc:TouchLeftWall()) then
            npc.ani_no = 2
            npc.ym = -2.998046875
            npc.act_no = 20

            if not ModCS.Player.CheckCond(2) then
                ModCS.Sound.Play(30)
            end
        elseif (npc.direct == 2 and npc:TouchRightWall()) then
            npc.ani_no = 2
            npc.ym = -2.998046875
            npc.act_no = 20

            if not ModCS.Player.CheckCond(2) then
                ModCS.Sound.Play(30)
            end
        end
    elseif (npc.act_no == 20) then
        if (npc.direct == 0 and npc:TouchLeftWall()) then
            npc.count1 = npc.count1 + 1
        elseif (npc.direct == 2 and npc:TouchRightWall()) then
            npc.count1 = npc.count1 + 1
        else
            npc.count1 = 0
        end

        if (npc.count1 > 10) then
            if (npc.direct == 0) then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end

        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end

        if (npc:TouchFloor()) then
            npc.act_no = 21
            npc.ani_no = 20
            npc.act_wait = 0
            npc.xm = 0

            if not ModCS.Player.CheckCond(2) then
                ModCS.Sound.Play(23)
            end
        end
    elseif (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcKitL[npc.ani_no+1])
    else
        npc:SetRect(rcKitR[npc.ani_no+1])
    end

    -- Change to death gaudi if equal to or under 985 hp
    if (npc.life <= 985) then
        npc.id = 154
        npc.act_no = 0
    end
end

-- Gaudi (dead)
ModCS.Npc.Act[154] = function(npc)
    local rcKitL = {
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(24, 0, 48, 24),
        ModCS.Rect.Create(48, 0, 72, 24),
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(72, 0, 96, 24),
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(96, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 144, 24),
        ModCS.Rect.Create(144, 0, 168, 24),
        ModCS.Rect.Create(168, 0, 192, 24),
        ModCS.Rect.Create(192, 0, 216, 24),
        ModCS.Rect.Create(216, 0, 240, 24),
        ModCS.Rect.Create(240, 0, 264, 24),
        ModCS.Rect.Create(264, 0, 288, 24),
        ModCS.Rect.Create(0, 48, 24, 72),
        ModCS.Rect.Create(24, 48, 48, 72),
        ModCS.Rect.Create(48, 48, 72, 72),
        ModCS.Rect.Create(72, 48, 96, 72),
        ModCS.Rect.Create(288, 0, 312, 24),
        ModCS.Rect.Create(24, 48, 48, 72),
        ModCS.Rect.Create(96, 48, 120, 72),
    }

    local rcKitR = {
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(24, 24, 48, 48),
        ModCS.Rect.Create(48, 24, 72, 48),
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(72, 24, 96, 48),
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(96, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 144, 48),
        ModCS.Rect.Create(144, 24, 168, 48),
        ModCS.Rect.Create(168, 24, 192, 48),
        ModCS.Rect.Create(192, 24, 216, 48),
        ModCS.Rect.Create(216, 24, 240, 48),
        ModCS.Rect.Create(240, 24, 264, 48),
        ModCS.Rect.Create(264, 24, 288, 48),
        ModCS.Rect.Create(0, 72, 24, 96),
        ModCS.Rect.Create(24, 72, 48, 96),
        ModCS.Rect.Create(48, 72, 72, 96),
        ModCS.Rect.Create(72, 72, 96, 96),
        ModCS.Rect.Create(288, 24, 312, 48),
        ModCS.Rect.Create(24, 72, 48, 96),
        ModCS.Rect.Create(96, 72, 120, 96),
    }

    if (npc.act_no == 0) then
        npc:UnsetBit(5) -- Unset shootable bit
        npc:UnsetBit(3) -- Unset ignore collision bit
        npc.damage = 0
        npc.act_no = 1
        npc.ani_no = 9
        npc.ym = -1

        if (npc.direct == 0) then
            npc.xm = 0.5
        else
            npc.xm = -0.5
        end

        ModCS.Sound.Play(53)
    elseif (npc.act_no == 1) then
        if (npc:TouchFloor()) then
            npc.ani_no = 10
            npc.ani_wait = 0
            npc.act_no = 2
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.xm = (npc.xm * 8) / 9

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no +1
        end

        if (npc.ani_no > 11) then
            npc.ani_no = 10
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.cond = ModCS.Game.SetBit(npc.cond, 8)
        end
    end

    npc.ym = npc.ym + 0.0625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcKitL[npc.ani_no+1])
    else
        npc:SetRect(rcKitR[npc.ani_no+1])
    end
end

-- Gaudi (flying)
ModCS.Npc.Act[155] = function(npc)
    local rcKitL = {
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(24, 0, 48, 24),
        ModCS.Rect.Create(48, 0, 72, 24),
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(72, 0, 96, 24),
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(96, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 144, 24),
        ModCS.Rect.Create(144, 0, 168, 24),
        ModCS.Rect.Create(168, 0, 192, 24),
        ModCS.Rect.Create(192, 0, 216, 24),
        ModCS.Rect.Create(216, 0, 240, 24),
        ModCS.Rect.Create(240, 0, 264, 24),
        ModCS.Rect.Create(264, 0, 288, 24),
        ModCS.Rect.Create(0, 48, 24, 72),
        ModCS.Rect.Create(24, 48, 48, 72),
        ModCS.Rect.Create(48, 48, 72, 72),
        ModCS.Rect.Create(72, 48, 96, 72),
        ModCS.Rect.Create(288, 0, 312, 24),
        ModCS.Rect.Create(24, 48, 48, 72),
        ModCS.Rect.Create(96, 48, 120, 72),
    }

    local rcKitR = {
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(24, 24, 48, 48),
        ModCS.Rect.Create(48, 24, 72, 48),
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(72, 24, 96, 48),
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(96, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 144, 48),
        ModCS.Rect.Create(144, 24, 168, 48),
        ModCS.Rect.Create(168, 24, 192, 48),
        ModCS.Rect.Create(192, 24, 216, 48),
        ModCS.Rect.Create(216, 24, 240, 48),
        ModCS.Rect.Create(240, 24, 264, 48),
        ModCS.Rect.Create(264, 24, 288, 48),
        ModCS.Rect.Create(0, 72, 24, 96),
        ModCS.Rect.Create(24, 72, 48, 96),
        ModCS.Rect.Create(48, 72, 72, 96),
        ModCS.Rect.Create(72, 72, 96, 96),
        ModCS.Rect.Create(288, 24, 312, 48),
        ModCS.Rect.Create(24, 72, 48, 96),
        ModCS.Rect.Create(96, 72, 120, 96),
    }

    local deg = 0
    local xm = 0
    local ym = 0

    if not (npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120)) then
        return
    end

    if (npc.act_no == 0) then
        deg = ModCS.Game.Random(0, 0xFF)
        npc.xm = ModCS.Triangle.GetCos(deg)
        deg = deg + 0x40
        npc.tgt_x = npc.x + (ModCS.Triangle.GetCos(deg) * 8)

        deg = ModCS.Game.Random(0, 0xFF)
        npc.ym = ModCS.Triangle.GetSin(deg)
        deg = deg + 0x40
        npc.tgt_y = npc.y + (ModCS.Triangle.GetSin(deg) * 8)

        npc.act_no = 1
        npc.count1 = 120
        npc.act_wait = ModCS.Game.Random(70, 150)
        npc.ani_no = 14
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 15) then
            npc.ani_no = 14
        end

        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc.act_no = 2
            npc.ani_no = 18
        end
    elseif (npc.act_no == 2) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 19) then
            npc.ani_no = 18
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
            deg = deg + ModCS.Game.Random(-6, 6)
            ym = ModCS.Triangle.GetSin(deg) * 3
            xm = ModCS.Triangle.GetCos(deg) * 3
            ModCS.Npc.Spawn2(156, npc.x, npc.y, xm, ym, 0)

            if not ModCS.Player.CheckCond(2) then
                ModCS.Sound.Play(39)
            end

            npc.act_no = 1
            npc.act_wait = ModCS.Game.Random(70, 150)
            npc.ani_no = 14
            npc.ani_wait = 0
        end
    end

    if (npc.tgt_mc.x < npc.x) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    if (npc.tgt_x < npc.x) then
        npc.xm = npc.xm - 0.03125
    end

    if (npc.tgt_x > npc.x) then
        npc.xm = npc.xm + 0.03125
    end

    if (npc.tgt_y < npc.y) then
        npc.ym = npc.ym - 0.03125
    end

    if (npc.tgt_y > npc.y) then
        npc.ym = npc.ym + 0.03125
    end

    if (npc.xm > 1) then
        npc.xm = 1
    end

    if (npc.xm < -1) then
        npc.xm = -1
    end

    if (npc.ym > 1) then
        npc.ym = 1
    end

    if (npc.ym < -1) then
        npc.ym = -1
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcKitL[npc.ani_no+1])
    else
        npc:SetRect(rcKitR[npc.ani_no+1])
    end

    -- Change to death gaudi if equal to or under 985 hp
    if (npc.life <= 985) then
        npc.id = 154
        npc.act_no = 0
    end
end

-- Gaudi projectile
ModCS.Npc.Act[156] = function(npc)
    if (npc:TouchTile()) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(96, 112, 112, 128),
        ModCS.Rect.Create(112, 112, 128, 128),
        ModCS.Rect.Create(128, 112, 144, 128),
    }

    npc.ani_no = npc.ani_no + 1
    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    npc:SetRect(rect_left[npc.ani_no+1])

    npc.count1 = npc.count1 + 1
    if (npc.count1 > 300) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end
end

-- Moving block (vertical)
ModCS.Npc.Act[157] = function(npc)
    local i = 0

    if (npc.act_no == 0) then
        npc.x = npc.x + 8
        npc.y = npc.y + 8

        if (npc.direct == 0) then
            npc.act_no = 10
        else
            npc.act_no = 20
        end

        npc.xm = 0
        npc.ym = 0

        npc:SetBit(6) -- Set solid (tile-like) bit
    elseif (npc.act_no == 10) then
        npc:UnsetBit(7) -- Unset "bottom and top not damaging player" bit
        npc.damage = 0
        if (npc.tgt_mc.y < npc.y + 25 and npc.tgt_mc.y > npc.y - (25 * 0x10) and npc.tgt_mc.x < npc.x + 25 and npc.tgt_mc.x > npc.x - 25) then
            npc.act_no = 11
            npc.act_wait = 0
        end
    elseif (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 10 == 6) then
            ModCS.Sound.Play(107)
        end

        if (npc:TouchCeiling()) then
            npc.ym = 0
            npc.direct = 2
            npc.act_no = 20
            ModCS.Camera.SetQuake(10)
            ModCS.Sound.Play(26)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y - 16, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end

        if (npc.tgt_mc:TouchCeiling()) then
            npc:SetBit(7) -- Set "bottom and top not damaging player" bit
            npc.damage = 100
        else
            npc:UnsetBit(7) -- Unset "bottom and top not damaging player" bit
            npc.damage = 0
        end

        npc.ym = npc.ym - 0.0625
    elseif (npc.act_no == 20) then
        npc:UnsetBit(7) -- Unset "bottom and top not damaging player" bit
        npc.damage = 0

        if (npc.tgt_mc.y > npc.y - 25 and npc.tgt_mc.y < npc.y + (25 * 0x10) and npc.tgt_mc.x < npc.x + 25 and npc.tgt_mc.x > npc.x - 25) then
            npc.act_no = 21
            npc.act_wait = 0
        end
    elseif (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 10 == 6) then
            ModCS.Sound.Play(107)
        end

        if (npc:TouchFloor()) then
            npc.ym = 0
            npc.direct = 0
            npc.act_no = 10
            ModCS.Camera.SetQuake(10)
            ModCS.Sound.Play(26)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + 16, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end

        if (npc.tgt_mc.TouchFloor()) then
            npc:SetBit(7) -- Set "bottom and top not damaging player" bit
            npc.damage = 100
        else
            npc:UnsetBit(7) -- Unset "bottom and top not damaging player" bit
            npc.damage = 0
        end

        npc.ym = npc.ym + 0.0625
    end

    if (npc.ym > 1) then
        npc.ym = 1
    end

    if (npc.ym < -1) then
        npc.ym = -1
    end

    npc:Move()

    local rect = ModCS.Rect.Create(16, 0, 48, 32)
    npc:SetRect(rect)
end

-- Fish Missile
ModCS.Npc.Act[158] = function(npc)
    local dir = 0

    local rect = {
        ModCS.Rect.Create(0, 224, 16, 240),
        ModCS.Rect.Create(16, 224, 32, 240),
        ModCS.Rect.Create(32, 224, 48, 240),
        ModCS.Rect.Create(48, 224, 64, 240),
        ModCS.Rect.Create(64, 224, 80, 240),
        ModCS.Rect.Create(80, 224, 96, 240),
        ModCS.Rect.Create(96, 224, 112, 240),
        ModCS.Rect.Create(112, 224, 128, 240),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.count1 = 0xA0
        elseif (npc.direct == 1) then
            npc.count1 = 0xE0
        elseif (npc.direct == 2) then
            npc.count1 = 0x20
        elseif (npc.direct == 3) then
            npc.count1 = 0x60
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.xm = 2 * ModCS.Triangle.GetCos(npc.count1)
        npc.ym = 2 * ModCS.Triangle.GetSin(npc.count1)

        npc:Move()

        dir = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)

        if (dir < npc.count1) then
            if (npc.count1 - dir < 0x80) then
                npc.count1 = npc.count1 - 1
            else
                npc.count1 = npc.count1 + 1
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

-- Monster X (defeated)
ModCS.Npc.Act[159] = function(npc)
    local i = 0

    local rect = ModCS.Rect.Create(144, 128, 192, 200)

    if (npc.act_no == 0) then
        npc.act_no = 1

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-16, 16), npc.y + ModCS.Game.Random(-16, 16), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-0.666015625, 0.666015625), 0)
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 2
            npc.xm = -0.5
        end

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.x + 1
        else
            npc.x = npc.x - 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        npc.ym = npc.ym + 0.125
        if (npc.y > 40 * 0x10) then
            npc.cond = 0
        end
    end

    npc:Move()

    npc:SetRect(rect)

    if (npc.act_wait % 8 == 1) then
        ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-16, 16), npc.y + ModCS.Game.Random(-16, 16), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-0.666015625, 0.666015625), 0)
    end
end