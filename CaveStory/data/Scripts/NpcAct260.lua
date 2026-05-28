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
ModCS.Npc.Act[268] = function(npc)
    local deg = 0
    local xm = 0
    local ym = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(40, 0, 80, 40),
        ModCS.Rect.Create(80, 0, 120, 40),
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(120, 0, 160, 40),
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(40, 80, 80, 120),
        ModCS.Rect.Create(0, 80, 40, 120),
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
        ModCS.Rect.Create(160, 80, 200, 120),
        ModCS.Rect.Create(120, 80, 160, 120),
        ModCS.Rect.Create(240, 40, 280, 80),
        ModCS.Rect.Create(280, 40, 320, 80),
    }

    if not (npc:TriggerBox(320, 240, 320, 240)) then
        npc.act_no = 1
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 20) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc:TriggerBox(112, 112, 112, 48)) then
            npc.act_no = 10
        end

        if (npc:IsHit()) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        npc.ani_no = 0
        npc.ani_wait = 0

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end
    
    if (npc.act_no == 11) then
        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end

        if (npc.x < npc.tgt_mc.x + 64 and npc.x > npc.tgt_mc.x - 64) then
            npc.act_no = 20
            npc.act_wait = 0
        end

        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.act_no = 20
            npc.act_wait = 0
        end

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.act_no = 20
            npc.act_wait = 0
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end
    elseif (npc.act_no == 20) then
        npc.xm = 0
        npc.ani_no = 6

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 30
            npc.ym = -2.998046875

            if (npc.direct == 0) then
                npc.xm = -1
            else
                npc.xm = 1
            end
            
            ModCS.Sound.Play(108)
        end
    elseif (npc.act_no == 30) then
        npc.ani_no = 7

        if (npc:TouchFloor()) then
            npc.act_no = 40
            npc.act_wait = 0
            ModCS.Camera.SetQuake(20)
            ModCS.Sound.Play(26)
        end
    elseif (npc.act_no == 40) then
        npc.xm = 0
        npc.ani_no = 6

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 50
        end
    elseif (npc.act_no == 50) then
        npc.act_no = 51
        npc.act_wait = 0

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 51) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30 and npc.act_wait % 4 == 1) then
            if (npc.direct == 0) then
                deg = 0x88
            else
                deg = 0xF8
            end

            deg = deg + ModCS.Game.Random(-0x10, 0x10)
            ym = ModCS.Triangle.GetSin(deg) * 5
            xm = ModCS.Triangle.GetCos(deg) * 5
            ModCS.Npc.Spawn2(11, npc.x, npc.y + 4, xm, ym, 0)
            ModCS.Sound.Play(12)
        end

        if (npc.act_wait < 50 and math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 9
        else
            npc.ani_no = 8
        end

        if (npc.act_wait > 82) then
            npc.act_no = 10

            if (npc.tgt_mc.x < npc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    end

    npc.ym = npc.ym + 0.1
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

-- Red Bat (bouncing)
ModCS.Npc.Act[269] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(232, 0, 248, 16),
        ModCS.Rect.Create(248, 0, 264, 16),
        ModCS.Rect.Create(248, 16, 264, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(232, 32, 248, 48),
        ModCS.Rect.Create(248, 32, 264, 48),
        ModCS.Rect.Create(248, 48, 264, 64),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.xm2 = npc.xm
        npc.ym2 = npc.ym
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.xm2 < 0 and npc:TouchLeftWall()) then
            npc.direct = 2
            npc.xm2 = npc.xm2 * -1
        elseif (npc.xm2 > 0 and npc:TouchRightWall()) then
            npc.direct = 0
            npc.xm2 = npc.xm2 * -1
        elseif (npc.ym2 < 0 and npc:TouchCeiling()) then
            npc.ym2 = npc.ym2 * -1
        elseif (npc.ym2 > 0 and npc:TouchFloor()) then
            npc.ym2 = npc.ym2 * -1
        end

        npc:Move2()

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
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

-- Doctor's blood (or "red energy")
ModCS.Npc.Act[270] = function(npc)
    local rc = {
        ModCS.Rect.Create(170, 34, 174, 38),
        ModCS.Rect.Create(170, 42, 174, 46),
    }

    if (npc.direct == 3 or npc.direct == 1) then
        if (npc.direct == 3) then
            npc.ym = npc.ym + 0.125
        end

        if (npc.direct == 1) then
            npc.ym = npc.ym - 0.125
        end

        npc.act_wait = npc.act_wait + 1
        
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()

        if (npc.act_wait > 50) then
            npc.cond = 0
        end

        if (npc:TouchTile()) then
            npc.cond = 0
        end
    elseif (npc.direct == 2) then
        if (npc.act_no == 0) then
            npc.act_no = 1
            npc:SetBit(3) -- Set ignore tile collision bit

            npc.xm = ModCS.Game.Random2(-1, 1) * 3
            npc.ym = ModCS.Game.Random2(-1, 1) * 3

            npc.count1 = ModCS.Game.Random(0x10, 0x33)
            npc.count2 = ModCS.Game.Random(0x80, 0x100)
        end

        if (npc.x < npc.pNpc.x) then
            npc.xm = npc.xm + (1 / npc.count1)
        end

        if (npc.x > npc.pNpc.x) then
            npc.xm = npc.xm - (1 / npc.count1)
        end

        if (npc.y < npc.pNpc.y) then
            npc.ym = npc.ym + (1 / npc.count1)
        end

        if (npc.y > npc.pNpc.y) then
            npc.ym = npc.ym - (1 / npc.count1)
        end

        if (npc.xm > ((npc.count2 * 2) / 512)) then
            npc.xm = ((npc.count2 * 2) / 512)
        end

        if (npc.xm < -((npc.count2 * 2) / 512)) then
            npc.xm = -((npc.count2 * 2) / 512)
        end

        if (npc.ym > ((npc.count2 * 3) / 512)) then
            npc.ym = ((npc.count2 * 3) / 512)
        end

        if (npc.ym < -((npc.count2 * 3) / 512)) then
            npc.ym = -((npc.count2 * 3) / 512)
        end

        npc:Move()
    end

    npc:SetRect(rc[ModCS.Game.Random(1, 2)])
end

-- Ironhead block
ModCS.Npc.Act[271] = function(npc)
    local a = 0
    local rect = ModCS.Rect.Create(0, 0, 0, 0)
    local view = npc:GetViewbox()
    local hit = npc:GetHitbox()

    if (npc.xm < 0 and npc.x < -16) then
        npc:Vanish()
        return
    end

    if (npc.xm > 0 and npc.x > (ModCS.Map.GetWidth() * 0x10) + (1 * 0x10)) then
        npc:Vanish()
        return
    end

    if (npc.act_no == 0) then
        npc.act_no = 1

        a = ModCS.Game.Random(0, 9)

        if (a == 9) then
            rect.left = 0
            rect.right = 0x20
            rect.top = 0x40
            rect.bottom = 0x60

            view.front = 16
            view.back = 16
            view.top = 16
            view.bottom = 16

            hit.front = 12
            hit.back = 12
            hit.top = 12
            hit.bottom = 12
            npc:SetRect(rect)
            npc:SetViewbox(view)
            npc:SetHitbox(hit)
        else
            rect.left = ((a % 3) * 16) + (7 * 16)
            rect.top = (a / 3) * 16
            rect.right = rect.left + 16
            rect.bottom = rect.top + 16
            npc:SetRect(rect)
        end

        if (npc.direct == 0) then
            npc.xm = ModCS.Game.Random2(0.5, 1) * -2
        else
            npc.xm = ModCS.Game.Random2(0.5, 1) * 2
        end

        npc.ym = ModCS.Game.Random2(-1, 1)
    end

    if (npc.ym < 0 and npc.y - hit.top < 8) then
        npc.ym = npc.ym * -1
        ModCS.Caret.Spawn(ModCS.Const.CARET_TINY_PARTICLES, npc.x, npc.y - 8, 0)
        ModCS.Caret.Spawn(ModCS.Const.CARET_TINY_PARTICLES, npc.x, npc.y - 8, 0)
    end

    if (npc.ym > 0 and npc.y + hit.bottom > 232) then
        npc.ym = npc.ym * -1
        ModCS.Caret.Spawn(ModCS.Const.CARET_TINY_PARTICLES, npc.x, npc.y + 8, 0)
        ModCS.Caret.Spawn(ModCS.Const.CARET_TINY_PARTICLES, npc.x, npc.y + 8, 0)
    end

    npc:Move()
end

-- Ironhead block generator
ModCS.Npc.Act[272] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = ModCS.Game.Random(0, 200)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc.act_no = 0
            ModCS.Npc.Spawn2(271, npc.x, npc.y + ModCS.Game.Random(-32, 32), 0, 0, npc.direct)
        end
    end
end

-- Droll projectile
ModCS.Npc.Act[273] = function(npc)
    local rc = {
        ModCS.Rect.Create(248, 40, 272, 64),
        ModCS.Rect.Create(272, 40, 296, 64),
        ModCS.Rect.Create(296, 40, 320, 64),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc:Move()

        if (npc:TouchTile()) then
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            npc:Vanish()
            return
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 5 == 0) then
            ModCS.Sound.Play(110)
        end

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Droll
ModCS.Npc.Act[274] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 32, 40),
        ModCS.Rect.Create(32, 0, 64, 40),
        ModCS.Rect.Create(64, 0, 96, 40),
        ModCS.Rect.Create(64, 80, 96, 120),
        ModCS.Rect.Create(96, 80, 128, 120),
        ModCS.Rect.Create(96, 0, 128, 40),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 40, 32, 80),
        ModCS.Rect.Create(32, 40, 64, 80),
        ModCS.Rect.Create(64, 40, 96, 80),
        ModCS.Rect.Create(64, 120, 96, 160),
        ModCS.Rect.Create(96, 120, 128, 160),
        ModCS.Rect.Create(96, 40, 128, 80),
    }

    local deg = 0
    local xm = 0
    local ym = 0

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

        if (npc:IsHit()) then
            npc.act_no = 10
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
            npc.count1 = 0

            if (npc.tgt_x > npc.x) then
                npc.xm = 1
            else
                npc.xm = -1
            end
        end
    elseif (npc.act_no == 12) then
        if (npc.ym > 0) then
            npc.ani_no = 4

            if (npc.count1 == 0) then
                npc.count1 = npc.count1 + 1
                deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, (npc.y - 10) - npc.tgt_mc.y)
                ym = ModCS.Triangle.GetSin(deg) * 4
                xm = ModCS.Triangle.GetCos(deg) * 4
                ModCS.Npc.Spawn2(273, npc.x, npc.y - 10, xm, ym, 0)
                ModCS.Sound.Play(39)
            end
        end

        if (npc.ym > 1) then
            npc.ani_no = 5
        end

        if (npc:TouchFloor()) then
            npc.ani_no = 2
            npc.act_no = 13
            npc.act_wait = 0
            npc.xm = 0
        end
    elseif (npc.act_no == 13) then
        npc.xm = npc.xm / 2

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
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
end

