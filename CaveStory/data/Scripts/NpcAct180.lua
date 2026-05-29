-- Curly AI
ModCS.Npc.Act[180] = function(npc)
    local xx = 0
    local yy = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(16, 96, 32, 112),
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(32, 96, 48, 112),
        ModCS.Rect.Create(0, 96, 16, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
        ModCS.Rect.Create(64, 96, 80, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
        ModCS.Rect.Create(80, 96, 96, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
        ModCS.Rect.Create(144, 96, 160, 112),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(16, 112, 32, 128),
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(32, 112, 48, 128),
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(48, 112, 64, 128),
        ModCS.Rect.Create(64, 112, 80, 128),
        ModCS.Rect.Create(48, 112, 64, 128),
        ModCS.Rect.Create(80, 112, 96, 128),
        ModCS.Rect.Create(48, 112, 64, 128),
        ModCS.Rect.Create(144, 112, 160, 128),
    }

    if (npc.y < npc.tgt_mc.y - (10 * 0x10)) then
        if (npc.y < (16 * 0x10)) then
            npc.tgt_x = 320 * 0x10
            npc.tgt_y = npc.y
        else
            npc.tgt_x = 0
            npc.tgt_y = npc.y
        end
    else
        if (ModCS.Npc.GetCurlyShootWait() ~= 0) then
            npc.tgt_x = ModCS.Npc.GetCurlyShootX()
            npc.tgt_y = ModCS.Npc.GetCurlyShootY()
        else
            npc.tgt_x = npc.tgt_mc.x
            npc.tgt_y = npc.tgt_mc.y
        end
    end

    if (npc.xm < 0 and npc:TouchLeftWall()) then
        npc.xm = 0
    end

    if (npc.xm > 0 and npc:TouchRightWall()) then
        npc.xm = 0
    end

    if (npc.act_no == 20) then
        npc.x = npc.tgt_mc.x
        npc.y = npc.tgt_mc.y
        npc.act_no = 100
        npc.ani_no = 0
        ModCS.Npc.Spawn3(183, 0, 0, 0, 0, 0, npc)

        if (ModCS.Flag.Get(563)) then -- Polar star if flag 563 is set
            ModCS.Npc.Spawn3(182, 0, 0, 0, 0, 0, npc)
        else -- Machine gun otherwise
            ModCS.Npc.Spawn3(181, 0, 0, 0, 0, 0, npc)
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.act_wait = 0
        npc.ani_no = 10
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 750) then
            npc:UnsetBit(13) -- Unset interactable bit
            npc.ani_no = 0
        end

        if (npc.act_wait > 1000) then
            npc.act_no = 100
            npc.ani_no = 0
            ModCS.Npc.Spawn3(183, 0, 0, 0, 0, 0, npc)

            if (ModCS.Flag.Get(563)) then -- Polar star if flag 563 is set
                ModCS.Npc.Spawn3(182, 0, 0, 0, 0, 0, npc)
            else -- Machine gun otherwise
                ModCS.Npc.Spawn3(181, 0, 0, 0, 0, 0, npc)
            end
        end
    elseif (npc.act_no == 100) then
        npc.ani_no = 0
        npc.xm = (npc.xm * 7) / 8
        npc.count1 = 0

        if (npc.x > npc.tgt_x + 16) then
            npc.act_no = 200
            npc.ani_no = 1
            npc.direct = 0
            npc.act_wait = ModCS.Game.Random(20, 60)
        elseif (npc.x < npc.tgt_x - 16) then
            npc.act_no = 300
            npc.ani_no = 1
            npc.direct = 2
            npc.act_wait = ModCS.Game.Random(20, 60)
        end
    elseif (npc.act_no == 200) then
        npc.xm = npc.xm - 0.0625
        npc.direct = 0

        if (npc:TouchLeftWall()) then
            npc.count1 = npc.count1 + 1
        else
            npc.count1 = 0
        end
    elseif (npc.act_no == 210) then
        npc.xm = npc.xm - 0.0625
        npc.direct = 0

        if (npc:TouchFloor()) then
            npc.act_no = 100
        end
    elseif (npc.act_no == 300) then
        npc.xm = npc.xm + 0.0625
        npc.direct = 2

        if (npc:TouchRightWall()) then
            npc.count1 = npc.count1 + 1
        else
            npc.count1 = 0
        end
    elseif (npc.act_no == 310) then
        npc.xm = npc.xm + 0.0625
        npc.direct = 2

        if (npc:TouchFloor()) then
            npc.act_no = 100
        end
    end

    if (ModCS.Npc.GetCurlyShootWait() ~= 0) then
        ModCS.Npc.SetCurlyShootWait(ModCS.Npc.GetCurlyShootWait() - 1)
    end

    if (ModCS.Npc.GetCurlyShootWait() == 70) then
        npc.count2 = 10
    end

    if (ModCS.Npc.GetCurlyShootWait() == 60 and npc:TouchFloor() and ModCS.Game.Random(0, 2)) then
        npc.count1 = 0
        npc.ym = -3
        npc.ani_no = 1
        ModCS.Sound.Play(15)

        if (npc.x > npc.tgt_x) then
            npc.act_no = 210
        else
            npc.act_no = 310
        end
    end

    xx = npc.x - npc.tgt_x
    yy = npc.y - npc.tgt_y

    if (xx < 0) then
        xx = xx * -1
    end

    if (npc.act_no == 100) then
        if (xx + 2 < yy) then
            npc.ani_no = 5
        else
            npc.ani_no = 0
        end
    end

    if (npc.act_no == 210 or npc.act_no == 310) then
        if (xx + 2 < yy) then
            npc.ani_no = 6
        else
            npc.ani_no = 1
        end
    end

    if (npc.act_no == 200 or npc.act_no == 300) then
        npc.ani_wait = npc.ani_wait + 1

        if (xx + 2 < yy) then
            npc.ani_no = 6 + (math.floor(npc.ani_wait / 4) % 4)
        else
            npc.ani_no = 1 + (math.floor(npc.ani_wait / 4) % 4)
        end

        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1

            if (npc:TouchFloor() and npc.count1 > 10) then
                npc.count1 = 0
                npc.ym = -3
                npc.act_no = npc.act_no + 10
                npc.ani_no = 1
                ModCS.Sound.Play(15)
            end
        else
            npc.act_no = 100
            npc.ani_no = 0
        end
    end

    if (npc.act_no >= 100 and npc.act_no < 500) then
        if (npc.x < npc.tgt_mc.x - 80 or npc.x > npc.tgt_mc.x + 80) then
            if (npc:TouchLeftWall() or npc:TouchRightWall()) then
                npc.ym = npc.ym + 0.03125
            else
                npc.ym = npc.ym + 0.1
            end
        else
            npc.ym = npc.ym + 0.1
        end
    end

    if (npc.xm > 1.5) then
        npc.xm = 1.5
    end

    if (npc.xm < -1.5) then
        npc.xm = -1.5
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.act_no >= 100 and not npc:TouchFloor()) then
        if (npc.ani_no ~= 1000) then
            if (xx + 2 < yy) then
                npc.ani_no = 6
            else
                npc.ani_no = 1
            end
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Curly AI Machine Gun
ModCS.Npc.Act[181] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(216, 152, 232, 168),
        ModCS.Rect.Create(232, 152, 248, 168),
    }

    local rcRight = {
        ModCS.Rect.Create(216, 168, 232, 184),
        ModCS.Rect.Create(232, 168, 248, 184),
    }

    if (npc.pNpc == nil) then
        return
    end

    if (npc.pNpc.ani_no < 5) then
        if (npc.pNpc.direct == 0) then
            npc.direct = 0
            npc.x = npc.pNpc.x - 8
        else
            npc.direct = 2
            npc.x = npc.pNpc.x + 8
        end

        npc.y = npc.pNpc.y
        npc.ani_no = 0
    else
        if (npc.pNpc.direct == 0) then
            npc.direct = 0
            npc.x = npc.pNpc.x
        else
            npc.direct = 2
            npc.x = npc.pNpc.x
        end

        npc.y = npc.pNpc.y - 10
        npc.ani_no = 1
    end

    if (npc.pNpc.ani_no == 1 or npc.pNpc.ani_no == 3 or npc.pNpc.ani_no == 6 or npc.pNpc.ani_no == 8) then
        npc.y = npc.y - 1
    end

    if (npc.act_no == 0) then
        if (npc.pNpc.count2 == 10) then
            npc.pNpc.count2 = 0
            npc.act_no = 10
            npc.act_wait = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 6 == 1) then
            if (npc.ani_no == 0) then
                if (npc.direct == 0) then
                    ModCS.Bullet.Spawn(12, npc.x - 4, npc.y + 3, 0)
                    ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x - 4, npc.y + 3, 0)
                else
                    ModCS.Bullet.Spawn(12, npc.x + 4, npc.y + 3, 2)
                    ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x + 4, npc.y + 3, 0)
                end
            else
                if (npc.direct == 0) then
                    ModCS.Bullet.Spawn(12, npc.x - 2, npc.y - 4, 1)
                    ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x - 2, npc.y - 4, 0)
                else
                    ModCS.Bullet.Spawn(12, npc.x + 2, npc.y - 4, 1)
                    ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x + 2, npc.y - 4, 0)
                end
            end
        end

        if (npc.act_wait == 60) then
            npc.act_no = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Curly AI Polar Star
