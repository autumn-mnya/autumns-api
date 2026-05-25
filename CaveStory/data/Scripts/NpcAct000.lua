-- Null
ModCS.Npc.Act[0] = function(npc)
    local rect = ModCS.Rect.Create(0, 0, 16, 16)

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 2) then
            npc.y = npc.y + 16
        end
    end

    npc:SetRect(rect)
end

-- Experience
ModCS.Npc.Act[1] = function(npc)
    -- In wind
    if (ModCS.Back.type == 5 or ModCS.Back.type == 6) then
        if (npc.act_no == 0) then
            -- Set state
            npc.act_no = 1

            -- Set random speed
            npc.ym = ModCS.Game.Random2(-0.25, 0.25)
            npc.xm = ModCS.Game.Random2(0.248046875, 0.5)
        end

        -- Blow to the left
        npc.xm = npc.xm - 0.015625

        -- Destroy when off-screen
        if (npc.x < 80) then
            npc.cond = 0
        end

        -- the original code does this, which is probably a bug.
        -- instead of limiting the npcs xm, pixel may have accidentally limited the npcs x position instead.
        -- if (npc.x < -3) then
        --     npc.x = -3
        -- end

        -- Limit speed
        if (npc.xm < -3) then
            npc.xm = -3
        end

        -- Bounce off walls
        if (npc:TouchLeftWall()) then
            npc.xm = 0.5
        end

        if (npc:TouchCeiling()) then
            npc.ym = 0.125
        end

        if (npc:TouchFloor()) then
            npc.ym = -0.125
        end
    else -- Not in wind
        if (npc.act_no == 0) then
            -- Set state
            npc.act_no = 1
            npc.ani_no = ModCS.Game.Random(0, 4)

            -- Random speed
            npc.xm = ModCS.Game.Random2(-1, 1)
            npc.ym = ModCS.Game.Random2(-2, 0)

            -- Random direction (reverse animation or not)
            if (ModCS.Game.Random(0, 1) ~= 0) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end

        -- Gravity
        if (npc:TouchWater()) then
            npc.ym = npc.ym + 0.041015625
        else
            npc.ym = npc.ym + 0.08203125
        end

        -- Bounce off walls
        if (npc:TouchLeftWall() and npc.xm < 0) then
            npc.xm = npc.xm * -1
        end

        if (npc:TouchRightWall() and npc.xm > 0) then
            npc.xm = npc.xm * -1
        end

        -- Bounce off ceiling
        if (npc:TouchCeiling() and npc.ym < 0) then
            npc.ym = npc.ym * -1
        end

        -- Bounce off floor
        if (npc:TouchFloor()) then
            ModCS.Sound.Play(45)
            npc.ym = -1.25
            npc.xm = 2 * npc.xm / 3
        end

        -- Play bounce song (and try to clip out of floor if stuck)
        if ((npc:HitFlag(0xD))) then
            ModCS.Sound.Play(45)
            npc.count2 = npc.count2 + 1
            if (npc.count2 > 2) then
                npc.y = npc.y - 1
            end
        else
            npc.count2 = 0
        end

        -- Limit speed
        if (npc.xm < -2.998046875) then
            npc.xm = -2.998046875
        end

        if (npc.xm > 2.998046875) then
            npc.xm = 2.998046875
        end

        if (npc.ym < -2.998046875) then
            npc.ym = -2.998046875
        end

        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end
    end

    -- Move
    npc:Move()

    -- Get framerects
    local rect = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(64, 16, 80, 32),
        ModCS.Rect.Create(80, 16, 96, 32),
    }

    local rcNo = ModCS.Rect.Create(0, 0, 0, 0)

    -- Animate
    npc.ani_wait = npc.ani_wait + 1

    if (npc.direct == 0) then
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 5) then
                npc.ani_no = 0
            end
        end
    else
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no - 1
            if (npc.ani_no < 0) then
                npc.ani_no = 5
            end
        end
    end

    -- Size
    if (npc.act_no ~= 0) then
        local r = rect[npc.ani_no + 1]  -- get current frame

        if (npc.exp == 5) then
            r.top = r.top + 16
            r.bottom = r.bottom + 16
        elseif (npc.exp == 20) then
            r.top = r.top + 32
            r.bottom = r.bottom + 32
        end

        npc.act_no = 1
    end

    npc:SetRect(rect[npc.ani_no+1])

    -- Delete after 500 frames
    npc.count1 = npc.count1 + 1
    if (npc.count1 > 500 and npc.ani_no == 5 and npc.ani_wait == 2) then
        npc.cond = 0
    end

    -- Blink after 400 frames
    if (npc.count1 > 400) then
        if ((math.floor(npc.count1 / 2) % 2) ~= 0) then
            npc:SetRect(rcNo)
        end
    end