-- Puppy (plantation)
ModCS.Npc.Act[275] = function(npc)
    local rcRight = {
        ModCS.Rect.Create(272, 80, 288, 96),
        ModCS.Rect.Create(288, 80, 304, 96),
        ModCS.Rect.Create(272, 80, 288, 96),
        ModCS.Rect.Create(304, 80, 320, 96),
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

        if (npc:TriggerBox(64, 32, 64, 16)) then
            npc.ani_wait = npc.ani_wait + 1
            if (npc.ani_wait > 3) then
                npc.ani_wait = 0
                npc.ani_no = npc.ani_no + 1
            end

            if (npc.ani_no > 3) then
                npc.ani_no = 2
            end
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rcRight[npc.ani_no+1])
end

-- Red Demon
ModCS.Npc.Act[276] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 64, 32, 104),
        ModCS.Rect.Create(32, 64, 64, 104),
        ModCS.Rect.Create(64, 64, 96, 104),
        ModCS.Rect.Create(96, 64, 128, 104),
        ModCS.Rect.Create(128, 64, 160, 104),
        ModCS.Rect.Create(160, 64, 192, 104),
        ModCS.Rect.Create(192, 64, 224, 104),
        ModCS.Rect.Create(224, 64, 256, 104),
        ModCS.Rect.Create(256, 64, 288, 104),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 104, 32, 144),
        ModCS.Rect.Create(32, 104, 64, 144),
        ModCS.Rect.Create(64, 104, 96, 144),
        ModCS.Rect.Create(96, 104, 128, 144),
        ModCS.Rect.Create(128, 104, 160, 144),
        ModCS.Rect.Create(160, 104, 192, 144),
        ModCS.Rect.Create(192, 104, 224, 144),
        ModCS.Rect.Create(224, 104, 256, 144),
        ModCS.Rect.Create(256, 104, 288, 144),
    }

    local deg = 0
    local xm = 0
    local ym = 0

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
        if (npc.ani_wait > 20) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc:IsHit()) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        npc.ani_no = 3
        npc:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30 or npc.act_wait == 40 or npc.act_wait == 50) then
            npc.ani_no = 4

            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
            ym = ModCS.Triangle.GetSin(deg) * 4
            xm = ModCS.Triangle.GetCos(deg) * 4

            ModCS.Npc.Spawn2(277, npc.x, npc.y, xm, ym, 0)
            ModCS.Sound.Play(39)
        elseif (npc.act_wait == 34 or npc.act_wait == 44 or npc.act_wait == 54) then
            npc.ani_no = 3
        end

        if (npc.act_wait > 60) then
            npc.act_no = 20
            npc.act_wait = 0
            npc.ani_no = 2
        end
    elseif (npc.act_no == 20) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 21
            npc.act_wait = 0
            npc.ani_no = 5
            npc.ym = -2.998046875

            if (npc.x < npc.tgt_mc.x) then
                npc.xm = 0.5
            else
                npc.xm = -0.5
            end
        end
    elseif (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30 or npc.act_wait == 40 or npc.act_wait == 50) then
            npc.ani_no = 6

            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - 10 - npc.tgt_mc.y)
            ym = ModCS.Triangle.GetSin(deg) * 4
            xm = ModCS.Triangle.GetCos(deg) * 4

            ModCS.Npc.Spawn2(277, npc.x, npc.y - 10, xm, ym, 0)
            ModCS.Sound.Play(39)
        elseif (npc.act_wait == 34 or npc.act_wait == 44) then
            npc.ani_no = 5
        end

        if (npc.act_wait > 53) then
            npc.ani_no = 7
        end

        if (npc:TouchFloor()) then
            npc.act_no = 22
            npc.act_wait = 0
            npc.ani_no = 2
            ModCS.Camera.SetQuake(10)
            ModCS.Sound.Play(26)
        end
    elseif (npc.act_no == 22) then
        npc.xm = npc.xm / 2

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 22) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 50) then
        npc:UnsetBit(5) -- Unset shootable bit
        npc.damage = 0

        if (npc:TouchFloor()) then
            npc.act_no = 51
            npc.ani_no = 2
            ModCS.Camera.SetQuake(10)
            ModCS.Npc.SpawnExp(npc.x, npc.y, 19)
            ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
            ModCS.Sound.Play(72)
        end
    elseif (npc.act_no == 51) then
        npc.xm = (npc.xm * 7) / 8
        npc.ani_no = 8
    end

    npc.ym = npc.ym + 0.0625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.act_no < 50) then
        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Red Demon projectile
