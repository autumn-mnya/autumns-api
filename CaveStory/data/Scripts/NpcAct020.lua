-- Computer
ModCS.Npc.Act[20] = function(npc)
    local rcLeft = ModCS.Rect.Create(288, 16, 320, 40)

    local rcRight = {
        ModCS.Rect.Create(288, 40, 320, 64),
        ModCS.Rect.Create(288, 40, 320, 64),
        ModCS.Rect.Create(288, 64, 320, 88),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 3) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight[npc.ani_no + 1])
    end
end

-- Chest (open)
ModCS.Npc.Act[21] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 2) then
            npc.y = npc.y + 16
        end
    end

    local rect = ModCS.Rect.Create(224, 40, 240, 48)
    npc:SetRect(rect)
end

-- Teleporter
ModCS.Npc.Act[22] = function(npc)
    local rect = {
        ModCS.Rect.Create(240, 16, 264, 48),
        ModCS.Rect.Create(248, 152, 272, 184),
    }

    if (npc.act_no == 0) then
        npc.ani_no = 0
    elseif (npc.act_no == 1) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    npc:SetRect(rect[npc.ani_no + 1])
end

-- Teleporter Lights
ModCS.Npc.Act[23] = function(npc)
    local rect = {
        ModCS.Rect.Create(264, 16, 288, 20),
        ModCS.Rect.Create(264, 20, 288, 24),
        ModCS.Rect.Create(264, 24, 288, 28),
        ModCS.Rect.Create(264, 28, 288, 32),
        ModCS.Rect.Create(264, 32, 288, 36),
        ModCS.Rect.Create(264, 36, 288, 40),
        ModCS.Rect.Create(264, 40, 288, 44),
        ModCS.Rect.Create(264, 44, 288, 48),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 7) then
        npc.ani_no = 0
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Power Critter
ModCS.Npc.Act[24] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 24, 24),
        ModCS.Rect.Create(24, 0, 48, 24),
        ModCS.Rect.Create(48, 0, 72, 24),
        ModCS.Rect.Create(72, 0, 96, 24),
        ModCS.Rect.Create(96, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 144, 24),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 24, 24, 48),
        ModCS.Rect.Create(24, 24, 48, 48),
        ModCS.Rect.Create(48, 24, 72, 48),
        ModCS.Rect.Create(72, 24, 96, 48),
        ModCS.Rect.Create(96, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 144, 48),
    }

    if (npc.act_no == 0) then
        npc.y = npc.y + 3
        npc.act_no = 1
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        if (npc.act_wait >= 8 and npc:TriggerBox(128, 128, 128, 48)) then
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

        if (npc.act_wait >= 8 and npc:TriggerBox(96, 96, 96, 48)) then
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
            ModCS.Sound.Play(108)
            
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            if (npc.direct == 0) then
                npc.xm = -0.5
            else
                npc.xm = 0.5
            end
        end
    elseif (npc.act_no == 3) then
        if (npc.ym > 1) then
            npc.tgt_y = npc.y
            npc.act_no = 4
            npc.ani_no = 3
            npc.act_wait = 0
        end
    elseif (npc.act_no == 4) then
        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        npc.act_wait = npc.act_wait + 1

        if (npc:HitFlag(7) or npc.act_wait > 100) then
            npc.damage = 12
            npc.act_no = 5
            npc.ani_no = 2
            npc.xm = npc.xm / 2
        end

        if (npc.act_wait % 4 == 1) then
            ModCS.Sound.Play(110)
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 3
        end
    elseif (npc.act_no == 5) then
        if (npc:TouchFloor()) then
            npc.damage = 2
            npc.xm = 0
            npc.act_wait = 0
            npc.ani_no = 0
            npc.act_no = 1
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(30)
        end
    end

    if (npc.act_no ~= 4) then
        npc.ym = npc.ym + 0.0625
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end
    else
        if (npc.x < npc.tgt_mc.x) then
            npc.xm = npc.xm + 0.0625
        else
            npc.xm = npc.xm - 0.0625
        end

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
        npc:SetRect(rcLeft[npc.ani_no + 1])
    else
        npc:SetRect(rcRight[npc.ani_no + 1])
    end
