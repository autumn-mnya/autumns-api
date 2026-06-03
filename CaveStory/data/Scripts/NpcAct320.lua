-- Curly (carried, shooting)
ModCS.Npc.Act[320] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(16, 96, 32, 112),
        ModCS.Rect.Create(48, 96, 64, 112),
        ModCS.Rect.Create(96, 96, 112, 112),
    }

    local rcRight = {
        ModCS.Rect.Create(16, 112, 32, 128),
        ModCS.Rect.Create(48, 112, 64, 128),
        ModCS.Rect.Create(96, 112, 112, 128),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.x = npc.tgt_mc.x
        npc.y = npc.tgt_mc.y
        ModCS.Npc.Spawn3(321, 0, 0, 0, 0, 0, npc)
    end

    if (npc.tgt_mc:TouchFloor()) then
        if (npc.tgt_mc:IsLookingUp()) then
            npc.tgt_x = npc.tgt_mc.x
            npc.tgt_y = npc.tgt_mc.y - 10
            npc.ani_no = 1
        else
            npc.ani_no = 0

            if (npc.tgt_mc.direct == 0) then
                npc.tgt_x = npc.tgt_mc.x + 7
                npc.tgt_y = npc.tgt_mc.y - 3
            else
                npc.tgt_x = npc.tgt_mc.x - 7
                npc.tgt_y = npc.tgt_mc.y - 3
            end
        end
    else
        if (npc.tgt_mc:IsLookingUp()) then
            npc.tgt_x = npc.tgt_mc.x
            npc.tgt_y = npc.tgt_mc.y + 8
            npc.ani_no = 2
        elseif (npc.tgt_mc:IsLookingDown()) then
            npc.tgt_x = npc.tgt_mc.x
            npc.tgt_y = npc.tgt_mc.y - 8
            npc.ani_no = 1
        else
            npc.ani_no = 0

            if (npc.tgt_mc.direct == 0) then
                npc.tgt_x = npc.tgt_mc.x + 7
                npc.tgt_y = npc.tgt_mc.y - 3
            else
                npc.tgt_x = npc.tgt_mc.x - 7
                npc.tgt_y = npc.tgt_mc.y - 3
            end
        end
    end

    npc.x = npc.x + ((npc.tgt_x - npc.x) / 2)
    npc.y = npc.y + ((npc.tgt_y - npc.y) / 2)

    if (npc.tgt_mc.ani_no % 2 == 1) then
        npc.y = npc.y - 1
    end

    if (npc.tgt_mc.direct == 0) then
        npc:SetRect(rcRight[npc.ani_no+1])
    else
        npc:SetRect(rcLeft[npc.ani_no+1])
    end
end

-- Curly's Nemesis
ModCS.Npc.Act[321] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(136, 152, 152, 168),
        ModCS.Rect.Create(152, 152, 168, 168),
        ModCS.Rect.Create(168, 152, 184, 168),
    }

    local rcRight = {
        ModCS.Rect.Create(136, 168, 152, 184),
        ModCS.Rect.Create(152, 168, 168, 184),
        ModCS.Rect.Create(168, 168, 184, 184),
    }

    local direct = 0

    if (npc.pNpc == nil) then
        return
    end

    if (npc.pNpc.ani_no == 0) then
        if (npc.tgt_mc.direct == 0) then
            npc.x = npc.pNpc.x + 8
            direct = 2
        else
            npc.x = npc.pNpc.x - 8
            direct = 0
        end

        npc.y = npc.pNpc.y
    elseif (npc.pNpc.ani_no == 1) then
        npc.x = npc.pNpc.x

        direct = 1
        npc.y = npc.pNpc.y - 10
    elseif (npc.pNpc.ani_no == 2) then
        npc.x = npc.pNpc.x

        direct = 3
        npc.y = npc.pNpc.y + 10
    end

    npc.ani_no = npc.pNpc.ani_no

    if (ModCS.Game.CanControl() and ModCS.Bullet.CountByID(43) < 2 and npc.tgt_mc:KeyShoot()) then
        ModCS.Bullet.Spawn(43, npc.pNpc.x, npc.pNpc.y, direct)
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, npc.pNpc.x, npc.pNpc.y, 0)
        ModCS.Sound.Play(117)
    end

    if (npc.tgt_mc.direct == 0) then
        npc:SetRect(rcRight[npc.ani_no+1])
    else
        npc:SetRect(rcLeft[npc.ani_no+1])
    end