ModCS.Npc.Act[277] = function(npc)
    local rc = {
        ModCS.Rect.Create(128, 0, 152, 24),
        ModCS.Rect.Create(152, 0, 176, 24),
        ModCS.Rect.Create(176, 0, 200, 24),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc:Move()

        if (npc:TouchTile()) then
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            ModCS.Npc.Spawn2(4, npc.x, npc.y, 0, 0, 0)
            npc:Vanish()
            return
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 5 == 0) then
            ModCS.Sound.Play(110)
        end

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Little family
ModCS.Npc.Act[278] = function(npc)
    local rcPapa = {
        ModCS.Rect.Create(0, 120, 8, 128),
        ModCS.Rect.Create(8, 120, 16, 128),
    }

    local rcMama = {
        ModCS.Rect.Create(16, 120, 24, 128),
        ModCS.Rect.Create(24, 120, 32, 128),
    }

    local rcKodomo = {
        ModCS.Rect.Create(32, 120, 40, 128),
        ModCS.Rect.Create(40, 120, 48, 128),
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
        npc.ani_no = 0
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
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 0x20) then
            npc.act_no = 0
        end
    end

    npc.ym = npc.ym + 0.0625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.event == 200) then
        npc:SetRect(rcPapa[npc.ani_no+1])
    elseif (npc.event == 210) then
        npc:SetRect(rcMama[npc.ani_no+1])
    else
        npc:SetRect(rcKodomo[npc.ani_no+1])
    end