end

-- Egg Corridor Lift
ModCS.Npc.Act[25] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(256, 64, 288, 80),
        ModCS.Rect.Create(256, 80, 288, 96),
    }

    local liftLength = 0x40
    local liftDelay = 150

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.x = npc.x + 8
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > liftDelay) then
            npc.act_wait = 0
            npc.act_no = npc.act_no + 1
        end
    elseif (npc.act_no == 2) then -- Identical to case 4
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait <= liftLength) then
            npc.y = npc.y - 1
        else
            npc.act_wait = 0
            npc.act_no = npc.act_no + 1
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > liftDelay) then
            npc.act_wait = 0
            npc.act_no = npc.act_no + 1
        end
    elseif (npc.act_no == 4) then -- Identical to case 2
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait <= liftLength) then
            npc.y = npc.y - 1
        else
            npc.act_wait = 0
            npc.act_no = npc.act_no + 1
        end
    elseif (npc.act_no == 5) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > liftDelay) then
            npc.act_wait = 0
            npc.act_no = npc.act_no + 1
        end
    elseif (npc.act_no == 6) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait <= liftLength) then
            npc.y = npc.y + 1
        else
            npc.act_wait = 0
            npc.act_no = npc.act_no + 1
        end
    elseif (npc.act_no == 7) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > liftDelay) then
            npc.act_wait = 0
            npc.act_no = npc.act_no + 1
        end
    elseif (npc.act_no == 8) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait <= liftLength) then
            npc.y = npc.y + 1
        else
            npc.act_wait = 0
            npc.act_no = 1
        end
    end

    if (npc.act_no == 2 or npc.act_no == 4 or npc.act_no == 6 or npc.act_no == 8) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Bat (Grasstown, flying)
