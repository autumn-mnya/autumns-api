-- Colon (1)
ModCS.Npc.Act[120] = function(npc)
    local rect = {
        ModCS.Rect.Create(64, 0, 80, 16),
        ModCS.Rect.Create(64, 16, 80, 32),
    }

    if (npc.direct == 0) then
        npc:SetRect(rect[1])
    else
        npc:SetRect(rect[2])
    end
end

-- Colon (2)
ModCS.Npc.Act[121] = function(npc)
    local rect = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
    }

    if (npc.direct == 0) then
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

        npc:SetRect(rect[npc.ani_no+1])
    else
        npc:SetRect(rect[3])

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_wait = 0
            ModCS.Caret.Spawn(ModCS.Const.CARET_ZZZ, npc.x, npc.y, 0)
        end
    end
end

-- Colon (attacking)
ModCS.Npc.Act[122] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(32, 0, 48, 16),
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(48, 0, 64, 16),
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(80, 0, 96, 16),
        ModCS.Rect.Create(96, 0, 112, 16),
        ModCS.Rect.Create(112, 0, 128, 16),
        ModCS.Rect.Create(128, 0, 144, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(48, 16, 64, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(80, 16, 96, 32),
        ModCS.Rect.Create(96, 16, 112, 32),
        ModCS.Rect.Create(112, 16, 128, 32),
        ModCS.Rect.Create(128, 16, 144, 32),
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
        npc.life = 1000
        npc.act_no = 11
        npc.act_wait = ModCS.Game.Random(0, 50)
        npc.ani_no = 0
        npc.damage = 0
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
        npc.act_wait = ModCS.Game.Random(0, 50)

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

        if (npc.ani_no > 5) then
            npc.ani_no = 2
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
            npc.act_no = 15
            npc.ani_no = 2
            npc.ym = -1
            npc.damage = 2
        end
    elseif (npc.act_no == 15) then
        if (npc:TouchFloor()) then
            npc:SetBit(5) -- Set shootable bit
            npc.xm = 0
            npc.act_no = 10
            npc.damage = 0
        end
    elseif (npc.act_no == 20) then
        if (npc:TouchFloor()) then
            npc.xm = 0
            npc.act_no = 21
            npc.damage = 0

            if (npc.ani_no == 6) then
                npc.ani_no = 8
            else
                npc.ani_no = 9
            end

            npc.act_wait = ModCS.Game.Random(300, 400)
        end
    elseif (npc.act_no == 21) then
        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc:SetBit(5) -- Set shootable bit
            npc.life = 1000
            npc.act_no = 11
            npc.act_wait = ModCS.Game.Random(0, 50)
            npc.ani_no = 0
        end
    end

    if (npc.act_no > 10 and npc.act_no < 20 and npc.life ~= 1000) then
        npc.act_no = 20
        npc.ym = -1
        npc.ani_no = ModCS.Game.Random(6, 7)
        npc:UnsetBit(5) -- Unset shootable bit
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

-- Curly boss projectile
ModCS.Npc.Act[123] = function(npc)
    local rect = {
        ModCS.Rect.Create(192, 0, 208, 16),
        ModCS.Rect.Create(208, 0, 224, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
        ModCS.Rect.Create(240, 0, 256, 16),
    }

    local bBreak = false

    if (npc.act_no == 0) then
        npc.act_no = 1
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x, npc.y, 0)
        ModCS.Sound.Play(32)

        if (npc.direct == 0) then
            npc.xm = -8
            npc.ym = ModCS.Game.Random2(-0.25, 0.25)
        elseif (npc.direct == 1) then
            npc.ym = -8
            npc.xm = ModCS.Game.Random2(-0.25, 0.25)
        elseif (npc.direct == 2) then
            npc.xm = 8
            npc.ym = ModCS.Game.Random2(-0.25, 0.25)
        elseif (npc.direct == 3) then
            npc.ym = 8
            npc.xm = ModCS.Game.Random2(-0.25, 0.25)
        end
    elseif (npc.act_no == 1) then
        if (npc.direct == 0) then
            if (npc:TouchLeftWall()) then
                bBreak = true
            end
        elseif (npc.direct == 1) then
            if (npc:TouchCeiling()) then
                bBreak = true
            end
        elseif (npc.direct == 2) then
            if (npc:TouchRightWall()) then
                bBreak = true
            end
        elseif (npc.direct == 3) then
            if (npc:TouchFloor()) then
                bBreak = true
            end
        end

        npc:Move()
    end

    if (bBreak) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        ModCS.Sound.Play(28)
        npc.cond = 0
    end

    npc:SetRect(rect[npc.direct+1])
end

-- Sunstone
ModCS.Npc.Act[124] = function(npc)
    local rect = {
        ModCS.Rect.Create(160, 0, 192, 32),
        ModCS.Rect.Create(192, 0, 224, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.x = npc.x + 8
        npc.y = npc.y + 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc:UnsetBit(3) -- Unset ignore collision bit
        npc.ani_no = 0
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 1
        npc.act_wait = 0
        npc:SetBit(3) -- Ignore solid bit
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc.direct == 0) then
            npc.x = npc.x - 0.25
        elseif (npc.direct == 1) then
            npc.y = npc.y - 0.25
        elseif (npc.direct == 2) then
            npc.x = npc.x + 0.25
        elseif (npc.direct == 3) then
            npc.y = npc.y + 0.25
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 8 == 0) then
            ModCS.Sound.Play(26)
        end

        ModCS.Camera.SetQuake(20)
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Hidden item
ModCS.Npc.Act[125] = function(npc)
    if (npc.life < 990) then
        ModCS.Npc.Explode(npc.x, npc.y, npc:GetViewbox().back, 8)
        ModCS.Sound.Play(70)

        if (npc.direct == 0) then
            ModCS.Npc.Spawn2(87, npc.x, npc.y, 0, 0, 2)
        else
            ModCS.Npc.Spawn2(86, npc.x, npc.y, 0, 0, 2)
        end

        npc.cond = 0
    end

    local rc = {
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(16, 96, 32, 112),
    }

    if (npc.direct == 0) then
        npc:SetRect(rc[1])
    else
        npc:SetRect(rc[2])
    end
end

-- Puppy (running)
ModCS.Npc.Act[126] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(48, 144, 64, 160),
        ModCS.Rect.Create(64, 144, 80, 160),
        ModCS.Rect.Create(48, 144, 64, 160),
        ModCS.Rect.Create(80, 144, 96, 160),
        ModCS.Rect.Create(96, 144, 112, 160),
        ModCS.Rect.Create(112, 144, 128, 160),
    }

    local rcRight = {
        ModCS.Rect.Create(48, 160, 64, 176),
        ModCS.Rect.Create(64, 160, 80, 176),
        ModCS.Rect.Create(48, 160, 64, 176),
        ModCS.Rect.Create(80, 160, 96, 176),
        ModCS.Rect.Create(96, 160, 112, 176),
        ModCS.Rect.Create(112, 160, 128, 176),
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

        if (npc:TriggerBox(96, 32, 96, 16)) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end

        if (npc:TriggerBox(32, 32, 32, 16)) then
            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 2
            else
                npc.direct = 0
            end

            npc.act_no = 10
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 4
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (npc:TouchFloor()) then
            npc.ani_wait = npc.ani_wait + 1
            if (npc.ani_wait > 2) then
                npc.ani_wait = 0
                npc.ani_no = npc.ani_no + 1
            end

            if (npc.ani_no > 5) then
                npc.ani_no = 4
            end
        else
            npc.ani_no = 5
            npc.ani_wait = 0
        end

        if (npc.xm < 0 and npc:TouchLeftWall()) then
            npc.xm = npc.xm * -1
            npc.direct = 2
        end

        if (npc.xm > 0 and npc:TouchRightWall()) then
            npc.xm = npc.xm * -1
            npc.direct = 0
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.125
        else
            npc.xm = npc.xm + 0.125
        end

        if (npc.xm > 2.998046875) then
            npc.xm = 2
        end

        if (npc.xm < -2.998046875) then
            npc.xm = -2
        end
    end

    if (npc.tgt_mc:KeyDown()) then
        npc:SetBit(13) -- Set interactable bit
    else
        npc:UnsetBit(13) -- Unset interactable bit
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

-- Machine gun trail (Level 2)
ModCS.Npc.Act[127] = function(npc)
    local rcV = {
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(112, 64, 128, 80),
        ModCS.Rect.Create(112, 80, 128, 96),
    }

    local rcH = {
        ModCS.Rect.Create(64, 80, 80, 96),
        ModCS.Rect.Create(80, 80, 96, 96),
        ModCS.Rect.Create(96, 80, 112, 96),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 0) then
        npc.ani_wait = 0

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 2) then
            npc.cond = 0
            return
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcH[npc.ani_no+1])
    else
        npc:SetRect(rcV[npc.ani_no+1])
    end
