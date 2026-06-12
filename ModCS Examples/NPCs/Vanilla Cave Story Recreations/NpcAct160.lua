-- Puu Black
ModCS.Npc.Act[160] = function(npc)
    local i = 0

    if (npc.act_no == 0) then
        npc:UnsetBit(0) -- Unset 'solid soft' bit
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then

        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end


        npc.ym = 5

        if (npc.y < 128) then
            npc.count1 = npc.count1 + 1
        else
            npc:UnsetBit(3) -- Unset ignore tile collision bit
            npc.act_no = 2
        end
    elseif (npc.act_no == 2) then
        npc.ym = 5

        if (npc:TouchFloor()) then
            ModCS.Npc.KillEveryID(161, true)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end

            npc.act_no = 3
            npc.act_wait = 0
            ModCS.Camera.SetQuake(30)
            ModCS.Sound.Play(26)
            ModCS.Sound.Play(72)
        end

        if (npc.y < npc.tgt_mc.y and npc:TouchFloor()) then
            npc.damage = 20
        else
            npc.damage = 0
        end
    elseif (npc.act_no == 3) then
        npc.damage = 20 -- Overwritten by the following line ?
        npc.damage = 0

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 24) then
            npc.act_no = 4
            npc.count1 = 0
            npc.count2 = 0
        end
    elseif (npc.act_no == 4) then
        ModCS.Npc.SetSuperX(npc.x)
        ModCS.Npc.SetSuperY(npc.y)

        if (npc.shock % 2 == 1) then
            ModCS.Npc.Spawn2(161, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-3, 3), ModCS.Game.Random(-3, 3), 0)

            npc.count1 = npc.count1 + 1
            if (npc.count1 > 30) then
                npc.count1 = 0
                npc.act_no = 5
                npc.ym = -6
                npc:SetBit(3) -- Set ignore tile collision bit
            end
        end
    elseif (npc.act_no == 5) then
        ModCS.Npc.SetSuperX(npc.x)
        ModCS.Npc.SetSuperY(npc.y)

        npc.count1 = npc.count1 + 1
        if (npc.count1 > 60) then
            npc.count1 = 0
            npc.act_no = 6
        end
    elseif (npc.act_no == 6) then
        ModCS.Npc.SetSuperX(npc.tgt_mc.x)
        ModCS.Npc.SetSuperY(400 * 0x10)

        npc.count1 = npc.count1 + 1
        if (npc.count1 > 110) then
            npc.count1 = 10
            npc.x = npc.tgt_mc.x
            npc.y = 0
            npc.ym = 2.998046875
            npc.act_no = 1
        end
    end

    npc:Move()

    npc.ani_no = 3

    if npc.act_no == 3 then
        npc.ani_no = 2
    elseif npc.act_no == 4 then
        npc.ani_no = 0
    end

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

    if (npc.direct == 0) then
        npc:SetRect(rect_left[npc.ani_no+1])
    else
        npc:SetRect(rect_right[npc.ani_no+1])
    end
end

-- Puu Black projectile
ModCS.Npc.Act[161] = function(npc)
    npc.exp = 0

    if (npc.x < ModCS.Npc.GetSuperX()) then
        npc.xm = npc.xm + 0.125
    else
        npc.xm = npc.xm - 0.125
    end

    if (npc.y < ModCS.Npc.GetSuperY()) then
        npc.ym = npc.ym + 0.125
    else
        npc.ym = npc.ym - 0.125
    end

    if (npc.xm < -8.994140625) then
        npc.xm = -8.994140625
    end

    if (npc.xm > 8.994140625) then
        npc.xm = 8.994140625
    end

    if (npc.ym < -8.994140625) then
        npc.ym = -8.994140625
    end

    if (npc.ym > 8.994140625) then
        npc.ym = 8.994140625
    end

    if (npc.life < 100) then
        npc:UnsetBit(5) -- Unset shootable bit
        npc:UnsetBit(2) -- Unset invulnerable bit
        npc.damage = 0
        npc.ani_no = 2
    end

    npc:Move()

    if (npc.ani_no < 2) then
        if (ModCS.Game.Random(0, 10) == 2) then
            npc.ani_no = 0
        else
            npc.ani_no = 1
        end
    end

    local rect = {
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
        ModCS.Rect.Create(32, 48, 48, 64),
    }

    npc:SetRect(rect[npc.ani_no+1])