end

-- Behemoth
ModCS.Npc.Act[2] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(32, 0,  64, 24),
        ModCS.Rect.Create(0, 0,  32, 24),
        ModCS.Rect.Create(32, 0,  64, 24),
        ModCS.Rect.Create(64, 0,  96, 24),
        ModCS.Rect.Create(96, 0, 128, 24),
        ModCS.Rect.Create(128, 0, 160, 24),
        ModCS.Rect.Create(160, 0, 192, 24),
    }

    local rcRight = {
        ModCS.Rect.Create(32, 24,  64, 48),
        ModCS.Rect.Create(0, 24,  32, 48),
        ModCS.Rect.Create(32, 24,  64, 48),
        ModCS.Rect.Create(64, 24,  96, 48),
        ModCS.Rect.Create(96, 24, 128, 48),
        ModCS.Rect.Create(128, 24, 160, 48),
        ModCS.Rect.Create(160, 24, 192, 48),
    }

    -- Turn when touching a wall
    if (npc:TouchLeftWall()) then
        npc.direct = 2
    elseif (npc:TouchRightWall()) then
        npc.direct = 0
    end

    if (npc.act_no == 0) then -- Walking
        if (npc.direct == 0) then
            npc.xm = -0.5
        else
            npc.xm = 0.5
        end

        npc.ani_wait = npc.ani_wait + 1

        if (npc.ani_wait > 8) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 0
        end

        if (npc:IsHit()) then
            npc.count1 = 0
            npc.act_no = 1
            npc.ani_no = 4
        end
    elseif (npc.act_no == 1) then -- When shot
        npc.xm = (npc.xm * 7) / 8

        npc.count1 = npc.count1 + 1
        if (npc.count1 > 40) then
            if (npc:IsHit()) then
                npc.count1 = 0
                npc.act_no = 2
                npc.ani_no = 6
                npc.ani_wait = 0
                npc.damage = 5
            else
                npc.act_no = 0
                npc.ani_wait = 0
            end
        end
    elseif (npc.act_no == 2) then -- Charging and Angry
        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end

        npc.count1 = npc.count1 + 1
        if (npc.count1 > 200) then
            npc.act_no = 0
            npc.damage = 1
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 5) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 6) then
            npc.ani_no = 5
            ModCS.Sound.Play(26)
            ModCS.Npc.Spawn(4, npc.x, npc.y + 3)
            ModCS.Camera.SetQuake(8)
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

