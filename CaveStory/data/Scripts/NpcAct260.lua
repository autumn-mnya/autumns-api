-- Shovel Brigade (caged)
ModCS.Npc.Act[260] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(128, 64, 144, 80),
        ModCS.Rect.Create(144, 64, 160, 80),
        ModCS.Rect.Create(224, 64, 240, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(128, 80, 144, 96),
        ModCS.Rect.Create(144, 80, 160, 96),
        ModCS.Rect.Create(224, 80, 240, 96),
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
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 2
        ModCS.Npc.Spawn2(87, npc.x, npc.y - 16, 0, 0, 0)
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

-- Chie (caged)
ModCS.Npc.Act[261] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(112, 32, 128, 48),
        ModCS.Rect.Create(128, 32, 144, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(128, 48, 144, 64),
    }

    if (npc.act_no == 0) then
        npc.x = npc.x - 1
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

-- Chaco (caged)
ModCS.Npc.Act[262] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
    }

    if (npc.act_no == 0) then
        npc.x = npc.x - 1
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

-- Doctor (boss)
ModCS.Npc.Act[263] = function(npc)
    local deg = 0
    local xm = 0
    local ym = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 24, 32),
        ModCS.Rect.Create(24, 0, 48, 32),
        ModCS.Rect.Create(48, 0, 72, 32),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(72, 0, 96, 32),
        ModCS.Rect.Create(96, 0, 120, 32),
        ModCS.Rect.Create(120, 0, 144, 32),
        ModCS.Rect.Create(144, 0, 168, 32),
        ModCS.Rect.Create(264, 0, 288, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 32, 24, 64),
        ModCS.Rect.Create(24, 32, 48, 64),
        ModCS.Rect.Create(48, 32, 72, 64),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(72, 32, 96, 64),
        ModCS.Rect.Create(96, 32, 120, 64),
        ModCS.Rect.Create(120, 32, 144, 64),
        ModCS.Rect.Create(144, 32, 168, 64),
        ModCS.Rect.Create(264, 32, 288, 64),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)
    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 8
        npc.ani_no = 3
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 0
        else
            npc.ani_no = 3
        end

        if (npc.act_wait > 50) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.ym = npc.ym + 0.25
        npc:SetBit(5) -- Set shootable bit
        npc.damage = 3

        if (npc:TouchFloor()) then
            npc.act_no = 20
            npc.act_wait = 0
            npc.ani_no = 0
            npc.count2 = npc.life

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 20) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait < 50 and npc.life < npc.count2 - 20) then
            npc.act_wait = 50
        end

        if (npc.act_wait == 50) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            npc.ani_no = 4
        end

        if (npc.act_wait == 80) then
            npc.ani_no = 5
            ModCS.Sound.Play(25)

            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(264, npc.x - 16, npc.y, 0, 0, 0)
                ModCS.Npc.Spawn2(264, npc.x - 16, npc.y, 0, 0, 0x400)
            else
                ModCS.Npc.Spawn2(264, npc.x + 16, npc.y, 0, 0, 2)
                ModCS.Npc.Spawn2(264, npc.x + 16, npc.y, 0, 0, 2 + 0x400)
            end
        end

        if (npc.act_wait == 120) then
            npc.ani_no = 0
        end

        if (npc.act_wait > 130 and npc.life < npc.count2 - 50) then
            npc.act_wait = 161
        end

        if (npc.act_wait > 160) then
            npc.act_no = 100
            npc.ani_no = 0
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0
        npc.ani_no = 6
        npc.tgt_x = npc.x
        npc:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x
        else
            npc.x = npc.tgt_x + 1
        end

        if (npc.act_wait > 50) then
            npc.act_no = 32
            npc.act_wait = 0
            npc.ani_no = 7
            ModCS.Sound.Play(101)

            for deg = 8, 0xFF, 0x10 do
                xm = ModCS.Triangle.GetCos(deg) * 2
                ym = ModCS.Triangle.GetSin(deg) * 2
                ModCS.Npc.Spawn2(266, npc.x, npc.y, xm, ym, 0)
            end
        end
    elseif (npc.act_no == 32) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 100
        end
    elseif (npc.act_no == 100) then
        npc.act_no = 101
        npc:UnsetBit(5) -- Unset shootable bit
        npc.damage = 0
        npc.act_wait = 0
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 101) then
        npc.act_wait = npc.act_wait + 2

        if (npc.act_wait > 16) then
            npc.act_no = 102
            npc.act_wait = 0
            npc.ani_no = 3
            npc.tgt_x = ModCS.Game.Random(5, 35) * 0x10
            npc.tgt_y = ModCS.Game.Random(5, 7) * 0x10
        end
    elseif (npc.act_no == 102) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_no = 103
            npc.act_wait = 16
            npc.ani_no = 2
            npc.ym = 0
            npc.x = npc.tgt_x
            npc.y = npc.tgt_y

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 103) then
        npc.act_wait = npc.act_wait - 2

        if (npc.act_wait <= 0) then
            npc:SetBit(5) -- Set shootable bit
            npc.damage = 3

            if (npc.count1 < 3) then
                npc.count1 = npc.count1 + 1
                npc.act_no = 10
            else
                npc.count1 = 0
                npc.act_no = 30
            end
        end
    elseif (npc.act_no == 500) then
        npc:UnsetBit(500)
        npc.ani_no = 6
        npc.ym = npc.ym + 0.03125

        if (npc:TouchFloor()) then
            npc.act_no = 501
            npc.act_wait = 0
            npc.tgt_x = npc.x

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 501) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.ani_no = 8

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x
        else
            npc.x = npc.tgt_x + 1
        end
    end

    if (npc.act_no >= 10) then
        if (npc.act_no == 102) then
            ModCS.Npc.SetSuperX(npc.tgt_x)
            ModCS.Npc.SetSuperY(npc.tgt_y)
        else
            ModCS.Npc.SetSuperX(npc.x)
            ModCS.Npc.SetSuperY(npc.y)
        end
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 101 or npc.act_no == 103) then
        rect.top = rect.top + npc.act_wait
        rect.bottom = rect.bottom - npc.act_wait
        view.top = (16 - npc.act_wait)
    else
        view.top = 16
    end

    npc:SetRect(rect)
    npc:SetViewbox(view)