end

-- Deleet
ModCS.Npc.Act[322] = function(npc)
    local rc = {
        ModCS.Rect.Create(272, 216, 296, 240),
        ModCS.Rect.Create(296, 216, 320, 240),
        ModCS.Rect.Create(160, 216, 184, 240),
    }

    local hit = npc:GetHitbox()

    if (npc.act_no < 2 and npc.life <= 968) then
        npc.act_no = 2
        npc.act_wait = 0
        npc:UnsetBit(5) -- Unset shootable bit
        npc:SetBit(2) -- Set invulnerable bit
        ModCS.Sound.Play(22)
    end

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.y = npc.y + 8
        else
            npc.x = npc.x + 8
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:IsHit()) then
            npc.count1 = npc.count1 + 1
        else
            npc.count1 = 0
        end

        npc:SetRect(rc[(math.floor(npc.count1 / 2) % 2)+1])
    elseif (npc.act_no == 2) then
        npc.ani_no = 2

        -- Interestingly, this NPC counts down at 50 frames per second,
        -- while NPC206 (the Egg Corridor Counter Bomb), counts at 60.
        if (npc.act_wait == (50 * 0)) then
            ModCS.Npc.Spawn2(207, npc.x + 4, npc.y, 0, 0, 0)
        elseif (npc.act_wait == (50 * 1)) then
            ModCS.Npc.Spawn2(207, npc.x + 4, npc.y, 0, 0, 1)
        elseif (npc.act_wait == (50 * 2)) then
            ModCS.Npc.Spawn2(207, npc.x + 4, npc.y, 0, 0, 2)
        elseif (npc.act_wait == (50 * 3)) then
            ModCS.Npc.Spawn2(207, npc.x + 4, npc.y, 0, 0, 3)
        elseif (npc.act_wait == (50 * 4)) then
            ModCS.Npc.Spawn2(207, npc.x + 4, npc.y, 0, 0, 4)
        elseif (npc.act_wait == (50 * 5)) then
            hit.back = 48
            hit.front = 48
            hit.top = 48
            hit.bottom = 48
            npc.damage = 12
            ModCS.Sound.Play(26)
            ModCS.Npc.Explode(npc.x, npc.y, 48, 40)
            ModCS.Camera.SetQuake(10)
            
            if (npc.direct == 0) then
                ModCS.Map.DeleteTile(npc.x / 0x10, (npc.y - 8) / 0x10)
                ModCS.Map.DeleteTile(npc.x / 0x10, (npc.y + 8) / 0x10)
            else
                ModCS.Map.DeleteTile((npc.x - 8) / 0x10, npc.y / 0x10)
                ModCS.Map.DeleteTile((npc.x + 8) / 0x10, npc.y / 0x10)
            end

            npc:KillOnNextFrame()
        end

        npc.act_wait = npc.act_wait + 1
        npc:SetRect(rc[3])
    end

    npc:SetHitbox(hit)
end

