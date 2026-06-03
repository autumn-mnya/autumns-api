-- Dragon Zombie
ModCS.Npc.Act[200] = function(npc)
    local deg = 0
    local xm = 0
    local ym = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(40, 0, 80, 40),
        ModCS.Rect.Create(80, 0, 120, 40),
        ModCS.Rect.Create(120, 0, 160, 40),
        ModCS.Rect.Create(160, 0, 200, 40),
        ModCS.Rect.Create(200, 0, 240, 40),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 40, 40, 80),
        ModCS.Rect.Create(40, 40, 80, 80),
        ModCS.Rect.Create(80, 40, 120, 80),
        ModCS.Rect.Create(120, 40, 160, 80),
        ModCS.Rect.Create(160, 40, 200, 80),
        ModCS.Rect.Create(200, 40, 240, 80),
    }

    if (npc.act_no < 100 and npc.life < 950) then
        ModCS.Sound.Play(72)
        ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
        ModCS.Npc.SpawnExp(npc.x, npc.y, npc.exp)
        npc.act_no = 100
        npc:UnsetBit(5) -- Unset shootable bit
        npc.damage = 0
    end

    if (npc.act_no == 0) then
        npc.act_no = 10
        npc.count1 = 0
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 30) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc.count1 ~= 0) then
            npc.count1 = npc.count1 - 1
        end

        if (npc.count1 == 0 and npc.tgt_mc.x > npc.x - 112 and npc.tgt_mc.x < npc.x + 112) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 2
        else
            npc.ani_no = 3
        end

        if (npc.act_wait > 30) then
            npc.act_no = 30
        end

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0
        npc.ani_no = 4
        npc.tgt_x = npc.tgt_mc.x
        npc.tgt_y = npc.tgt_mc.y
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait < 40 and npc.act_wait % 8 == 1) then
            if (npc.direct == 0) then
                deg = ModCS.Triangle.GetArktan(npc.x - 14 - npc.tgt_x, npc.y - npc.tgt_y)
            else
                deg = ModCS.Triangle.GetArktan(npc.x + 14 - npc.tgt_x, npc.y - npc.tgt_y)
            end

            deg = deg + ModCS.Game.Random(-6, 6)

            ym = ModCS.Triangle.GetSin(deg) * 3
            xm = ModCS.Triangle.GetCos(deg) * 3

            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(202, npc.x - 14, npc.y, xm, ym, 0)
            else
                ModCS.Npc.Spawn2(202, npc.x + 14, npc.y, xm, ym, 0)
            end

            if not ModCS.Player.CheckCond(2) then
                ModCS.Sound.Play(33)
            end
        end

        if (npc.act_wait > 60) then
            npc.act_no = 10
            npc.count1 = ModCS.Game.Random(100, 200)
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 100) then
        npc.ani_no = 5
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Dragon Zombie (dead)
ModCS.Npc.Act[201] = function(npc)
    local rcLeft = ModCS.Rect.Create(200, 0, 240, 40)
    local rcRight = ModCS.Rect.Create(200, 40, 240, 80)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight)
    end
end

-- Dragon Zombie projectile
ModCS.Npc.Act[202] = function(npc)
    if (npc:TouchTile()) then
        npc.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(184, 216, 200, 240),
        ModCS.Rect.Create(200, 216, 216, 240),
        ModCS.Rect.Create(216, 216, 232, 240),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    npc:SetRect(rect_left[npc.ani_no+1])

    npc.count1 = npc.count1 + 1
    if (npc.count1 > 300) then
        npc.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end
end

-- Critter (destroyed Egg Corridor)
ModCS.Npc.Act[203] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(32, 80, 48, 96),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(16, 96, 32, 112),
        ModCS.Rect.Create(32, 96, 48, 112),
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

        if (npc.act_wait >= 8 and npc:TriggerBox(112, 80, 112, 80)) then
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

        if (npc.act_wait >= 8 and npc:TriggerBox(48, 80, 48, 48)) then
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

            if not ModCS.Player.CheckCond(2) then
                ModCS.Sound.Play(30)
            end

            if (npc.direct == 0) then
                npc.xm = -0.5
            else
                npc.xm = 0.5
            end
        end
    elseif (npc.act_no == 3) then
        if (npc:TouchFloor()) then
            npc.xm = 0
            npc.act_wait = 0
            npc.ani_no = 0
            npc.act_no = 1

            if not ModCS.Player.CheckCond(2) then
                ModCS.Sound.Play(23)
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

