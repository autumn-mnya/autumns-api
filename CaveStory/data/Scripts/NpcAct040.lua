-- Santa
ModCS.Npc.Act[40] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
        ModCS.Rect.Create(32, 32, 48, 48),
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(48, 32, 64, 48),
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(64, 32, 80, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
        ModCS.Rect.Create(32, 48, 48, 64),
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(48, 48, 64, 64),
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(64, 48, 80, 64),
    }

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
        -- Fallthrough to npc.act_no 4, so dont elseif here
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
    elseif (npc.act_no == 5) then
        npc.ani_no = 6
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Busted Door
ModCS.Npc.Act[41] = function(npc)
    local rect = ModCS.Rect.Create(0, 80, 48, 112)

    if (npc.act_no == 0) then
        npc.act_no = npc.act_no + 1
        npc.y = npc.y - 16 -- Move one tile up
    end

    npc:SetRect(rect)
end

-- Sue
ModCS.Npc.Act[42] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(32, 0, 48, 16),
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(48, 0, 64, 16),
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(64, 0, 80, 16),
        ModCS.Rect.Create(80, 32, 96, 48),
        ModCS.Rect.Create(96, 32, 112, 48),
        ModCS.Rect.Create(128, 32, 144, 48),
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(112, 32, 128, 48),
        ModCS.Rect.Create(160, 32, 176, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(64, 16, 80, 32),
        ModCS.Rect.Create(80, 48, 96, 64),
        ModCS.Rect.Create(96, 48, 112, 64),
        ModCS.Rect.Create(128, 48, 144, 64),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(160, 48, 176, 64),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.xm = 0
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
    elseif (npc.act_no == 3) then
        npc.act_no = 4
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough to npc.act_no 4, so dont elseif here
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
            npc.xm = -1
        else
            npc.xm = 1
        end
    elseif (npc.act_no == 5) then
        npc.ani_no = 6
        npc.xm = 0
    elseif (npc.act_no == 6) then
        ModCS.Sound.Play(50)
        npc.act_wait = 0
        npc.act_no = 7
        npc.ani_no = 7
        -- Fallthrough to npc.act_no 7, so dont elseif here
    end
    
    if (npc.act_no == 7) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.act_no = 0
        end
    elseif (npc.act_no == 8) then
        ModCS.Sound.Play(50)
        npc.act_wait = 0
        npc.act_no = 9
        npc.ani_no = 7
        npc.ym = -1
        
        if (npc.direct == 0) then
            npc.xm = 2
        else
            npc.xm = -2
        end

        -- Fallthrough to npc.act_no 9, so dont elseif here
    end
    
    if (npc.act_no == 9) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3 and npc:TouchFloor()) then
            npc.act_no = 10

            if (npc.direct == 0) then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end
    elseif (npc.act_no == 10) then
        npc.xm = 0
        npc.ani_no = 8
    elseif (npc.act_no == 11) then
        npc.act_no = 12
        npc.act_wait = 0
        npc.ani_no = 9
        npc.ani_wait = 0
        npc.xm = 0
        -- Fallthrough to npc.act_no 12, so dont elseif here
    end
    
    if (npc.act_no == 12) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 8) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 10) then
            npc.ani_no = 9
        end
    elseif (npc.act_no == 13) then
        npc.ani_no = 11
        npc.xm = 0
        npc.ym = 0
        npc.act_no = 14

        local foundNpc = ModCS.Npc.GetByEvent(501)

        if not foundNpc then
            npc.act_no = 0
            return
        end

        npc.pNpc = foundNpc

        -- Fallthrough to npc.act_no 14, so dont elseif here
    end
    
    if (npc.act_no == 14) then
        if (npc.pNpc.direct == 0) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        if (npc.pNpc.direct == 0) then
            npc.x = npc.pNpc.x - 6
        else
            npc.x = npc.pNpc.x + 6
        end

        npc.y = npc.pNpc.y + 4

        if (npc.pNpc.ani_no == 2 or npc.pNpc.ani_no == 4) then
            npc.y = npc.y - 1
        end
    elseif (npc.act_no == 15) then
        npc.act_no = 16
        ModCS.Npc.Spawn2(257, npc.x + 128, npc.y, 0, 0, 0)
        ModCS.Npc.Spawn2(257, npc.x + 128, npc.y, 0, 0, 2)
        npc.xm = 0
        npc.ani_no = 0
        -- Fallthrough to npc.act_no 16, so dont elseif here
    end
    
    if (npc.act_no == 16) then
        ModCS.Npc.SetSuperX(npc.x - 24)
        ModCS.Npc.SetSuperY(npc.y - 8)
    elseif (npc.act_no == 17) then
        npc.xm = 0
        npc.ani_no = 12
        ModCS.Npc.SetSuperX(npc.x)
        ModCS.Npc.SetSuperY(npc.y - 8)
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough to npc.act_no 21, so dont elseif here
    end
    
    if (npc.act_no == 21) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end

        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end

        if (npc.x < npc.tgt_mc.x - 8) then
            npc.direct = 2
            npc.act_no = 0
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough to npc.act_no 31, so dont elseif here
    end
    
    if (npc.act_no == 31) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end

        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.ani_no = 9
        npc.ym = -2
    end

    if (npc.act_no ~= 14) then
        npc.ym = npc.ym + 0.125

        if (npc.xm > 2) then
            npc.xm = 2
        end

        if (npc.xm < -2) then
            npc.xm = -2
        end

        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Chalkboard
