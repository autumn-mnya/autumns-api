-- Toroko
ModCS.Npc.Act[60] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 64, 16, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
        ModCS.Rect.Create(32, 64, 48, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
        ModCS.Rect.Create(48, 64, 64, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
        ModCS.Rect.Create(112, 64, 128, 80),
        ModCS.Rect.Create(128, 64, 144, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 80, 16, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(48, 80, 64, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(112, 80, 128, 96),
        ModCS.Rect.Create(128, 80, 144, 96),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.xm = 0
        --Fallthrough
    end

    if (npc.act_no == 1) then
        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end

        if (npc:TriggerBox(16, 16, 16, 16)) then
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
        npc.ani_no = 1
        npc.ani_wait = 0
        --Fallthrough
    end

    if (npc.act_no == 4) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 1
        end

        if (npc:TouchLeftWall()) then
            npc.direct = 2
            npc.xm = 1
        end

        if (npc:TouchRightWall()) then
            npc.direct = 0
            npc.xm = -1
        end

        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end
    elseif (npc.act_no == 6) then
        npc.act_no = 7
        npc.act_wait = 0
        npc.ani_no = 1
        npc.ani_wait = 0
        npc.ym = -2
        --Fallthrough
    end

    if (npc.act_no == 7) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 1
        end

        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end

        if (npc.act_wait ~= 0 and npc:TouchFloor()) then
            npc.act_no = 3
        end
        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 8) then
        npc.ani_no = 1
        npc.act_wait = 0
        npc.act_no = 9
        npc.ym = -1
        --Fallthrough
    end

    if (npc.act_no == 9) then
        if (npc.act_wait ~= 0 and npc:TouchFloor()) then
            npc.act_no = 0
        end
        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 6
        npc.ym = -2
        ModCS.Sound.Play(50)

        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end
    elseif (npc.act_no == 11) then
        if (npc.act_wait ~= 0 and npc:TouchFloor()) then
            npc.act_no = 12
            npc.ani_no = 7
            npc:SetBit(13) -- Interactable
        end
        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 12) then
        npc.xm = 0
    end

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

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- King
ModCS.Npc.Act[61] = function(npc)
    local i = 0

    local rcLeft = {
        ModCS.Rect.Create(224, 32, 240, 48),
        ModCS.Rect.Create(240, 32, 256, 48),
        ModCS.Rect.Create(256, 32, 272, 48),
        ModCS.Rect.Create(272, 32, 288, 48),
        ModCS.Rect.Create(288, 32, 304, 48),
        ModCS.Rect.Create(224, 32, 240, 48),
        ModCS.Rect.Create(304, 32, 320, 48),
        ModCS.Rect.Create(224, 32, 240, 48),
        ModCS.Rect.Create(272, 32, 288, 48),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(112, 32, 128, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(224, 48, 240, 64),
        ModCS.Rect.Create(240, 48, 256, 64),
        ModCS.Rect.Create(256, 48, 272, 64),
        ModCS.Rect.Create(272, 48, 288, 64),
        ModCS.Rect.Create(288, 48, 304, 64),
        ModCS.Rect.Create(224, 48, 240, 64),
        ModCS.Rect.Create(304, 48, 320, 64),
        ModCS.Rect.Create(224, 48, 240, 64),
        ModCS.Rect.Create(272, 48, 288, 64),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(112, 32, 128, 48),
    }

    if (npc.act_no == 0) then -- Stood
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
    elseif (npc.act_no == 2) then -- Blink
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 5) then -- Lying down
        npc.ani_no = 3
        npc.xm = 0
    elseif (npc.act_no == 6) then -- Being knocked-back
        npc.act_no = 7
        npc.act_wait = 0
        npc.ani_wait = 0
        npc.ym = -2
        -- Fallthrough
    end

    if (npc.act_no == 7) then
        npc.ani_no = 2

        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end

        -- If touching ground, enter 'lying down' state (the 'act_wait' check is probably
        -- so he doesn't do it before he even leaves the ground in the first place)
        if (npc.act_wait ~= 0 and npc:TouchFloor()) then
            npc.act_no = 5
        end
        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 8) then
        npc.act_no = 9
        npc.ani_no = 4
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 9) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 7) then
            npc.ani_no = 4
        end

        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end
    elseif (npc.act_no == 10) then -- Running
        npc.act_no = 11
        npc.ani_no = 4
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 7) then
            npc.ani_no = 4
        end

        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end
    elseif (npc.act_no == 20) then -- Spawn his sword, before entering his 'idle' state
        ModCS.Npc.Spawn3(145, 0, 0, 0, 0, 2, npc)
        npc.ani_no = 0
        npc.act_no = 0
    elseif (npc.act_no == 30) then -- Flying through air after being attacked by Misery
        npc.act_no = 31
        npc.act_wait = 0
        npc.ani_wait = 0
        npc.ym = 0
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.ani_no = 2

        if (npc.direct == 0) then
            npc.xm = -3
        else
            npc.xm = 3
        end 

        if (npc:TouchLeftWall()) then
            npc.direct = 2
            npc.act_no = 7
            npc.act_wait = 0
            npc.ani_wait = 0
            npc.ym = -2
            npc.xm = 1
            ModCS.Sound.Play(71)
            ModCS.Npc.Explode(npc.x, npc.y, 4, 4)
        end
    elseif (npc.act_no == 40) then -- Dying
        npc.act_no = 42
        npc.act_wait = 0
        npc.ani_no = 8
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 42) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 9) then
            npc.ani_no = 8
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end

            npc.act_no = 50
            npc.surf = 20 -- Set surface to NpcSym
            npc.ani_no = 10
        end
    elseif (npc.act_no == 60) then -- Leap (used to attack Balrog in the Sand Zone storehouse)
        npc.ani_no = 6
        npc.act_no = 61
        npc.ym = -2.998046875
        npc.xm = 2
        npc.count2 = 1
    elseif (npc.act_no == 61) then -- Leap - Part 2
        npc.ym = npc.ym + 0.125

        if (npc:TouchFloor()) then
            npc.act_no = 0
            npc.count2 = 0
            npc.xm = 0
        end
    end

    -- Apply gravity and speed-caps during most states
    if (npc.act_no < 30 or npc.act_no >= 40) then
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
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Kazuma at computer
ModCS.Npc.Act[62] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(272, 192, 288, 216),
        ModCS.Rect.Create(288, 192, 304, 216),
        ModCS.Rect.Create(304, 192, 320, 216),
    }

    if (npc.act_no == 0) then
        npc.x = npc.x - 4
        npc.y = npc.y + 16
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (ModCS.Game.Random(0, 80) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
        end

        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 3
            npc.act_wait = 0
            npc.ani_no = 2
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_no = 3
            npc.act_wait = 0
            npc.ani_no = 2
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 80) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    end

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Toroko with stick
ModCS.Npc.Act[63] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(64, 64, 80, 80),
        ModCS.Rect.Create(80, 64, 96, 80),
        ModCS.Rect.Create(64, 64, 80, 80),
        ModCS.Rect.Create(96, 64, 112, 80),
        ModCS.Rect.Create(112, 64, 128, 80),
        ModCS.Rect.Create(128, 64, 144, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(64, 80, 80, 96),
        ModCS.Rect.Create(80, 80, 96, 96),
        ModCS.Rect.Create(64, 80, 80, 96),
        ModCS.Rect.Create(96, 80, 112, 96),
        ModCS.Rect.Create(112, 80, 128, 96),
        ModCS.Rect.Create(128, 80, 144, 96),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = 0
        npc.ani_wait = 0
        npc.ym = -2
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.ym > 0) then
            npc:UnsetBit(3) -- Disable ignore collision bit
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 0
        end

        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end

        if (npc.act_wait ~= 0 and npc:TouchFloor()) then
            npc.act_no = 2
        end
        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 2) then
        npc.act_no = 3
        npc.act_wait = 0
        npc.ani_no = 0
        npc.ani_wait = 0
    end

    if (npc.act_no == 3) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_wait = 40
            npc.xm = npc.xm * -1

            if (npc.direct == 0) then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end

        if (npc.act_wait > 35) then
            npc:SetBit(5) -- Set shootable bit
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.125
        else
            npc.xm = npc.xm + 0.125
        end

        if (npc:IsHit()) then
            npc.act_no = 4
            npc.ani_no = 4
            npc.ym = -2
            npc:UnsetBit(5) -- Unset shootable bit
            npc.damage = 0
        end
    elseif (npc.act_no == 4) then
        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end

        if (npc.act_wait ~= 0 and npc:TouchFloor()) then
            npc.act_no = 5
            npc:SetBit(13) -- Set interactable bit
        end
        npc.act_wait = npc.act_wait + 1
    elseif (npc.act_no == 5) then
        npc.xm = 0
        npc.ani_no = 5
    end

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

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- First Cave Critter
ModCS.Npc.Act[64] = function(npc)
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

    if (npc.act_no == 0) then -- Initialize
        npc.y = npc.y + 3
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then -- Waiting
        -- Look at player
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.tgt_x < 100) then
            npc.tgt_x = npc.tgt_x + 1
        end

        -- Open eyes near player
        if (npc.act_wait >= 8 and npc:TriggerBox(112, 80, 112, 80)) then
            npc.ani_no = 1
        else
            if (npc.act_wait < 8) then
                npc.act_wait = npc.act_wait + 1
            end

            npc.ani_no = 0
        end

        -- Jump if attacked
        if (npc:IsHit()) then
            npc.act_no = 2
            npc.ani_no = 0
            npc.act_wait = 0
        end

        -- Jump if player is nearby
        if (npc.act_wait >= 8 and npc.tgt_x >= 100 and npc:TriggerBox(64, 80, 64, 48)) then
            npc.act_no = 2
            npc.ani_no = 0
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then -- Going to jump
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            -- Set jump state
            npc.act_no = 3
            npc.ani_no = 2

            -- Jump
            npc.ym = -2.998046875
            ModCS.Sound.Play(30)

            -- Jump in facing direction
            if (npc.direct == 0) then
                npc.xm = -0.5
            else
                npc.xm = 0.5
            end
        end
    elseif (npc.act_no == 3) then -- Jumping
        -- Land
        if (npc:TouchFloor()) then
            npc.xm = 0
            npc.act_wait = 0
            npc.ani_no = 0
            npc.act_no = 1
            ModCS.Sound.Play(23)
        end
    end

    -- Gravity
    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    -- Move
    npc:Move()

    -- Set framerect
    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- First Cave Bat