-- Dead enemy (to make sure the damage-value doesn't teleport to a newly-loaded NPC)
ModCS.Npc.Act[3] = function(npc)
    npc.count1 = npc.count1 + 1
    if (npc.count1 > 100) then
        npc.cond = 0
    end

    local rect = ModCS.Rect.Create(0, 0, 0, 0)
    npc:SetRect(rect)
end

-- Smoke
ModCS.Npc.Act[4] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(16, 0,  17,  1),
        ModCS.Rect.Create(16, 0,  32, 16),
        ModCS.Rect.Create(32, 0,  48, 16),
        ModCS.Rect.Create(48, 0,  64, 16),
        ModCS.Rect.Create(64, 0,  80, 16),
        ModCS.Rect.Create(80, 0,  96, 16),
        ModCS.Rect.Create(96, 0, 112, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
    }

    local rcUp = {
        ModCS.Rect.Create(16, 0,  17,  1),
        ModCS.Rect.Create(80,  48, 96,  64),
        ModCS.Rect.Create(0, 128, 16, 144),
        ModCS.Rect.Create(16, 128, 32, 144),
        ModCS.Rect.Create(32, 128, 48, 144),
        ModCS.Rect.Create(48, 128, 64, 144),
        ModCS.Rect.Create(64, 128, 80, 144),
        ModCS.Rect.Create(80, 128, 96, 144),
    }

    local deg 

    if (npc.act_no == 0) then
        -- Move in random direction at random speed
        if (npc.direct == 0 or npc.direct == 1) then
            deg = ModCS.Game.Random(0, 0xFF)
            local speed = ModCS.Game.Random2(1, 2.998046875)
            npc.xm = ModCS.Triangle.GetCos(deg) * speed
            npc.ym = ModCS.Triangle.GetSin(deg) * speed
        end

        -- Set state
        npc.ani_no = ModCS.Game.Random(0, 4)
        npc.ani_wait = ModCS.Game.Random(0, 3)
        npc.act_no = 1
    else
        -- Slight drag
        npc.xm = (npc.xm * 20) / 21
        npc.ym = (npc.ym * 20) / 21

        -- Move
        npc:Move()
    end

    -- Animate
    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 4) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    -- Set framerect
    if (npc.ani_no > 7) then
        npc.cond = 0
    else
        if (npc.direct == 1) then
            npc:SetRect(rcUp[npc.ani_no+1])
        end

        if (npc.direct == 0) then
            npc:SetRect(rcLeft[npc.ani_no+1])
        end

        if (npc.direct == 2) then
            npc:SetRect(rcLeft[npc.ani_no+1])
        end
    end
end

-- Critter (Green, Egg Corridor)
ModCS.Npc.Act[5] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create( 0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
        ModCS.Rect.Create(32, 48, 48, 64),
    }

    local rcRight = {
        ModCS.Rect.Create( 0, 64, 16, 80),
        ModCS.Rect.Create(16, 64, 32, 80),
        ModCS.Rect.Create(32, 64, 48, 80),
    }

    if (npc.act_no == 0) then -- Initialize
        npc.y = npc.y + 3
        npc.act_no = 1
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then -- Waiting
        -- Look at player
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
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
        if (npc.act_wait >= 8 and npc:TriggerBox(48, 80, 48, 80)) then
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

-- Beetle (Goes left and right, Egg Corridor)
ModCS.Npc.Act[6] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create( 0, 80, 16, 96),
        ModCS.Rect.Create(16, 80, 32, 96),
        ModCS.Rect.Create(32, 80, 48, 96),
        ModCS.Rect.Create(48, 80, 64, 96),
        ModCS.Rect.Create(64, 80, 80, 96),
    }

    local rcRight = {
        ModCS.Rect.Create( 0, 96, 16, 112),
        ModCS.Rect.Create(16, 96, 32, 112),
        ModCS.Rect.Create(32, 96, 48, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
        ModCS.Rect.Create(64, 96, 80, 112),
    }

    if (npc.act_no == 0) then -- Initialize
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.act_no = 1
        else
            npc.act_no = 3
        end
    elseif (npc.act_no == 1) then
        -- Accelerate to the left
        npc.xm = npc.xm - 0.03125
        if (npc.xm < -2) then
            npc.xm = -2
        end

        --if (npc:IsHit()) then
        --    npc.x = npc.x + (npc.xm / 2)
        --end

        -- Animate
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end

        -- Stop when hitting a wall
        if (npc:TouchLeftWall()) then
            npc.act_no = 2
            npc.act_wait = 0
            npc.ani_no = 0
            npc.xm = 0
            npc.direct = 2
        end
    elseif (npc.act_no == 2) then
        -- Wait 60 frames then move to the right
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 60) then
            npc.act_no = 3
            npc.ani_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 3) then
        -- Accelerate to the right
        npc.xm = npc.xm + 0.03125
        if (npc.xm > 2) then
            npc.xm = 2
        end

        --if (npc:IsHit()) then
        --    npc.x = npc.x + (npc.xm / 2)
        --end

        -- Animate
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end

        -- Stop when hitting a wall
        if (npc:TouchRightWall()) then
            npc.act_no = 4
            npc.act_wait = 0
            npc.ani_no = 0
            npc.xm = 0
            npc.direct = 0
        end
    elseif (npc.act_no == 4) then
        -- Wait 60 frames then move to the left
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 60) then
            npc.act_no = 1
            npc.ani_wait = 0
            npc.ani_no = 1
        end
    end

    -- Move (after function in lua, not entirely accurate to Cave Story)
    if (npc.act_no == 1 or npc.act_no == 3) then
        local xm = npc.xm
        if (npc:IsHit()) then -- Slow down when hurt
            npc.xm = npc.xm / 2
        end

        npc:Move()

        npc.xm = xm
    end

    -- Set framerect
    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Basil