ModCS.Npc.Act[43] = function(npc)
    local rcLeft = ModCS.Rect.Create(128, 80, 168, 112)
    local rcRight = ModCS.Rect.Create(168, 80, 208, 112)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 16 -- Move up one tile
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight)
    end
end

-- Polish
ModCS.Npc.Act[44] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 32, 32),
        ModCS.Rect.Create(96, 0, 128, 32),
        ModCS.Rect.Create(128, 0, 160, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 0, 32, 32),
        ModCS.Rect.Create(32, 0, 64, 32),
        ModCS.Rect.Create(64, 0, 96, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        npc.ani_no = 0

        if (npc.direct == 0) then
            npc.act_no = 8
        else
            npc.act_no = 2
        end
        -- Fallthrough to npc.act_no 2, so dont elseif here
    end
    
    if (npc.act_no == 2) then
        npc.ym = npc.ym + 0.0625

        if (npc.ym > 0 and npc:TouchFloor()) then
            npc.ym = -0.5
            npc.xm = npc.xm + 0.5
        end

        if (npc:TouchRightWall()) then
            npc.act_no = 3
        end
    elseif (npc.act_no == 3) then
        npc.xm = npc.xm + 0.0625

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.xm = -0.5
            npc.ym = npc.ym - 0.5
        end

        if (npc:TouchCeiling()) then
            npc.act_no = 4
        end
    elseif (npc.act_no == 4) then
        npc.ym = npc.ym - 0.0625

        if (npc.ym < 0 and npc:TouchCeiling()) then
            npc.ym = 0.5
            npc.xm = npc.xm - 0.5
        end

        if (npc:TouchLeftWall()) then
            npc.act_no = 5
        end
    elseif (npc.act_no == 5) then
        npc.xm = npc.xm - 0.0625

        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.xm = 0.5
            npc.ym = npc.ym + 0.5
        end

        if (npc:TouchFloor()) then
            npc.act_no = 2
        end
    elseif (npc.act_no == 6) then
        npc.ym = npc.ym + 0.0625

        if (npc.ym > 0 and npc:TouchFloor()) then
            npc.ym = -0.5
            npc.xm = npc.xm - 0.5
        end

        if (npc:TouchLeftWall()) then
            npc.act_no = 7
        end
    elseif (npc.act_no == 7) then
        npc.xm = npc.xm - 0.0625

        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.xm = 0.5
            npc.ym = npc.ym - 0.5
        end

        if (npc:TouchCeiling()) then
            npc.act_no = 8
        end
    elseif (npc.act_no == 8) then
        npc.ym = npc.ym - 0.0625

        if (npc.ym < 0 and npc:TouchCeiling()) then
            npc.ym = 0.5
            npc.xm = npc.xm + 0.5
        end

        if (npc:TouchRightWall()) then
            npc.act_no = 9
        end
    elseif (npc.act_no == 9) then
        npc.xm = npc.xm + 0.0625

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.xm = -0.5
            npc.ym = npc.ym + 0.5
        end

        if (npc:TouchFloor()) then
            npc.act_no = 6
        end
    end

    if (npc.life <= 100) then
        local i

        for i = 0, 10 do
            ModCS.Npc.Spawn2(45, npc.x, npc.y, 0, 0, 0)
        end

        ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
        ModCS.Sound.Play(25)
        npc.cond = 0
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

    if (npc:IsHit()) then
        npc:Move3(npc.xm_cs / 2, npc.ym_cs / 2)
    else
        npc:Move()
    end

    npc.ani_no = npc.ani_no + 1
    if (npc.act_no >= 2 and npc.act_no <= 9 and npc.ani_no > 2) then
        npc.ani_no = 1
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Baby
ModCS.Npc.Act[45] = function(npc)
    local rect = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
        ModCS.Rect.Create(32, 32, 48, 48),
    }

    if (npc.act_no == 0) then
        npc.act_no = 2

        if (ModCS.Game.Random(0, 1) == 0) then
            npc.xm = ModCS.Game.Random2(-1, -0.5)
        else
            npc.xm = ModCS.Game.Random2(0.5, 1)
        end

        if (ModCS.Game.Random(0, 1) == 0) then
            npc.ym = ModCS.Game.Random2(-1, -0.5)
        else
            npc.ym = ModCS.Game.Random2(0.5, 1)
        end

        npc.xm2 = npc.xm
        npc.ym2 = npc.ym
        -- Fallthrough to npc.act_no 1/2, so dont elseif here
    end
    
    if (npc.act_no == 1 or npc.act_no == 2) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end
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

    if (npc.xm2 > 1) then
        npc.xm2 = 1
    end

    if (npc.xm2 < -1) then
        npc.xm2 = -1
    end

    if (npc.ym2 > 1) then
        npc.ym2 = 1
    end

    if (npc.ym2 < -1) then
        npc.ym2 = -1
    end

    if (npc:IsHit()) then
        npc:Move3(npc.xm2_cs, npc.ym2_cs)
    else
        npc:Move2()
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- H/V Trigger
ModCS.Npc.Act[46] = function(npc)
    local rect = ModCS.Rect.Create(0, 0, 16, 16)

    npc:SetBit(8) -- Run event when touched enabled

    if (npc.direct == 0) then
        if (npc.x < npc.tgt_mc.x) then
            npc.x = npc.x + 2.998046875
        else
            npc.x = npc.x - 2.998046875
        end
    else
        if (npc.y < npc.tgt_mc.y) then
            npc.y = npc.y + 2.998046875
        else
            npc.y = npc.y - 2.998046875
        end
    end

    npc:SetRect(rect)
