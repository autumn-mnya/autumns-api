-- Grate
ModCS.Npc.Act[100] = function(npc)
    local rc = {
        ModCS.Rect.Create(272, 48, 288, 64),
        ModCS.Rect.Create(272, 48, 288, 64),
    }

    if (npc.act_no == 0) then
        npc.y = npc.y + 16
        npc.act_no = 1
    end

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
    else
        npc:SetRect(rc[2])
    end
end

-- Malco computer screen
ModCS.Npc.Act[101] = function(npc)
    local rect = {
        ModCS.Rect.Create(240, 136, 256, 152),
        ModCS.Rect.Create(240, 136, 256, 152),
        ModCS.Rect.Create(256, 136, 272, 152),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 3) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Malco computer wave
ModCS.Npc.Act[102] = function(npc)
    local rect = {
        ModCS.Rect.Create(208, 120, 224, 136),
        ModCS.Rect.Create(224, 120, 240, 136),
        ModCS.Rect.Create(240, 120, 256, 136),
        ModCS.Rect.Create(256, 120, 272, 136),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 8
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 0) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 3) then
        npc.ani_no = 0
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Mannan projectile
ModCS.Npc.Act[103] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(192, 96, 208, 120),
        ModCS.Rect.Create(208, 96, 224, 120),
        ModCS.Rect.Create(224, 96, 240, 120),
    }

    local rcRight = {
        ModCS.Rect.Create(192, 120, 208, 144),
        ModCS.Rect.Create(208, 120, 224, 144),
        ModCS.Rect.Create(224, 120, 240, 144),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end
    
    if (npc.act_no == 1) then
        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.0625
        else
            npc.xm = npc.xm + 0.0625
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    npc.count1 = npc.count1 + 1
    if (npc.count1 > 100) then
        npc.cond = 0
    end

    if (npc.count1 % 4 == 1) then
        ModCS.Sound.Play(46)
    end
end

-- Frog
ModCS.Npc.Act[104] = function(npc)
    local bJump = false

    local rcLeft = {
        ModCS.Rect.Create(0, 112, 32, 144),
        ModCS.Rect.Create(32, 112, 64, 144),
        ModCS.Rect.Create(64, 112, 96, 144),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 144, 32, 176),
        ModCS.Rect.Create(32, 144, 64, 176),
        ModCS.Rect.Create(64, 144, 96, 176),
    }

    if (npc.act_no == 0) then
        local skipEnd = false
        npc.act_no = 1
        npc.act_wait = 0
        npc.xm = 0
        npc.ym = 0

        if (npc.direct == 4) then
            if (ModCS.Game.Random(0, 1)) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            npc:SetBit(3) -- Set ignore collision bit
            npc.ani_no = 2
            npc.act_no = 3
            skipEnd = true
        end

        if (skipEnd == false) then
            npc:UnsetBit(3) -- Unset ignore collision bit
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1

        if (ModCS.Game.Random(0, 50) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 0
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc.act_wait > 18) then
            npc.act_no = 1
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc:UnsetBit(3) -- Unset ignore collision bit
        end

        if (npc:TouchFloor()) then
            npc.act_no = 0
            npc.ani_no = 0
            npc.act_wait = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc:TouchLeftWall() and npc.xm < 0) then
            npc.xm = npc.xm * -1
            npc.direct = 2
        end

        if (npc:TouchRightWall() and npc.xm > 0) then
            npc.xm = npc.xm * -1
            npc.direct = 0
        end

        if (npc:TouchFloor()) then
            npc.act_no = 0
            npc.ani_no = 0
            npc.act_wait = 0
        end
    end

    bJump = false

    if (npc.act_no < 10 and npc.act_no ~= 3 and npc.act_wait > 10) then
        if (npc:IsHit()) then
            bJump = true
        end

        if (npc:TriggerBox(160, 64, 160, 64)) then
            if (ModCS.Game.Random(0, 50) == 2) then
                bJump = true
            end
        end
    end

    if (bJump) then
        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        npc.act_no = 10
        npc.ani_no = 2
        npc.ym = -2.998046875

        if not npc.tgt_mc.CheckCond(2) then
            ModCS.Sound.Play(30)
        end

        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end
    end

    npc.ym = npc.ym + 0.25
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