ModCS.Npc.Act[65] = function(npc)
    if (npc.act_no == 0) then
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.count1 = 120
        npc.act_no = 1
        npc.act_wait = ModCS.Game.Random(0, 50)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait < 50) then
            -- nothing
        else
            npc.act_wait = 0
            npc.act_no = 2
            npc.ym = 1.5
        end
    elseif (npc.act_no == 2) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
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

-- Misery bubble
ModCS.Npc.Act[66] = function(npc)
    local rect = {
        ModCS.Rect.Create(32, 192, 56, 216),
        ModCS.Rect.Create(56, 192, 80, 216),
        ModCS.Rect.Create(32, 216, 56, 240), -- Toroko in bubble
        ModCS.Rect.Create(56, 216, 80, 240), -- Toroko in bubble
    }

    if (npc.act_no == 0) then
        local npcFound = ModCS.Npc.GetByEvent(1000)

        npc.tgt_x = npcFound.x
        npc.tgt_y = npcFound.y

        local deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_x, npc.y - npc.tgt_y)
        npc.xm = ModCS.Triangle.GetCos(deg) * 2
        npc.ym = ModCS.Triangle.GetSin(deg) * 2

        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        local npcFound = ModCS.Npc.GetByEvent(1000)

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc.x - 3 < npc.tgt_x and npc.x + 3 > npc.tgt_x and npc.y - 3 < npc.tgt_y and npc.y + 3 > npc.tgt_y) then
            npc.act_no = 2
            npc.ani_no = 2
            npcFound.cond = 0
            ModCS.Sound.Play(21)
        end
    elseif (npc.act_no == 2) then
        npc.xm = npc.xm - 0.0625
        npc.ym = npc.ym - 0.0625

        if (npc.xm < -2.998046875) then
            npc.xm = -2.998046875
        end

        if (npc.ym < -2.998046875) then
            npc.ym = -2.998046875
        end

        if (npc.y < -8) then
            npc.cond = 0
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end
    end

    npc:Move()

    npc:SetRect(rect[npc.ani_no+1])