end

-- Machine gun trail (Level 3)
ModCS.Npc.Act[128] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(176, 16, 184, 32),
        ModCS.Rect.Create(184, 16, 192, 32),
        ModCS.Rect.Create(192, 16, 200, 32),
        ModCS.Rect.Create(200, 16, 208, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(232, 16, 240, 32),
        ModCS.Rect.Create(224, 16, 232, 32),
        ModCS.Rect.Create(216, 16, 224, 32),
        ModCS.Rect.Create(208, 16, 216, 32),
    }

    local rcUp = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(176, 32, 192, 40),
        ModCS.Rect.Create(176, 40, 192, 48),
        ModCS.Rect.Create(192, 32, 208, 40),
        ModCS.Rect.Create(192, 40, 208, 48),
    }

    local rcDown = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(208, 32, 224, 40),
        ModCS.Rect.Create(208, 40, 224, 48),
        ModCS.Rect.Create(224, 32, 232, 40),
        ModCS.Rect.Create(224, 40, 232, 48),
    }

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        
        if (npc.direct == 0 or npc.direct == 2) then
            view.front = 4
            view.top = 8
        else
            view.front = 8
            view.top = 4
        end
    end

    npc.ani_no = npc.ani_no + 1
    if (npc.ani_no > 4) then
        npc.cond = 0
        return
    end

    npc:SetViewbox(view)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    elseif (npc.direct == 1) then
        npc:SetRect(rcUp[npc.ani_no+1])
    elseif (npc.direct == 2) then
        npc:SetRect(rcRight[npc.ani_no+1])
    elseif (npc.direct == 3) then
        npc:SetRect(rcDown[npc.ani_no+1])
    end