-- Falling spike (small)
ModCS.Npc.Act[204] = function(npc)
    local rc = {
        ModCS.Rect.Create(240, 80, 256, 96),
        ModCS.Rect.Create(240, 144, 256, 160),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.tgt_mc.x > npc.x - 12 and npc.tgt_mc.x < npc.x + 12 and npc.tgt_mc.y > npc.y) then
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 6) % 2 == 1) then
            npc.x = npc.tgt_x - 1
        else
            npc.x = npc.tgt_x
        end

        if (npc.act_wait > 30) then
            npc.act_no = 3
            npc.ani_no = 1
        end
    elseif (npc.act_no == 3) then
        npc.ym = npc.ym + 0.0625

        if (npc:TouchTile()) then
            if not ModCS.Player.CheckCond(2) then
                ModCS.Sound.Play(12)
            end

            ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 4)
            npc.cond = 0
            return
        end
    end

    if (npc.ym > 6) then
        npc.ym = 6
    end

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Falling spike (large)
ModCS.Npc.Act[205] = function(npc)
    local rc = {
        ModCS.Rect.Create(112, 80, 128, 112),
        ModCS.Rect.Create(128, 80, 144, 112),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.y = npc.y + 4
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.tgt_mc.x > npc.x - 12 and npc.tgt_mc.x < npc.x + 12 and npc.tgt_mc.y > npc.y) then
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 6) % 2 == 1) then
            npc.x = npc.tgt_x - 1
        else
            npc.x = npc.tgt_x
        end

        if (npc.act_wait > 30) then
            npc.act_no = 3
            npc.ani_no = 1
            npc.act_wait = 0
        end
    elseif (npc.act_no == 3) then
        npc.ym = npc.ym + 0.0625

        if (npc.tgt_mc.y > npc.y) then
            npc:UnsetBit(6) -- Unset solid collision against player
            npc.damage = 127
        else
            npc:SetBit(6) -- Set solid collision against player
            npc.damage = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8 and npc:TouchTile()) then
            npc:SetBit(6) -- Set solid collision against player
            npc.act_no = 4
            npc.act_wait = 0
            npc.ym = 0
            npc.damage = 0
            ModCS.Sound.Play(12)
            ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 4)
            ModCS.Bullet.Spawn(24, npc.x, npc.y, 0)
            return
        end
    elseif (npc.act_no == 4) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 4) then
            npc.act_no = 5
            npc:SetBit(5) -- Set shootable bit
        end
    end

    if (npc.ym > 6) then
        npc.ym = 6
    end

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Counter Bomb
ModCS.Npc.Act[206] = function(npc)
    local hit = npc:GetHitbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.count1 = 120
        npc.act_wait = ModCS.Game.Random(0, 50)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait >= 50) then
            npc.act_wait = 0
            npc.act_no = 2
            npc.ym = 1.5
        end
    elseif (npc.act_no == 2) then
        if (npc.tgt_mc.x > npc.x - 80 and npc.tgt_mc.x < npc.x + 80) then
            npc.act_wait = 0
            npc.act_no = 3
        end

        if (npc:IsHit()) then
            npc.act_wait = 0
            npc.act_no = 3
        end
    elseif (npc.act_no == 3) then
        -- Interestingly, this NPC counts down at 60 frames
        -- per second, while NPC322 (Deleet) counts at 50.
        if (npc.act_wait == 0) then
            ModCS.Npc.Spawn2(207, npc.x + 16, npc.y + 4, 0, 0, 0)
        elseif (npc.act_wait == (60 * 1)) then
            ModCS.Npc.Spawn2(207, npc.x + 16, npc.y + 4, 0, 0, 1)
        elseif (npc.act_wait == (60 * 2)) then
            ModCS.Npc.Spawn2(207, npc.x + 16, npc.y + 4, 0, 0, 2)
        elseif (npc.act_wait == (60 * 3)) then
            ModCS.Npc.Spawn2(207, npc.x + 16, npc.y + 4, 0, 0, 3)
        elseif (npc.act_wait == (60 * 4)) then
            ModCS.Npc.Spawn2(207, npc.x + 16, npc.y + 4, 0, 0, 4)
        elseif (npc.act_wait == (60 * 5)) then
            hit.back = 128
            hit.front = 128
            hit.top = 100
            hit.bottom = 100
            npc.damage = 30
            ModCS.Sound.Play(35)
            ModCS.Npc.Explode(npc.x, npc.y, 128, 100)
            ModCS.Camera.SetQuake(20)
            npc:KillOnNextFrame()
        end

        npc.act_wait = npc.act_wait + 1
    end

    if (npc.act_no > 1) then
        if (npc.tgt_y < npc.y) then
            npc.ym = npc.ym - 0.03125
        end

        if (npc.tgt_y > npc.y) then
            npc.ym = npc.ym + 0.03125
        end

        if (npc.ym > 0.5) then
            npc.ym = 0.5
        end

        if (npc.ym < -0.5) then
            npc.ym = -0.5
        end
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(80, 80, 120, 120),
        ModCS.Rect.Create(120, 80, 160, 120),
        ModCS.Rect.Create(160, 80, 200, 120),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 4) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    npc:SetHitbox(hit)
    npc:SetRect(rect_left[npc.ani_no+1])