end

-- Misery (floating)
ModCS.Npc.Act[67] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.ani_no = 0
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.x = npc.tgt_x + ModCS.Game.Random(-1, 1)

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 0x20) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        npc.ani_no = 0
        npc.ym = 1
        -- Fallthrough
    end

    if (npc.act_no == 11) then
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
    elseif (npc.act_no == 13) then
        npc.ani_no = 1

        npc.ym = npc.ym + 0.125
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        if (npc:TouchFloor()) then
            ModCS.Sound.Play(23)
            npc.ym = 0
            npc.act_no = 14
            npc:SetBit(3) -- Set ignore solid collision
            npc.ani_no = 2
        end
    elseif (npc.act_no == 15) then
        npc.act_no = 16
        npc.act_wait = 0
        npc.ani_no = 4
        -- Fallthrough
    end

    if (npc.act_no == 16) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30) then
            ModCS.Sound.Play(21)
            ModCS.Npc.Spawn3(66, npc.x, npc.y - 16, 0, 0, 0, npc, 0)
        end

        if (npc.act_wait == 50) then
            npc.act_no = 14
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.ani_no = 0
        npc.ym = 0
        npc:SetBit(3) -- Set ignore solid collision
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ym = npc.ym - 0.0625

        if (npc.y < -8) then
            npc.cond = 0
        end
    elseif (npc.act_no == 25) then
        npc.act_no = 26
        npc.act_wait = 0
        npc.ani_no = 5
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 26) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 7) then
            npc.ani_no = 5
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30) then
            ModCS.Sound.Play(101)
            ModCS.Flash.Spawn()
            npc.act_no = 27
            npc.ani_no = 7
        end
    elseif (npc.act_no == 27) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 50) then
            npc.act_no = 14
        end
    end

    npc:Move()

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    local rcLeft = {
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(96, 0, 112, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(80, 16, 96, 32),
        ModCS.Rect.Create(96, 16, 112, 32),
        ModCS.Rect.Create(112, 16, 128, 32),
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
    }

    if (npc.act_no == 11) then
        if (npc.ani_wait ~= 0) then
            npc.ani_wait = npc.ani_wait - 1
            npc.ani_no = 1
        else
            if (ModCS.Game.Random(0, 100) == 1) then
                npc.ani_wait = 30
            end

            npc.ani_no = 0
        end
    end

    if (npc.act_no == 14) then
        if (npc.ani_wait ~= 0) then
            npc.ani_wait = npc.ani_wait - 1
            npc.ani_no = 3
        else
            if (ModCS.Game.Random(0, 100) == 1) then
                npc.ani_wait = 30
            end

            npc.ani_no = 2
        end
    end

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 1 and npc.ani_wait < 32) then
        npc.ani_wait = npc.ani_wait + 1
        rect.bottom = (npc.ani_wait / 2) + rect.bottom - 16
    end

    npc:SetRect(rect)