end

-- Fireball trial (Level 2 & 3)
ModCS.Npc.Act[129] = function(npc)
    local rect = {
        ModCS.Rect.Create(128, 48, 144, 64),
        ModCS.Rect.Create(144, 48, 160, 64),
        ModCS.Rect.Create(160, 48, 176, 64),

        ModCS.Rect.Create(128, 64, 144, 80),
        ModCS.Rect.Create(144, 64, 160, 80),
        ModCS.Rect.Create(160, 64, 176, 80),

        ModCS.Rect.Create(128, 80, 144, 96),
        ModCS.Rect.Create(144, 80, 160, 96),
        ModCS.Rect.Create(160, 80, 176, 96),

        ModCS.Rect.Create(176, 48, 192, 64),
        ModCS.Rect.Create(192, 48, 208, 64),
        ModCS.Rect.Create(208, 48, 224, 64),

        ModCS.Rect.Create(176, 64, 192, 80),
        ModCS.Rect.Create(192, 64, 208, 80),
        ModCS.Rect.Create(208, 64, 224, 80),

        ModCS.Rect.Create(176, 80, 192, 96),
        ModCS.Rect.Create(192, 80, 208, 96),
        ModCS.Rect.Create(208, 80, 224, 96),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 2) then
            npc.cond = 0
            return
        end
    end

    npc:Move()

    npc:SetRect(rect[((npc.direct * 3) + npc.ani_no)+1])
end

-- Puppy (sitting, wagging tail)
ModCS.Npc.Act[130] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(48, 144, 64, 160),
        ModCS.Rect.Create(64, 144, 80, 160),
        ModCS.Rect.Create(48, 144, 64, 160),
        ModCS.Rect.Create(80, 144, 96, 160),
    }

    local rcRight = {
        ModCS.Rect.Create(48, 160, 64, 176),
        ModCS.Rect.Create(64, 160, 80, 176),
        ModCS.Rect.Create(48, 160, 64, 176),
        ModCS.Rect.Create(80, 160, 96, 176),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc:SetBit(13) -- Set interactable bit
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

-- Puppy (sleeping)
ModCS.Npc.Act[131] = function(npc)
    local rcLeft = ModCS.Rect.Create(144, 144, 160, 160)
    local rcRight = ModCS.Rect.Create(144, 160, 160, 176)

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 100) then
        npc.act_wait = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_ZZZ, npc.x, npc.y, 0)
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight)
    end
end