end

-- Sandcroc
ModCS.Npc.Act[47] = function(npc)
    if (npc.act_no == 0) then
        npc.ani_no = 0
        npc.act_no = 1
        npc.act_wait = 0
        npc.tgt_y = npc.y
        npc:UnsetBit(5) -- Unset shootable bit
        npc:UnsetBit(2) -- Unset invulnearable
        npc:UnsetBit(0) -- Unset solid (soft) collision
        npc:UnsetBit(3) -- Unset ignoring tile collision
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        if (npc:TriggerBox(8, 0, 8, 8)) then
            npc.act_no = 2
            npc.act_wait = 0
            ModCS.Sound.Play(102)
        end

        if (npc.x < npc.tgt_mc.x) then
            npc.x = npc.x + 2
        end

        if (npc.x > npc.tgt_mc.x) then
            npc.x = npc.x - 2
        end
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_no = npc.ani_no + 1
            npc.ani_wait = 0
        end

        if (npc.ani_no == 3) then
            npc.damage = 10
        end

        if (npc.ani_no == 4) then
            npc:SetBit(5) -- Set shootable bit
            npc.act_no = 3
            npc.act_wait = 0
        end
    elseif (npc.act_no == 3) then
        npc:SetBit(0) -- Set solid (soft) bit
        npc.damage = 0
        npc.act_wait = npc.act_wait + 1

        if (npc:IsHit()) then
            npc.act_no = 4
            npc.act_wait = 0
        end
    elseif (npc.act_no == 4) then
        npc:SetBit(3) -- Set ignoring tile collision bit
        npc.y = npc.y + 1

        npc.act_wait = npc.act_wait + 1

        if (npc.act_wait == 32) then
            npc:UnsetBit(0) -- Unset solid (soft) bit
            npc:UnsetBit(5) -- Unset shootable bit
            npc.act_no = 5
            npc.act_wait = 0
        end
    elseif (npc.act_no == 5) then
        if (npc.act_wait < 100) then
            npc.act_wait = npc.act_wait + 1
        else
            npc.y = npc.tgt_y
            npc.ani_no = 0
            npc.act_no = 0
        end
    end

    local rect = {
        ModCS.Rect.Create(0, 48, 48, 80),
        ModCS.Rect.Create(48, 48, 96, 80),
        ModCS.Rect.Create(96, 48, 144, 80),
        ModCS.Rect.Create(144, 48, 192, 80),
        ModCS.Rect.Create(192, 48, 240, 80),
    }

    npc:SetRect(rect[npc.ani_no+1])
end