end

-- Balrog (running)
ModCS.Npc.Act[68] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.act_wait = 30

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait - 1

        if (npc.act_wait == 0) then
            npc.act_no = 2
            npc.count1 = npc.count1 + 1
        end
    elseif (npc.act_no == 2) then
        npc.act_no = 3
        npc.act_wait = 0
        npc.ani_no = 1
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 3) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no == 2 or npc.ani_no == 4) then
                ModCS.Sound.Play(23)
            end
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 1
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.03125
        else
            npc.xm = npc.xm + 0.03125
        end

        if (npc.act_wait >= 8 and npc:TriggerBox(12, 12, 12, 8)) then
            npc.act_no = 10
            npc.ani_no = 5
            npc.tgt_mc.cond = ModCS.Game.SetBit(npc.tgt_mc.cond, 2) -- Hide player
            npc.tgt_mc:DamageMyID(2)
        else
            npc.act_wait = npc.act_wait + 1

            if ((npc:TouchLeftWall() or npc:TouchRightWall()) or npc.act_wait > 75) then
                npc.act_no = 9
                npc.ani_no = 0
            elseif ((npc.count1 % 3) == 0 and npc.act_wait > 25) then
                npc.act_no = 4
                npc.ani_no = 7
                npc.ym = -2
            end
        end
    elseif (npc.act_no == 4) then
        if (npc:TouchFloor()) then
            npc.act_no = 9
            npc.ani_no = 8
            ModCS.Camera.SetQuake(30)
            ModCS.Sound.Play(26)
        end

        if (npc.act_wait >= 8 and npc:TriggerBox(12, 12, 12, 8)) then
            npc.act_no = 10
            npc.ani_no = 5
            npc.tgt_mc.cond = ModCS.Game.SetBit(npc.tgt_mc.cond, 2) -- Hide player
            npc.tgt_mc:DamageMyID(2)
        end
    elseif (npc.act_no == 9) then
        npc.xm = (npc.xm * 4) / 5

        if (npc.xm == 0) then
            npc.act_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.tgt_mc.x = npc.x
        npc.tgt_mc.y = npc.y

        npc.xm = (npc.xm * 4) / 5

        if (npc.xm == 0) then
            npc.act_no = 11
            npc.act_wait = 0
            npc.ani_no = 5
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 11) then
        npc.tgt_mc.x = npc.x
        npc.tgt_mc.y = npc.y

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 6) then
            npc.ani_no = 5
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        ModCS.Sound.Play(25)
        npc.tgt_mc.cond = ModCS.Game.UnsetBit(npc.tgt_mc.cond, 2) -- Show player
        
        if (npc.direct == 0) then
            npc.tgt_mc.x = npc.tgt_mc.x + 4
            npc.tgt_mc.y = npc.tgt_mc.y - 8
            npc.tgt_mc.xm = 2.998046875
            npc.tgt_mc.ym = -1
            npc.tgt_mc.direct = 2
            npc.direct = 2
        else
            npc.tgt_mc.x = npc.tgt_mc.x - 4
            npc.tgt_mc.y = npc.tgt_mc.y - 8
            npc.tgt_mc.xm = -2.998046875
            npc.tgt_mc.ym = -1
            npc.tgt_mc.direct = 0
            npc.direct = 0
        end

        npc.act_no = 21
        npc.act_wait = 0
        npc.ani_no = 7
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait >= 50) then
            npc.act_no = 0
        end
    end

    npc.ym = npc.ym + 0.0625

    if (npc.xm < -2) then
        npc.xm = -2
    end

    if (npc.xm > 2) then
        npc.xm = 2
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(0, 48, 40, 72),
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(40, 48, 80, 72),
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(80, 48, 120, 72),
        ModCS.Rect.Create(120, 48, 160, 72),
        ModCS.Rect.Create(120, 0, 160, 24),
        ModCS.Rect.Create(80, 0, 120, 24),
    }

    local rect_right = {
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(0, 72, 40, 96),
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(40, 72, 80, 96),
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(80, 72, 120, 96),
        ModCS.Rect.Create(120, 72, 160, 96),
        ModCS.Rect.Create(120, 24, 160, 48),
        ModCS.Rect.Create(80, 24, 120, 48),
    }

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Pignon
ModCS.Npc.Act[69] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(48, 0, 64, 16),
        ModCS.Rect.Create(64, 0, 80, 16),
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(96, 0, 112, 16),
        ModCS.Rect.Create(48, 0, 64, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(64, 16, 80, 32),
        ModCS.Rect.Create(80, 16, 96, 32),
        ModCS.Rect.Create(96, 16, 112, 32),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(112, 16, 128, 32),
    }

    if npc.act_no == 0 then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.xm = 0
        -- fallthrough
    end

    if (npc.act_no == 1) then
        local done = false

        if (ModCS.Game.Random(0, 100) == 1) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 1
            done = true
        end

        if (not done) and ModCS.Game.Random(0, 150) == 1 then
            if npc.direct == 0 then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end

        if (not done) and ModCS.Game.Random(0, 150) == 1 then
            npc.act_no = 3
            npc.act_wait = 50
            npc.ani_no = 0
            done = true
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
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait == 0) then
            npc.act_no = 0
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            npc.ani_no = 2
        end

        if (npc:TouchLeftWall()) then
            npc.direct = 2
            npc.xm = 1
        end

        if (npc:TouchRightWall()) then
            npc.direct = 0
            npc.xm = -1
        end

        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end
    elseif (npc.act_no == 5) then
        if (npc:TouchFloor()) then
            npc.act_no = 0
        end
    end

    if (npc.act_no == 1 or npc.act_no == 2 or npc.act_no == 4) then
        if (npc:IsHit()) then
            npc.ym = -1
            npc.ani_no = 5
            npc.act_no = 5
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