-- Puppy (barking)
ModCS.Npc.Act[132] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(48, 144, 64, 160),
        ModCS.Rect.Create(64, 144, 80, 160),
        ModCS.Rect.Create(96, 144, 112, 160),
        ModCS.Rect.Create(96, 144, 112, 160),
        ModCS.Rect.Create(128, 144, 144, 160),
    }

    local rcRight = {
        ModCS.Rect.Create(48, 160, 64, 176),
        ModCS.Rect.Create(64, 160, 80, 176),
        ModCS.Rect.Create(96, 160, 112, 176),
        ModCS.Rect.Create(96, 160, 112, 176),
        ModCS.Rect.Create(128, 160, 144, 176),
    }

    if (npc.act_no < 100) then
        if (npc.tgt_mc.x < npc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    end

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

        if (npc:TriggerBox(64, 16, 64, 16)) then
            npc.ani_wait = npc.ani_wait + 1
            if (npc.ani_wait > 4) then
                npc.ani_wait = 0
                npc.ani_no = npc.ani_no + 1
            end

            if (npc.ani_no > 4) then
                npc.ani_no = 2
            end

            if (npc.ani_no == 4 and npc.ani_wait == 0) then
                ModCS.Sound.Play(105)
            end
        else
            if (npc.ani_no == 4) then
                npc.ani_no = 2
            end
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 1
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        if (ModCS.Game.Random(0, 120) == 10) then
            npc.act_no = 12
            npc.act_wait = 0
            npc.ani_no = 1
        end
    elseif (npc.act_no == 12) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 8) then
            npc.act_no = 11
            npc.ani_no = 0
        end
    elseif (npc.act_no == 100) then
        npc.act_no = 101
        npc.count1 = 0
        -- Fallthrough
    end

    if (npc.act_no == 101) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 4) then
            if (npc.count1 < 3) then
                npc.ani_no = 2
                npc.count1 = npc.count1 + 1
            else
                npc.ani_no = 0
                npc.count1 = 0
            end
        end

        if (npc.ani_no == 4 and npc.ani_wait == 0) then
            ModCS.Sound.Play(105)
        end
    elseif (npc.act_no == 120) then
        npc.ani_no = 0
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

-- Jenka
ModCS.Npc.Act[133] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(176, 32, 192, 48),
        ModCS.Rect.Create(192, 32, 208, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(176, 48, 192, 64),
        ModCS.Rect.Create(192, 48, 208, 64),
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
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Armadillo
ModCS.Npc.Act[134] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(224, 0, 256, 16),
        ModCS.Rect.Create(256, 0, 288, 16),
        ModCS.Rect.Create(288, 0, 320, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(224, 16, 256, 32),
        ModCS.Rect.Create(256, 16, 288, 32),
        ModCS.Rect.Create(288, 16, 320, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 2
        npc:UnsetBit(5) -- Unset shootable bit
        npc:SetBit(2) -- Set invulnerable bit
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TriggerBox(320, 160, 320, 64)) then
            npc.act_no = 10
            npc:SetBit(5) -- Set shootable bit
            npc:UnsetBit(2) -- Unset invulnerable bit
        end
    elseif (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 4) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc.direct == 0 and npc:TouchLeftWall()) then
            npc.direct = 2
        end

        if (npc.direct == 2 and npc:TouchRightWall()) then
            npc.direct = 0
        end

        if (npc.direct == 0) then
            npc.x = npc.x - 0.5
        else
            npc.x = npc.x + 0.5
        end

        if (ModCS.Arms.CountBullet(6) ~= 0) then
            npc.act_no = 20
            npc.act_wait = 0
            npc.ani_no = 2
            npc:UnsetBit(5) -- Unset shootable bit
            npc:SetBit(2) -- Set invulnerable bit
        end
    elseif (npc.act_no == 20) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_no = 10
            npc.ani_no = 0
            npc.ani_wait = 0
            npc:SetBit(5) -- Set shootable bit
            npc:UnsetBit(2) -- Unset invulnerable bit
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

-- Skeleton
ModCS.Npc.Act[135] = function(npc)
    local deg = 0
    local xm = 0
    local ym = 0

    local rcLeft = {
        ModCS.Rect.Create(256, 32, 288, 64),
        ModCS.Rect.Create(288, 32, 320, 64),
    }

    local rcRight = {
        ModCS.Rect.Create(256, 64, 288, 96),
        ModCS.Rect.Create(288, 64, 320, 96),
    }

    if not (npc:TriggerBox(352, 160, 352, 64)) then
        npc.act_no = 0
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.xm = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TriggerBox(320, 160, 320, 64)) then
            npc.act_no = 10
        end

        if (npc:TouchFloor()) then
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.xm = 0
        npc.act_no = 11
        npc.act_wait = 0
        npc.ani_no = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait >= 5 and npc:TouchFloor()) then
            npc.act_no = 20
            npc.ani_no = 1
            npc.count1 = 0
            npc.ym = -1 * ModCS.Game.Random(1, 3)

            if (npc:IsHit()) then
                if (npc.x < npc.tgt_mc.x) then
                    npc.xm = npc.xm - 0.5
                else
                    npc.xm = npc.xm + 0.5
                end
            else
                if (npc.x < npc.tgt_mc.x) then
                    npc.xm = npc.xm + 0.5
                else
                    npc.xm = npc.xm - 0.5
                end
            end
        end
    elseif (npc.act_no == 20) then
        if (npc.ym > 0 and npc.count1 == 0) then
            npc.count1 = npc.count1 + 1
            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, (npc.y + 4) - npc.tgt_mc.y)
            ym = ModCS.Triangle.GetSin(deg) * 2
            xm = ModCS.Triangle.GetCos(deg) * 2
            ModCS.Npc.Spawn2(50, npc.x, npc.y, xm, ym, 0)
            ModCS.Sound.Play(39)
        end

        if (npc:TouchFloor()) then
            npc.act_no = 10
            npc.ani_no = 0
        end
    end

    if (npc.act_no >= 10) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
    end

    npc.ym = npc.ym + 0.1
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    if (npc.xm > 2.998046875) then
        npc.xm = 2.998046875
    end

    if (npc.xm < -2.998046875) then
        npc.xm = -2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Puppy (carried)