ModCS.Npc.Act[7] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(256, 64, 288, 80),
        ModCS.Rect.Create(256, 80, 288, 96),
        ModCS.Rect.Create(256, 96, 288, 112),
    }

    local rcRight = {
        ModCS.Rect.Create(288, 64, 320, 80),
        ModCS.Rect.Create(288, 80, 320, 96),
        ModCS.Rect.Create(288, 96, 320, 112),
    }

    if (npc.act_no == 0) then
        npc.x = npc.tgt_mc.x -- Spawn beneath player

        if (npc.direct == 0) then
            npc.act_no = 1
        else
            npc.act_no = 2
        end
    elseif (npc.act_no == 1) then -- Going left
        npc.xm = npc.xm - 0.125

        -- Turn around if far enough away from the player
        if (npc.x < (npc.tgt_mc.x - 192)) then
            npc.act_no = 2
        end

        -- Turn around if touching a wall
        if (npc:TouchLeftWall()) then
            npc.xm = 0
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then -- Going right
        npc.xm = npc.xm + 0.125

        -- Turn around if far enough away from the player
        if (npc.x > (npc.tgt_mc.x + 192)) then
            npc.act_no = 1
        end

        -- Turn around if touching a wall
        if (npc:TouchRightWall()) then
            npc.xm = 0
            npc.act_no = 1
        end
    end

    -- Face direction Bazil is moving
    if (npc.xm < 0) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    -- Cap speed
    if (npc.xm > 2.998046875) then
        npc.xm = 2.998046875
    end

    if (npc.xm < -2.998046875) then
        npc.xm = -2.998046875
    end

    -- Apply momentum
    npc:Move()

    -- Increment animation
    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    -- Loop animation
    if (npc.ani_no == 2) then
        npc.ani_no = 0
    end

    -- Update sprite
    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Beetle (follows you, Egg Corridor)
ModCS.Npc.Act[8] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(80, 80,  96, 96),
        ModCS.Rect.Create(96, 80, 112, 96),
    }

    local rcRight = {
        ModCS.Rect.Create(80, 96,  96, 112),
        ModCS.Rect.Create(96, 96, 112, 112),
    }

    local rcNo = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        if (npc.tgt_mc.x < (npc.x + 16) and npc.tgt_mc.x > (npc.x - 16)) then
            npc:SetBit(5) -- Set shootable
            npc.ym = -0.5
            npc.tgt_y = npc.y
            npc.act_no = 1
            npc.damage = 2

            if (npc.direct == 0) then
                npc.x = npc.tgt_mc.x + 256
            else
                npc.x = npc.tgt_mc.x - 256
            end
        else
            npc:UnsetBit(5) -- Unset shootable
            npc:SetRect(rcNo) -- While not on screen and in act state 0, set rect to rcNo first
            npc.damage = 0
            npc.xm = 0
            npc.ym = 0
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
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    if (npc.act_no ~= 0) then -- check not in original code, but neccessary here
        if (npc.direct == 0) then
            npc:SetRect(rcLeft[npc.ani_no+1])
        else
            npc:SetRect(rcRight[npc.ani_no+1])
        end
    end