-- Omega projectiles
ModCS.Npc.Act[48] = function(npc)
    if (npc:TouchLeftWall() and npc.xm < 0) then
        npc.xm = npc.xm * -1
    elseif (npc:TouchRightWall() and npc.xm > 0) then
        npc.xm = npc.xm * -1
    elseif (npc:TouchFloor()) then
        npc.count1 = npc.count1 + 1
        if (npc.count1 > 2 and npc.direct == 2) then
            npc:Vanish()
            ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        else
            npc.ym = -0.5
        end
    end

    if (npc.direct == 2) then
        npc:UnsetBit(5)
        npc:SetBit(3)
    end

    npc.ym = npc.ym + 0.009765625

    npc:Move()

    local rcLeft = {
        ModCS.Rect.Create(288, 88, 304, 104),
        ModCS.Rect.Create(304, 88, 320, 104),
    }

    local rcRight = {
        ModCS.Rect.Create(288, 104, 304, 120),
        ModCS.Rect.Create(304, 104, 320, 120),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 750) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Skullhead
ModCS.Npc.Act[49] = function(npc)
    local deg
    local xm
    local ym

    if (npc.act_no >= 10 and npc.pNpc.id == 3) then
        npc.act_no = 3
        npc.xm = 0
        npc.ym = 0
        npc.count2 = 1
    end

    if (npc:TouchLeftWall()) then
        npc.direct = 2
        npc.xm = 0.5
    end

    if (npc:TouchRightWall()) then
        npc.direct = 0
        npc.xm = -0.5
    end

    if (npc.act_no == 0) then
        if (npc.pNpc ~= nil) then
            npc.ani_no = 1
            npc.act_no = 10
        else
            npc.act_no = 1
        end

        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3) then
            npc.ym = -2
            npc.act_no = 3
            npc.ani_no = 2

            if (npc.count2 ~= 0) then
                if (npc.direct == 0) then
                    npc.xm = -1
                else
                    npc.xm = 1
                end
            else
                if (npc.direct == 0) then
                    npc.xm = -0.5
                else
                    npc.xm = 0.5
                end
            end
        end

        npc.ani_no = 1
    elseif (npc.act_no == 3) then
        if (npc:TouchFloor()) then
            npc.act_no = 1
            npc.act_wait = 0
            npc.xm = 0
        end

        if (npc:TouchFloor() or npc.ym > 0) then
            npc.ani_no = 1
        else
            npc.ani_no = 2
        end
    elseif (npc.act_no == 10) then
        if (npc.count1 < 50) then
            npc.count1 = npc.count1 + 1
        else
            if (npc:TriggerBox(128, 96, 128, 96)) then
                npc.act_no = 11
                npc.act_wait = 0
                npc.ani_no = 2
            end
        end
    elseif (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30 or npc.act_wait == 35) then
            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, (npc.y + 4) - npc.tgt_mc.y)
            ym = ModCS.Triangle.GetSin(deg) * 2
            xm = ModCS.Triangle.GetCos(deg) * 2
            ModCS.Npc.Spawn2(50, npc.x, npc.y, xm, ym, 0)
            ModCS.Sound.Play(39)
        end

        if (npc.act_wait > 50) then
            npc.count1 = 0
            npc.act_no = 10
            npc.ani_no = 1
        end
    end

    if (npc.act_no >= 10) then
        npc.x = npc.pNpc.x
        npc.y = npc.pNpc.y + 16
        npc.direct = npc.pNpc.direct
        npc.pNpc.count1 = npc.pNpc.count1 - 1
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    local rcLeft = {
        ModCS.Rect.Create(0, 80, 32, 104),
        ModCS.Rect.Create(32, 80, 64, 104),
        ModCS.Rect.Create(64, 80, 96, 104),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 104, 32, 128),
        ModCS.Rect.Create(32, 104, 64, 128),
        ModCS.Rect.Create(64, 104, 96, 128),
    }

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Skeleton projectile
ModCS.Npc.Act[50] = function(npc)
    if (npc.act_no == 0) then
        if (npc.direct == 2) then
            npc.act_no = 2
        else
            npc.act_no = 1
        end
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        npc:Move()

        if (npc:TouchLeftWall()) then
            npc.act_no = 2
            npc.xm = 1
            npc.count1 = npc.count1 + 1
        end

        if (npc:TouchRightWall()) then
            npc.act_no = 2
            npc.xm = -1
            npc.count1 = npc.count1 + 1
        end

        if (npc:TouchCeiling()) then
            npc.act_no = 2
            npc.ym = 1
            npc.count1 = npc.count1 + 1
        end

        if (npc:TouchFloor()) then
            npc.act_no = 2
            npc.ym = -1
            npc.count1 = npc.count1 + 1
        end

    elseif (npc.act_no == 2) then
        npc.ym = npc.ym + 0.125

        npc:Move()

        if (npc:TouchFloor()) then
            npc.count1 = npc.count1 + 1
            if (npc.count1 > 1) then
                ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
                npc.cond = 0
            end
        end
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    if (npc.ym < -2.998046875) then
        npc.ym = -2.998046875
    end

    local rect = {
        ModCS.Rect.Create(48, 32, 64, 48),
        ModCS.Rect.Create(64, 32, 80, 48),
        ModCS.Rect.Create(80, 32, 96, 48),
        ModCS.Rect.Create(96, 32, 112, 48),
    }

    if (npc.direct == 0) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 0
        end
    else
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no - 1
        end

        if (npc.ani_no < 0) then
            npc.ani_no = 3
        end
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Crow & Skullhead
ModCS.Npc.Act[51] = function(npc)
    if (npc.act_no == 0) then
        if (npc:TriggerBox((ModCS.GetWindowWidth() / 2) + 160, (ModCS.GetWindowHeight() / 2) + 200, (ModCS.GetWindowWidth() / 2) + 160, (ModCS.GetWindowHeight() / 2) + 200)) then
            npc.tgt_x = npc.x
            npc.tgt_y = npc.y

            npc.ym = 2

            npc.act_no = 1
            ModCS.Npc.Spawn3(49, 0, 0, 0, 0, 0, npc)
        else
            return
        end

        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.tgt_y < npc.y) then
            npc.ym = npc.ym - 0.01953125
        end

        if (npc.tgt_y > npc.y) then
            npc.ym = npc.ym + 0.01953125
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        if (npc.count1 < 10) then
            npc.count1 = npc.count1 + 1
        else
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.y > (npc.tgt_mc.y + 32)) then
            if (npc.tgt_mc.x < npc.x) then
                npc.xm = npc.xm + 0.03125
            end

            if (npc.tgt_mc.x > npc.x) then
                npc.xm = npc.xm - 0.03125
            end
        else
            if (npc.tgt_mc.x < npc.x) then
                npc.xm = npc.xm - 0.03125
            end

            if (npc.tgt_mc.x > npc.x) then
                npc.xm = npc.xm + 0.03125
            end
        end

        if (npc.tgt_mc.y < npc.y) then
            npc.ym = npc.ym - 0.03125
        end

        if (npc.tgt_mc.y > npc.y) then
            npc.ym = npc.ym + 0.03125
        end

        if (npc:IsHit()) then
            npc.ym = npc.ym + 0.0625
            npc.xm = 0
        end
    end

    if (npc.xm < 0 and npc:TouchLeftWall()) then
        npc.xm = 0.5
    end

    if (npc.xm > 0 and npc:TouchRightWall()) then
        npc.xm = -0.5
    end

    if (npc.ym < 0 and npc:TouchCeiling()) then
        npc.ym = 0.5
    end

    if (npc.ym > 0 and npc:TouchFloor()) then
        npc.ym = -0.5
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

    local rect_left = {
        ModCS.Rect.Create(96, 80, 128, 112),
        ModCS.Rect.Create(128, 80, 160, 112),
        ModCS.Rect.Create(160, 80, 192, 112),
        ModCS.Rect.Create(192, 80, 224, 112),
        ModCS.Rect.Create(224, 80, 256, 112),
    }

    local rect_right = {
        ModCS.Rect.Create(96, 112, 128, 144),
        ModCS.Rect.Create(128, 112, 160, 144),
        ModCS.Rect.Create(160, 112, 192, 144),
        ModCS.Rect.Create(192, 112, 224, 144),
        ModCS.Rect.Create(224, 112, 256, 144),
    }

    if npc:IsHit() then
        npc.ani_no = 4
    elseif npc.act_no == 2 and npc.y < (npc.tgt_mc.y - 32) then
        npc.ani_no = 0
    else
        if npc.act_no ~= 0 then
            npc.ani_wait = npc.ani_wait + 1

            if npc.ani_wait > 1 then
                npc.ani_wait = 0
                npc.ani_no = npc.ani_no + 1
            end

            if npc.ani_no > 1 then
                npc.ani_no = 0
            end
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Blue robot (sitting)
ModCS.Npc.Act[52] = function(npc)
    local rect = ModCS.Rect.Create(240, 96, 256, 112)
    npc:SetRect(rect)