ModCS.Npc.Act[182] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(184, 152, 200, 168),
        ModCS.Rect.Create(200, 152, 216, 168),
    }

    local rcRight = {
        ModCS.Rect.Create(184, 168, 200, 184),
        ModCS.Rect.Create(200, 168, 216, 184),
    }

    if (npc.pNpc == nil) then
        return
    end

    if (npc.pNpc.ani_no < 5) then
        if (npc.pNpc.direct == 0) then
            npc.direct = 0
            npc.x = npc.pNpc.x - 8
        else
            npc.direct = 2
            npc.x = npc.pNpc.x + 8
        end

        npc.y = npc.pNpc.y
        npc.ani_no = 0
    else
        if (npc.pNpc.direct == 0) then
            npc.direct = 0
            npc.x = npc.pNpc.x
        else
            npc.direct = 2
            npc.x = npc.pNpc.x
        end

        npc.y = npc.pNpc.y - 10
        npc.ani_no = 1
    end

    if (npc.pNpc.ani_no == 1 or npc.pNpc.ani_no == 3 or npc.pNpc.ani_no == 6 or npc.pNpc.ani_no == 8) then
        npc.y = npc.y - 1
    end

    if (npc.act_no == 0) then
        if (npc.pNpc.count2 == 10) then
            npc.pNpc.count2 = 0
            npc.act_no = 10
            npc.act_wait = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 12 == 1) then
            if (npc.ani_no == 0) then
                if (npc.direct == 0) then
                    ModCS.Bullet.Spawn(6, npc.x - 4, npc.y + 3, 0)
                    ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x - 4, npc.y + 3, 0)
                else
                    ModCS.Bullet.Spawn(6, npc.x + 4, npc.y + 3, 2)
                    ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x + 4, npc.y + 3, 0)
                end
            else
                if (npc.direct == 0) then
                    ModCS.Bullet.Spawn(6, npc.x - 2, npc.y - 4, 1)
                    ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x - 2, npc.y - 4, 0)
                else
                    ModCS.Bullet.Spawn(6, npc.x + 2, npc.y - 4, 1)
                    ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x + 2, npc.y - 4, 0)
                end
            end
        end

        if (npc.act_wait == 60) then
            npc.act_no = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Curly Air Tank Bubble