end

-- Counter Bomb's countdown
ModCS.Npc.Act[207] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 144, 16, 160),
        ModCS.Rect.Create(16, 144, 32, 160),
        ModCS.Rect.Create(32, 144, 48, 160),
        ModCS.Rect.Create(48, 144, 64, 160),
        ModCS.Rect.Create(64, 144, 80, 160),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = npc.direct
        ModCS.Sound.Play(43)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.x = npc.x + 1

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_wait = 0
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.cond = 0
            return
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Basu (destroyed Egg Corridor)
ModCS.Npc.Act[208] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(248, 80, 272, 104),
        ModCS.Rect.Create(272, 80, 296, 104),
        ModCS.Rect.Create(296, 80, 320, 104),
    }

    local rcRight = {
        ModCS.Rect.Create(248, 104, 272, 128),
        ModCS.Rect.Create(272, 104, 296, 128),
        ModCS.Rect.Create(296, 104, 320, 128),
    }

    if (npc.act_no == 0) then
        if (npc.tgt_mc.x < npc.x + 16 and npc.tgt_mc.x > npc.x - 16) then
            npc:SetBit(5) -- Set shootable bit
            npc.ym = -1
            npc.tgt_x = npc.x
            npc.tgt_y = npc.y
            npc.act_no = 1
            npc.act_wait = 0
            npc.count1 = npc.direct
            npc.count2 = 0
            npc.damage = 6

            if (npc.direct == 0) then
                npc.x = npc.tgt_mc.x + 256
                npc.xm = -1.498046875
            else
                npc.x = npc.tgt_mc.x - 256
                npc.xm = 1.498046875
            end

            return
        end

        npc:SetRect(ModCS.Rect.Create(0, 0, 0, 0))
        npc.damage = 0
        npc.xm = 0
        npc.ym = 0
        npc:UnsetBit(5) -- Unset shootable bit
        return
    elseif (npc.act_no == 1) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
            npc.xm = npc.xm - 0.03125
        else
            npc.direct = 2
            npc.xm = npc.xm + 0.03125
        end

        if (npc:TouchLeftWall()) then
            npc.xm = 1
        end

        if (npc:TouchRightWall()) then
            npc.xm = -1
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.015625
        else
            npc.ym = npc.ym - 0.015625
        end

        if (npc.xm > 1.498046875) then
            npc.xm = 1.498046875
        end

        if (npc.xm < -1.498046875) then
            npc.xm = -1.498046875
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

        if (npc.tgt_mc.x > npc.x + 400 or npc.tgt_mc.x < npc.x - 400) then
            npc.act_no = 0
            npc.xm = 0
            npc.direct = npc.count1
            npc.x = npc.tgt_x
            npc:SetRect(ModCS.Rect.Create(0, 0, 0, 0))
            npc.damage = 0
            return
        end
    end

    if (npc.act_no ~= 0) then
        if (npc.act_wait < 150) then
            npc.act_wait = npc.act_wait + 1
        end

        if (npc.act_wait == 150) then
            npc.count2 = npc.count2 + 1
            if (npc.count2 % 8 == 0 and npc.x < npc.tgt_mc.x + 160 and npc.x > npc.tgt_mc.x - 160) then
                local deg = 0
                local xm = 0
                local ym = 0

                deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
                deg = deg + ModCS.Game.Random(-6, 6)
                ym = ModCS.Triangle.GetSin(deg) * 3
                xm = ModCS.Triangle.GetCos(deg) * 3
                ModCS.Npc.Spawn2(209, npc.x, npc.y, xm, ym, 0)
                ModCS.Sound.Play(39)
            end

            if (npc.count2 > 16) then
                npc.act_wait = 0
                npc.count2 = 0
            end
        end
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    if (npc.act_wait > 120 and math.floor(npc.act_wait / 2) % 2 == 1 and npc.ani_no == 1) then
        npc.ani_no = 2
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Basu projectile (destroyed Egg Corridor)
ModCS.Npc.Act[209] = function(npc)
    if (npc:TouchTile()) then
        npc.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(232, 96, 248, 112),
        ModCS.Rect.Create(200, 112, 216, 128),
        ModCS.Rect.Create(216, 112, 232, 128),
        ModCS.Rect.Create(232, 112, 248, 128),
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
        npc.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end
