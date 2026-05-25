-- Mimiga (jailed)
ModCS.Npc.Act[240] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(160, 64, 176, 80),
        ModCS.Rect.Create(176, 64, 192, 80),
        ModCS.Rect.Create(192, 64, 208, 80),
        ModCS.Rect.Create(160, 64, 176, 80),
        ModCS.Rect.Create(208, 64, 224, 80),
        ModCS.Rect.Create(160, 64, 176, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(160, 80, 176, 96),
        ModCS.Rect.Create(176, 80, 192, 96),
        ModCS.Rect.Create(192, 80, 208, 96),
        ModCS.Rect.Create(160, 80, 176, 96),
        ModCS.Rect.Create(208, 80, 224, 96),
        ModCS.Rect.Create(160, 80, 176, 96),
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

-- Critter (Last Cave)
ModCS.Npc.Act[241] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(32, 0, 48, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
    }

    if (npc.act_no == 0) then
        npc.y = npc.y + 3
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.act_wait >= 8 and npc:TriggerBox(144, 80, 144, 80)) then
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

        if (npc.act_wait >= 8 and npc:TriggerBox(96, 80, 96, 96)) then
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

            if (npc.direct == 0) then
                npc.xm = -1
            else
                npc.xm = 1
            end
        end
    elseif (npc.act_no == 3) then
        if (npc:TouchFloor()) then
            npc.xm = 0
            npc.act_wait = 0
            npc.ani_no = 0
            npc.act_no = 1
            ModCS.Sound.Play(23)
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
end