ModCS.Npc.Act[183] = function(npc)
    local rect = {
        ModCS.Rect.Create(56, 96, 80, 120),
        ModCS.Rect.Create(80, 96, 104, 120),
    }

    local rcNo = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.pNpc == nil) then
        return
    end

    if (npc.act_no == 0) then
        npc.x = npc.pNpc.x
        npc.y = npc.pNpc.y
        npc.act_no = 1
    end

    npc.x = npc.x + ((npc.pNpc.x - npc.x) / 2)
    npc.y = npc.y + ((npc.pNpc.y - npc.y) / 2)

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    if (npc.pNpc:TouchWater()) then
        npc:SetRect(rect[npc.ani_no+1])
    else
        npc:SetRect(rcNo)
    end
end

-- Big Shutter
ModCS.Npc.Act[184] = function(npc)
    local i = 0

    local rc = {
        ModCS.Rect.Create(0, 64, 32, 96),
        ModCS.Rect.Create(32, 64, 64, 96),
        ModCS.Rect.Create(64, 64, 96, 96),
        ModCS.Rect.Create(32, 64, 64, 96),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.x = npc.x + 8
        npc.y = npc.y + 8
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 1
        npc.act_wait = 0
        npc:SetBit(3) -- Set ignore tile collision bit
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
    elseif (npc.act_no == 20) then
        for i = 0, 3 do
            ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + 16, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        npc.act_no = 1
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 10) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 3) then
        npc.ani_no = 0
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Small Shutter
ModCS.Npc.Act[185] = function(npc)
    local rc = ModCS.Rect.Create(96, 64, 112, 96)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 8
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 1
        npc.act_wait = 0
        npc:SetBit(3) -- Set ignore tile collision bit
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
    elseif (npc.act_no == 20) then
        npc.y = npc.y - 24
        npc.act_no = 1
    end

    npc:SetRect(rc)