ModCS.Npc.Act[26] = function(npc)
    local deg = 0

    if (npc.act_no == 0) then
        deg = ModCS.Game.Random(0, 0xFF)
        npc.xm = ModCS.Triangle.GetCos(deg)
        deg = deg + 0x40
        npc.tgt_x = npc.x + ModCS.Triangle.GetCos(deg) * 8

        deg = ModCS.Game.Random(0, 0xFF)
        npc.ym = ModCS.Triangle.GetSin(deg)
        deg = deg + 0x40
        npc.tgt_y = npc.y + ModCS.Triangle.GetSin(deg) * 8

        npc.act_no = 1
        npc.count1 = 120
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
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

        if (npc.count1 < 120) then
            npc.count1 = npc.count1 + 1
        else
            if (npc:TriggerBox(8, 0, 8, 96)) then
                npc.xm = npc.xm / 2
                npc.ym = 0
                npc.act_no = 3
                npc:UnsetBit(3) -- Ignore collision unchecked
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
            npc:SetBit(3) -- Ignore collision checked
        end
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(48, 80, 64, 96),
        ModCS.Rect.Create(64, 80, 80, 96),
        ModCS.Rect.Create(80, 80, 96, 96),
    }

    local rect_right = {
        ModCS.Rect.Create(32, 96, 48, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
        ModCS.Rect.Create(64, 96, 80, 112),
        ModCS.Rect.Create(80, 96, 96, 112),
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
        npc:SetRect(rect_left[npc.ani_no + 1])
    else
        npc:SetRect(rect_right[npc.ani_no + 1])
    end
end

-- Death trap
ModCS.Npc.Act[27] = function(npc)
    local rcLeft = ModCS.Rect.Create(96, 64, 128, 88)
    npc:SetRect(rcLeft)
end

-- Flying Critter (Grasstown)
ModCS.Npc.Act[28] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
        ModCS.Rect.Create(32, 48, 48, 64),
        ModCS.Rect.Create(48, 48, 64, 64),
        ModCS.Rect.Create(64, 48, 80, 64),
        ModCS.Rect.Create(80, 48, 96, 64),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 64, 16, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
        ModCS.Rect.Create(32, 64, 48, 80),
        ModCS.Rect.Create(48, 64, 64, 80),
        ModCS.Rect.Create(64, 64, 80, 80),
        ModCS.Rect.Create(80, 64, 96, 80),
    }

    if (npc.act_no == 0) then
        npc.y = npc.y + 3
        npc.act_no = 1
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        if (npc.act_wait >= 8 and npc:TriggerBox(128, 128, 128, 48)) then
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

        if (npc.act_wait >= 8 and npc:TriggerBox(96, 96, 96, 48)) then
            npc.act_no = 2
            npc.ani_no = 0
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 3
            npc.ani_no = 2
            npc.ym = -2.3984375
            ModCS.Sound.Play(30)

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            if (npc.direct == 0) then
                npc.xm = -0.5
            else
                npc.xm = 0.5
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
        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        npc.act_wait = npc.act_wait + 1

        if (npc:HitFlag(7) or npc.act_wait > 100) then
            npc.damage = 3
            npc.act_no = 5
            npc.ani_no = 2
            npc.xm = npc.xm / 2
            return
        end

        if (npc.act_wait % 4 == 1) then
            ModCS.Sound.Play(109)
        end

        if (npc:TouchFloor()) then
            npc.ym = -1
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 3
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
        npc.ym = npc.ym + 0.125
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end
    else
        if (npc.x < npc.tgt_mc.x) then
            npc.xm = npc.xm + 0.0625
        else
            npc.xm = npc.xm - 0.0625
        end

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
        npc:SetRect(rcLeft[npc.ani_no + 1])
    else
        npc:SetRect(rcRight[npc.ani_no + 1])
    end
end

-- Cthulhu
ModCS.Npc.Act[29] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 192, 16, 216),
        ModCS.Rect.Create(16, 192, 32, 216),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 216, 16, 240),
        ModCS.Rect.Create(16, 216, 32, 240),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        if (npc:TriggerBox(48, 48, 48, 16)) then
            npc.ani_no = 1
        else
            npc.ani_no = 0
        end
    end
    
    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no + 1])
    else
        npc:SetRect(rcRight[npc.ani_no + 1])
    end
end

-- Gunsmith
ModCS.Npc.Act[30] = function(npc)
    local rc = {
        ModCS.Rect.Create(48, 0, 64, 16),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(0, 32, 16, 48),
    }

    if (npc.direct == 0) then
        if (npc.act_no == 0) then
            npc.act_no = 1
            npc.ani_no = 0
            npc.ani_wait = 0
            -- Fallthrough to npc.act_no 1, so dont elseif here
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
    else
        if (npc.act_no == 0) then
            npc.act_no = 1
            npc.y = npc.y + 16
            npc.ani_no = 2
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_wait = 0
            ModCS.Caret.Spawn(ModCS.Const.CARET_ZZZ, npc.x, npc.y - 2, 0) -- Spawn "ZZZ" caret
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Bat (Grasstown, hanging)
ModCS.Npc.Act[31] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(48, 80, 64, 96),
        ModCS.Rect.Create(64, 80, 80, 96),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(16, 96, 32, 112),
        ModCS.Rect.Create(32, 96, 48, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
        ModCS.Rect.Create(64, 96, 80, 112),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end

        if (npc:TriggerBox(8, 8, 8, 96)) then
            npc.ani_no = 0
            npc.act_no = 3
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 3) then
        npc.ani_no = 0

        if (npc:IsHit() or (npc.x - 20) > npc.tgt_mc.x or (npc.x + 20) < npc.tgt_mc.x) then
            npc.ani_no = 1
            npc.ani_wait = 0
            npc.act_no = 4
            npc.act_wait = 0
        end
    elseif (npc.act_no == 4) then
        npc.ym = npc.ym + 0.0625
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait < 20 and not npc:TouchFloor()) then
            --nothing
        else
            if (npc:TouchFloor() or npc.y > (npc.tgt_mc.y - 16)) then
                npc.ani_wait = 0
                npc.ani_no = 2
                npc.act_no = 5
                npc.tgt_y = npc.y

                if (npc:TouchFloor()) then
                    npc.ym = -1
                end
            end
        end
    elseif (npc.act_no == 5) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 2
        end

        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.tgt_mc.x < npc.x) then
            npc.xm = npc.xm - 0.03125
        end

        if (npc.tgt_mc.x > npc.x) then
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

        if (npc:TouchFloor()) then
            npc.ym = -1
        end

        if (npc:TouchCeiling()) then
            npc.ym = 1
        end
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no + 1])
    else
        npc:SetRect(rcRight[npc.ani_no + 1])
    end