-- "HEY!" speech bubble (low)
ModCS.Npc.Act[105] = function(npc)
    local rect = {
        ModCS.Rect.Create(128, 32, 144, 48),
        ModCS.Rect.Create(128, 32, 128, 32),
    }

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 30) then
        npc.cond = 0
    end

    if (npc.act_wait < 5) then
        npc.y = npc.y - 1
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- "HEY!" speech bubble (high)
ModCS.Npc.Act[106] = function(npc)
    if (npc.act_no == 0) then
        ModCS.Npc.Spawn2(105, npc.x, npc.y - 8, 0, 0, 0) -- Spawns the normal "HEY" bubble, just 8px higher
        npc.act_no = 1
    end
end

-- Malco
ModCS.Npc.Act[107] = function(npc)
    local i = 0

    if (npc.act_no == 0) then
        npc.act_no = 1
        
        if (npc.direct == 2) then
            npc.ani_no = 5
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        npc.ani_wait = 0

        for i = 0, 3 do
            ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            ModCS.Sound.Play(43)
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_no = 12
        end
    elseif (npc.act_no == 12) then
        npc.act_no = 13
        npc.act_wait = 0
        npc.ani_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 13) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 14
        end
    elseif (npc.act_no == 14) then
        npc.act_no = 15
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 15) then
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.x + 1
            ModCS.Sound.Play(11)
        else
            npc.x = npc.x - 1
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 16
        end
    elseif (npc.act_no == 16) then
        npc.act_no = 17
        npc.act_wait = 0
        npc.ani_no = 2
        ModCS.Sound.Play(12)

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end
        -- Fallthrough
    end

    if (npc.act_no == 17) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 150) then
            npc.act_no = 18
        end
    elseif (npc.act_no == 18) then
        npc.act_no = 19
        npc.act_wait = 0
        npc.ani_no = 3
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 19) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            ModCS.Sound.Play(11)
            npc.ani_no = 3
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_no = 20
            ModCS.Sound.Play(12)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end
    elseif (npc.act_no == 20) then
        npc.ani_no = 4
    elseif (npc.act_no == 21) then
        npc.act_no = 22
        npc.ani_no = 5
        ModCS.Sound.Play(51)
    elseif (npc.act_no == 100) then
        npc.act_no = 101
        npc.ani_no = 6
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 101) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 9) then
            npc.ani_no = 6
        end
    elseif (npc.act_no == 110) then
        ModCS.Npc.Explode(npc.x, npc.y, 16, 16)
        npc.cond = 0
    end

    local rcPoweron = {
        ModCS.Rect.Create(144, 0, 160, 24),
        ModCS.Rect.Create(160, 0, 176, 24),
        ModCS.Rect.Create(176, 0, 192, 24),
        ModCS.Rect.Create(192, 0, 208, 24),
        ModCS.Rect.Create(208, 0, 224, 24),
        ModCS.Rect.Create(224, 0, 240, 24),
        ModCS.Rect.Create(176, 0, 192, 24),
        ModCS.Rect.Create(192, 0, 208, 24),
        ModCS.Rect.Create(208, 0, 224, 24),
        ModCS.Rect.Create(192, 0, 208, 24),
    }

    npc:SetRect(rcPoweron[npc.ani_no+1])
end

-- Balfrog projectile
ModCS.Npc.Act[108] = function(npc)
    if (npc:TouchTile()) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(96, 48, 112, 64),
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(128, 48, 144, 64),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no +1 
    end

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

-- Malco (broken)
ModCS.Npc.Act[109] = function(npc)
    local i = 0

    local rcLeft = {
        ModCS.Rect.Create(240, 0, 256, 24),
        ModCS.Rect.Create(256, 0, 272, 24),
    }

    local rcRight = {
        ModCS.Rect.Create(240, 24, 256, 48),
        ModCS.Rect.Create(256, 24, 272, 48),
    }

    if (npc.act_no == 0) then
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait ~= 0) then
            npc.act_no = 1
        end
        
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
    elseif (npc.act_no == 10) then
        npc.act_no = 0
        ModCS.Sound.Play(12)

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
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