end

-- Lift block
ModCS.Npc.Act[186] = function(npc)
    local rc = {
        ModCS.Rect.Create(48, 48, 64, 64),
        ModCS.Rect.Create(64, 48, 80, 64),
        ModCS.Rect.Create(80, 48, 96, 64),
        ModCS.Rect.Create(64, 48, 80, 64),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 1
        npc.act_wait = 0
        npc:SetBit(3) -- Set ignore tile collision bit
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
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 10) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 3) then
        npc.ani_no = 0
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Fuzz Core
ModCS.Npc.Act[187] = function(npc)
    local i = 0

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.count1 = 120
        npc.act_wait = ModCS.Game.Random(0, 50)

        for i = 0, 4 do
            ModCS.Npc.Spawn3(188, 0, 0, 0, 0, 51 * i, npc)
        end
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
        npc.count1 = npc.count1 + 4

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

        if (npc.ym > 1.666015625) then
            npc.ym = 1.666015625
        end

        if (npc.ym < -1.666015625) then
            npc.ym = -1.666015625
        end
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(224, 104, 256, 136),
        ModCS.Rect.Create(256, 104, 288, 136),
    }

    local rect_right = {
        ModCS.Rect.Create(224, 136, 256, 168),
        ModCS.Rect.Create(256, 136, 288, 168),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Fuzz
ModCS.Npc.Act[188] = function(npc)
    local deg = 0

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.count1 = npc.direct
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.pNpc.id == 187 and ModCS.Game.CheckBit(npc.pNpc.cond, 0x80)) then
            deg = (npc.pNpc.count1 + npc.count1 % 0x100)
            npc.x = npc.pNpc.x + (ModCS.Triangle.GetSin(deg) * 20)
            npc.y = npc.pNpc.y + (ModCS.Triangle.GetCos(deg) * 0x20)
        else
            npc.xm = ModCS.Game.Random2(-1, 1)
            npc.ym = ModCS.Game.Random2(-1, 1)
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        if (npc.tgt_mc.x < npc.x) then
            npc.xm = npc.xm - 0.0625
        else
            npc.xm = npc.xm + 0.0625
        end

        if (npc.tgt_mc.y < npc.y) then
            npc.ym = npc.ym - 0.0625
        else
            npc.ym = npc.ym + 0.0625
        end

        if (npc.xm > 4) then
            npc.xm = 4
        end

        if (npc.xm < -4) then
            npc.xm = -4
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        npc:Move()
    end

    if (npc.tgt_mc.x < npc.x) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    local rect_left = {
        ModCS.Rect.Create(288, 104, 304, 120),
        ModCS.Rect.Create(304, 104, 320, 120),
    }

    local rect_right = {
        ModCS.Rect.Create(288, 120, 304, 136),
        ModCS.Rect.Create(304, 120, 320, 136),
    }

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Unused homing flame object
ModCS.Npc.Act[189] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.xm = npc.xm - 0.125
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc:Move()

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 256) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        if (npc.tgt_mc.x < npc.x) then
            npc.xm = npc.xm - 0.015625
        else
            npc.xm = npc.xm + 0.015625
        end

        if (npc.tgt_mc.y < npc.y) then
            npc.ym = npc.ym - 0.015625
        else
            npc.ym = npc.ym + 0.015625
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
    end

    if (npc.tgt_mc.x < npc.x) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 2) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    local rect = {
        ModCS.Rect.Create(224, 184, 232, 200),
        ModCS.Rect.Create(232, 184, 240, 200),
        ModCS.Rect.Create(240, 184, 248, 200),
    }

    npc:SetRect(rect[npc.ani_no+1])