end

-- Puu Black (dead)
ModCS.Npc.Act[162] = function(npc)
    local i = 0
    
    local rect_left = ModCS.Rect.Create(40, 0, 80, 24)
    local rect_right = ModCS.Rect.Create(40, 24, 80, 48)
    local rect_end = ModCS.Rect.Create(0, 0, 0, 0)
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        ModCS.Npc.KillEveryID(161, true)
        ModCS.Sound.Play(72)

        for i = 0, 9 do
            ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-3, 3), ModCS.Game.Random(-3, 3), 0)
        end

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        if (npc.direct == 0) then
            npc:SetRect(rect_left)
        else
            npc:SetRect(rect_right)
        end

        npc.count1 = 0
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.count1 = npc.count1 + 1

        if (npc.count1 % 4 == 0) then
            ModCS.Npc.Spawn2(161, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), 0, 0, 0)
        end

        if (npc.count1 > 160) then
            npc.count1 = 0
            npc.act_no = 2
            npc.tgt_y = npc.y
        end
    elseif (npc.act_no == 2) then
        ModCS.Camera.SetQuake(2)

        npc.count1 = npc.count1 + 1

        if (npc.count1 <= 240) then
            if (npc.direct == 0) then
                rect = rect_left
            else
                rect = rect_right
            end

            rect.top = rect.top + (npc.count1 / 8)
            npc.y = npc.tgt_y + ((npc.count1 / 8))
            rect.left = rect.left - (math.floor(npc.count1 / 2) % 2)
            npc:SetRect(rect)
        else
            npc:SetRect(rect_end)

            npc.count1 = 0
            npc.act_no = 3
        end

        if (npc.count1 % 3 == 2) then
            ModCS.Npc.Spawn2(161, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), 0.5, 0, 0)
        end

        if (npc.count1 % 4 == 2) then
            ModCS.Sound.Play(21)
        end
    elseif (npc.act_no == 3) then
        npc.count1 = npc.count1 + 1
        if (npc.count1 >= 60) then
            ModCS.Npc.KillEveryID(161, true)
            npc.cond = 0
        end
    end

    ModCS.Npc.SetSuperX(npc.x)
    ModCS.Npc.SetSuperY(-1000)
end

-- Dr Gero
ModCS.Npc.Act[163] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(192, 0, 208, 16),
        ModCS.Rect.Create(208, 0, 224, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
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

-- Nurse Hasumi
ModCS.Npc.Act[164] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(224, 0, 240, 16),
        ModCS.Rect.Create(240, 0, 256, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(224, 16, 240, 32),
        ModCS.Rect.Create(240, 16, 256, 32),
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

-- Curly (collapsed)
ModCS.Npc.Act[165] = function(npc)
    local rcRight = {
        ModCS.Rect.Create(192, 96, 208, 112),
        ModCS.Rect.Create(208, 96, 224, 112),
    }

    local rcLeft = ModCS.Rect.Create(144, 96, 160, 112)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y + 10
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.direct == 2 and npc:TriggerBox(32, 16, 32, 16)) then
            npc.ani_no = 1
        else
            npc.ani_no = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft)
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Chaba
ModCS.Npc.Act[166] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(144, 104, 184, 128),
        ModCS.Rect.Create(184, 104, 224, 128),
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

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Professor Booster (falling)
ModCS.Npc.Act[167] = function(npc)
    local i = 0

    local rect = {
        ModCS.Rect.Create(304, 0, 320, 16),
        ModCS.Rect.Create(304, 16, 320, 32),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 1
    elseif (npc.act_no == 10) then
        npc.ani_no = 0

        npc.ym = npc.ym + 0.125
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        npc.ani_no = 0
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 2) then
            npc.ani_no = 1
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(-12, 12), npc.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end

            npc.cond = 0
        end
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Boulder
ModCS.Npc.Act[168] = function(npc)
    local rect = ModCS.Rect.Create(264, 56, 320, 96)

    if (npc.act_no == 0) then
        npc.act_no = 1
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        npc.tgt_x = npc.x
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        npc.x = npc.tgt_x

        if (math.floor(npc.act_wait / 3) % 2 == 1) then
            npc.x = npc.x + 1
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        npc.ym = -2
        npc.xm = 0.5
        ModCS.Sound.Play(25)
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ym = npc.ym + 0.03125

        npc:Move()

        if (npc.act_wait ~= 0 and npc:TouchFloor()) then
            ModCS.Sound.Play(35)
            ModCS.Camera.SetQuake(40)
            npc.act_no = 0
        end

        if (npc.act_wait == 0) then
            npc.act_wait = npc.act_wait + 1
        end
    end

    npc:SetRect(rect)