-- Puchi
ModCS.Npc.Act[110] = function(npc)
    local bJump = false

    local rcLeft = {
        ModCS.Rect.Create(96, 128, 112, 144),
        ModCS.Rect.Create(112, 128, 128, 144),
        ModCS.Rect.Create(128, 128, 144, 144),
    }

    local rcRight = {
        ModCS.Rect.Create(96, 144, 112, 160),
        ModCS.Rect.Create(112, 144, 128, 160),
        ModCS.Rect.Create(128, 144, 144, 160),
    }

    if (npc.act_no == 0) then
        local skipEnd = false
        npc.act_no = 1
        npc.act_wait = 0
        npc.xm = 0
        npc.ym = 0

        if (npc.direct == 4) then
            if (ModCS.Game.Random(0, 1)) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            npc:SetBit(3) -- Set ignore collision bit
            npc.ani_no = 2
            npc.act_no = 3
            skipEnd = true
        end

        if (skipEnd == false) then
            npc:UnsetBit(3) -- Unset ignore collision bit
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1

        if (ModCS.Game.Random(0, 50) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 0
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc.act_wait > 18) then
            npc.act_no = 1
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc:UnsetBit(3) -- Unset ignore collision bit
        end

        if (npc:TouchFloor()) then
            npc.act_no = 0
            npc.ani_no = 0
            npc.act_wait = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc:TouchLeftWall() and npc.xm < 0) then
            npc.xm = npc.xm * -1
            npc.direct = 2
        end

        if (npc:TouchRightWall() and npc.xm > 0) then
            npc.xm = npc.xm * -1
            npc.direct = 0
        end

        if (npc:TouchFloor()) then
            npc.act_no = 0
            npc.ani_no = 0
            npc.act_wait = 0
        end
    end

    bJump = false

    if (npc.act_no < 10 and npc.act_no ~= 3 and npc.act_wait > 10) then
        if (npc:IsHit()) then
            bJump = true
        end

        if (npc:TriggerBox(160, 64, 160, 64)) then
            if (ModCS.Game.Random(0, 50) == 2) then
                bJump = true
            end
        end
    end

    if (bJump) then
        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        npc.act_no = 10
        npc.ani_no = 2
        npc.ym = -1.498046875
        ModCS.Sound.Play(6)

        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end
    end

    npc.ym = npc.ym + 0.25
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

-- Quote (teleport out)
ModCS.Npc.Act[111] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)
    local hit = npc:GetHitbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.y = npc.y - 16
    elseif (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_wait = 0
            npc.act_no = 2
            npc.ani_no = 1
            npc.ym = -1.498046875
        end
    elseif (npc.act_no == 2) then
        if (npc.ym > 0) then
            hit.bottom = 16
        end

        if (npc:TouchFloor()) then
            npc.act_no = 3
            npc.act_wait = 0
            npc.ani_no = 0
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_no = 4
            npc.act_wait = 64
            ModCS.Sound.Play(29)
        end
    elseif (npc.act_no == 4) then
        npc.act_wait = npc.act_wait - 1
        npc.ani_no = 0

        if (npc.act_wait == 0) then
            npc.cond = 0
        end
    end

    npc.ym = npc.ym + 0.125
    npc:Move()

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    -- Use a different sprite if the player is wearing the Mimiga Mask
    if (npc.tgt_mc.HasEquipped(ModCS.Const.EQUIP_MIMIGA_MASK)) then
        rect.top = rect.top + 32
        rect.bottom = rect.bottom + 32
    end

    if (npc.act_no == 4) then
        rect.bottom = rect.top + (npc.act_wait / 4)

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            rect.left = rect.left + 1
        end
    end

    npc:SetHitbox(hit)
    npc:SetRect(rect)
end

-- Quote (teleport in)
ModCS.Npc.Act[112] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)
    local hit = npc:GetHitbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.x = npc.x + 16
        npc.y = npc.y + 8
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
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 3
            npc.ani_no = 1
            hit.bottom = 8
        end
    elseif (npc.act_no == 3) then
        if (npc:TouchFloor()) then
            npc.act_no = 4
            npc.act_wait = 0
            npc.ani_no = 0
        end
    end

    npc.ym = npc.ym + 0.125
    
    npc:Move()

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    -- Use a different sprite if the player is wearing the Mimiga Mask
    if (npc.tgt_mc.HasEquipped(ModCS.Const.EQUIP_MIMIGA_MASK)) then
        rect.top = rect.top + 32
        rect.bottom = rect.bottom + 32
    end

    if (npc.act_no == 1) then
        rect.bottom = rect.top + (npc.act_wait / 4)

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            rect.left = rect.left + 1
        end
    end

    npc:SetHitbox(hit)
    npc:SetRect(rect)