-- Bute (spinning)
ModCS.Npc.Act[323] = function(npc)
    local rc = {
        ModCS.Rect.Create(216, 32, 232, 56),
        ModCS.Rect.Create(232, 32, 248, 56),
        ModCS.Rect.Create(216, 56, 232, 80),
        ModCS.Rect.Create(232, 56, 248, 80),
    }

    local view = npc:GetViewbox()

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 3) then
        npc.ani_wait = 0

        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 3) then
            npc.ani_no = 0
        end
    end

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.xm = -3
        elseif (npc.direct == 2) then
            npc.xm = 3
        elseif (npc.direct == 1) then
            npc.ym = -3
        elseif (npc.direct == 3) then
            npc.ym = 3
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 16) then
            npc:UnsetBit(3) -- Unset ignore tile collision bit
        end

        npc:Move()

        if (npc:TouchTile()) then
            npc.act_no = 10
        end

        if (npc.act_wait > 20) then
            if (npc.direct == 0) then
                if (npc.x <= npc.tgt_mc.x + 32) then
                    npc.act_no = 10
                end
            elseif (npc.direct == 2) then
                if (npc.x >= npc.tgt_mc.x - 32) then
                    npc.act_no = 10
                end
            elseif (npc.direct == 1) then
                if (npc.y <= npc.tgt_mc.y + 32) then
                    npc.act_no = 10
                end
            elseif (npc.direct == 3) then
                if (npc.y >= npc.tgt_mc.y - 32) then
                    npc.act_no = 10
                end
            end
        end
    end

    if (npc.act_no == 10) then
        npc.id = 309
        npc.ani_no = 0
        npc.act_no = 11
        npc:SetBit(5) -- Set shootable bit
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        npc.damage = 5
        view.top = 8
    end

    npc:SetRect(rc[npc.ani_no+1])
    npc:SetViewbox(view)
end

-- Bute generator
ModCS.Npc.Act[324] = function(npc)
    if (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 50 == 1) then
            ModCS.Npc.Spawn2(323, npc.x, npc.y, 0, 0, npc.direct)
        end

        if (npc.act_wait > 351) then
            npc.act_no = 0
        end
    end
end

-- Heavy Press lightning
ModCS.Npc.Act[325] = function(npc)
    local rc = {
        ModCS.Rect.Create(240, 96, 272, 128),
        ModCS.Rect.Create(272, 96, 304, 128),
        ModCS.Rect.Create(240, 128, 272, 160),
        ModCS.Rect.Create(240, 0, 256, 96),
        ModCS.Rect.Create(256, 0, 272, 96),
        ModCS.Rect.Create(272, 0, 288, 96),
        ModCS.Rect.Create(288, 0, 304, 96),
    }

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 0) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 10
            npc.ani_wait = 0
            npc.ani_no = 3
            npc.damage = 10
            view.front = 8
            view.top = 12
            ModCS.Sound.Play(101)
            ModCS.Npc.Explode(npc.x, npc.y + 84, 0, 3)
        end
    elseif (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 6) then
            npc.cond = 0
            return
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
    npc:SetViewbox(view)
end