end

-- Balrog (missile)
ModCS.Npc.Act[169] = function(npc)
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
            npc.xm = npc.xm - 0.0625
        else
            npc.xm = npc.xm + 0.0625
        end

        if (npc.act_wait >= 8 and npc:TriggerBox(12, 0, 12, 8)) then
            npc.act_no = 10
            npc.ani_no = 5
            npc.tgt_mc.cond = ModCS.Game.SetBit(npc.tgt_mc.cond, 2) -- Hide player
            npc.tgt_mc:DamageMyID(5)
        else
            npc.act_wait = npc.act_wait + 1

            if (npc.act_wait > 75) then
                npc.act_no = 9
                npc.ani_no = 0
            else
                if (npc:TouchLeftWall() or npc:TouchRightWall()) then
                    if (npc.count2 < 5) then
                        npc.count2 = npc.count2 + 1
                    else
                        npc.act_no = 4
                        npc.act_wait = 0
                        npc.ani_no = 7
                        npc.ym = -2.998046875
                    end
                else
                    npc.count2 = 0
                end

                if (npc.count1 % 2 == 0 and npc.act_wait > 25) then
                    npc.act_no = 4
                    npc.act_wait = 0
                    npc.ani_no = 7
                    npc.ym = -2.998046875
                end
            end
        end
    elseif (npc.act_no == 4) then
        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.act_wait = npc.act_wait + 1

        if (npc.act_wait < 30 and npc.act_wait % 6 == 1) then
            ModCS.Sound.Play(39)
            ModCS.Npc.Spawn2(170, npc.x, npc.y, 0, 0, npc.direct)
        end

        if (npc:TouchFloor()) then
            npc.act_no = 9
            npc.ani_no = 8
            ModCS.Camera.SetQuake(30)
            ModCS.Sound.Play(26)
        end

        if (npc.act_wait >= 8 and npc:TriggerBox(12, 0, 12, 8)) then
            npc.act_no = 10
            npc.ani_no = 5
            npc.tgt_mc.cond = ModCS.Game.SetBit(npc.tgt_mc.cond, 2) -- Hide player
            npc.tgt_mc:DamageMyID(10)
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

    if (npc.xm < -1.5) then
        npc.xm = -1.5
    end

    if (npc.xm > 1.5) then
        npc.xm = 1.5
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