-- Sparkle
ModCS.Npc.Act[70] = function(npc)
    local rect = {
        ModCS.Rect.Create(96, 48, 112, 64),
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(128, 48, 144, 64),
        ModCS.Rect.Create(144, 48, 160, 64),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 3) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no +1
    end

    if (npc.ani_no > 3) then
        npc.ani_no = 0
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Chinfish
ModCS.Npc.Act[71] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.ym = 0.25
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.tgt_y < npc.y) then
            npc.ym = npc.ym - 0.015625
        end

        if (npc.tgt_y > npc.y) then
            npc.ym = npc.ym + 0.015625
        end

        if (npc.ym > 0.5) then
            npc.ym = 0.5
        end

        if (npc.ym < -0.5) then
            npc.ym = -0.5
        end
    end

    npc:Move()

    local rcLeft = {
        ModCS.Rect.Create(64, 32, 80, 48),
        ModCS.Rect.Create(80, 32, 96, 48),
        ModCS.Rect.Create(96, 32, 112, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(64, 48, 80, 64),
        ModCS.Rect.Create(80, 48, 96, 64),
        ModCS.Rect.Create(96, 48, 112, 64),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 4) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    if (npc:IsHit()) then
        npc.ani_no = 2
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Sprinkler
ModCS.Npc.Act[72] = function(npc)
    if (npc.direct == 0) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
            return
        end

        if (npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120)) then
            npc.act_no = npc.act_no + 1
            if (npc.act_no % 2 ~= 0) then
                ModCS.Npc.Spawn2(73, npc.x, npc.y, ModCS.Game.Random2(-1, 1) * 2, ModCS.Game.Random2(-1, 1) * 3, 0)
            end

            ModCS.Npc.Spawn2(73, npc.x, npc.y, ModCS.Game.Random2(-1, 1) * 2, ModCS.Game.Random2(-1, 1) * 3, 0)
        end
    end

    local rect = {
        ModCS.Rect.Create(224, 48, 240, 64),
        ModCS.Rect.Create(240, 48, 256, 64),
    }

    npc:SetRect(rect[npc.ani_no+1])