-- Bat (Last Cave)
ModCS.Npc.Act[242] = function(npc)
    if (npc.x < 0 or npc.x > ModCS.Map.GetWidth() * 0x10) then
        npc:Vanish()
        return
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.act_wait = ModCS.Game.Random(0, 50)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        local done = false
        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
            done = true
        end

        if not done then
            npc.act_no = 2
            npc.ym = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 2) then
        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end

        if (npc.tgt_y < npc.y) then
            npc.ym = npc.ym - 0.03125
        end

        if (npc.tgt_y > npc.y) then
            npc.ym = npc.ym + 0.03125
        end

        if (npc.ym > 1.5) then
            npc.ym = 1.5
        end

        if (npc.ym < -1.5) then
            npc.ym = -1.5
        end
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(32, 32, 48, 48),
        ModCS.Rect.Create(48, 32, 64, 48),
        ModCS.Rect.Create(64, 32, 80, 48),
        ModCS.Rect.Create(80, 32, 96, 48),
    }

    local rect_right = {
        ModCS.Rect.Create(32, 48, 48, 64),
        ModCS.Rect.Create(48, 48, 64, 64),
        ModCS.Rect.Create(64, 48, 80, 64),
        ModCS.Rect.Create(80, 48, 96, 64),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Bat generator (Last Cave)
ModCS.Npc.Act[243] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = ModCS.Game.Random(0, 500)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc.act_no = 0
            ModCS.Npc.Spawn2(242, npc.x, npc.y + ModCS.Game.Random(-0x20, 0x20), 0, 0, npc.direct)
        end
    end
end

-- Lava drop
ModCS.Npc.Act[244] = function(npc)
    local rc = ModCS.Rect.Create(96, 0, 104, 16)
    local bHit = false

    npc.ym = npc.ym + 0.125

    if (npc:TouchTile()) then
        bHit = true
    end

    if (npc.act_wait > 10 and npc:TouchWater()) then
        bHit = true
    end

    if (bHit) then
        for i = 0, 2 do
            ModCS.Caret.Spawn(ModCS.Const.CARET_BUBBLE, npc.x, npc.y + 4, 2)
        end

        if (npc:TriggerBox(256, 160, 256, 160)) then
            ModCS.Sound.Play(21)
        end

        npc.cond = 0
    else
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()

        npc:SetRect(rc)
    end
end

-- Lava drop generator
ModCS.Npc.Act[245] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(104, 0, 112, 16),
        ModCS.Rect.Create(112, 0, 120, 16),
        ModCS.Rect.Create(120, 0, 128, 16),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.act_wait = npc.event
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0

        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
            return
        end

        npc.act_no = 10
        npc.ani_wait = 0
    elseif (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 10) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 0
            npc.act_no = 1
            npc.act_wait = npc.flag
            ModCS.Npc.Spawn2(244, npc.x, npc.y, 0, 0, 0)
        end
    end

    if (math.floor(npc.ani_wait / 2) % 2 == 1) then
        npc.x = npc.tgt_x
    else
        npc.x = npc.tgt_x + 1
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Press (proximity)
ModCS.Npc.Act[246] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(144, 112, 160, 136),
        ModCS.Rect.Create(160, 112, 176, 136),
        ModCS.Rect.Create(176, 112, 196, 136),
    }

    local i = 0

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 4
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TriggerBox(8, 8, 8, 128)) then
            npc.act_no = 5
        end
    elseif (npc.act_no == 5) then
        if not npc:TouchFloor() then
            npc.act_no = 10
            npc.ani_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 2
        end

        if (npc.tgt_mc.y > npc.y) then
            npc:UnsetBit(6) -- Unset npc solid bit
            npc.damage = 0x7F
        else
            npc:SetBit(6) -- Set npc solid bit
            npc.damage = 0
        end

        if (npc:TouchFloor()) then
            if (npc.ani_no > 1) then
                for i = 0, 7 do
                    ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
                end

                ModCS.Sound.Play(26)
                ModCS.Camera.SetQuake(10)
            end

            npc.act_no = 20
            npc.ani_no = 0
            npc.ani_wait = 0
            npc:SetBit(6) -- Set npc solid bit
            npc.damage = 0
        end
    end

    if (npc.act_no >= 5) then
        npc.ym = npc.ym + 0.25
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()
    end

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Misery (boss)
ModCS.Npc.Act[247] = function(npc)
    local deg = 0
    local xm = 0
    local ym = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(32, 0, 48, 16),
        ModCS.Rect.Create(48, 0, 64, 16),
        ModCS.Rect.Create(64, 0, 80, 16),
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(96, 0, 112, 16),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(112, 0, 128, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(64, 16, 80, 32),
        ModCS.Rect.Create(80, 16, 96, 32),
        ModCS.Rect.Create(96, 16, 112, 32),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(112, 16, 128, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 6
        npc.tgt_y = 64
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
    elseif (npc.act_no == 20) then
        npc.xm = 0
        npc.ym = npc.ym + 0.125
        
        if (npc:TouchFloor()) then
            npc.act_no = 21
            npc.ani_no = 2
        end
    elseif (npc.act_no == 21) then
        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 22
            npc.act_wait = 0
            npc.ani_no = 3
        end
    elseif (npc.act_no == 22) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 21
            npc.ani_no = 2
        end
    elseif (npc.act_no == 100) then
        npc.act_no = 101
        npc.act_wait = 0
        npc.ani_no = 0
        npc.xm = 0
        npc:SetBit(5) -- Set shootable bit
        npc.count2 = npc.life
        -- Fallthrough
    end

    if (npc.act_no == 101) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.0625
        else
            npc.ym = npc.ym - 0.0625
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 200 or npc.life <= npc.count2 - 80) then
            npc.act_wait = 0
            npc.act_no = 110
        end
    elseif (npc.act_no == 110) then
        npc.act_no = 111
        npc.act_wait = 0
        npc.xm = 0
        npc.ym = 0
        npc:UnsetBit(5) -- Unset shootable bit
        -- Fallthrough
    end

    if (npc.act_no == 111) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 2 == 1) then
            npc.ani_no = 5
        else
            npc.ani_no = 6
        end

        if (npc.act_wait > 30) then
            npc.act_wait = 0

            npc.count1 = npc.count1 + 1
            if (npc.count1 % 3 == 0) then
                npc.act_no = 113
            else
                npc.act_no = 112
            end

            npc.ani_no = 4
        end
    elseif (npc.act_no == 112) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 6 == 0) then
            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
            deg = deg + ModCS.Game.Random(-4, 4)
            ym = ModCS.Triangle.GetSin(deg) * 4
            xm = ModCS.Triangle.GetCos(deg) * 4

            ModCS.Npc.Spawn2(248, npc.x, npc.y + 4, xm, ym, 0)
            ModCS.Sound.Play(34)
        end

        if (npc.act_wait > 30) then
            npc.act_wait = 0
            npc.act_no = 150
        end
    elseif (npc.act_no == 113) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 10) then
            ym = npc.tgt_mc.y - 64
            ModCS.Npc.Spawn2(279, npc.tgt_mc.x, ym, 0, 0, 1)
        end

        if (npc.act_wait > 30) then
            npc.act_wait = 0
            npc.act_no = 150
        end
    elseif (npc.act_no == 150) then
        npc.act_no = 151
        npc.act_wait = 0
        npc.ani_no = 7

        ModCS.Npc.Spawn2(249, npc.x, npc.y, 0, 0, 0)
        ModCS.Npc.Spawn2(249, npc.x, npc.y, 0, 0, 2)

        npc.tgt_x = ModCS.Game.Random(9, 31) * 0x10
        npc.tgt_y = ModCS.Game.Random(5, 7) * 0x10

        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 151) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 42) then
            ModCS.Npc.Spawn2(249, npc.tgt_x + 16, npc.tgt_y, 0, 0, 0)
            ModCS.Npc.Spawn2(249, npc.tgt_x - 16, npc.tgt_y, 0, 0, 2)
        end

        if (npc.act_wait > 50) then
            npc.act_wait = 0
            npc.ym = -1
            npc:SetBit(5) -- Set shootable bit
            npc.x = npc.tgt_x
            npc.y = npc.tgt_y

            if (npc.life < 340) then
                ModCS.Npc.Spawn3(252, 0, 0, 0, 0, 0, npc)
                ModCS.Npc.Spawn3(252, 0, 0, 0, 0, 0x80, npc)
            end

            if (npc.life < 180) then
                ModCS.Npc.Spawn3(252, 0, 0, 0, 0, 0x40, npc)
                ModCS.Npc.Spawn3(252, 0, 0, 0, 0, 0xC0, npc)
            end

            if (npc.tgt_mc.x < npc.x - 112 or npc.tgt_mc.x > npc.x + 112) then
                npc.act_no = 160
            else
                npc.act_no = 100
            end
        end
    elseif (npc.act_no == 160) then
        npc.act_no = 161
        npc.act_wait = 0
        npc.ani_no = 4

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 161) then
        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.0625
        else
            npc.ym = npc.ym - 0.0625
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 24 == 0) then
            ModCS.Npc.Spawn2(250, npc.x, npc.y + 4, 0, 0, 0)
            ModCS.Sound.Play(34)
        end

        if (npc.act_wait > 72) then
            npc.act_wait = 0
            npc.act_no = 100
        end
    elseif (npc.act_no == 1000) then
        npc:UnsetBit(5) -- Unset shootable bit
        npc.act_no = 1001
        npc.act_wait = 0
        npc.ani_no = 4
        
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y

        npc.xm = 0
        npc.ym = 0

        ModCS.Npc.KillEveryID(252, true)
        
        ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
        ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
        ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
        -- Fallthrough
    end

    if (npc.act_no == 1001) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x + 1
        else
            npc.x = npc.tgt_x
        end
    elseif (npc.act_no == 1010) then
        npc.ym = npc.ym + 0.03125

        if (npc:TouchFloor()) then
            npc.act_no = 1020
            npc.ani_no = 8
        end
    end

    if (npc.xm < -1) then
        npc.xm = -1
    end

    if (npc.xm > 1) then
        npc.ym = 1
    end

    if (npc.ym < -2) then
        npc.ym = -2
    end

    if (npc.ym > 2) then
        npc.ym = 2
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Boss Misery (vanishing)
ModCS.Npc.Act[248] = function(npc)
    if (npc:TouchTile()) then
        npc.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
        ModCS.Rect.Create(32, 48, 48, 64),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end
    end

    npc:SetRect(rect_left[npc.ani_no+1])

    npc.count1 = npc.count1 + 1
    if (npc.count1 > 300) then
        npc.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end