end

-- Professor Booster
ModCS.Npc.Act[113] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(224, 0, 240, 16),
        ModCS.Rect.Create(240, 0, 256, 16),
        ModCS.Rect.Create(256, 0, 272, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
        ModCS.Rect.Create(272, 0, 288, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
        ModCS.Rect.Create(288, 0, 304, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(224, 16, 240, 32),
        ModCS.Rect.Create(240, 16, 256, 32),
        ModCS.Rect.Create(256, 16, 272, 32),
        ModCS.Rect.Create(224, 16, 240, 32),
        ModCS.Rect.Create(272, 16, 288, 32),
        ModCS.Rect.Create(224, 16, 240, 32),
        ModCS.Rect.Create(288, 16, 304, 32),
    }

    local hit = npc:GetHitbox()
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

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
    elseif (npc.act_no == 3) then
        npc.act_no = 4
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
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
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.ani_no = 0
        npc.ani_wait = 0
        hit.bottom = 16
        npc.x = npc.x - 16
        npc.y = npc.y + 8
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 64) then
            npc.act_no = 32
            npc.act_wait = 0
        end
    elseif (npc.act_no == 32) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 33
            npc.ani_no = 1
            hit.bottom = 8
        end
    elseif (npc.act_no == 33) then
        if (npc:TouchFloor()) then
            npc.act_no = 34
            npc.act_wait = 0
            npc.ani_no = 0
        end
    end

    npc.ym = npc.ym + 0.125

    npc:Move()

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 31) then
        rect.bottom = rect.top + (npc.act_wait / 4)
        
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            rect.left = rect.left + 1
        end
    end

    npc:SetHitbox(hit)
    npc:SetRect(rect)
end

-- Press
ModCS.Npc.Act[114] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(144, 112, 160, 136),
        ModCS.Rect.Create(160, 112, 176, 136),
        ModCS.Rect.Create(176, 112, 192, 136),
    }

    local i = 0

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 4
        -- Fallthrough
    end

    if (npc.act_no == 1) then
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
            npc:UnsetBit(6) -- Unset 'npc is solid' bit
            npc.damage = 127
        else
            npc:SetBit(6) -- Set 'npc is solid' bit
            npc.damage = 0
        end

        if (npc:TouchFloor()) then
            if (npc.ani_no > 1) then
                for i = 0, 3 do
                    ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
                end

                ModCS.Sound.Play(26)
                ModCS.Camera.SetQuake(10)
            end

            npc.act_no = 1
            npc.ani_no = 0
            npc.damage = 0
            npc:SetBit(6) -- Set 'npc is solid' bit
        end
    end

    npc.ym = npc.ym + 0.0625
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Ravil
ModCS.Npc.Act[115] = function(npc)
    local i = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 120, 24, 144),
        ModCS.Rect.Create(24, 120, 48, 144),
        ModCS.Rect.Create(48, 120, 72, 144),
        ModCS.Rect.Create(72, 120, 96, 144),
        ModCS.Rect.Create(96, 120, 120, 144),
        ModCS.Rect.Create(120, 120, 144, 144),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 144, 24, 168),
        ModCS.Rect.Create(24, 144, 48, 168),
        ModCS.Rect.Create(48, 144, 72, 168),
        ModCS.Rect.Create(72, 144, 96, 168),
        ModCS.Rect.Create(96, 144, 120, 168),
        ModCS.Rect.Create(120, 144, 144, 168),
    }

    if (npc.act_no == 0) then
        npc.xm = 0
        npc.act_no = 1
        npc.act_wait = 0
        npc.count1 = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TriggerBox(96, 96, 96, 32)) then
            npc.act_no = 10
        end

        if (npc:IsHit()) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.ani_no = 1

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_wait = 0
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.damage = 0
        npc.xm = 0

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            if (npc.direct == 0) then
                npc.xm = -1
            else
                npc.xm = 1
            end

            npc.count1 = npc.count1 + 1
            if (npc.count1 > 2) then
                npc.count1 = 0
                npc.ani_no = 4
                npc.act_no = 21
                npc.ym = -2
                npc.xm = npc.xm * 2
                npc.damage = 5
                ModCS.Sound.Play(102)
            else
                npc.act_no = 21
                npc.ym = -2
                ModCS.Sound.Play(30)
            end
        end
    elseif (npc.act_no == 21) then
        if (npc:TouchFloor()) then
            ModCS.Sound.Play(23)
            npc.act_no = 20
            npc.ani_no = 1
            npc.ani_wait = 0
            npc.damage = 0
            
            if not (npc:TriggerBox(144, 144, 144, 48)) then
                npc.act_no = 0
            end
        end
    elseif (npc.act_no == 30) then
        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, npc.x + (ModCS.Game.Random(-12, 12)), npc.y + (ModCS.Game.Random(-12, 12)), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        npc.ani_no = 0
        npc.act_no = 0
    elseif (npc.act_no == 50) then
        npc.act_on = 51
        npc.ani_no = 4
        npc.damage = 0
        npc.ym = -1
        npc:UnsetBit(0)
        npc:UnsetBit(5)
        ModCS.Sound.Play(51)
        -- Fallthrough
    end

    if (npc.act_no == 51) then
        if (npc:TouchFloor()) then
            ModCS.Sound.Play(23)
            npc.act_no = 52
            npc.ani_no = 5
            npc.xm = 0
        end
    end

    if (npc.act_no > 50) then
        npc.ym = npc.ym + 0.0625
    else
        npc.ym = npc.ym + 0.125
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