end

-- Doctor red wave (projectile)
ModCS.Npc.Act[264] = function(npc)
    local rc = ModCS.Rect.Create(288, 0, 304, 16)
    local deg = 0

    if (npc.x < 0 or npc.x > ModCS.Map.GetWidth() * 0x10) then
        npc:Vanish()
        return
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.count1 = npc.direct / 8
        npc.direct = npc.direct % 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.count1 = npc.count1 + 6
        npc.count1 = npc.count1 % 0x100
        deg = npc.count1

        if (npc.act_wait < 128) then
            npc.act_wait = npc.act_wait + 1
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.041015625
        else
            npc.xm = npc.xm + 0.041015625
        end

        npc.tgt_x = npc.tgt_x + npc.xm

        npc.x = npc.tgt_x + (ModCS.Triangle.GetCos(deg) * npc.act_wait) / 2 / 4
        npc.y = npc.tgt_y + (ModCS.Triangle.GetSin(deg) * npc.act_wait) / 2

        ModCS.Npc.Spawn2(265, npc.x, npc.y, 0, 0, 0)
    end

    npc:SetRect(rc)
end

-- Doctor red ball projectile
ModCS.Npc.Act[265] = function(npc)
    local rc = {
        ModCS.Rect.Create(288, 16, 304, 32),
        ModCS.Rect.Create(288, 32, 304, 48),
        ModCS.Rect.Create(288, 48, 304, 64),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 3) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.cond = 0
    else
        npc:SetRect(rc[npc.ani_no+1])
    end
end

-- Doctor red ball projectile (bouncing)
ModCS.Npc.Act[266] = function(npc)
    local rc = {
        ModCS.Rect.Create(304, 16, 320, 32),
        ModCS.Rect.Create(304, 32, 320, 48),
    }

    if (npc:TouchLeftWall()) then
        npc.xm = npc.xm * -1
    end

    if (npc:TouchRightWall()) then
        npc.xm = npc.xm * -1
    end

    if (npc:TouchCeiling()) then
        npc.ym = 1
    end

    if (npc:TouchFloor()) then
        npc.ym = -1
    end

    npc:Move()

    npc.ani_no = npc.ani_no + 1
    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    npc:SetRect(rc[npc.ani_no+1])

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait % 4 == 1) then
        ModCS.Npc.Spawn2(265, npc.x, npc.y, 0, 0, 0)
    end

    if (npc.act_wait > 250) then
        npc:Vanish()
    end
end