end

-- Boss Misery energy shot
ModCS.Npc.Act[249] = function(npc)
    local rc = {
        ModCS.Rect.Create(48, 48, 64, 64),
        ModCS.Rect.Create(64, 48, 80, 64),
    }

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 8) then
        npc.cond = 0
    end

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
        npc.x = npc.x - 2
    else
        npc:SetRect(rc[2])
        npc.x = npc.x + 2
    end
end

-- Boss Misery lightning ball
ModCS.Npc.Act[250] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
        ModCS.Rect.Create(32, 32, 48, 48),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_y = npc.y
        npc.xm = 0
        npc.ym = -1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.x < npc.tgt_mc.x) then
            npc.xm = npc.xm + 0.03125
        else
            npc.xm = npc.xm - 0.03125
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.0625
        else
            npc.ym = npc.ym - 0.0625
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

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc.tgt_mc.x > npc.x - 8 and npc.tgt_mc.x < npc.x + 8 and npc.tgt_mc.y > npc.y) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            ModCS.Npc.Spawn2(251, npc.x, npc.y, 0, 0, 0)
            ModCS.Sound.Play(101)
            npc.cond = 0
            return
        end

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 2
        else
            npc.ani_no = 1
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Boss Misery lightning
ModCS.Npc.Act[251] = function(npc)
    local rc = {
        ModCS.Rect.Create(80, 32, 96, 64),
        ModCS.Rect.Create(96, 32, 112, 64),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.y = npc.y + 8

        if (npc:TouchTile()) then
            ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 3)
            npc.cond = 0
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Boss Misery bats
ModCS.Npc.Act[252] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(48, 32, 64, 48),
        ModCS.Rect.Create(112, 32, 128, 48),
        ModCS.Rect.Create(128, 32, 144, 48),
        ModCS.Rect.Create(144, 32, 160, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(48, 32, 64, 48),
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(128, 48, 144, 64),
        ModCS.Rect.Create(144, 48, 160, 64),
    }

    local deg = 0

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = 0
        npc.count1 = npc.direct
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.count1 = npc.count1 + 2
        npc.count1 = npc.count1 % 0x100

        deg = npc.count1

        if (npc.act_wait < 192) then
            npc.act_wait = npc.act_wait + 1
        end

        npc.x = npc.pNpc.x + (ModCS.Triangle.GetCos(deg) * npc.act_wait) / 4
        npc.y = npc.pNpc.y + (ModCS.Triangle.GetSin(deg) * npc.act_wait) / 4

        if (npc.pNpc.act_no == 151) then
            npc.act_no = 10
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc:SetBit(5) -- Set shootable bit
        npc:UnsetBit(2) -- Unset invulnerable bit
        npc:UnsetBit(3) -- Unset ignore tile collision bit

        deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
        deg = deg + ModCS.Game.Random(-3, 3)
        npc.xm = ModCS.Triangle.GetCos(deg)
        npc.ym = ModCS.Triangle.GetSin(deg)

        npc.ani_no = 1
        npc.ani_wait = 0

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc:Move()

        if (npc:TouchTile()) then
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            npc.cond = 0
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 1
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- EXP capsule
ModCS.Npc.Act[253] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    if (npc.life <= 100) then
        ModCS.Npc.SpawnExp(npc.x, npc.y, npc.flag)
        ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
        ModCS.Sound.Play(25)
        npc.cond = 0
    end

    local rc = {
        ModCS.Rect.Create(0, 64, 16, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
    }

    npc:SetRect(rc[npc.ani_no+1])
end

-- Helicopter
ModCS.Npc.Act[254] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 0, 128, 64),
        ModCS.Rect.Create(0, 64, 128, 128),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        ModCS.Npc.Spawn3(255, npc.x + 18, npc.y - 57, 0, 0, 0, npc)
        ModCS.Npc.Spawn3(255, npc.x - 32, npc.y - 52, 0, 0, 2, npc)
    elseif (npc.act_no == 20) then
        npc.act_wait = 0
        npc.count1 = 60
        npc.act_no = 21
    elseif (npc.act_no == 30) then
        npc.act_no = 21
        ModCS.Npc.Spawn2(223, npc.x - 11, npc.y - 14, 0, 0, 0)
    elseif (npc.act_no == 40) then
        npc.act_no = 21
        ModCS.Npc.Spawn2(223, npc.x - 9, npc.y - 14, 0, 0, 0)
        ModCS.Npc.Spawn2(40, npc.x - 22, npc.y - 14, 0, 0, 0)
        ModCS.Npc.Spawn2(93, npc.x - 35, npc.y - 14, 0, 0, 0)
    end

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
    else
        npc:SetRect(rc[2])
    end