-- Sue/Itoh becoming human
ModCS.Npc.Act[326] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 8
        npc.x = npc.x + 16
        npc.ani_no = 0
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        local done = false

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 80) then
            npc.act_no = 10
            npc.act_wait = 0
            done = true
        end
        
        if not done then
            if (npc.direct == 0) then
                if (npc.act_wait == 30) then
                    npc.ani_no = 1
                end

                if (npc.act_wait == 40) then
                    npc.ani_no = 0
                end
            else
                if (npc.act_wait == 50) then
                    npc.ani_no = 1
                end

                if (npc.act_wait == 60) then
                    npc.ani_no = 0
                end
            end
        end
    elseif (npc.act_no == 10) then
        local done = false
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 15
            npc.ani_no = 4

            if (npc.direct == 0) then
                npc.act_wait = 0
            else
                npc.act_wait = -20
            end

            done = true
        end

        if not done then
            if (math.floor(npc.act_wait / 2) % 2 == 1) then
                npc.ani_no = 2
            else
                npc.ani_no = 3
            end
        end
    elseif (npc.act_no == 15) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 40) then
            npc.act_wait = 0
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.ym = npc.ym + 0.125
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 50) then
            npc.act_no = 30
            npc.act_wait = 0
            npc.ani_no = 6

            if (npc.direct == 0) then
                ModCS.Npc.Spawn3(327, npc.x, npc.y - 16, 0, 0, 0, npc)
            else
                ModCS.Npc.Spawn3(327, npc.x, npc.y - 8, 0, 0, 0, npc)
            end
        end
    elseif (npc.act_no == 30) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30) then
            npc.ani_no = 7
        end

        if (npc.act_wait == 40) then
            npc.act_no = 40
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.act_wait = 0
        npc.ani_no = 0
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait == 30) then
            npc.ani_no = 1
        end

        if (npc.act_wait == 40) then
            npc.ani_no = 0
        end
    end

    local rcItoh = {
        ModCS.Rect.Create(0, 128, 16, 152),
        ModCS.Rect.Create(16, 128, 32, 152),
        ModCS.Rect.Create(32, 128, 48, 152),
        ModCS.Rect.Create(48, 128, 64, 152),
        ModCS.Rect.Create(64, 128, 80, 152),
        ModCS.Rect.Create(80, 128, 96, 152),
        ModCS.Rect.Create(96, 128, 112, 152),
        ModCS.Rect.Create(112, 128, 128, 152),
    }

    local rcSu = {
        ModCS.Rect.Create(128, 128, 144, 152),
        ModCS.Rect.Create(144, 128, 160, 152),
        ModCS.Rect.Create(160, 128, 176, 152),
        ModCS.Rect.Create(176, 128, 192, 152),
        ModCS.Rect.Create(192, 128, 208, 152),
        ModCS.Rect.Create(208, 128, 224, 152),
        ModCS.Rect.Create(224, 128, 240, 152),
        ModCS.Rect.Create(32, 152, 48, 176),
    }

    if (npc.direct == 0) then
        npc:SetRect(rcItoh[npc.ani_no+1])
    else
        npc:SetRect(rcSu[npc.ani_no+1])
    end
end

-- Sneeze
ModCS.Npc.Act[327] = function(npc)
    local rc = {
        ModCS.Rect.Create(240, 80, 256, 96),
        ModCS.Rect.Create(256, 80, 272, 96),
    }

    npc.act_wait = npc.act_wait + 1

    if (npc.act_no == 0) then
        if (npc.act_wait < 4) then
            npc.y = npc.y - 2
        end

        if (npc.pNpc.ani_no == 7) then
            npc.ani_no = 1
            npc.act_no = 1
            npc.tgt_x = npc.x
            npc.tgt_y = npc.y
        end
    elseif (npc.act_no == 1) then
        if (npc.act_wait < 48) then
            npc.x = npc.tgt_x + ModCS.Game.Random(-1, 1)
            npc.y = npc.tgt_y + ModCS.Game.Random(-1, 1)
        else
            npc.x = npc.tgt_x
            npc.y = npc.tgt_y
        end
    end

    if (npc.act_wait > 70) then
        npc.cond = 0
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Thingy that turns Sue and Itoh into humans for 4 seconds
ModCS.Npc.Act[328] = function(npc)
    local rc = ModCS.Rect.Create(96, 0, 128, 48)
    npc:SetRect(rc)
end