-- Balrog missile (projectile)
ModCS.Npc.Act[170] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(112, 96, 128, 104),
        ModCS.Rect.Create(128, 96, 144, 104),
    }

    local rcRight = {
        ModCS.Rect.Create(112, 104, 128, 112),
        ModCS.Rect.Create(128, 104, 144, 112),
    }

    local bHit = false

    if (npc.direct == 0 and npc:TouchLeftWall()) then
        bHit = true
    end

    if (npc.direct == 2 and npc:TouchRightWall()) then
        bHit = true
    end

    if (bHit) then
        ModCS.Sound.Play(44)
        ModCS.Npc.Explode(npc.x, npc.y, 0, 3)
        npc:Vanish()
        return
    end

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.xm = ModCS.Game.Random2(1, 2)
        else
            npc.xm = ModCS.Game.Random2(-2, -1)
        end

        npc.ym = ModCS.Game.Random2(-2, 0)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.count1 = npc.count1 + 1

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.0625

            if (npc.count1 % 3 == 1) then
                ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x + 8, npc.y, 2)
            end
        else
            npc.xm = npc.xm + 0.0625

            if (npc.count1 % 3 == 1) then
                ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, npc.x - 8, npc.y, 0)
            end
        end

        if (npc.count1 < 50) then
            if (npc.y < npc.tgt_mc.y) then
                npc.ym = npc.ym + 0.0625
            else
                npc.ym = npc.ym - 0.0625
            end
        else
            npc.ym = 0
        end

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    if (npc.xm < -2) then
        npc.xm = -3
    end

    if (npc.xm > 2) then
        npc.xm = 3
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Fire Whirrr
ModCS.Npc.Act[171] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(120, 48, 152, 80),
        ModCS.Rect.Create(152, 48, 184, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(184, 48, 216, 80),
        ModCS.Rect.Create(216, 48, 248, 80),
    }

    if (npc.x > npc.tgt_mc.x) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = ModCS.Game.Random(0, 50)
        npc.tgt_y = npc.y
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc.act_no = 10
            npc.ym = 1
        end
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.03125
        else
            npc.ym = npc.ym - 0.03125
        end

        if (npc.ym > 1) then
            npc.ym = 1
        end

        if (npc.ym < -1) then
            npc.ym = -1
        end

        npc:Move()

        if (npc.direct == 0) then
            if (npc:TriggerBox(160, 80, 0, 80)) then
                npc.count1 = npc.count1 + 1
            end
        else
            if (npc:TriggerBox(0, 80, 160, 0)) then
                npc.count1 = npc.count1 + 1
            end
        end

        if (npc.count1 > 20) then
            ModCS.Npc.Spawn2(172, npc.x, npc.y, 0, 0, npc.direct)
            npc.count1 = -100
            ModCS.Npc.SetCurlyShootWait(ModCS.Game.Random(80, 100))
            ModCS.Npc.SetCurlyShootX(npc.x)
            ModCS.Npc.SetCurlyShootY(npc.y)
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Fire Whirr projectile
ModCS.Npc.Act[172] = function(npc)
    local rect = {
        ModCS.Rect.Create(248, 48, 264, 80),
        ModCS.Rect.Create(264, 48, 280, 80),
        ModCS.Rect.Create(280, 48, 296, 80),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end

        if (npc.direct == 0) then
            npc.x = npc.x - 1
        else
            npc.x = npc.x + 1
        end

        if (npc:TouchLeftWall() or npc:TouchRightWall()) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
            npc:Vanish()
            return
        end
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Gaudi (armoured)
ModCS.Npc.Act[173] = function(npc)
    local deg = 0
    local xm = 0
    local ym = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 128, 24, 152),
        ModCS.Rect.Create(24, 128, 48, 152),
        ModCS.Rect.Create(48, 128, 72, 152),
        ModCS.Rect.Create(72, 128, 96, 152),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 152, 24, 176),
        ModCS.Rect.Create(24, 152, 48, 176),
        ModCS.Rect.Create(48, 152, 72, 176),
        ModCS.Rect.Create(72, 152, 96, 176),
    }

    if not (npc:TriggerBox((ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120, (ModCS.Const.WINDOW_WIDTH / 2) + 160, (ModCS.Const.WINDOW_HEIGHT / 2) + 120)) then
        return
    end

    if (npc.act_no == 0) then
        npc.tgt_x = npc.x
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
        npc.xm = 0

        if (npc.act_wait < 5) then
            npc.act_wait = npc.act_wait + 1
        else
            if (npc:TriggerBox(192, 160, 192, 160)) then
                npc.act_no = 10
                npc.act_wait = 0
                npc.ani_no = 1
            end
        end
    elseif (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3) then
            npc.count1 = npc.count1 + 1
            if (npc.count1 == 3) then
                ModCS.Sound.Play(30)
                npc.count1 = 0
                npc.act_no = 25
                npc.act_wait = 0
                npc.ani_no = 2
                npc.ym = -3

                if (npc.x < npc.tgt_x) then
                    npc.xm = 0.25
                else
                    npc.xm = -0.25
                end
            else
                ModCS.Sound.Play(30)
                npc.act_no = 20
                npc.ani_no = 2
                npc.ym = -1

                if (npc.x < npc.tgt_x) then
                    npc.xm = 1
                else
                    npc.xm = -1
                end
            end
        end
    elseif (npc.act_no == 20) then
        npc.act_wait = npc.act_wait + 1

        if (npc:TouchFloor()) then
            ModCS.Sound.Play(23)
            npc.ani_no = 1
            npc.act_no = 30
            npc.act_wait = 0
        end
    elseif (npc.act_no == 25) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30 or npc.act_wait == 40) then
            deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_mc.x, npc.y - npc.tgt_mc.y)
            deg = deg + ModCS.Game.Random(-6, 6)
            ym = ModCS.Triangle.GetSin(deg) * 3
            xm = ModCS.Triangle.GetCos(deg) * 3

            ModCS.Npc.Spawn2(174, npc.x, npc.y, xm, ym, 0)
            
            ModCS.Sound.Play(39)
            npc.ani_no = 3
            ModCS.Npc.SetCurlyShootWait(ModCS.Game.Random(80, 100))
            ModCS.Npc.SetCurlyShootX(npc.x)
            ModCS.Npc.SetCurlyShootY(npc.y)
        end

        if (npc.act_wait == 35 or npc.act_wait == 45) then
            npc.ani_no = 2
        end

        if (npc:TouchFloor()) then
            ModCS.Sound.Play(23)
            npc.ani_no = 1
            npc.act_no = 30
            npc.act_wait = 0
        end
    elseif (npc.act_no == 30) then
        npc.xm = 7 * npc.xm / 8

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 3) then
            npc.ani_no = 0
            npc.act_no = 1
            npc.act_wait = 0
        end
    end

    npc.ym = npc.ym + 0.099609375

    if (npc.tgt_mc.x < npc.x) then
        npc.direct = 0
    else
        npc.direct = 2
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    if (npc.ym < -2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    if (npc.life <= 985) then
        ModCS.Npc.Explode(npc.x, npc.y, 0, 2)
        npc.id = 154
        npc.act_no = 0
    end
end

-- Armoured-Gaudi projectile
ModCS.Npc.Act[174] = function(npc)
    local bHit = false

    if (npc.act_no == 0) then
        if (npc.direct == 2) then
            npc.act_no = 2
        else
            npc.act_no = 1
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc:Move()

        bHit = false

        if (npc:TouchLeftWall()) then
            bHit = true
            npc.xm = 1
        end

        if (npc:TouchRightWall()) then
            bHit = true
            npc.xm = -1
        end

        if (npc:TouchCeiling()) then
            bHit = true
            npc.ym = 1
        end

        if (npc:TouchFloor()) then
            bHit = true
            npc.ym = -1
        end

        if (bHit) then
            npc.act_no = 2
            npc.count1 = npc.count1 + 1
            ModCS.Sound.Play(31)
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

    local rect_left = {
        ModCS.Rect.Create(120, 80, 136, 96),
        ModCS.Rect.Create(136, 80, 152, 96),
        ModCS.Rect.Create(152, 80, 168, 96),
    }

    npc.ani_no = npc.ani_no + 1
    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    npc:SetRect(rect_left[npc.ani_no+1])
end

-- Gaudi egg
ModCS.Npc.Act[175] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(168, 80, 192, 104),
        ModCS.Rect.Create(192, 80, 216, 104),
    }

    local rcRight = {
        ModCS.Rect.Create(216, 80, 240, 104),
        ModCS.Rect.Create(240, 80, 264, 104),
    }

    if (npc.act_no < 3 and npc.life < 90) then
        npc:Kill(false)
        npc.act_no = 10
        npc.ani_no = 1
        npc:UnsetBit(5) -- Unset shootable bit
        npc.damage = 0
    end

    if (npc.act_no == 0) then
        npc.ani_no = 0
        npc.act_no = 1
    end

    if (npc.direct == 0) then
        npc.ym = npc.ym + 0.0625
    else
        npc.ym = npc.ym - 0.0625
    end

    if (npc.ym < -2.998046875) then
        npc.ym = -2.998046875
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