end

-- Balrog (drop-in)
ModCS.Npc.Act[9] = function(npc)
    local i

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 2
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end

    if (npc.act_no == 1) then
        npc.ym = npc.ym + 0.0625

        if (npc.count1 < 40) then
            npc.count1 = npc.count1 + 1
        else
            npc:UnsetBit(3) -- Ignore tile collision disabled
            npc:SetBit(0) -- 'Solid Soft' enabled (pushes player outwards)
        end

        if (npc:TouchFloor()) then
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + (ModCS.Game.Random(-12, 12)), npc.y + (ModCS.Game.Random(-12, 12)), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end

            npc.act_no = 2
            npc.ani_no = 1
            npc.act_wait = 0
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(30)
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 16) then
            npc.act_no = 3
            npc.ani_no = 0
            npc.ani_wait = 0
        end
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    if (npc.ym < -2.998046875) then
        npc.ym = -2.998046875
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(80, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 160, 24),
    }

    local rect_right = {
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(80, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 160, 48),
    }

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Balrog (shooting) (super-secret unused version from the prototype)
ModCS.Npc.Act[10] = function(npc)
    local deg
    local xm
    local ym

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
        if (npc:TouchLeftWall() or npc:TouchRightWall()) then
            npc.xm = 0
        end

        if ((npc.y + 16) < npc.tgt_mc.y) then
            npc.damage = 5
        else
            npc.damage = 0
        end

        if (npc:TouchFloor()) then
            npc.act_no = 5
            npc.act_wait = 0
            npc.ani_no = 2
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(30)
            npc.damage = 0
        end
    elseif (npc.act_no == 5) then
        npc.xm = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3) then
            npc.act_no = 1
            npc.act_wait = 0
        end
    end

    npc.ym = npc.ym + 0.0625

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(40, 0, 80, 24),
        ModCS.Rect.Create(80, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 160, 24),
    }

    local rect_right = {
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(40, 24, 80, 48),
        ModCS.Rect.Create(80, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 160, 48),
    }

    if (npc.x < npc.tgt_mc.x) then
        npc.direct = 2
    else
        npc.direct = 0
    end

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Proto-Balrog's projectile
ModCS.Npc.Act[11] = function(npc)
    if (npc:TouchTile()) then
        npc.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(208, 104, 224, 120),
        ModCS.Rect.Create(224, 104, 240, 120),
        ModCS.Rect.Create(240, 104, 256, 120),
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
    if (npc.count1 > 150) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end
end