end

-- Helicopter Blades
ModCS.Npc.Act[255] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(128, 0, 240, 16),
        ModCS.Rect.Create(128, 16, 240, 32),
        ModCS.Rect.Create(128, 32, 240, 48),
        ModCS.Rect.Create(128, 16, 240, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(240, 0, 320, 16),
        ModCS.Rect.Create(240, 16, 320, 32),
        ModCS.Rect.Create(240, 32, 320, 48),
        ModCS.Rect.Create(240, 16, 320, 32),
    }

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            view.front = 56
            view.back = 56
        else
            view.front = 40
            view.back = 40
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.pNpc.act_no >= 20) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 3) then
            npc.ani_no = 0
        end
    end

    if (npc.direct == 0) then
        npc.x = npc.pNpc.x + 18
        npc.y = npc.pNpc.y - 57
    else
        npc.x = npc.pNpc.x - 32
        npc.y = npc.pNpc.y - 52
    end

    npc:SetViewbox(view)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Doctor (facing away)
ModCS.Npc.Act[256] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(48, 160, 72, 192),
        ModCS.Rect.Create(72, 160, 96, 192),
        ModCS.Rect.Create(0, 128, 24, 160),
        ModCS.Rect.Create(24, 128, 48, 160),
        ModCS.Rect.Create(0, 160, 24, 192),
        ModCS.Rect.Create(24, 160, 48, 192),
    }

    if (npc.act_no == 0) then
        ModCS.Npc.SetSuperX(0)
        npc.act_no = 1
        npc.y = npc.y - 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_wait = 0
        npc.ani_no = 0
        npc.count1 = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
            npc.count1 = npc.count1 + 1
        end

        if (npc.count1 > 5) then
            npc.act_no = 1
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ani_no = 2
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        ModCS.Npc.Spawn2(257, npc.x - 14, npc.y - 16, 0, 0, 0)
        ModCS.Npc.Spawn2(257, npc.x - 14, npc.y - 16, 0, 0, 2, 0xAA)
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc.ani_no = 4
    elseif (npc.act_no == 50) then
        npc.act_no = 51
        npc.ani_wait = 0
        npc.ani_no = 4
        npc.count1 = 0
        -- Fallthrough
    end

    if (npc.act_no == 51) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 4
            npc.count1 = npc.count1 + 1
        end

        if (npc.count1 > 5) then
            npc.act_no = 41
        end
    end

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Red crystal
ModCS.Npc.Act[257] = function(npc)
    local rc = {
        ModCS.Rect.Create(176, 32, 184, 48),
        ModCS.Rect.Create(184, 32, 192, 48),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Npc.GetSuperX() ~= 0) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        if (npc.x < ModCS.Npc.GetSuperX()) then
            npc.xm = npc.xm + 0.166015625
        end

        if (npc.x > ModCS.Npc.GetSuperX()) then
            npc.xm = npc.xm - 0.166015625
        end

        if (npc.y < ModCS.Npc.GetSuperY()) then
            npc.ym = npc.ym + 0.166015625
        end

        if (npc.y > ModCS.Npc.GetSuperY()) then
            npc.ym = npc.ym - 0.166015625
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

        npc:Move()
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 3) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    if (npc.direct == 0 and npc.xm > 0) then
        npc.ani_no = 2
    end

    if (npc.direct == 2 and npc.xm < 0) then
        npc.ani_no = 2
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Mimiga (sleeping)
ModCS.Npc.Act[258] = function(npc)
    local rc = ModCS.Rect.Create(48, 32, 64, 48)
    npc:SetRect(rc)
end

-- Curly (carried and unconcious)
ModCS.Npc.Act[259] = function(npc)
    local rcLeft = ModCS.Rect.Create(224, 96, 240, 112)
    local rcRight = ModCS.Rect.Create(224, 112, 240, 128)
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc:UnsetBit(13) -- Unset interactable bit
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.tgt_mc.direct == 0) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.y = npc.tgt_mc.y - 4

        if (npc.direct == 0) then
            npc.x = npc.tgt_mc.x + 3
            rect = rcLeft
        else
            npc.x = npc.tgt_mc.x - 3
            rect = rcRight
        end

        if (npc.tgt_mc.x % 2 == 1) then
            rect.top = rect.top + 1
        end

        npc:SetRect(rect)
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.xm = 0.125
        npc.ym = -0.0625

        npc:SetRect(rcLeft)
    elseif (npc.act_no == 11) then
        if (npc.y < 64) then
            npc.ym = 0.0625
        end

        npc:Move()
    elseif (npc.act_no == 20) then
        npc:Vanish()
        ModCS.Npc.Explode(npc.x, npc.y, 16, 0x40, 1)
    end
end