end

-- Life capsule
ModCS.Npc.Act[32] = function(npc)
    local rect = {
        ModCS.Rect.Create(32, 96, 48, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Balrog bouncing projectile
ModCS.Npc.Act[33] = function(npc)
    if (npc:TouchLeftWall() or npc:TouchRightWall()) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    elseif (npc:TouchFloor()) then
        npc.ym = -2
    end

    npc.ym = npc.ym + 0.08203125

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(240, 64, 256, 80),
        ModCS.Rect.Create(240, 80, 256, 96),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    npc:SetRect(rect_left[npc.ani_no+1])

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 250) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 2)
        npc.cond = 0
    end
end

-- Bed
ModCS.Npc.Act[34] = function(npc)
    local rcLeft = ModCS.Rect.Create(192, 48, 224, 64)
    local rcRight = ModCS.Rect.Create(192, 184, 224, 200)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight)
    end
end

-- Mannan
ModCS.Npc.Act[35] = function(npc)
    if (npc.act_no < 3 and npc.life < 90) then
        ModCS.Sound.Play(71)
        ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
        ModCS.Npc.SpawnExp(npc.x, npc.y, npc.exp)
        npc.act_no = 3
        npc.act_wait = 0
        npc.ani_no = 2
        npc:UnsetBit(5)
        npc.damage = 0
    end

    if (npc.act_no == 0 or npc.act_no == 1) then
        if (npc:IsHit()) then
            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(103, npc.x - 8, npc.y + 8, 0, 0, npc.direct)
            else
                ModCS.Npc.Spawn2(103, npc.x + 8, npc.y + 8, 0, 0, npc.direct)
            end

            npc.ani_no = 1
            npc.act_no = 2
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_wait = 0
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 50 or npc.act_wait == 60) then
            npc.ani_no = 3
        end

        if (npc.act_wait == 53 or npc.act_wait == 63) then
            npc.ani_no = 2
        end

        if (npc.act_wait > 100) then
            npc.act_no = 4
        end
    end

    local rcLeft = {
        ModCS.Rect.Create(96, 64, 120, 96),
        ModCS.Rect.Create(120, 64, 144, 96),
        ModCS.Rect.Create(144, 64, 168, 96),
        ModCS.Rect.Create(168, 64, 192, 96),
    }

    local rcRight = {
        ModCS.Rect.Create(96, 96, 120, 128),
        ModCS.Rect.Create(120, 96, 144, 128),
        ModCS.Rect.Create(144, 96, 168, 128),
        ModCS.Rect.Create(168, 96, 192, 128),
    }

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Balrog (hover)
ModCS.Npc.Act[36] = function(npc)
    local i
    local deg
    local xm, ym

    -- ai code
    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 12) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.count1 = 3
            npc.ani_no = 1
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 16) then
            npc.count1 = npc.count1 - 1
            npc.act_wait = 0

            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, (npc.y + 4) - npc.tgt_mc.y)

            deg = deg + ModCS.Game.Random(-0x10, 0x10)
            ym = ModCS.Triangle.GetSin(deg)
            xm = ModCS.Triangle.GetCos(deg)

            ModCS.Npc.Spawn2(11, npc.x, npc.y + 4, xm, ym, 0)
            ModCS.Sound.Play(39)

            if (npc.count1 == 0) then
                npc.act_no = 3
                npc.act_wait = 0
            end
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3) then
            npc.act_no = 4
            npc.act_wait = 0
            npc.xm = (npc.tgt_mc.x - npc.x) / 100
            npc.ym = -3
            npc.ani_no = 3
        end
    elseif (npc.act_no == 4) then
        if (npc.ym > -1) then
            if (npc.life > 60) then
                npc.act_no = 5
                npc.ani_no = 4
                npc.ani_wait = 0
                npc.act_wait = 0
                npc.tgt_y = npc.y
            else
                npc.act_no = 6
            end
        end
    elseif (npc.act_no == 5) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 4
            ModCS.Sound.Play(47)
        end
        
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_no = 6
            npc.ani_no = 3
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.125
        else
            npc.ym = npc.ym - 0.125
        end
    elseif (npc.act_no == 6) then
        if ((npc.y + 16) < npc.tgt_mc.y) then
            npc.damage = 10
        else
            npc.damage = 0
        end

        if (npc:TouchFloor()) then
            npc.act_no = 7
            npc.act_wait = 0
            npc.ani_no = 2
            ModCS.Sound.Play(26)
            ModCS.Sound.Play(25)
            ModCS.Camera.SetQuake(30)
            npc.damage = 0

            for i = 0, 7 do
                ModCS.Npc.Spawn2(4, npc.x + (ModCS.Game.Random(-12, 12)), npc.y + (ModCS.Game.Random(-12, 12)), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end

            for i = 0, 7 do
                ModCS.Npc.Spawn2(33, npc.x + (ModCS.Game.Random(-12, 12)), npc.y + (ModCS.Game.Random(-12, 12)), ModCS.Game.Random2(-2, 2), ModCS.Game.Random2(-2, 0), 0)
            end
        end
    elseif (npc.act_no == 7) then
        npc.xm = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3) then
            npc.act_no = 1
            npc.act_wait = 0
        end
    end

    if (npc.act_no ~= 5) then
        npc.ym = npc.ym + (1 / 10)

        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end
    end

    -- speed limit here
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(40, 0, 80, 24),
        ModCS.Rect.Create(80, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 160, 24),
        ModCS.Rect.Create(160, 48, 200, 72),
        ModCS.Rect.Create(200, 48, 240, 72),
    }

    local rect_right = {
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(40, 24, 80, 48),
        ModCS.Rect.Create(80, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 160, 48),
        ModCS.Rect.Create(160, 72, 200, 96),
        ModCS.Rect.Create(200, 72, 240, 96),
    }

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Signpost
ModCS.Npc.Act[37] = function(npc)
    local rect = {
        ModCS.Rect.Create(192, 64, 208, 80),
        ModCS.Rect.Create(208, 64, 224, 80),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Fireplace
ModCS.Npc.Act[38] = function(npc)
    local rect = {
        ModCS.Rect.Create(128, 64, 144, 80),
        ModCS.Rect.Create(144, 64, 160, 80),
        ModCS.Rect.Create(160, 64, 176, 80),
        ModCS.Rect.Create(176, 64, 192, 80),
    }

    local rcNone = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 0
        end

        npc:SetRect(rect[npc.ani_no + 1])
    elseif(npc.act_no == 10) then
        npc.act_no = 11
        ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
        -- Fallthrough to npc.act_no 11, so dont elseif here
    end

    if (npc.act_no == 11) then
        npc:SetRect(rcNone)
    end
end

-- Save sign
ModCS.Npc.Act[39] = function(npc)
    local rect = {
        ModCS.Rect.Create(224, 64, 240, 80),
        ModCS.Rect.Create(240, 64, 256, 80),
    }

    if (npc.direct == 0) then
        npc.ani_no = 0
    else
        npc.ani_no = 1
    end

    npc:SetRect(rect[npc.ani_no + 1])
end