-- Balrog (cutscene)
ModCS.Npc.Act[12] = function(npc)
    local i
    local x, y
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

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
        -- Fallthrough to npc.act_no 1, so dont elseif here
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
    elseif (npc.act_no == 10) then
        if (npc.direct == 4) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end

        npc.act_no = 11
        npc.ani_no = 2
        npc.act_wait = 0
        npc.tgt_x = 0
        -- Fallthrough to npc.act_no 11, so dont elseif here
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 12
            npc.act_wait = 0
            npc.ani_no = 3
            npc.ym = npc.ym - 4
            npc:SetBit(3)
        end
    elseif (npc.act_no == 12) then
        if (npc:TouchLeftWall() or npc:TouchRightWall()) then
            npc.xm = 0
        end

        if (npc.y < 0) then
            npc.id = 0
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(30)
        end
    elseif (npc.act_no == 20) then
        if (npc.direct == 4) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end

        npc.act_no = 21
        npc.ani_no = 5
        npc.act_wait = 0
        npc.count1 = 0

        for i = 0, 3 do
            ModCS.Npc.Spawn2(4, npc.x + (ModCS.Game.Random(-12, 12)), npc.y + (ModCS.Game.Random(-12, 12)), ModCS.Game.Random2(-0.666015625, 0.666015625), 0, 0)
        end

        ModCS.Sound.Play(72)
        -- Fallthrough to npc.act_no 21, so dont elseif here
    end
    
    if (npc.act_no == 21) then
        npc.tgt_x = 1

        if (npc:TouchFloor()) then
            npc.act_wait = npc.act_wait + 1
        end

        npc.count1 = npc.count1 + 1
        if ((math.floor(npc.count1 / 2) % 2) ~= 0) then
            npc.x = npc.x + 1
        else
            npc.x = npc.x - 1
        end

        if (npc.act_wait > 100) then
            npc.act_no = 11
            npc.act_wait = 0
            npc.ani_no = 2
        end

        npc.ym = npc.ym + 0.0625
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end
    elseif (npc.act_no == 30) then
        npc.ani_no = 4

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_no = 0
            npc.ani_no = 0
        end
    elseif (npc.act_no == 40) then
        if (npc.direct == 4) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end

        npc.act_no = 41
        npc.act_wait = 0
        npc.ani_no = 5
        -- Fallthrough to npc.act_no 41, so dont elseif here
    end
    
    if (npc.act_no == 41) then
        npc.ani_wait = npc.ani_wait + 1
        if ((math.floor(npc.ani_wait / 2) % 2) ~= 0) then
            npc.ani_no = 5
        else
            npc.ani_no = 6
        end
    elseif (npc.act_no == 42) then
        if (npc.direct == 4) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end

        npc.act_no = 43
        npc.act_wait = 0
        npc.ani_no = 6
        -- Fallthrough to npc.act_no 43, so dont elseif here
    end
    
    if (npc.act_no == 43) then
        npc.ani_wait = npc.ani_wait + 1
        if ((math.floor(npc.ani_wait / 2) % 2) ~= 0) then
            npc.ani_no = 7
        else
            npc.ani_no = 6
        end
    elseif (npc.act_no == 50) then
        npc.ani_no = 8
        npc.xm = 0
    elseif (npc.act_no == 60) then
        npc.act_no = 61
        npc.ani_no = 9
        npc.ani_wait = 0
        -- Fallthrough to npc.act_no 61, so dont elseif here
    end
    
    if (npc.act_no == 61) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no == 10 or npc.ani_no == 11) then
                ModCS.Sound.Play(23)
            end
        end

        if (npc.ani_no > 12) then
            npc.ani_no = 9
        end

        if (npc.direct == 0) then
            npc.xm = -1
        else
            npc.xm = 1
        end
    elseif (npc.act_no == 70) then
        npc.act_no = 71
        npc.act_wait = 64
        ModCS.Sound.Play(29)
        npc.ani_no = 13
        -- Fallthrough to npc.act_no 71, so dont elseif here
    end
    
    if (npc.act_no == 71) then
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait == 0) then
            npc.cond = 0
        end
    elseif (npc.act_no == 80) then
        npc.count1 = 0
        npc.act_no = 81
    elseif (npc.act_no == 81) then
        npc.count1 = npc.count1 + 1
        if ((math.floor(npc.count1 / 2) % 2) ~= 0) then
            npc.x = npc.x + 1
        else
            npc.x = npc.x - 1
        end

        npc.ani_no = 5
        npc.xm = 0
        npc.ym = npc.ym + 0.0625
    elseif (npc.act_no == 100) then
        npc.act_no = 101
        npc.act_wait = 0
        npc.ani_no = 2
        -- Fallthrough to npc.act_no 101, so dont elseif here
    end
    
    if (npc.act_no == 101) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 102
            npc.act_wait = 0
            npc.ani_no = 3
            npc.ym = -4
            npc:SetBit(3)
            ModCS.Npc.KillEveryID(150)
            ModCS.Npc.KillEveryID(117)
            ModCS.Npc.Spawn3(355, 0, 0, 0, 0, 0, npc)
            ModCS.Npc.Spawn3(355, 0, 0, 0, 0, 1, npc)
        end
    elseif (npc.act_no == 102) then
        x = npc.x / 0x10
        y = npc.y / 0x10

        if (y >= 0 and y < 35 and ModCS.Map.ChangeTile(0, x, y)) then
            ModCS.Map.ChangeTile(0, x - 1, y)
            ModCS.Map.ChangeTile(0, x + 1, y)
            ModCS.Sound.Play(44)
            ModCS.Camera.SetAltQuake(30)
        end

        if (npc.y < -32) then
            npc.id = 0
            ModCS.Camera.SetQuake(30)
        end
    end

    if ((npc.tgt_x ~= 0) and ModCS.Game.Random(0, 10) == 0) then
        ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(160, 0, 200, 24),
        ModCS.Rect.Create(80, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 160, 24),
        ModCS.Rect.Create(240, 0, 280, 24),
        ModCS.Rect.Create(200, 0, 240, 24),
        ModCS.Rect.Create(280, 0, 320, 24),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(80, 48, 120, 72),
        ModCS.Rect.Create(0, 48, 40, 72),
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(40, 48, 80, 72),
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(280, 0, 320, 24),
    }

    local rect_right = {
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(160, 24, 200, 48),
        ModCS.Rect.Create(80, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 160, 48),
        ModCS.Rect.Create(240, 24, 280, 48),
        ModCS.Rect.Create(200, 24, 240, 48),
        ModCS.Rect.Create(280, 24, 320, 48),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(80, 72, 120, 96),
        ModCS.Rect.Create(0, 72, 40, 96),
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(40, 72, 80, 96),
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(280, 24, 320, 48),
    }

    if (npc.direct == 0) then
        rect = rect_left[npc.ani_no+1]
    else
        rect = rect_right[npc.ani_no+1]
    end

    if (npc.act_no == 71) then
        rect.bottom = rect.top + (npc.act_wait / 2)

        if (npc.act_wait % 2 ~= 0) then
            rect.left = rect.left + 1
        end
    end

    npc:SetRect(rect)