-- Laboratory fan
ModCS.Npc.Act[329] = function(npc)
    local rc = {
        ModCS.Rect.Create(48, 0, 64, 16),
        ModCS.Rect.Create(64, 0, 80, 16),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (math.floor(npc.ani_wait / 2) % 2 == 1) then
        npc:SetRect(rc[1])
    else
        npc:SetRect(rc[2])
    end
end

-- Rolling
ModCS.Npc.Act[330] = function(npc)
    local rc = {
        ModCS.Rect.Create(144, 136, 160, 152),
        ModCS.Rect.Create(160, 136, 176, 152),
        ModCS.Rect.Create(176, 136, 192, 152),
    }

    if (npc.act_no == 0) then
        ModCS.Map.ChangeTile(0, npc.x / 0x10, npc.y / 0x10)

        if (npc.direct == 0) then
            npc.act_no = 10
        else
            npc.act_no = 30
        end
    elseif (npc.act_no == 10) then
        npc.xm = npc.xm - 0.125
        npc.ym = 0

        if (npc:TouchLeftWall()) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 20) then
        npc.xm = 0
        npc.ym = npc.ym - 0.125

        if (npc:TouchCeiling()) then
            npc.act_no = 30
        end
    elseif (npc.act_no == 30) then
        npc.xm = npc.xm + 0.125
        npc.ym = 0

        if (npc:TouchRightWall()) then
            npc.act_no = 40
        end
    elseif (npc.act_no == 40) then
        npc.xm = 0
        npc.ym = npc.ym + 0.125

        if (npc:TouchFloor()) then
            npc.act_no = 10
        end
    end

    if (npc.xm < -2) then
        npc.xm = -2
    end

    if (npc.xm > 2) then
        npc.xm = 2
    end

    if (npc.ym < -2) then
        npc.ym = -2
    end

    if (npc.ym > 2) then
        npc.ym = 2
    end

    npc:Move()

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.ani_no = 0
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ballos bone projectile
ModCS.Npc.Act[331] = function(npc)
    local rc = {
        ModCS.Rect.Create(288, 80, 304, 96),
        ModCS.Rect.Create(304, 80, 320, 96),
        ModCS.Rect.Create(288, 96, 304, 112),
        ModCS.Rect.Create(304, 96, 320, 112),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc:TouchFloor()) then
            npc.ym = -1
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        if (npc:TouchFloor()) then
            npc.cond = 0
            ModCS.Caret.Spawn(ModCS.Const.CARET_PROJECTILE_DISSIPATION, npc.x, npc.y, 0)
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 3) then
        npc.ani_wait = 0

        if (npc.direct == 0) then
            npc.ani_no = npc.ani_no + 1
        else
            npc.ani_no = npc.ani_no - 1
        end

        if (npc.ani_no < 0) then
            npc.ani_no = npc.ani_no + 4
        end

        if (npc.ani_no > 3) then
            npc.ani_no = npc.ani_no - 4
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ballos shockwave
ModCS.Npc.Act[332] = function(npc)
    local rc = {
        ModCS.Rect.Create(144, 96, 168, 120),
        ModCS.Rect.Create(168, 96, 192, 120),
        ModCS.Rect.Create(192, 96, 216, 120),
    }

    local xm = 0

    if (npc.act_no == 0) then
        ModCS.Sound.Play(44)
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.xm = -2
        else
            npc.xm = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0

            npc.ani_no = npc.ani_no + 1
            if (npc.ani_no > 2) then
                npc.ani_no = 0
            end
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 6 == 1) then
            if (npc.direct == 0) then
                xm = ModCS.Game.Random2(-0x10, -4) / 8
            else
                xm = ModCS.Game.Random(4, 0x10) / 8
            end

            ModCS.Npc.Spawn2(331, npc.x, npc.y, xm, -2, 0, 0)

            ModCS.Sound.Play(12)
        end
    end

    if (npc:TouchLeftWall()) then
        npc.cond = 0
    end

    if (npc:TouchRightWall()) then
        npc.cond = 0
    end

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ballos lightning
ModCS.Npc.Act[333] = function(npc)
    local rc = {
        ModCS.Rect.Create(80, 120, 104, 144),
        ModCS.Rect.Create(104, 120, 128, 144),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        ModCS.Sound.Play(103)
        npc.y = npc.tgt_mc.y
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 0
        else
            npc.ani_no = 1
        end

        if (npc.direct == 0 and npc.act_wait == 20) then
            ModCS.Npc.Spawn2(146, npc.tgt_x, npc.tgt_y, 0, 0, 0)
        end

        if (npc.act_wait > 40) then
            npc.cond = 0
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Sweat
ModCS.Npc.Act[334] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(160, 184, 168, 200),
        ModCS.Rect.Create(168, 184, 176, 200),
    }

    local rcRight = {
        ModCS.Rect.Create(176, 184, 184, 200),
        ModCS.Rect.Create(184, 184, 192, 200),
    }

    if (npc.act_no == 0) then
        npc.act_no = 10

        if (npc.direct == 0) then
            npc.x = npc.x + 10
            npc.y = npc.y - 18
        else
            npc.x = npc.tgt_mc.x - 10
            npc.y = npc.tgt_mc.y - 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 8) % 2 == 1) then
            npc.ani_no = 0
        else
            npc.ani_no = 1
        end

        if (npc.act_wait >= 64) then
            npc.cond = 0
        end
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end
end