-- Red petals
ModCS.Npc.Act[116] = function(npc)
    local rc = ModCS.Rect.Create(272, 184, 320, 200)
    npc:SetRect(rc)
end

-- Curly
ModCS.Npc.Act[117] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(16, 96, 32, 112),
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(32, 96, 48, 112),
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(176, 96, 192, 112),
        ModCS.Rect.Create(112, 96, 128, 112),
        ModCS.Rect.Create(160, 96, 176, 112),
        ModCS.Rect.Create(144, 96, 160, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(16, 112, 32, 128),
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(32, 112, 48, 128),
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(176, 112, 192, 128),
        ModCS.Rect.Create(112, 112, 128, 128),
        ModCS.Rect.Create(160, 112, 176, 128),
        ModCS.Rect.Create(144, 112, 160, 128),
        ModCS.Rect.Create(48, 112, 64, 128),
    }

    if (npc.act_no == 0) then
        if (npc.direct == 4) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end

        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.xm = 0
        npc.ym = npc.ym + 0.125
    elseif (npc.act_no == 3) then
        npc.act_no = 4
        npc.ani_no = 1
        npc.ani_wait = 0
        -- Fallthrough
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

        npc.ym = npc.ym + 0.125

        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end
    elseif (npc.act_no == 5) then
        npc.act_no = 6
        npc.ani_no = 5
        ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
    elseif (npc.act_no == 6) then
        npc.ani_no = 5
    elseif (npc.act_no == 10) then
        npc.act_no = 11
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

        if (npc.tgt_mc.x < npc.x + 20 and npc.tgt_mc.x > npc.x - 20) then
            npc.act_no = 0
        end
    elseif (npc.act_no == 20) then
        npc.xm = 0
        npc.ani_no = 6
    elseif (npc.act_no == 21) then
        npc.xm = 0
        npc.ani_no = 9
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0
        npc.ym = -2
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.ani_no = 7

        if (npc.direct == 0) then
            npc.xm = 1
        else
            npc.xm = -1
        end

        npc.ym = npc.ym + 0.125

        if (npc.act_wait ~= 0 and npc:TouchFloor()) then
            npc.act_no = 32
        end

        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 32) then
        npc.ym = npc.ym + 0.125
        npc.ani_no = 8
        npc.xm = 0
    elseif (npc.act_no == 70) then
        npc.act_no = 71
        npc.act_wait = 0
        npc.ani_no = 1
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

        if (npc.ani_no > 4) then
            npc.ani_no = 1
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