end

-- Skullstep leg
ModCS.Npc.Act[53] = function(npc)
    local deg = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 128, 24, 144),
        ModCS.Rect.Create(24, 128, 48, 144),
    }

    local rcRight = {
        ModCS.Rect.Create(48, 128, 72, 144),
        ModCS.Rect.Create(72, 128, 96, 144),
    }

    local back = npc:GetViewbox().back

    if (npc.pNpc.id == 3) then
        npc:Vanish()
        ModCS.Npc.Explode(npc.x, npc.y, back, 4)
        return
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.count1 = 10
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end

    if (npc.act_no == 1) then
        if (npc.direct == 0 and npc:HitFlag(0x20)) then
            npc.pNpc.y = npc.pNpc.y - 2
            npc.pNpc.ym = npc.pNpc.ym - 0.5
        end

        if (npc.direct == 2 and npc:HitFlag(0x10)) then
            npc.pNpc.y = npc.pNpc.y - 2
            npc.pNpc.ym = npc.pNpc.ym - 0.5
        end

        if (npc:TouchFloor()) then
            npc.pNpc.y = npc.pNpc.y - 2
            npc.pNpc.ym = npc.pNpc.ym - 0.5

            if (npc.pNpc.direct == 0) then
                npc.pNpc.xm = npc.pNpc.xm - 0.25
            else
                npc.pNpc.xm = npc.pNpc.xm + 0.25
            end
        end

        deg = (npc.xm_cs + npc.pNpc.count2) % 256

        npc:SetXY(npc.pNpc.x_cs + npc.count1 * ModCS.Triangle.GetCos2(deg), npc.pNpc.y_cs + npc.count1 * ModCS.Triangle.GetSin2(deg))

        npc.direct = npc.pNpc.direct
    end

    npc.direct = npc.pNpc.direct

    if (deg >= 20 and deg <= 108) then
        npc.ani_no = 0
    else
        npc.ani_no = 1
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Skullstep
ModCS.Npc.Act[54] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 80, 32, 104),
        ModCS.Rect.Create(32, 80, 64, 104),
        ModCS.Rect.Create(64, 80, 96, 104),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 104, 32, 128),
        ModCS.Rect.Create(32, 104, 64, 128),
        ModCS.Rect.Create(64, 104, 96, 128),
    }

    local deg = 0

    if (npc.act_no == 0) then
        ModCS.Npc.Spawn3(53, 0, 0, 0, 0, npc.direct, npc, 0x100)
        ModCS.Npc.Spawn3(53, 0, 0, 0.25, 0, npc.direct, npc, 0)
        npc.act_no = 1
        npc.ani_no = 1
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end

    if (npc.act_no == 1) then
        deg = npc.count2

        if (npc.direct == 0) then
            deg = deg - 6
        else
            deg = deg + 6
        end

        npc.count2 = deg

        if (npc:TouchFloor()) then
            npc.xm = (npc.xm * 3) / 4

            npc.act_wait = npc.act_wait + 1
            if (npc.act_wait > 60) then
                npc.act_no = 2
                npc.act_wait = 0
            end
        else
            npc.act_wait = 0
        end

        if (npc.direct == 0 and npc:TouchLeftWall()) then
            npc.count1 = npc.count1 + 1
            if (npc.count1 > 8) then
                npc.direct = 2
                npc.xm = npc.xm * -1
            end
        elseif (npc.direct == 2 and npc:TouchRightWall()) then
            npc.count1 = npc.count1 + 1
            if (npc.count1 > 8) then
                npc.direct = 0
                npc.xm = npc.xm * -1
            end
        else
            npc.count1 = 0
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        npc.shock = npc.shock + (npc.act_wait % 256)

        if (npc.act_wait > 50) then
            npc:Vanish()
            ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
            ModCS.Sound.Play(25)
        end
    end

    npc.ym = npc.ym + 0.25

    if (npc.xm > 1.498046875) then
        npc.xm = 1.498046875
    end

    if (npc.xm < -1.498046875) then
        npc.xm = -1.498046875
    end

    if (npc.ym > 1.498046875) then
        npc.ym = 1.498046875
    end

    if (npc.ym < -1.498046875) then
        npc.ym = -1.498046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Kazuma