end

-- Water droplet
ModCS.Npc.Act[73] = function(npc)
    local rcDrop = {
        ModCS.Rect.Create(72, 16, 74, 18),
        ModCS.Rect.Create(74, 16, 76, 18),
        ModCS.Rect.Create(76, 16, 78, 18),
        ModCS.Rect.Create(78, 16, 80, 18),
        ModCS.Rect.Create(80, 16, 82, 18),
    }

    npc.ym = npc.ym + 0.0625
    npc.ani_no = ModCS.Game.Random(0, 4)

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    local rect = rcDrop[npc.ani_no+1]

    if (npc.direct == 2) then
        rect.top = rect.top + 2
        rect.bottom = rect.bottom + 2
    end

    npc:SetRect(rect)

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 10) then
        if (npc:TouchLeftWall()) then
            npc.cond = 0
        end
        if (npc:TouchRightWall()) then
            npc.cond = 0
        end
        if (npc:TouchFloor()) then
            npc.cond = 0
        end
        if (npc:TouchWater()) then
            npc.cond = 0
        end
    end

    if (npc.y > ModCS.Map.GetHeight() * 0x200 * 0x10) then
        npc.cond = 0
    end
end

-- Jack
ModCS.Npc.Act[74] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(64, 0, 80, 16),
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(96, 0, 112, 16),
        ModCS.Rect.Create(64, 0, 80, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
        ModCS.Rect.Create(64, 0, 80, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(64, 16, 80, 32),
        ModCS.Rect.Create(80, 16, 96, 32),
        ModCS.Rect.Create(96, 16, 112, 32),
        ModCS.Rect.Create(64, 16, 80, 32),
        ModCS.Rect.Create(112, 16, 128, 32),
        ModCS.Rect.Create(64, 16, 80, 32),
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
    elseif (npc.act_no == 8) then
        npc.act_no = 9
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 9) then
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
    end

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

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Kanpachi (fishing)
ModCS.Npc.Act[75] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(272, 32, 296, 56),
        ModCS.Rect.Create(296, 32, 320, 56),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TriggerBox(48, 48, 48, 16)) then
            npc.ani_no = 1
        else
            npc.ani_no = 0
        end
    end

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Flowers
ModCS.Npc.Act[76] = function(npc)
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    rect.left = npc.event * 16
    rect.top = 0
    rect.right = rect.left + 16
    rect.bottom = 16

    npc:SetRect(rect)
end

-- Yamashita
ModCS.Npc.Act[77] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 16, 48, 48),
        ModCS.Rect.Create(48, 16, 96, 48),
        ModCS.Rect.Create(96, 16, 144, 48),
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
        npc:SetRect(rc[npc.ani_no+1])
    else
        npc:SetRect(rc[3])
    end
end

-- Pot
ModCS.Npc.Act[78] = function(npc)
    local rc = {
        ModCS.Rect.Create(160, 48, 176, 64),
        ModCS.Rect.Create(176, 48, 192, 64),
    }

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
    else
        npc:SetRect(rc[2])
    end
end

-- Mahin
ModCS.Npc.Act[79] = function(npc)
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
        npc.act_no = 1
        npc.ani_no = 2
        npc.ani_wait = 0
    elseif (npc.act_no == 2) then
        npc.ani_no = 0

        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 3
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
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 2
            npc.ani_no = 0
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