-- Curly (boss)
ModCS.Npc.Act[118] = function(npc)
    local bUpper = false

    local rcLeft = {
        ModCS.Rect.Create(0, 32, 32, 56),
        ModCS.Rect.Create(32, 32, 64, 56),
        ModCS.Rect.Create(64, 32, 96, 56),
        ModCS.Rect.Create(96, 32, 128, 56),
        ModCS.Rect.Create(0, 32, 32, 56),
        ModCS.Rect.Create(128, 32, 160, 56),
        ModCS.Rect.Create(0, 32, 32, 56),
        ModCS.Rect.Create(0, 32, 32, 56),
        ModCS.Rect.Create(160, 32, 192, 56),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 56, 32, 80),
        ModCS.Rect.Create(32, 56, 64, 80),
        ModCS.Rect.Create(64, 56, 96, 80),
        ModCS.Rect.Create(96, 56, 128, 80),
        ModCS.Rect.Create(0, 56, 32, 80),
        ModCS.Rect.Create(128, 56, 160, 80),
        ModCS.Rect.Create(0, 56, 32, 80),
        ModCS.Rect.Create(0, 56, 32, 80),
        ModCS.Rect.Create(160, 56, 192, 80),
    }

    bUpper = false

    if (npc.direct == 0 and npc.x < npc.tgt_mc.x) then
        bUpper = true
    end

    if (npc.direct == 2 and npc.x > npc.tgt_mc.x) then
        bUpper = true
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = ModCS.Game.Random(50, 100)
        npc.ani_no = 0

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc:SetBit(5) -- Set shootable bit
        npc:UnsetBit(2) -- Unset invulnerable bit
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc.act_no = 13
        end
    elseif (npc.act_no == 13) then
        npc.act_no = 14
        npc.ani_no = 3
        npc.act_wait = ModCS.Game.Random(50, 100)

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 14) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 6) then
            npc.ani_no = 3
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.125
        else
            npc.xm = npc.xm + 0.125
        end

        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc:SetBit(5) -- Set shootable bit
            npc.act_no = 20
            npc.act_wait = 0
            ModCS.Sound.Play(103)
        end
    elseif (npc.act_no == 20) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.xm = (npc.xm * 8) / 9

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 21
            npc.act_wait = 0
        end
    elseif (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 4 == 1) then
            if (npc.direct == 0) then
                if (bUpper) then
                    npc.ani_no = 2
                    ModCS.Npc.Spawn2(123, npc.x, npc.y - 8, 0, 0, 1)
                else
                    npc.ani_no = 0
                    ModCS.Npc.Spawn2(123, npc.x - 8, npc.y + 4, 0, 0, 0)
                    npc.x = npc.x + 1
                end
            else
                if (bUpper) then
                    npc.ani_no = 2
                    ModCS.Npc.Spawn2(123, npc.x, npc.y - 8, 0, 0, 1)
                else
                    npc.ani_no = 0
                    ModCS.Npc.Spawn2(123, npc.x + 8, npc.y + 4, 0, 0, 2)
                    npc.x = npc.x - 1
                end
            end
        end

        if (npc.act_wait > 30) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 30) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 8) then
            npc.ani_no = 7
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 10
            npc.ani_no = 0
        end
    end

    if (npc.act_no > 10 and npc.act_no < 30 and ModCS.Arms.CountBullet(6) ~= 0) then
        npc.act_wait = 0
        npc.act_no = 30
        npc.ani_no = 7
        npc:UnsetBit(5) -- Unset shootable bit
        npc:SetBit(2) -- Set invulnerable bit
        npc.xm = 0
    end

    npc.ym = npc.ym + 0.0625

    if (npc.xm > 0.998046875) then
        npc.xm = 0.998046875
    end

    if (npc.xm < -0.998046875) then
        npc.xm = -0.998046875
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

-- Table and chair
ModCS.Npc.Act[119] = function(npc)
    local rc = ModCS.Rect.Create(248, 184, 272, 200)
    npc:SetRect(rc)
end