ModCS.Npc.Act[136] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(48, 144, 64, 160),
        ModCS.Rect.Create(64, 144, 80, 160),
    }

    local rcRight = {
        ModCS.Rect.Create(48, 160, 64, 176),
        ModCS.Rect.Create(64, 160, 80, 176),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc:UnsetBit(13) -- Unset interactable bit
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
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

    if (npc.tgt_mc.direct == 0) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    npc.y = npc.tgt_mc.y - 10

    if (npc.direct == 0) then
        npc.x = npc.tgt_mc.x + 4
        rect = rcLeft[npc.ani_no+1]
    else
        npc.x = npc.tgt_mc.x - 4
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.tgt_mc.ani_no % 2 == 1) then
        rect.top = rect.top + 1
    end

    npc:SetRect(rect)
end

-- Large door (frame)
ModCS.Npc.Act[137] = function(npc)
    local rc = ModCS.Rect.Create(96, 136, 128, 188)
    npc:SetRect(rc)
end

-- Large door
ModCS.Npc.Act[138] = function(npc)
    local rcLeft = ModCS.Rect.Create(96, 112, 112, 136)
    local rcRight = ModCS.Rect.Create(112, 112, 128, 136)
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc:SetRect(rcLeft)
            npc.x = npc.x + 8
        else
            npc:SetRect(rcRight)
            npc.x = npc.x - 8
        end

        npc.tgt_x = npc.x
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 1
        npc.act_wait = 0
        npc:SetBit(3) -- Set ignore solid bit
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 8 == 0) then
            ModCS.Sound.Play(26)
        end

        if (npc.direct == 0) then
            rect = rcLeft
            rect.left = rect.left + (npc.act_wait / 8)
            npc:SetRect(rect)
        else
            npc.x = npc.tgt_x + (npc.act_wait / 8)
            rect = rcRight
            rect.right = rect.right - (npc.act_wait / 8)
            npc:SetRect(rect)
        end

        if (npc.act_wait == 104) then
            npc.cond = 0
        end
    end
end

-- Doctor
ModCS.Npc.Act[139] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 128, 24, 160),
        ModCS.Rect.Create(24, 128, 48, 160),
        ModCS.Rect.Create(48, 128, 72, 160),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 160, 24, 192),
        ModCS.Rect.Create(24, 160, 48, 192),
        ModCS.Rect.Create(48, 160, 72, 192),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.xm = 0
        npc.ym = 0
        npc.y = npc.y - 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TouchFloor()) then
            npc.ani_no = 0
        else
            npc.ani_no = 2
        end

        npc.ym = npc.ym + 0.125
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 1
        npc.ani_wait = 0
        npc.count1 = 0
        -- Fallthrough
    end
    
    if (npc.act_no == 11) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 6) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
            npc.count1 = npc.count1 + 1
        end

        if (npc.count1 > 8) then
            npc.ani_no = 0
            npc.act_no = 1
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        npc.ani_no = 2
        npc.tgt_y = npc.y - 32
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.0625
        else
            npc.ym = npc.ym - 0.0625
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.xm = 0
        npc.ym = 0
        npc.act_wait = (npc:GetRect().bottom - npc:GetRect().top) * 2
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.act_wait = npc.act_wait - 1
        npc.ani_no = 0

        if (npc.act_wait == 0) then
            npc.cond = 0
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.act_wait = 0
        npc.xm = 0
        npc.ym = 0
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        local done = false
        npc.ani_no = 2

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait < 64) then
            done = true
        end

        if not done then
            npc.act_no = 20
        end
    end

    npc:Move()

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 31 or npc.act_no == 41) then
        rect.bottom = rect.top + (npc.act_wait / 2)

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            rect.left = rect.left + 1
        end
    end

    npc:SetRect(rect)
end