end

-- Broken robot
ModCS.Npc.Act[190] = function(npc)
    local rect = {
        ModCS.Rect.Create(192, 32, 208, 48),
        ModCS.Rect.Create(208, 32, 224, 48),
    }

    local i = 0

    if (npc.act_no == 0) then
        npc.ani_no = 0
    elseif (npc.act_no == 10) then
        ModCS.Sound.Play(72)

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, npc.x, npc.y + ModCS.Game.Random(-8, 8), ModCS.Game.Random2(-8, -2), ModCS.Game.Random2(-3, 3), 0)
        end

        npc.cond = 0
    elseif (npc.act_no == 20) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 10) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Water level
ModCS.Npc.Act[191] = function(npc)
    local rc = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.act_no = 10
        npc.tgt_y = npc.y
        npc.ym = 1
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.0078125
        else
            npc.ym = npc.ym - 0.0078125
        end

        if (npc.ym < -0.5) then
            npc.ym = -0.5
        end

        if (npc.ym > 0.5) then
            npc.ym = 0.5
        end

        npc:Move()
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.0078125
        else
            npc.ym = npc.ym - 0.0078125
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        npc:Move()

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 1000) then
            npc.act_no = 22
        end
    elseif (npc.act_no == 22) then
        if (npc.y < 0) then
            npc.ym = npc.ym + 0.0078125
        else
            npc.ym = npc.ym - 0.0078125
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        npc:Move()

        if (npc.y < 64 or ModCS.Npc.GetSuperY() ~= 0) then
            npc.act_no = 21
            npc.act_wait = 0
        end
    elseif (npc.act_no == 30) then
        if (npc.y < 0) then
            npc.ym = npc.ym + 0.0078125
        else
            npc.ym = npc.ym - 0.0078125
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        npc:Move()
    end
    
    ModCS.Back.waterY = npc.y

    npc:SetRect(rc)
end

-- Scooter
ModCS.Npc.Act[192] = function(npc)
    local view = npc:GetViewbox()
    if (npc.act_no == 0) then
        npc.act_no = 1
        view.back = 16
        view.front = 16
        view.top = 8
        view.bottom = 8
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 1
        view.top = 16
        view.bottom = 16
        npc.y = npc.y - 5
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.x = npc.tgt_x + ModCS.Game.Random(-1, 1)
        npc.y = npc.tgt_y + ModCS.Game.Random(-1, 1)

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 30) then
            npc.act_no = 30
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 1
        npc.xm = -4
        npc.x = npc.tgt_x
        npc.y = npc.tgt_y
        ModCS.Sound.Play(44)
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.xm = npc.xm + 0.0625
        npc.x = npc.x + npc.xm
        npc.act_wait = npc.act_wait + 1
        npc.y = npc.tgt_y + ModCS.Game.Random(-1, 1)

        if (npc.act_wait > 10) then
            npc.direct = 2
        end

        if (npc.act_wait > 200) then
            npc.act_no = 40
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.act_wait = 2
        npc.direct = 0
        npc.y = npc.y - 48
        npc.xm = -8
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc:Move()

        npc.act_wait = npc.act_wait + 2

        if (npc.act_wait > 1200) then
            npc.cond = 0
        end
    end

    if (npc.act_wait % 4 == 0 and npc.act_no >= 20) then
        ModCS.Sound.Play(34)

        if (npc.direct == 0) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x + 10, npc.y + 10, 2)
        else
            ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x - 10, npc.y + 10, 0)
        end
    end

    local rcLeft = {
        ModCS.Rect.Create(224, 64, 256, 80),
        ModCS.Rect.Create(256, 64, 288, 96), -- Kazuma + Booster
    }

    local rcRight = {
        ModCS.Rect.Create(224, 80, 256, 96),
        ModCS.Rect.Create(288, 64, 320, 96), -- Kazuma + Booster
    }

    npc:SetViewbox(view)

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Scooter (broken)
ModCS.Npc.Act[193] = function(npc)
    local rc = ModCS.Rect.Create(256, 96, 320, 112)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.x = npc.x + 24
    end

    npc:SetRect(rc)