-- Ikachan
ModCS.Npc.Act[335] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = ModCS.Game.Random(3, 20)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait <= 0) then
            npc.act_no = 2
            npc.act_wait = ModCS.Game.Random(10, 50)
            npc.ani_no = 1
            npc.xm = 3
        end
    elseif (npc.act_no == 2) then
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait <= 0) then
            npc.act_no = 3
            npc.act_wait = ModCS.Game.Random(40, 50)
            npc.ani_no = 2
            npc.ym = ModCS.Game.Random2(-0.5, 0.5)
        end
    elseif (npc.act_no == 3) then
        npc.act_wait = npc.act_wait - 1
        if (npc.act_wait <= 0) then
            npc.act_no = 1
            npc.act_wait = 0
            npc.ani_no = 0
        end
    end

    npc.xm = npc.xm - 0.03125

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
end

-- Ikachan generator
ModCS.Npc.Act[336] = function(npc)
    local y = 0

    if (npc.act_no == 0) then
        -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or npc.tgt_mc
        -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
        -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
        -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
        for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
            local mychar = ModCS.Multiplayer.GetByID(i)
            if (mychar:IsPlaying()) then
                if (mychar:IsHit()) then
                    npc.cond = 0
                end
            end
        end
    elseif (npc.act_no == 10) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 4 == 1) then
            y = npc.y + ModCS.Game.Random(0, 13) * 0x10
            ModCS.Npc.Spawn2(335, npc.x, y, 0, 0, 0)
        end
    end
end

-- Numhachi
ModCS.Npc.Act[337] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(256, 112, 288, 152),
        ModCS.Rect.Create(288, 112, 320, 152),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.xm = 0
        npc.act_no = 2
        npc.ani_no = 0
        -- Fallthrough
    end

    if (npc.act_no == 2) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 50) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    end

    npc.ym = npc.ym + 0.125
    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    npc:SetRect(rcLeft[npc.ani_no+1])
end

-- Green Devil
ModCS.Npc.Act[338] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(288, 0, 304, 16),
        ModCS.Rect.Create(304, 0, 320, 16),
    }

    local rcRight = {
        ModCS.Rect.Create(288, 16, 304, 32),
        ModCS.Rect.Create(304, 16, 320, 32),
    }

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        view.top = 8
        view.bottom = 8
        npc.damage = 3
        npc:SetBit(5) -- Set shootable bit
        npc.tgt_y = npc.y
        npc.ym = ModCS.Game.Random2(-10, 10) / 2
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

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.25
        else
            npc.ym = npc.ym - 0.25
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.0625
        else
            npc.xm = npc.xm + 0.0625
        end

        if (npc.xm > 2) then
            npc.xm = 2
        end

        if (npc.xm < -2) then
            npc.xm = -2
        end

        if (npc.x < 0 or npc.y < 0 or npc.x > ModCS.Map.GetWidth() * 0x10 or npc.y > ModCS.Map.GetHeight() * 0x10) then
            npc:Vanish()
            return
        end
    end

    npc:Move()

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    npc:SetViewbox(view)
end

-- Green Devil generator
ModCS.Npc.Act[339] = function(npc)
    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.act_wait = ModCS.Game.Random(0, 40)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.act_wait ~= 0) then
            npc.act_wait = npc.act_wait - 1
        else
            npc.act_no = 0
            ModCS.Npc.Spawn2(338, npc.x, npc.y + ModCS.Game.Random(-0x10, 0x10), 0, 0, npc.direct)
        end
    end
end