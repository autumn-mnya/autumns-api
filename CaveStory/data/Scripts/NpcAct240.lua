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

-- Lava drop generator

-- Press (proximity)

-- Misery (boss)

-- Boss Misery (vanishing)

-- Boss Misery energy shot

-- Boss Misery lightning ball

-- Boss Misery lightning

-- Boss Misery bats

-- EXP capsule

-- Helicopter

-- Helicopter Blades

-- Doctor (facing away)

-- Red crystal

-- Mimiga (sleeping)

-- Curly (carried and unconcious)