end

-- Forcefield
ModCS.Npc.Act[13] = function(npc)
    local rect = {
        ModCS.Rect.Create(128, 0, 144, 16),
        ModCS.Rect.Create(144, 0, 160, 16),
        ModCS.Rect.Create(160, 0, 176, 16),
        ModCS.Rect.Create(176, 0, 192, 16),
    }

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

-- Santa's Key
ModCS.Npc.Act[14] = function(npc)
    local rect = {
        ModCS.Rect.Create(192, 0, 208, 16),
        ModCS.Rect.Create(208, 0, 224, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
    }

    local i

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 2) then
            npc.ym = -1

            -- Spawn smoke
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rect[npc.ani_no+1])
end

-- Chest (closed)
ModCS.Npc.Act[15] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(240, 0, 256, 16),
        ModCS.Rect.Create(256, 0, 272, 16),
        ModCS.Rect.Create(272, 0, 288, 16),
    }

    local i

    if (npc.act_no == 0) then -- Init
        npc.act_no = 1
        npc:SetBit(13) -- Interactable

        -- Spawn with smoke if dir 2 is set
        if (npc.direct == 2) then
            npc.ym = -1

            -- Spawn smoke
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end

        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then -- Idle
        npc.ani_no = 0

        if (ModCS.Game.Random(0, 30) == 0) then
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then -- Shine
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
            npc.act_no = 1
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Save point
ModCS.Npc.Act[16] = function(npc)
    local rect = {
        ModCS.Rect.Create(96, 16, 112, 32),
        ModCS.Rect.Create(112, 16, 128, 32),
        ModCS.Rect.Create(128, 16, 144, 32),
        ModCS.Rect.Create(144, 16, 160, 32),
        ModCS.Rect.Create(160, 16, 176, 32),
        ModCS.Rect.Create(176, 16, 192, 32),
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
    }

    local i

    if (npc.act_no == 0) then
        npc:SetBit(13) -- Interactable
        npc.act_no = 1

        if (npc.direct == 2) then
            npc:UnsetBit(13) -- Unset interactable while falling in air
            npc.ym = -1

            -- Spawn smoke
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end

        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        if (npc:TouchFloor()) then
            npc:SetBit(13) -- Interactable if on ground
        end
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 7) then
        npc.ani_no = 0
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rect[npc.ani_no+1])
end