ModCS.Npc.Act[55] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(192, 192, 208, 216),
        ModCS.Rect.Create(208, 192, 224, 216),
        ModCS.Rect.Create(192, 192, 208, 216),
        ModCS.Rect.Create(224, 192, 240, 216),
        ModCS.Rect.Create(192, 192, 208, 216),
        ModCS.Rect.Create(240, 192, 256, 216),
    }

    local rcRight = {
        ModCS.Rect.Create(192, 216, 208, 240),
        ModCS.Rect.Create(208, 216, 224, 240),
        ModCS.Rect.Create(192, 216, 208, 240),
        ModCS.Rect.Create(224, 216, 240, 240),
        ModCS.Rect.Create(192, 216, 208, 240),
        ModCS.Rect.Create(240, 216, 256, 240),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
    elseif (npc.act_no == 3) then
        npc.act_no = 4
        npc.ani_no = 1
        npc.ani_wait = 0
        -- Fallthrough to npc.act_no 4, so dont elseif here
    end

    if (npc.act_no == 4) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 1
        end

        if (npc.direct == 0) then
            npc.x = npc.x - 1
        else
            npc.x = npc.x + 1
        end
    elseif (npc.act_no == 5) then
        npc.ani_no = 5
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

-- Beetle (Sand Zone)
ModCS.Npc.Act[56] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 144, 16, 160),
        ModCS.Rect.Create(16, 144, 32, 160),
        ModCS.Rect.Create(32, 144, 48, 160),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 160, 16, 176),
        ModCS.Rect.Create(16, 160, 32, 176),
        ModCS.Rect.Create(32, 160, 48, 176),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.act_no = 1
        else
            npc.act_no = 3
        end
    elseif (npc.act_no == 1) then
        npc.xm = npc.xm - 0.03125

        if (npc.xm < -2) then
            npc.xm = -2
        end

        if (npc:IsHit()) then
            npc.x = npc.x + (npc.xm / 2)
        else
            npc.x = npc.x + npc.xm
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end

        if (npc:TouchLeftWall()) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 0
            npc.xm = 0
            npc.direct = 2
        end
    elseif (npc.act_no == 2) then
        if (npc.tgt_mc.x > npc.x and npc:TriggerBox(0, 8, 256, 8)) then
            npc.act_no = 3
            npc.ani_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 3) then
        npc.xm = npc.xm + 0.03125

        if (npc.xm > 2) then
            npc.xm = 2
        end

        if (npc:IsHit()) then
            npc.x = npc.x + (npc.xm / 2)
        else
            npc.x = npc.x + npc.xm
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end

        if (npc:TouchRightWall()) then
            npc.act_no = 4
            npc.act_wait = 0
            npc.ani_no = 0
            npc.xm = 0
            npc.direct = 0
        end
    elseif (npc.act_no == 4) then
        if (npc.tgt_mc.x < npc.x and npc:TriggerBox(256, 8, 0, 8)) then
            npc.act_no = 1
            npc.ani_wait = 0
            npc.ani_no = 1
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Crow
ModCS.Npc.Act[57] = function(npc)
    local deg = 0

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
        npc.ani_no = ModCS.Game.Random(0, 1)
        npc.ani_wait = ModCS.Game.Random(0, 4)
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

        if (npc:IsHit()) then
            npc.act_no = 2
            npc.act_wait = 0

            if (npc.direct == 2) then
                npc.xm = -1
            else
                npc.xm = 1
            end

            npc.ym = 0
        end
    elseif (npc.act_no == 2) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.y > npc.tgt_mc.y + 48) then
            if (npc.tgt_mc.x < npc.x) then
                npc.xm = npc.xm + 0.03125
            end

            if (npc.tgt_mc.x > npc.x) then
                npc.xm = npc.xm - 0.03125
            end
        else
            if (npc.tgt_mc.x < npc.x) then
                npc.xm = npc.xm - 0.03125
            end

            if (npc.tgt_mc.x >  npc.x) then
                npc.xm = npc.xm + 0.03125
            end
        end

        if (npc.tgt_mc.y < npc.y) then
            npc.ym = npc.ym - 0.03125
        end

        if (npc.tgt_mc.y > npc.y) then
            npc.ym = npc.ym + 0.03125
        end

        if (npc:IsHit()) then
            npc.ym = npc.ym + 0.0625
            npc.xm = 0
        end

        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.xm = 1
        end

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.xm = -1
        end

        if (npc.ym < 0 and npc:TouchCeiling()) then
            npc.ym = 1
        end

        if (npc.ym > 0 and npc:TouchFloor()) then
            npc.ym = -1
        end

        if (npc.xm > 2.998046875) then
            npc.xm = 2.998046875
        end

        if (npc.xm < -2.998046875) then
            npc.xm = -2.998046875
        end

        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        if (npc.ym < -2.998046875) then
            npc.ym = -2.998046875
        end
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(96, 80, 128, 112),
        ModCS.Rect.Create(128, 80, 160, 112),
        ModCS.Rect.Create(160, 80, 192, 112),
        ModCS.Rect.Create(192, 80, 224, 112),
        ModCS.Rect.Create(224, 80, 256, 112),
    }

    local rect_right = {
        ModCS.Rect.Create(96, 112, 128, 144),
        ModCS.Rect.Create(128, 112, 160, 144),
        ModCS.Rect.Create(160, 112, 192, 144),
        ModCS.Rect.Create(192, 112, 224, 144),
        ModCS.Rect.Create(224, 112, 256, 144),
    }

    if (npc:IsHit()) then
        npc.ani_no = 4
    else
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Basu (Egg Corridor)
ModCS.Npc.Act[58] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(192, 0, 216, 24),
        ModCS.Rect.Create(216, 0, 240, 24),
        ModCS.Rect.Create(240, 0, 264, 24),
    }

    local rcRight = {
        ModCS.Rect.Create(192, 24, 216, 48),
        ModCS.Rect.Create(216, 24, 240, 48),
        ModCS.Rect.Create(240, 24, 264, 48),
    }

    local rcNo = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        if (npc.tgt_mc.x < npc.x + 16 and npc.tgt_mc.x > npc.x - 16) then
            npc:SetBit(5) -- Set shootable
            npc.ym = -0.5
            npc.tgt_x = npc.x
            npc.tgt_y = npc.y
            npc.act_no = 1
            npc.act_wait = 0
            npc.count1 = npc.direct
            npc.count2 = 0
            npc.damage = 6

            if (npc.direct == 0) then
                npc.x = npc.tgt_mc.x + (16 * 0x10)
                npc.xm = -1.498046875
            else
                npc.x = npc.tgt_mc.x - (16 * 0x10)
                npc.xm = 1.498046875
            end

            return
        end

        npc:SetRect(rcNo)
        npc.damage = 0
        npc.xm = 0
        npc.ym = 0
        npc:UnsetBit(5) -- Unset shootable
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

        if (npc.ym > 0.5) then
            npc.ym = 0.5
        end

        if (npc.ym < -0.5) then
            npc.ym = -0.5
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
            npc:SetRect(rcNo)
            npc.damage = 0
            return
        end
    end

    if (npc.act_no ~= 0) then -- This is always true
        if (npc.act_wait < 150) then
            npc.act_wait = npc.act_wait + 1
        end

        if (npc.act_wait == 150) then
            npc.count2 = npc.count2 + 1
            if ((npc.count2 % 8 == 0) and npc.x < npc.tgt_mc.x + 160 and npc.x > npc.tgt_mc.x - 160) then
                local deg = 0
                local xm = 0
                local ym = 0

                deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
                deg = deg + (ModCS.Game.Random(-6, 6) % 256)
                ym = ModCS.Triangle.GetSin(deg) * 2
                xm = ModCS.Triangle.GetCos(deg) * 2
                ModCS.Npc.Spawn2(84, npc.x, npc.y, xm, ym, 0)
                ModCS.Sound.Play(39)
            end

            if (npc.count2 > 8) then
                npc.act_wait = 0
                npc.count2 = 0
            end
        end
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no +1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    if (npc.act_wait > 120 and (math.floor(npc.act_wait / 2) % 2 == 1) and npc.ani_no == 1) then
        npc.ani_no = 2
    end

    if (npc.act_no ~= 0) then
        if (npc.direct == 0) then
            npc:SetRect(rcLeft[npc.ani_no+1])
        else
            npc:SetRect(rcRight[npc.ani_no+1])
        end
    end
end

-- Eye door
ModCS.Npc.Act[59] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(224, 16, 240, 40),
        ModCS.Rect.Create(208, 80, 224, 104),
        ModCS.Rect.Create(224, 80, 240, 104),
        ModCS.Rect.Create(240, 80, 256, 104),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end

    if (npc.act_no == 1) then
        if npc:TriggerBox(64, 64, 64, 64) then
            npc.act_no = 2
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no == 2) then
            npc.act_no = 3
        end
    elseif (npc.act_no == 3) then
        if not npc:TriggerBox(64, 64, 64, 64) then
            npc.act_no = 4
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 4) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no - 1
        end

        if (npc.ani_no == 0) then
            npc.act_no = 1
        end
    end

    if (npc.ani_no < 0) then
        npc.ani_no = 0
    end

    if (npc.ani_no > 3) then
        npc.ani_no = 3
    end

    if (npc:IsHit()) then
        npc:SetRect(rcLeft[4])
    else
        npc:SetRect(rcLeft[npc.ani_no + 1])
    end
end