-- Muscle Doctor
ModCS.Npc.Act[267] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(0, 64, 40, 112),
        ModCS.Rect.Create(40, 64, 80, 112),
        ModCS.Rect.Create(80, 64, 120, 112),
        ModCS.Rect.Create(120, 64, 160, 112),
        ModCS.Rect.Create(160, 64, 200, 112),
        ModCS.Rect.Create(200, 64, 240, 112),
        ModCS.Rect.Create(240, 64, 280, 112),
        ModCS.Rect.Create(280, 64, 320, 112),
        ModCS.Rect.Create(0, 160, 40, 208),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(0, 112, 40, 160),
        ModCS.Rect.Create(40, 112, 80, 160),
        ModCS.Rect.Create(80, 112, 120, 160),
        ModCS.Rect.Create(120, 112, 160, 160),
        ModCS.Rect.Create(160, 112, 200, 160),
        ModCS.Rect.Create(200, 112, 240, 160),
        ModCS.Rect.Create(240, 112, 280, 160),
        ModCS.Rect.Create(280, 112, 320, 160),
        ModCS.Rect.Create(40, 160, 80, 208),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)
    local view = npc:GetViewbox()

    local xm = 0
    local ym = 0
    local i = 0

    if (npc.act_no == 0) then
        if (ModCS.Npc.GetSuperX() > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.direct == 0) then
            npc.x = ModCS.Npc.GetSuperX() - 6
        else
            npc.x = ModCS.Npc.GetSuperX() + 6
        end

        npc.y = ModCS.Npc.GetSuperY()
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_no = 2
        -- Fallthrough
    end

    if (npc.act_no == 2) then
        npc.ym = npc.ym + 0.25

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 0
        else
            npc.ani_no = 3
        end
    elseif (npc.act_no == 5) then
        npc.act_no = 6
        npc.ani_no = 1
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 6) then
        npc.ym = npc.ym + 0.25

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 40) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end
    elseif (npc.act_no == 7) then
        npc.act_no = 8
        npc.act_wait = 0
        npc.ani_no = 3
        -- Fallthrough
    end

    if (npc.act_no == 8) then
        npc.ym = npc.ym + 0.125

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc:SetBit(2) -- Set invulnerable bit
        npc.xm = 0
        npc.act_no = 11
        npc.act_wait = 0
        npc.ani_no = 1
        npc.ani_wait = 0
        npc.count2 = npc.life
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.ym = npc.ym + 0.25

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc:TouchFloor()) then
            if (npc.life < npc.count2 - 20) then
                if (npc.tgt_mc:TouchFloor() and npc.tgt_mc.x > npc.x - 48 and npc.tgt_mc.x < npc.x + 48 and npc.ani_no ~= 6) then
                    npc.ani_no = 6
                    npc.tgt_mc:DamageMyID(5)
                    ModCS.Camera.SetQuake(10)
                    ModCS.Sound.Play(26)
                    npc.tgt_mc.y = -2

                    if (npc.x > npc.tgt_mc.x) then
                        npc.tgt_mc.xm = -2.998046875
                    else
                        npc.tgt_mc.xm = 2.998046875
                    end

                    for i = 0, 99 do
                        ModCS.Npc.Spawn2(270, npc.x + ModCS.Game.Random(0x10, 0x10), npc.y + ModCS.Game.Random(-0x10, 0x10), ModCS.Game.Random2(-1, 1) * 3, ModCS.Game.Random2(-1, 1) * 3, 3, 0xAA)
                    end
                end
            else
                npc.ani_wait = npc.ani_wait + 1
                if (npc.ani_wait > 10) then
                    npc.ani_wait = 0

                    npc.ani_no = npc.ani_no + 1
                    if (npc.ani_no > 2) then
                        npc.ani_no = 1
                    end
                end
            end
        else
            npc.ani_no = 4
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30 or npc.life < npc.count2 - 20) then
            npc.count1 = npc.count1 + 1
            if (npc.count1 > 10) then
                npc.count1 = 0
            end

            if (npc.count1 == 8) then
                npc.act_no = 20
            elseif (npc.count1 == 2 or npc.count1 == 7) then
                npc.act_no = 100
            elseif (npc.count1 == 3 or npc.count1 == 6) then
                npc.act_no = 30
            elseif (npc.count1 == 1 or npc.count1 == 9) then
                npc.act_no = 40
            else
                npc.act_no = 15
                npc.act_wait = 0
            end
        end
    elseif (npc.act_no == 15) then
        npc.ani_no = 3
        npc.act_wait = npc.act_wait + 1

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.act_wait > 20) then
            npc.act_no = 16
            npc.ani_no = 4
            npc.ani_wait = 0
            npc.ym = -3

            if (npc.direct == 0) then
                npc.xm = -2
            else
                npc.xm = 2
            end
        end
    elseif (npc.act_no == 16) then
        npc.ym = npc.ym + 0.125
        
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 4
        end

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.ym > 0 and npc:TouchFloor()) then
            npc.act_no = 17
        end
    elseif (npc.act_no == 17) then
        npc.act_no = 18
        npc.act_wait = 0
        ModCS.Camera.SetQuake(10)
        ModCS.Sound.Play(26)
        -- Fallthrough
    end

    if (npc.act_no == 18) then
        npc.ani_no = 3
        npc.act_wait = npc.act_wait + 1

        npc.xm = (npc.xm * 7) / 8
        npc.ym = npc.ym + 0.25

        if (npc.act_wait > 10) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        npc.ani_no = 6

        if (npc.act_wait > 20 and npc.act_wait % 3 == 1) then
            ym = ModCS.Game.Random2(-1, 1)
            xm = ModCS.Game.Random2(0.5, 1) * 4

            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(269, npc.x - 8, npc.y - 4, -xm, ym, 0)
            else
                ModCS.Npc.Spawn2(269, npc.x + 8, npc.y - 4, xm, ym, 2)
            end

            ModCS.Sound.Play(39)
        end

        if (npc.act_wait > 90) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0
        npc:SetBit(0) -- Set solid soft bit
        npc:UnsetBit(5) -- Unset shootable bit
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.ani_no = 3

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 32
            npc.act_wait = 0
            npc.ani_no = 7
            npc:SetBit(7) -- Set 'bottom and top don't hurt player' bit
            npc.damage = 10
            ModCS.Sound.Play(25)

            if (npc.direct == 0) then
                npc.xm = -2.998046875
            else
                npc.xm = 2.998046875
            end
        end
    elseif (npc.act_no == 32) then
        npc.act_wait = npc.act_wait + 1
        npc.ym = 0

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 7
        else
            npc.ani_no = 8
        end

        if (npc.act_wait > 30) then
            npc.act_wait = 0
            npc.act_no = 18
            npc.damage = 5
            npc:UnsetBit(0) -- Unset solid soft bit
            npc:UnsetBit(7) -- Unset 'bottom and top don't hurt player' bit
            npc:SetBit(5) -- Set shootable bit
        end

        if (npc:TouchLeftWall() or npc:TouchRightWall()) then
            npc.act_no = 15
            npc.act_wait = 0
            npc.damage = 5
            npc:UnsetBit(0) -- Unset solid soft bit
            npc:UnsetBit(7) -- Unset 'bottom and top don't hurt player' bit
            npc:SetBit(5) -- Set shootable bit
        end
    elseif (npc.act_no == 40) then
        npc.ani_no = 3
        npc.act_wait = npc.act_wait + 1

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.act_wait > 20) then
            npc.act_no = 41
            npc.ani_no = 4
            npc.ani_wait = 0
            npc.ym = -4

            if (npc.direct == 0) then
                npc.xm = -2
            else
                npc.xm = 2
            end
        end
    elseif (npc.act_no == 41) then
        npc.ym = npc.ym + 0.125

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 4
        end

        if (npc.tgt_mc.y > npc.y and npc.tgt_mc.x > npc.x - 8 and npc.tgt_mc.x < npc.x + 8) then
            npc.act_no = 16
            npc.ym = 2.998046875
            npc.xm = 0
        end

        if (npc.ym > 0 and npc:TouchFloor()) then
            npc.act_no = 17
        end
    elseif (npc.act_no == 100) then
        npc.act_no = 101
        npc.act_wait = 0
        npc:UnsetBit(2) -- Unset invulnerable bit
        npc:UnsetBit(5) -- Unset shootable bit
        npc.damage = 0
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 101) then
        npc.act_wait = npc.act_wait + 2

        if (npc.act_wait > 20) then
            npc.act_no = 102
            npc.act_wait = 0
            npc.ani_no = 0

            npc.tgt_x = npc.tgt_mc.x
            npc.tgt_y = npc.tgt_mc.y - 32

            if (npc.tgt_y < 64) then
                npc.tgt_y = 64
            end

            if (npc.tgt_x < 64) then
                npc.tgt_x = 64
            end

            if (npc.tgt_x > 576) then
                npc.tgt_x = 576
            end
        end
    elseif (npc.act_no == 102) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_no = 103
            npc.act_wait = 28
            npc.ani_no = 4
            npc.ym = 0
            npc.x = npc.tgt_x
            npc.y = npc.tgt_y

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 103) then
        npc.act_wait = npc.act_wait - 2

        if (npc.act_wait <= 0) then
            npc:SetBit(2) -- Set invulnerable bit
            npc:SetBit(5) -- Set shootable bit
            npc.damage = 5
            npc.act_no = 16
            npc.ym = -1
            npc.xm = 0
        end
    elseif (npc.act_no == 500) then
        ModCS.Npc.KillEveryID(269, true)
        npc:UnsetBit(5) -- Unset shootable bit
        npc.ani_no = 4
        npc.ym = npc.ym + 0.0625
        npc.xm = 0

        if (npc:TouchFloor()) then
            npc.act_no = 501
            npc.act_wait = 0
            npc.tgt_x = npc.x

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 501) then
        npc.ani_no = 9

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x
        else
            npc.x = npc.tgt_x + 1
        end
    elseif (npc.act_no == 510) then
        npc.act_no = 511
        npc.act_wait = 0
        npc.ani_no = 9
        npc.tgt_x = npc.x
        npc.y = npc.y + 16
        npc:SetBit(3) -- Set ignore tile collision bit
        -- Fallthrough
    end

    if (npc.act_no == 511) then
        ModCS.Camera.SetQuake(2)

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 6 == 3) then
            ModCS.Sound.Play(25)
        end

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x
        else
            npc.x = npc.tgt_x + 1
        end

        if (npc.act_wait > 352) then
            npc.ani_no = 0
            npc.act_no = 0x200
        end
    elseif (npc.act_no == 520) then
        npc.damage = 0
        ModCS.Npc.SetSuperY(-32)
    end

    if (npc.act_no >= 11 and npc.act_no < 501) then
        if (npc.act_no == 102) then
            ModCS.Npc.SetSuperX(npc.tgt_x)
            ModCS.Npc.SetSuperY(npc.tgt_y)
        else
            ModCS.Npc.SetSuperX(npc.x)
            ModCS.Npc.SetSuperY(npc.y)
        end
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.act_no >= 512) then
        -- Nothing happens here?
    elseif (npc.act_no < 510) then
        if (npc.act_no ~= 102 and npc.act_no ~= 103 and ModCS.Game.Random(0, 3) == 2) then
            ModCS.Npc.Spawn2(270, npc.x + ModCS.Game.Random(-0x10, 0x10), npc.y + ModCS.Game.Random(-8, 4), npc.xm, 0, 3)
        end
    else
        ModCS.Npc.Spawn2(270, npc.x + ModCS.Game.Random(-0x10, 0x10), npc.y - ((336 - npc.act_wait) / 8), ModCS.Game.Random2(-1, 1), ModCS.Game.Random2(-1, 0) * 2, 3)
        ModCS.Npc.Spawn2(270, npc.x + ModCS.Game.Random(-0x10, 0x10), npc.y - ((336 - npc.act_wait) / 8), ModCS.Game.Random2(-1, 1), ModCS.Game.Random2(-1, 0) * 2, 3)
        ModCS.Npc.Spawn2(270, npc.x + ModCS.Game.Random(-0x10, 0x10), npc.y - ((336 - npc.act_wait) / 8), 0, 2 * ModCS.Game.Random2(-1, 0), 3)
        ModCS.Npc.Spawn2(270, npc.x + ModCS.Game.Random(-0x10, 0x10), npc.y - ((336 - npc.act_wait) / 8), 0, 2 * ModCS.Game.Random2(-1, 0), 3)
    end

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 511) then
        rect.top = rect.top + (npc.act_wait / 8)
        view.top = 44 - (npc.act_wait / 8)
        view.bottom = 4
    elseif (npc.act_no == 101 or npc.act_no == 103) then
        rect.top = rect.top + npc.act_wait
        rect.bottom = rect.bottom - npc.act_wait
        view.top = (28 - npc.act_wait)
    else
        view.top = 28
    end

    npc:SetRect(rect)
    npc:SetViewbox(view)
end

-- Igor (enemy)

-- Red Bat (bouncing)

-- Doctor's blood (or "red energy")

-- Ironhead block

-- Ironhead block generator

-- Droll projectile

-- Droll

-- Puppy (plantation)

-- Red Demon

-- Red Demon projectile

-- Little family

-- Falling block (large)