end

-- Beetle (destroyed Egg Corridor)
ModCS.Npc.Act[210] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(16, 112, 32, 128),
    }

    local rcRight = {
        ModCS.Rect.Create(32, 112, 48, 128),
        ModCS.Rect.Create(48, 112, 64, 128),
    }

    if (npc.act_no == 0) then
        if (npc.tgt_mc.x < npc.x + 16 and npc.tgt_mc.x > npc.x - 16) then
            npc:SetBit(5) -- Set shootable bit
            npc.ym = -1
            npc.tgt_y = npc.y
            npc.act_no = 1
            npc.damage = 2

            if (npc.direct == 0) then
                npc.x = npc.tgt_mc.x + 256
                npc.xm = -1.498046875
            else
                npc.x = npc.tgt_mc.x - 256
                npc.xm = 1.498046875
            end
        else
            npc:UnsetBit(5) -- Unset shootable bit
            npc:SetRect(ModCS.Rect.Create(0, 0, 0, 0))
            npc.damage = 0
            npc.xm = 0
            npc.ym = 0
            return
        end
    elseif (npc.act_no == 1) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
            npc.xm = npc.xm - 0.03125
        else
            npc.direct = 2
            npc.xm = npc.xm + 0.03125
        end

        if (npc.xm > 1.498046875) then
            npc.xm = 1.498046875
        end

        if (npc.xm < -1.498046875) then
            npc.xm = -1.498046875
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

        if (npc:IsHit()) then
            npc.x = npc.x + (npc.xm / 2)
            npc.y = npc.y + (npc.ym / 2)
        else
            npc:Move()
        end
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Spikes (small)
ModCS.Npc.Act[211] = function(npc)
    local rects = {
        ModCS.Rect.Create(256, 200, 272, 216),
        ModCS.Rect.Create(272, 200, 288, 216),
        ModCS.Rect.Create(288, 200, 304, 216),
        ModCS.Rect.Create(304, 200, 320, 216),
    }

    npc:SetRect(rects[npc.event+1])
end

-- Sky Dragon
ModCS.Npc.Act[212] = function(npc)
    local rcRight = {
        ModCS.Rect.Create(160, 152, 200, 192),
        ModCS.Rect.Create(200, 152, 240, 192),
        ModCS.Rect.Create(240, 112, 280, 152),
        ModCS.Rect.Create(280, 112, 320, 152),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 4
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 30) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 2
        npc.ani_wait = 0
        npc.tgt_y = npc.y - 16
        npc.tgt_x = npc.x - 6
        npc.ym = 0
        npc:SetBit(3) -- Set ignore tile collision bit
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.x < npc.tgt_x) then
            npc.xm = npc.xm + 0.015625
        else
            npc.xm = npc.xm - 0.015625
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.015625
        else
            npc.ym = npc.ym - 0.015625
        end

        npc:Move()

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no +1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc:SetBit(3) -- Set ignore tile collision bit
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.03125
        else
            npc.ym = npc.ym - 0.03125
        end

        npc.xm = npc.xm + 0.0625

        if (npc.xm > 3) then
            npc.xm = 3
        end

        if (npc.xm < -3) then
            npc.xm = -3
        end

        npc:Move()

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        ModCS.Npc.Spawn3(297, 0, 0, 0, 0, 0, npc)
    end

    rect = rcRight[npc.ani_no+1]

    -- Use different sprite if player is wearing the Mimiga Mask
    if (ModCS.Player.HasEquipped(ModCS.Const.EQUIP_MIMIGA_MASK)) then
        if (npc.ani_no > 1) then
            rect.top = rect.top + 40
            rect.bottom = rect.bottom + 40
        end
    end

    npc:SetRect(rect)