-- Health refill
ModCS.Npc.Act[17] = function(npc)
    local rect = {
        ModCS.Rect.Create(288, 0, 304, 16),
        ModCS.Rect.Create(304, 0, 320, 16),
    }

    local a

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 2) then
            npc.ym = -1

            -- Spawn smoke
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end

        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        a = ModCS.Game.Random(0, 30)

        if (a < 10) then
            npc.act_no = 2
        elseif (a < 25) then
            npc.act_no = 3
        else
            npc.act_no = 4
        end

        npc.act_wait = ModCS.Game.Random(0x10, 0x40)
        npc.ani_wait = 0
    elseif (npc.act_no == 2) then
        npc:SetRect(rect[1])

        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait == 0) then
            npc.act_no = 1
        end
    elseif (npc.act_no == 3) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait % 2 ~= 0) then
            npc:SetRect(rect[1])
        else
            npc:SetRect(rect[2])
        end

        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait == 0) then
            npc.act_no = 1
        end
    elseif (npc.act_no == 4) then
        npc:SetRect(rect[2])

        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait == 0) then
            npc.act_no = 1
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()
end

-- Door
ModCS.Npc.Act[18] = function(npc)
    local i

    local rect = {
        ModCS.Rect.Create(224, 16, 240, 40),
        ModCS.Rect.Create(192, 112, 208, 136),
    }

    if (npc.act_no == 0) then
        if (npc.direct == 0) then
            npc:SetRect(rect[1])
        else
            npc:SetRect(rect[2])
        end
    elseif (npc.act_no == 1) then
        -- Spawn smoke
        for i = 0, 3 do
             ModCS.Npc.Spawn2(4, npc.x, npc.y, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        npc.act_no = 0
        npc:SetRect(rect[1])
    end
end

-- Balrog (burst)
ModCS.Npc.Act[19] = function(npc)
    local i

    if (npc.act_no == 0) then
            -- Spawn smoke
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end

        npc.y = npc.y + 10
        npc.act_no = 1
        npc.ani_no = 3
        npc.ym = -0.5
        ModCS.Sound.Play(12)
        ModCS.Sound.Play(26)
        ModCS.Camera.SetQuake(30)
        -- Fallthrough to npc.act_no 1, so dont elseif here
    end
    
    if (npc.act_no == 1) then
        npc.ym = npc.ym + 0.03125

        if (npc.ym > 0 and npc:TouchFloor()) then
            npc.act_no = 2
            npc.ani_no = 2
            npc.act_wait = 0
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(30)
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 0x10) then
            npc.act_no = 3
            npc.ani_no = 0
            npc.ani_wait = 0
        end
    elseif (npc.act_no == 3) then
        if (ModCS.Game.Random(0, 100) == 0) then
            npc.act_no = 4
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 4) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 0x10) then
            npc.act_no = 3
            npc.ani_no = 0
        end
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    if (npc.ym < -2.998046875) then
        npc.ym = -2.998046875
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(0, 0, 40, 24),
        ModCS.Rect.Create(160, 0, 200, 24),
        ModCS.Rect.Create(80, 0, 120, 24),
        ModCS.Rect.Create(120, 0, 160, 24),
    }

    local rect_right = {
        ModCS.Rect.Create(0, 24, 40, 48),
        ModCS.Rect.Create(160, 24, 200, 48),
        ModCS.Rect.Create(80, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 160, 48),
    }

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end