end

-- Falling block (large)
ModCS.Npc.Act[279] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 16, 32, 48),
        ModCS.Rect.Create(16, 0, 32, 16),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    local view = npc:GetViewbox()
    local hit = npc:GetHitbox()

    local i = 0

    if (npc.act_no == 0) then
        if (npc.direct == 0) then
            npc.act_no = 100
            npc:SetBit(2) -- Set invulnerable bit
            npc.ani_no = 0
        elseif (npc.direct == 2) then
            npc.act_no = 100
            npc:SetBit(2) -- Set invulnerable bit
            npc.ani_no = 1

            view.back = 8
            view.front = 8
            view.top = 8
            view.bottom = 8

            hit.back = 8
            hit.front = 8
            hit.top = 8
            hit.bottom = 8
        elseif (npc.direct == 1) then
            npc.ani_no = 0
            npc.act_no = 10
        end

        -- if (npc.direct ~= 1) then
        -- break (how do we translate this proper??)
        
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 16
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait - 2

        if (npc.act_wait <= 0) then
            npc.act_no = 100
            npc:SetBit(2) -- Set invulnerable bit
        end
    elseif (npc.act_no == 100) then
        npc.ym = npc.ym + 0.125
        if (npc.ym > 3.5) then
            npc.ym = 3.5
        end

        if (npc.y > 128) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        if (npc:TouchFloor()) then
            npc.ym = -1
            npc.act_no = 110
            npc:SetBit(3) -- Set ignore tile collision bit
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(10)

            for i = 0, 3 do
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

    if (npc.tgt_mc.y > npc.y) then
        npc.damage = 10
    else
        npc.damage = 0
    end

    npc:Move()
    rect = rc[npc.ani_no+1]

    if (npc.act_no == 11) then
        rect.top = rect.top + npc.act_wait
        rect.bottom = rect.bottom - npc.act_wait
        view.top = 16 - npc.act_wait
    end

    npc:SetRect(rect)
    npc:SetViewbox(view)
    npc:SetHitbox(hit)
end