end

-- Night Spirit
ModCS.Npc.Act[213] = function(npc)
    local rect = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(0, 0, 48, 48),
        ModCS.Rect.Create(48, 0, 96, 48),
        ModCS.Rect.Create(96, 0, 144, 48),
        ModCS.Rect.Create(144, 0, 192, 48),
        ModCS.Rect.Create(192, 0, 240, 48),
        ModCS.Rect.Create(240, 0, 288, 48),
        ModCS.Rect.Create(0, 48, 48, 96),
        ModCS.Rect.Create(48, 48, 96, 96),
        ModCS.Rect.Create(96, 48, 144, 96),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.tgt_mc.y > npc.y - 8 and npc.tgt_mc.y < npc.y + 8) then
            if (npc.direct == 0) then
                npc.y = npc.y - 240
            else
                npc.y = npc.y + 240
            end

            npc.act_no = 10
            npc.act_wait = 0
            npc.ani_no = 1
            npc.ym = 0
            npc:SetBit(5) -- Set shootable bit
        end
    elseif (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 1
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 200) then
            npc.act_no = 20
            npc.act_wait = 0
            npc.ani_no = 4
        end
    elseif (npc.act_no == 20) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 6) then
            npc.ani_no = 4
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 30
            npc.act_wait = 0
            npc.ani_no = 7
        end
    elseif (npc.act_no == 30) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 9) then
            npc.ani_no = 7
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 5 == 1) then
            ModCS.Npc.Spawn2(214, npc.x, npc.y, ModCS.Game.Random2(2, 12) / 4, ModCS.Game.Random2(-1, 1), 0)
            ModCS.Sound.Play(21)
        end

        if (npc.act_wait > 50) then
            npc.act_no = 10
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 40) then
        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.125
        else
            npc.ym = npc.ym - 0.125
        end

        if (npc.ym < -2) then
            npc.ym = -2
        end

        if (npc.ym > 2) then
            npc.ym = 2
        end

        if (npc:IsHit()) then
            npc.y = npc.y + (npc.ym / 2)
        else
            npc:Move()
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no +1
        end

        if (npc.ani_no > 6) then
            npc.ani_no = 4
        end

        if (npc.tgt_mc.y < npc.tgt_y + 240 and npc.tgt_mc.y > npc.tgt_y - 240) then
            npc.act_no = 20
            npc.act_wait = 0
            npc.ani_no = 4
        end
    end

    if (npc.act_no >= 10 and npc.act_no <= 30) then
        if (npc.y < npc.tgt_mc.y) then
            npc.ym = npc.ym + 0.048828125
        else
            npc.ym = npc.ym - 0.048828125
        end

        if (npc.ym < -2) then
            npc.ym = -2
        end

        if (npc.ym > 2) then
            npc.ym = 2
        end

        if (npc:TouchCeiling()) then
            npc.ym = 1
        end

        if (npc:TouchFloor()) then
            npc.ym = -1
        end

        if (npc:IsHit()) then
            npc.y = npc.y + (npc.ym / 2)
        else
            npc:Move()
        end

        if (npc.tgt_mc.y > npc.tgt_y + 240 or npc.tgt_mc.y < npc.tgt_y - 240) then
            npc.act_no = 40
        end
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Night Spirit projectile
ModCS.Npc.Act[214] = function(npc)
    local rect = {
        ModCS.Rect.Create(144, 48, 176, 64),
        ModCS.Rect.Create(176, 48, 208, 64),
        ModCS.Rect.Create(208, 48, 240, 64),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc:SetBit(3) -- Set ignore tile collision bit
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end

        npc.xm = npc.xm - 0.048828125

        npc:Move()

        if (npc.xm < 0) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        if (npc:TouchTile()) then
            ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 4)
            ModCS.Sound.Play(28)
            npc.cond = 0
        end
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Sandcroc (Outer Wall)
ModCS.Npc.Act[215] = function(npc)
    if (npc.act_no == 0) then
        npc.ani_no = 0
        npc.act_no = 1
        npc.act_wait = 0
        npc.tgt_y = npc.y
        npc:UnsetBit(5) -- Unset shootable bit
        npc:UnsetBit(2) -- Unset invulnerable bit
        npc:UnsetBit(0) -- Unset 'solid soft' bit
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TriggerBox(12, 0, 12, 8)) then
            npc.act_no = 15
            npc.act_wait = 0
        end
    elseif (npc.act_no == 15) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            ModCS.Sound.Play(102)
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_no = npc.ani_no + 1
            npc.ani_wait = 0
        end

        if (npc.ani_no == 3) then
            npc.damage = 15
        end

        if (npc.ani_no == 4) then
            npc:SetBit(5) -- Set shootable bit
            npc.act_no = 30
            npc.act_wait = 0
        end
    elseif (npc.act_no == 30) then
        npc:SetBit(0) -- Set 'solid soft' bit
        npc.damage = 0
        npc.act_wait = npc.act_wait + 1

        if (npc:IsHit()) then
            npc.act_no = 40
            npc.act_wait = 0
        end
    elseif (npc.act_no == 40) then
        npc:SetBit(3) -- Set ignore tile collision bit
        npc.y = npc.y + 1
        
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 32) then
            npc:UnsetBit(0) -- Unset 'solid soft' bit
            npc:UnsetBit(5) -- Unset shootable bit
            npc.act_no = 50
            npc.act_wait = 0
        end
    elseif (npc.act_no == 50) then
        if (npc.act_wait < 100) then
            npc.act_wait = npc.act_wait + 1
        else
            npc.y = npc.tgt_y
            npc.ani_no = 0
            npc.act_no = 0
        end
    end

    local rect = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(0, 96, 48, 128),
        ModCS.Rect.Create(48, 96, 96, 128),
        ModCS.Rect.Create(96, 96, 144, 128),
        ModCS.Rect.Create(144, 96, 192, 128),
    }

    npc:SetRect(rect[npc.ani_no+1])