end

-- Blue robot (broken)
ModCS.Npc.Act[194] = function(npc)
    local rc = ModCS.Rect.Create(192, 120, 224, 128)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 4
    end

    npc:SetRect(rc)
end

-- Grate
ModCS.Npc.Act[195] = function(npc)
    local rc = ModCS.Rect.Create(112, 64, 128, 80)
    npc:SetRect(rc)
end

-- Ironhead motion wall
ModCS.Npc.Act[196] = function(npc)
    local rcLeft = ModCS.Rect.Create(112, 64, 144, 80)
    local rcRight = ModCS.Rect.Create(112, 80, 144, 96)

    npc.x = npc.x - 6

    if (npc.x <= 19 * 0x10) then
        npc.x = npc.x + 22 * 0x10
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight)
    end
end

-- Porcupine Fish
ModCS.Npc.Act[197] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 0, 16, 16),
        ModCS.Rect.Create(16, 0, 32, 16),
        ModCS.Rect.Create(32, 0, 48, 16),
        ModCS.Rect.Create(48, 0, 64, 16),
    }

    if (npc.act_no == 0) then
        npc.act_no = 10
        npc.ani_wait = 0
        npc.ym = ModCS.Game.Random2(-1, 1)
        npc.xm = 4
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc.xm < 0) then
            npc.damage = 3
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.damage = 3

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end

        if (npc.x < 48) then
            npc.destroy_voice = 0
            npc:Kill(true)
        end
    end

    if (npc:TouchCeiling()) then
        npc.ym = 1
    end

    if (npc:TouchFloor()) then
        npc.ym = -1
    end

    npc.xm = npc.xm - 0.0234375

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ironhead projectile
ModCS.Npc.Act[198] = function(npc)
    local rcRight = {
        ModCS.Rect.Create(208, 48, 224, 72),
        ModCS.Rect.Create(224, 48, 240, 72),
        ModCS.Rect.Create(240, 48, 256, 72),
    }

    if (npc.act_no == 0) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20) then
            npc.act_no = 1
            npc.xm = 0
            npc.ym = 0
            npc.count1 = 0
        end
    elseif (npc.act_no == 1) then
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

    npc:Move()

    npc:SetRect(rcRight[npc.ani_no+1])

    npc.count1 = npc.count1 + 1
    if (npc.count1 > 100) then
        npc.cond = 0
    end

    if (npc.count1 % 4 == 1) then
        ModCS.Sound.Play(46)
    end
end

-- Water/wind particles
ModCS.Npc.Act[199] = function(npc)
    local rect = {
        ModCS.Rect.Create(72, 16, 74, 18),
        ModCS.Rect.Create(74, 16, 76, 18),
        ModCS.Rect.Create(76, 16, 78, 18),
        ModCS.Rect.Create(78, 16, 80, 18),
        ModCS.Rect.Create(80, 16, 82, 18),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = ModCS.Game.Random(0, 2)

        if (npc.direct == 0) then
            npc.xm = -0.001953125
        elseif (npc.direct == 1) then
            npc.ym = -0.001953125
        elseif (npc.direct == 2) then
            npc.xm = 0.001953125
        elseif (npc.direct == 3) then
            npc.ym = 0.001953125
        end

        npc.xm = npc.xm * (ModCS.Game.Random3(4, 8) / 2)
        npc.ym = npc.ym * (ModCS.Game.Random3(4, 8) / 2)
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 6) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 4) then
        npc.cond = 0
        return
    end

    npc:Move()

    npc:SetRect(rect[npc.ani_no+1])
end