-- BuyoBuyo Base
ModCS.Npc.Act[176] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(96, 128, 128, 144),
        ModCS.Rect.Create(128, 128, 160, 144),
        ModCS.Rect.Create(160, 128, 192, 144),
    }

    local rcRight = {
        ModCS.Rect.Create(96, 144, 128, 160),
        ModCS.Rect.Create(128, 144, 160, 160),
        ModCS.Rect.Create(160, 144, 192, 160),
    }

    if (npc.act_no < 3 and npc.life < 940) then
        npc:Kill(false)
        npc.act_no = 10
        npc.ani_no = 2
        npc:UnsetBit(5) -- Unset shootable bit
        npc.damage = 0
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.direct == 0) then
            if (npc:TriggerBox(160, 160, 160, 16)) then
                npc.count1 = npc.count1 + 1
            end
        else
            if (npc:TriggerBox(160, 16, 160, 160)) then
                npc.count1 = npc.count1 + 1
            end
        end

        if (npc.count1 > 10) then
            npc.act_no = 2
            npc.act_wait = 0
        end
    elseif (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.count2 = npc.count2 + 1
            if (npc.count2 > 2) then
                npc.count2 = 0
                npc.count1 = -90
            else
                npc.count1 = -10
            end

            if (npc.direct == 0) then
                ModCS.Npc.Spawn2(177, npc.x, npc.y - 8, 0, 0, 0)
            else
                ModCS.Npc.Spawn2(177, npc.x, npc.y + 8, 0, 0, 2)
            end

            ModCS.Sound.Play(39)

            npc.act_no = 0
            npc.ani_no = 0

            ModCS.Npc.SetCurlyShootWait(ModCS.Game.Random(80, 100))
            ModCS.Npc.SetCurlyShootX(npc.x)
            ModCS.Npc.SetCurlyShootY(npc.y)
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- BuyoBuyo
ModCS.Npc.Act[177] = function(npc)
    local rc = {
        ModCS.Rect.Create(192, 128, 208, 144),
        ModCS.Rect.Create(208, 128, 224, 144),
    }

    if (npc:TouchTile()) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x, npc.y, 0)
        npc.cond = 0
        return
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        
        if (npc.direct == 0) then
            npc.ym = -3
        else
            npc.ym = 3
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.y < npc.tgt_mc.y + 16 and npc.y > npc.tgt_mc.y - 16) then
            npc.act_no = 10

            npc.tgt_x = npc.x
            npc.tgt_y = npc.y

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end

            npc.xm = (((ModCS.Game.Random(0, 1) * 0x200) - 0x100) * 2) / 0x200
            npc.ym = (((ModCS.Game.Random(0, 1) * 0x200) - 0x100) * 2) / 0x200
        end
    elseif (npc.act_no == 10) then
        if (npc.x < npc.tgt_x) then
            npc.xm = npc.xm + 0.0625
        else
            npc.xm = npc.xm - 0.0625
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.0625
        else
            npc.ym = npc.ym - 0.0625
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 300) then
            ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.x, npc.y, 0)
            npc.cond = 0
            return
        end

        if (npc.direct == 0) then
            npc.tgt_x = npc.tgt_x - 1
        else
            npc.tgt_x = npc.tgt_x + 1
        end
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

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 6) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 1) then
        npc.ani_no = 0
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Core blade projectile
ModCS.Npc.Act[178] = function(npc)
    if (npc:TouchTile()) then
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        npc.cond = 0
    end

    if (npc:TouchWater()) then
        npc.x = npc.x + (npc.xm / 2)
        npc.y = npc.y + (npc.ym / 2)
    else
        npc.x = npc.x + npc.xm
        npc.y = npc.y + npc.ym
    end

    local rect_left = {
        ModCS.Rect.Create(0, 224, 16, 240),
        ModCS.Rect.Create(16, 224, 32, 240),
        ModCS.Rect.Create(32, 224, 48, 240),
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
    if (npc.count1 > 150) then
        npc:Vanish()
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end
end

-- Core wisp projectile
ModCS.Npc.Act[179] = function(npc)
    if (npc:TouchTile()) then
        npc.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end

    npc.xm = npc.xm - 0.0625
    npc.ym = 0

    if (npc.xm < -2) then
        npc.xm = -2
    end

    npc:Move()

    local rect_left = {
        ModCS.Rect.Create(48, 224, 72, 240),
        ModCS.Rect.Create(72, 224, 96, 240),
        ModCS.Rect.Create(96, 224, 120, 240),
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
        npc:Vanish()
        ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
    end
end