end

-- Debug Cat
ModCS.Npc.Act[216] = function(npc)
    local rect = ModCS.Rect.Create(256, 192, 272, 216)
    npc:SetRect(rect)
end

-- Itoh
ModCS.Npc.Act[217] = function(npc)
    local rect = {
        ModCS.Rect.Create(144, 64, 160, 80),
        ModCS.Rect.Create(160, 64, 176, 80),
        ModCS.Rect.Create(176, 64, 192, 80),
        ModCS.Rect.Create(192, 64, 208, 80),
        ModCS.Rect.Create(144, 80, 160, 96),
        ModCS.Rect.Create(160, 80, 176, 96),
        ModCS.Rect.Create(144, 80, 160, 96),
        ModCS.Rect.Create(176, 80, 192, 96),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.xm = 0
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
    elseif (npc.act_no == 10) then
        npc.ani_no = 2
        npc.xm = 0
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.ani_no = 2
        npc.xm = npc.xm + 1
        npc.ym = npc.ym - 2
    elseif (npc.act_no == 21) then
        if (npc:TouchFloor()) then
            npc.ani_no = 3
            npc.act_no = 30
            npc.act_wait = 0
            npc.xm = 0
            npc.tgt_x = npc.x
        end
    elseif (npc.act_no == 30) then
        npc.ani_no = 3

        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x + 1
        else
            npc.x = npc.tgt_x
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.ym = -1
        npc.ani_no = 2
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        if (npc:TouchFloor()) then
            npc.act_no = 42
            npc.ani_no = 4
        end
    elseif (npc.act_no == 42) then
        npc.xm = 0
        npc.ani_no = 4
    elseif (npc.act_no == 50) then
        npc.act_no = 51
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 51) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 32) then
            npc.act_no = 42
        end

        npc.xm = 1

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 7) then
            npc.ani_no = 4
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rect[npc.ani_no+1])
end

-- Core giant energy ball projectile
ModCS.Npc.Act[218] = function(npc)
    local rc = {
        ModCS.Rect.Create(256, 120, 288, 152),
        ModCS.Rect.Create(288, 120, 320, 152),
    }

    npc:Move()

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 200) then
        npc.cond = 0
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Smoke generator
ModCS.Npc.Act[219] = function(npc)
    local rc = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.direct == 0) then
        if (ModCS.Game.Random(0, 40) == 1) then
            ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-20, 20), npc.y, 0, -1, 0)
        end
    else
        ModCS.Npc.Spawn2(199, npc.x + ModCS.Game.Random(-160, 160), npc.y + ModCS.Game.Random(-128, 128), 0, 0, 2)
    end

    npc:SetRect(rc)
end