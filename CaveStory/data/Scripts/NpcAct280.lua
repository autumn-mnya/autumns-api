-- Sue (being teleported by Misery)
ModCS.Npc.Act[280] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(112, 32, 128, 48),
        ModCS.Rect.Create(144, 32, 160, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(144, 48, 160, 64),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.x = npc.x + 6
        npc.tgt_x = npc.x
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
        npc.ani_no = 0

        if (npc:TouchFloor()) then
            npc.act_no = 4
            npc.act_wait = 0
            npc.ani_no = 1
            ModCS.Sound.Play(23)
        end
    end

    if (npc.act_no > 1) then
        npc.ym = npc.ym + 0.0625
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end

        npc:Move()
    end

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 1) then
        rect.bottom = rect.top + npc.act_wait / 4

        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.x = npc.tgt_x
        else
            npc.x = npc.tgt_x + 1
        end
    end

    npc:SetRect(rect)
end

-- Doctor (red energy form)
ModCS.Npc.Act[281] = function(npc)
    local rc = ModCS.Rect.Create(0, 0, 0, 0)

    if (npc.act_no == 0) then
        npc.act_no = 1
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1

        ModCS.Npc.Spawn3(270, npc.x, npc.y + 128, 0, 0, 2, npc)

        if (npc.act_wait > 150) then
            npc.act_no = 12
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 250) then
            ModCS.Npc.KillEveryID(270, false)
            npc.act_no = 22
        end
    end

    npc:SetRect(rc)
end

-- Mini Undead Core (active)
ModCS.Npc.Act[282] = function(npc)
    -- Yes, Pixel spelt this wrong (should be 'rc')
    local tc = {
        ModCS.Rect.Create(256, 80, 320, 120),
        ModCS.Rect.Create(256, 0, 320, 40),
        ModCS.Rect.Create(256, 120, 320, 160),
    }

    local hit = npc:GetHitbox()
    local mc_hit = npc.tgt_mc:GetHitbox()

    if (npc.act_no == 0) then
        npc.act_no = 20
        npc.tgt_y = npc.y

        if (ModCS.Game.Random(0, 100) % 2 == 1) then
            npc.ym = -0.5
        else
            npc.ym = 0.5
        end
        -- Fallthrough
    end

    if (npc.act_no == 20) then
        npc.xm = -1

        if (npc.x < -64) then
            npc.cond = 0
        end

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

        -- TODO: Check if all of the tgt_mc code actually works with multiplayer correctly in CSE2LE
        -- It probably does not?
        -- Might need code similar to the fans..
        if (npc.tgt_mc:TouchFloor()
            and npc.tgt_mc.y < npc.y - 4
            and npc.tgt_mc.x > npc.x - 24
            and npc.tgt_mc.x < npc.x + 24) then

            npc.tgt_y = 144
            npc.ani_no = 2

        elseif (npc.ani_no ~= 1) then
            npc.ani_no = 0
        end

        if (npc.tgt_mc:TouchLeftWall()
            and npc.tgt_mc.x < npc.x - hit.back
            and npc.tgt_mc.x > npc.x - hit.back - 8
            and npc.tgt_mc.y + mc_hit.bottom > npc.y - hit.top
            and npc.tgt_mc.y - mc_hit.top < npc.y + hit.bottom) then

            npc:UnsetBit(6)
            npc.ani_no = 1

        elseif (npc.tgt_mc:TouchRightWall()
            and npc.tgt_mc.x > npc.x + hit.back
            and npc.tgt_mc.x < npc.x + hit.back + 8
            and npc.tgt_mc.y + mc_hit.bottom > npc.y - hit.top
            and npc.tgt_mc.y - mc_hit.top < npc.y + hit.bottom) then

            npc:UnsetBit(6)
            npc.ani_no = 1

        elseif (npc.tgt_mc:TouchCeiling()
            and npc.tgt_mc.y < npc.y - hit.top
            and npc.tgt_mc.y > npc.y - hit.top - 8
            and npc.tgt_mc.x + mc_hit.front > npc.x - hit.back
            and npc.tgt_mc.x - mc_hit.back < npc.x + hit.front) then

            npc:UnsetBit(6)
            npc.ani_no = 1

        elseif (npc.tgt_mc:TouchFloor()
            and npc.tgt_mc.y > npc.y + hit.bottom - 4
            and npc.tgt_mc.y < npc.y + hit.bottom + 12
            and npc.tgt_mc.x + mc_hit.front > npc.x - hit.back - 4
            and npc.tgt_mc.x - mc_hit.back < npc.x + hit.front + 4) then

            npc:UnsetBit(6)
            npc.ani_no = 1
        end
    end

    npc:Move()

    npc:SetRect(tc[npc.ani_no + 1])
end

-- Misery (transformed)
ModCS.Npc.Act[283] = function(npc)
    local x = 0
    local y = 0
    local direct = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 64, 32, 96),
        ModCS.Rect.Create(32, 64, 64, 96),
        ModCS.Rect.Create(64, 64, 96, 96),
        ModCS.Rect.Create(96, 64, 128, 96),
        ModCS.Rect.Create(128, 64, 160, 96),
        ModCS.Rect.Create(160, 64, 192, 96),
        ModCS.Rect.Create(192, 64, 224, 96),
        ModCS.Rect.Create(224, 64, 256, 96),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(256, 64, 288, 96),
        ModCS.Rect.Create(288, 64, 320, 96),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 96, 32, 128),
        ModCS.Rect.Create(32, 96, 64, 128),
        ModCS.Rect.Create(64, 96, 96, 128),
        ModCS.Rect.Create(96, 96, 128, 128),
        ModCS.Rect.Create(128, 96, 160, 128),
        ModCS.Rect.Create(160, 96, 192, 128),
        ModCS.Rect.Create(192, 96, 224, 128),
        ModCS.Rect.Create(224, 96, 256, 128),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(256, 96, 288, 128),
        ModCS.Rect.Create(288, 96, 320, 128),
    }

    local map_boss = ModCS.Boss.GetByBufferIndex(0, true)

    local hit = npc:GetHitbox()

    if (npc.act_no < 100 and (map_boss.cond == 0 or npc.life < 400)) then
        npc.act_no = 100
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 8
        ModCS.Sound.Play(29)
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 9
        else
            npc.ani_no = 0
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 9
    elseif (npc.act_no == 20) then
        ModCS.Npc.SetSuperX(0)
        npc.act_no = 21
        npc.act_wait = 0
        npc.ani_no = 0
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.xm = 7 * npc.xm / 8
        npc.ym = 7 * npc.ym / 8

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 20) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 100) then
            npc.act_no = 30
        end

        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0
        npc.ani_no = 2
        npc.count2 = npc.life
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 3) then
            npc.ani_no = 2
        end

        if (npc.x > map_boss.x) then
            npc.xm = npc.xm - 0.0625
        else
            npc.xm = npc.xm + 0.0625
        end

        if (npc.y > npc.tgt_mc.y) then
            npc.ym = npc.ym - 0.03125
        else
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

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 150 and (npc.life < npc.count2 - 20 or ModCS.Npc.GetSuperX() ~= 0)) then
            ModCS.Npc.SetSuperX(0)
            npc.act_no = 40
        end

        if (map_boss.ani_no ~= 0 and npc.act_wait > 250) then
            npc.act_no = 50
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.act_wait = 0
        npc.xm = 0
        npc.ym = 0

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        ModCS.Sound.Play(103)

        if (npc.tgt_mc.y < 160) then
            npc.count2 = 290
        else
            npc.count2 = 289
        end
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 4
        else
            npc.ani_no = 5
        end

        if (npc.act_wait % 6 == 1) then
            if (npc.count2 == 289) then
                x = npc.x + ModCS.Game.Random(-0x40, 0x40)
                y = npc.y + ModCS.Game.Random(-0x20, 0x20)
            else
                x = npc.x + ModCS.Game.Random(-0x20, 0x20)
                y = npc.y + ModCS.Game.Random(-0x40, 0x40)
            end

            if (x < 32) then
                x = 32
            end

            if (x > (ModCS.Map.GetWidth() - 2) * 0x10) then
                x = (ModCS.Map.GetWidth() - 2) * 0x10
            end

            if (y < 32) then
                y = 32
            end

            if (y > (ModCS.Map.GetHeight() - 2) * 0x10) then
                y = (ModCS.Map.GetHeight() - 2) * 0x10
            end

            ModCS.Sound.Play(39)
            ModCS.Npc.Spawn2(npc.count2, x, y, 0, 0, 0)
        end

        if (npc.act_wait > 50) then
            npc.act_no = 42
            npc.act_wait = 0

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 42) then
        npc.act_wait = npc.act_wait + 1
        npc.ani_no = 6

        if (npc.act_wait > 50) then
            npc.ym = -1

            if (npc.direct == 0) then
                npc.xm = 1
            else
                npc.xm = -1
            end

            npc.act_no = 30
        end
    elseif (npc.act_no == 50) then
        npc.act_no = 51
        npc.act_wait = 0
        npc.xm = 0
        npc.ym = 0

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end

        ModCS.Sound.Play(103)
        -- Fallthrough
    end

    if (npc.act_no == 51) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 4
        else
            npc.ani_no = 5
        end

        if (ModCS.Player.HasEquipped(ModCS.Const.EQUIP_BOOSTER_2_0)) then
            if (npc.act_wait % 10 == 1) then
                if (npc.direct == 0) then
                    x = npc.x + 10
                    y = npc.y

                    if (math.floor(npc.act_wait / 6) % 4 == 0) then
                        direct = 0xD8
                    elseif (math.floor(npc.act_wait / 6) % 4 == 1) then
                        direct = 0xEC
                    elseif (math.floor(npc.act_wait / 6) % 4 == 2) then
                        direct = 0x14
                    elseif (math.floor(npc.act_wait / 6) % 4 == 3) then
                        direct = 0x28
                    end
                else
                    x = npc.x - 10
                    y = npc.y

                    if (math.floor(npc.act_wait / 6) % 4 == 0) then
                        direct = 0x58
                    elseif (math.floor(npc.act_wait / 6) % 4 == 1) then
                        direct = 0x6C
                    elseif (math.floor(npc.act_wait / 6) % 4 == 2) then
                        direct = 0x94
                    elseif (math.floor(npc.act_wait / 6) % 4 == 3) then
                        direct = 0xA8
                    end
                end

                ModCS.Sound.Play(39)
                ModCS.Npc.Spawn2(301, x, y, 0, 0, direct)
            end
        elseif (npc.act_wait % 24 == 1) then
            if (npc.direct == 0) then
                x = npc.x + 10
                y = npc.y

                if (math.floor(npc.act_wait / 6) % 4 == 0) then
                    direct = 0xD8
                elseif (math.floor(npc.act_wait / 6) % 4 == 1) then
                    direct = 0xEC
                elseif (math.floor(npc.act_wait / 6) % 4 == 2) then
                    direct = 0x14
                elseif (math.floor(npc.act_wait / 6) % 4 == 3) then
                    direct = 0x28
                end
            else
                x = npc.x - 10
                y = npc.y

                if (math.floor(npc.act_wait / 6) % 4 == 0) then
                    direct = 0x58
                elseif (math.floor(npc.act_wait / 6) % 4 == 1) then
                    direct = 0x6C
                elseif (math.floor(npc.act_wait / 6) % 4 == 2) then
                    direct = 0x94
                elseif (math.floor(npc.act_wait / 6) % 4 == 3) then
                    direct = 0xA8
                end
            end

            ModCS.Sound.Play(39)
            ModCS.Npc.Spawn2(301, x, y, 0, 0, direct)
        end

        if (npc.act_wait > 50) then
            npc.act_no = 42
            npc.act_wait = 0

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 99) then
        npc.xm = 0
        npc.ym = 0
        npc.ani_no = 9
        npc:UnsetBit(5) -- Unset shootable bit
    elseif (npc.act_no == 100) then
        npc.act_no = 101
        npc.ani_no = 9
        npc.damage = 0
        npc:UnsetBit(5) -- Unset shootable bit
        npc:SetBit(3) -- Set ignore tile collision bit
        npc.ym = -1
        npc.shock = npc.shock + 50
        hit.bottom = 12
        map_boss.ani_no = map_boss.ani_no + 1
        -- Fallthrough
    end

    if (npc.act_no == 101) then
        npc.ym = npc.ym + 0.0625

        if (npc.y > 216 - hit.bottom) then
            npc.y = 216 - hit.bottom
            npc.act_no = 102
            npc.ani_no = 10
            npc.xm = 0
            npc.ym = 0
        end
    end

    npc.y = npc.y + npc.ym

    if (npc:IsHit()) then
        npc.x = npc.x + (npc.xm / 2)
    else
        npc.x = npc.x + npc.xm
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    npc:SetHitbox(hit)
end

-- Sue (transformed)
ModCS.Npc.Act[284] = function(npc)
    local deg = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 128, 32, 160),
        ModCS.Rect.Create(32, 128, 64, 160),
        ModCS.Rect.Create(64, 128, 96, 160),
        ModCS.Rect.Create(96, 128, 128, 160),
        ModCS.Rect.Create(128, 128, 160, 160),
        ModCS.Rect.Create(160, 128, 192, 160),
        ModCS.Rect.Create(192, 128, 224, 160),
        ModCS.Rect.Create(224, 128, 256, 160),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(256, 128, 288, 160),
        ModCS.Rect.Create(288, 128, 320, 160),
        ModCS.Rect.Create(224, 64, 256, 96),
        ModCS.Rect.Create(208, 32, 224, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 160, 32, 192),
        ModCS.Rect.Create(32, 160, 64, 192),
        ModCS.Rect.Create(64, 160, 96, 192),
        ModCS.Rect.Create(96, 160, 128, 192),
        ModCS.Rect.Create(128, 160, 160, 192),
        ModCS.Rect.Create(160, 160, 192, 192),
        ModCS.Rect.Create(192, 160, 224, 192),
        ModCS.Rect.Create(224, 160, 256, 192),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(256, 160, 288, 192),
        ModCS.Rect.Create(288, 160, 320, 192),
        ModCS.Rect.Create(224, 96, 256, 128),
        ModCS.Rect.Create(208, 48, 224, 64),
    }

    local map_boss = ModCS.Boss.GetByBufferIndex(0, true)

    local view = npc:GetViewbox()
    local hit = npc:GetHitbox()

    if (npc.act_no < 100 and (map_boss.cond == 0 or npc.life < 500)) then
        npc.act_no = 100
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 4
        ModCS.Sound.Play(29)
        npc.count2 = npc.life
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            view.top = 16
            view.back = 16
            view.front = 16
            npc.ani_no = 11
        else
            view.top = 3
            view.back = 8
            view.front = 8
            npc.ani_no = 12
        end

        if (npc.act_wait > 50) then
            npc.act_no = 10
        end
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 11
        view.top = 16
        view.back = 16
        view.front = 16
        ModCS.Npc.KillEveryID(257, true)
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.act_wait = 0
        npc.ani_no = 0
        npc.ani_wait = 0
        npc.damage = 0
        npc:SetBit(5) -- Set shootable bit
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.xm = (npc.xm * 7) / 8
        npc.ym = (npc.xm * 7) / 8

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 20) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 80) then
            npc.act_no = 30
        end

        if (npc.x < npc.tgt_mc.x) then
            npc.direct = 2
        else
            npc.direct = 0
        end

        if (npc.life < npc.count2 - 50) then
            npc.count2 = npc.life
            ModCS.Npc.SetSuperX(10)
        end
    elseif (npc.act_no == 30) then
        npc.act_no = 31
        npc.act_wait = 0
        npc.ani_no = 2
        npc.xm = 0
        npc.ym = 0
        -- Fallthrough
    end

    if (npc.act_no == 31) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 16) then
            npc.count1 = npc.count1 + 1
            npc.count1 = npc.count1 % 4

            if (npc.count1 == 1 or npc.count1 == 3) then
                npc.act_no = 34
            elseif (npc.count1 == 0 or npc.count1 == 2) then
                npc.act_no = 32
            end
        end
    elseif (npc.act_no == 32) then
        npc.act_no = 33
        npc.act_wait = 0
        npc:UnsetBit(5) -- Unset shootable bit

        if (npc.tgt_mc.x < npc.x) then
            npc.tgt_x = npc.tgt_mc.x - 160
        else
            npc.tgt_x = npc.tgt_mc.x + 160
        end

        npc.tgt_y = npc.tgt_mc.y

        deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_x, npc.y - npc.tgt_y)
        npc.xm = 3 * ModCS.Triangle.GetCos(deg)
        npc.ym = 3 * ModCS.Triangle.GetSin(deg)
        npc:UnsetBit(3) -- Unset ignore tile collision bit

        if (npc.x < (ModCS.Map.GetWidth() * 0x10) / 2 and npc.xm > 0) then
            if (npc.y < (ModCS.Map.GetHeight() * 0x10) / 2 and npc.ym > 0) then
                npc:SetBit(3) -- Set ignore tile collision bit
            end

            if (npc.y > (ModCS.Map.GetHeight() * 0x10) / 2 and npc.ym < 0) then
                npc:SetBit(3) -- Set ignore tile collision bit
            end
        end

        if (npc.x > (ModCS.Map.GetWidth() * 0x10) / 2 and npc.xm < 0) then
            if (npc.y < (ModCS.Map.GetHeight() * 0x10) / 2 and npc.ym > 0) then
                npc:SetBit(3) -- Set ignore tile collision bit
            end

            if (npc.y > (ModCS.Map.GetHeight() * 0x10) / 2 and npc.ym < 0) then
                npc:SetBit(3) -- Set ignore tile collision bit
            end
        end

        if (npc.xm > 0) then
            npc.direct = 2
        else
            npc.direct = 0
        end
        -- Fallthrough
    end

    if (npc.act_no == 33) then
        npc.act_wait = npc.act_wait + 1
        if (math.floor(npc.act_wait / 2) % 2 == 1) then
            npc.ani_no = 3
        else
            npc.ani_no = 8
        end

        if (npc.act_wait > 50 or (npc:TouchLeftWall() or npc:TouchRightWall())) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 34) then
        npc.act_no = 35
        npc.act_wait = 0
        npc.damage = 4

        npc.tgt_x = npc.tgt_mc.x
        npc.tgt_y = npc.tgt_mc.y

        deg = ModCS.Triangle.GetArktan(npc.x - npc.tgt_x, npc.y - npc.tgt_y)
        npc.xm = 3 * ModCS.Triangle.GetCos(deg)
        npc.ym = 3 * ModCS.Triangle.GetSin(deg)
        npc:UnsetBit(3) -- Unset ignore tile collision bit

        if (npc.x < (ModCS.Map.GetWidth() * 0x10) / 2 and npc.xm > 0) then
            if (npc.y < (ModCS.Map.GetHeight() * 0x10) / 2 and npc.ym > 0) then
                npc:SetBit(3) -- Set ignore tile collision bit
            end

            if (npc.y > (ModCS.Map.GetHeight() * 0x10) / 2 and npc.ym < 0) then
                npc:SetBit(3) -- Set ignore tile collision bit
            end
        end

        if (npc.x > (ModCS.Map.GetWidth() * 0x10) / 2 and npc.xm < 0) then
            if (npc.y < (ModCS.Map.GetHeight() * 0x10) / 2 and npc.ym > 0) then
                npc:SetBit(3) -- Set ignore tile collision bit
            end

            if (npc.y > (ModCS.Map.GetHeight() * 0x10) / 2 and npc.ym < 0) then
                npc:SetBit(3) -- Set ignore tile collision bit
            end
        end

        if (npc.xm > 0) then
            npc.direct = 2
        else
            npc.direct = 0
        end
        -- Fallthrough
    end

    if (npc.act_no == 35) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 20 and npc:IsHit()) then
            npc.act_no = 40
        elseif (npc.act_wait > 50 or (npc:TouchLeftWall() or npc:TouchRightWall())) then
            npc.act_no = 20
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 1) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 7) then
            npc.ani_no = 4
        end

        if (npc.act_wait % 5 == 1) then
            ModCS.Sound.Play(109)
        end
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.act_wait = 0
        npc.ani_no = 2
        npc.damage = 0
        npc:UnsetBit(3) -- Unset ignore tile collision bit
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc.xm = (npc.xm * 7) / 8
        npc.ym = (npc.ym * 7) / 8

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 6) then
            npc.act_no = 42
            npc.act_wait = 0
            npc.ym = -1

            if (npc.direct == 0) then
                npc.xm = 1
            else
                npc.xm = -1
            end
        end
    elseif (npc.act_no == 42) then
        npc.ani_no = 9

        if (npc:TouchFloor()) then
            npc.act_no = 43
            npc.act_wait = 0
            npc.ani_no = 2
            
            if (npc.x < npc.tgt_mc.x) then
                npc.direct = 2
            else
                npc.direct = 0
            end
        end

        npc.ym = npc.ym + 0.0625
        if (npc.ym > 2.998046875) then
            npc.ym = 2.998046875
        end
    elseif (npc.act_no == 43) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 16) then
            npc.act_no = 20
        end
    elseif (npc.act_no == 99) then
        npc.xm = 0
        npc.ym = 0
        npc.ani_no = 9
        npc:UnsetBit(5) -- Unset shootable bit
    elseif (npc.act_no == 100) then
        npc.act_no = 101
        npc.ani_no = 9
        npc.damage = 0
        npc:UnsetBit(5) -- Unset shootable bit
        npc:SetBit(3) -- Set ignore tile collision bit
        npc.ym = -1
        npc.shock = npc.shock + 50
        map_boss.ani_no = map_boss.ani_no + 1
        -- Fallthrough
    end

    if (npc.act_no == 101) then
        npc.ym = npc.ym + 0.0625

        if (npc.y > 216 - hit.bottom) then
            npc.y = 216 - hit.bottom
            npc.act_no = 102
            npc.ani_no = 10
            npc.xm = 0
            npc.ym = 0
        end
    end

    npc.y = npc.y + npc.ym

    if (npc:IsHit()) then
        npc.x = npc.x + (npc.xm / 2)
    else
        npc.x = npc.x + npc.xm
    end

    if (npc.direct == 0) then
        npc:SetRect(rcLeft[npc.ani_no+1])
    else
        npc:SetRect(rcRight[npc.ani_no+1])
    end

    npc:SetViewbox(view)
end

-- Undead Core spiral projectile
ModCS.Npc.Act[285] = function(npc)
    local rc = ModCS.Rect.Create(232, 104, 248, 120)
    local deg = 0

    if (npc.x < 0 or npc.x > ModCS.Map.GetWidth() * 0x10) then
        npc:Vanish()
        return
    end

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.tgt_x = npc.x
        npc.tgt_y = npc.y
        npc.count1 = npc.direct / 8
        npc.direct = npc.direct % 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.count1 = npc.count1 + 24
        npc.count1 = npc.count1 % 0x100

        deg = npc.count1

        if (npc.act_wait < 128) then
            npc.act_wait = npc.act_wait + 1
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.041015625
        else
            npc.xm = npc.xm + 0.041015625
        end

        npc.tgt_x = npc.tgt_x + npc.xm

        npc.x = npc.tgt_x + (ModCS.Triangle.GetCos(deg) * 4)
        npc.y = npc.tgt_y + (ModCS.Triangle.GetSin(deg) * 6)

        ModCS.Npc.Spawn2(286, npc.x, npc.y, 0, 0, 0)
    end

    npc:SetRect(rc)
end

-- Undead Core spiral shot trail
ModCS.Npc.Act[286] = function(npc)
    local rc = {
        ModCS.Rect.Create(232, 120, 248, 136),
        ModCS.Rect.Create(232, 136, 248, 152),
        ModCS.Rect.Create(232, 152, 248, 168),
    }

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 0) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 2) then
        npc.cond = 0
    else
        npc:SetRect(rc[npc.ani_no+1])
    end
end

-- Orange smoke
ModCS.Npc.Act[287] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(0, 224, 16, 240),
        ModCS.Rect.Create(16, 224, 32, 240),
        ModCS.Rect.Create(32, 224, 48, 240),
        ModCS.Rect.Create(48, 224, 64, 240),
        ModCS.Rect.Create(64, 224, 80, 240),
        ModCS.Rect.Create(80, 224, 96, 240),
        ModCS.Rect.Create(96, 224, 112, 240),
    }

    if (npc.act_no == 0) then
        npc.xm = ModCS.Game.Random2(-4, 4)
        npc.act_no = 1
    else
        npc.xm = (npc.xm * 20) / 21
        npc.ym = (npc.ym * 20) / 21

        npc:Move()
    end

    npc.ani_wait = npc.ani_wait + 1
    if (npc.ani_wait > 1) then
        npc.ani_wait = 0
        npc.ani_no = npc.ani_no + 1
    end

    if (npc.ani_no > 6) then
        npc.cond = 0
    else
        npc:SetRect(rcLeft[npc.ani_no+1])
    end
end

-- Undead Core exploding rock
ModCS.Npc.Act[288] = function(npc)
    local rc = {
        ModCS.Rect.Create(232, 72, 248, 88),
        ModCS.Rect.Create(232, 88, 248, 104),
        ModCS.Rect.Create(232, 0, 256, 24),
        ModCS.Rect.Create(232, 24, 256, 48),
        ModCS.Rect.Create(232, 48, 256, 72),
    }

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.xm = -1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        if (npc.direct == 1) then
            npc.ym = npc.ym - 0.0625
            if (npc.ym < -2.998046875) then
                npc.ym = -2.998046875
            end

            if (npc:TouchCeiling()) then
                npc.act_no = 2
            end
        elseif (npc.direct == 3) then
            npc.ym = npc.ym + 0.0625
            if (npc.ym > 2.998046875) then
                npc.ym = 2.998046875
            end

            if (npc:TouchFloor()) then
                npc.act_no = 2
            end
        end

        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 3) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end
    elseif (npc.act_no == 2) then
        ModCS.Sound.Play(44)
        npc.act_no = 3
        npc.act_wait = 0
        npc:SetBit(3) -- Set ignore tile collision bit
        npc.ym = 0

        if (npc.x > npc.tgt_mc.x) then
            npc.xm = -2
        else
            npc.xm = 2
        end

        view.back = 12
        view.front = 12
        view.top = 12
        view.bottom = 12
        -- Fallthrough
    end

    if (npc.act_no == 3) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 4) then
            npc.ani_no = 2
        end

        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait % 4 == 1) then
            if (npc.direct == 1) then
                ModCS.Npc.Spawn2(287, npc.x, npc.y, 0, 2, 0)
            else
                ModCS.Npc.Spawn2(287, npc.x, npc.y, 0, -2, 0)
            end
        end

        if (npc.x < 1 * 0x10 or npc.x > (ModCS.Map.GetWidth() * 0x10) - 0x10) then
            npc.cond = 0
        end
    end

    npc:Move()

    npc:SetRect(rc[npc.ani_no+1])
    npc:SetViewbox(view)
end

-- Critter (orange, Misery)
ModCS.Npc.Act[289] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(160, 32, 176, 48),
        ModCS.Rect.Create(176, 32, 192, 48),
        ModCS.Rect.Create(192, 32, 208, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(160, 48, 176, 64),
        ModCS.Rect.Create(176, 48, 192, 64),
        ModCS.Rect.Create(192, 48, 208, 64),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)
    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 2

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 16) then
            npc.act_no = 10
            view.top = 8
            view.bottom = 8
            npc.damage = 2
            npc:SetBit(5) -- Set shootable bit
        end
    elseif (npc.act_no == 10) then
        if (npc:TouchFloor()) then
            npc.act_no = 11
            npc.ani_no = 0
            npc.act_wait = 0
            npc.xm = 0

            if (npc.x > npc.tgt_mc.x) then
                npc.direct = 0
            else
                npc.direct = 2
            end
        end
    elseif (npc.act_no == 11) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 10) then
            npc.count1 = npc.count1 + 1
            if (npc.count1 > 4) then
                npc.act_no = 12
            else
                npc.act_no = 10
            end

            ModCS.Sound.Play(30)
            npc.ym = -3

            if (npc.direct == 0) then
                npc.xm = -1
            else
                npc.xm = 1
            end

            npc.ani_no = 2
        end
    elseif (npc.act_no == 12) then
        npc:SetBit(3) -- Set ignore tile collision bit

        if (npc.y > ModCS.Map.GetHeight() * 0x10) then
            npc:Vanish()
            return
        end
    end

    if (npc.act_no >= 10) then
        npc.ym = npc.ym + 0.125
    end

    if (npc.ym > 2.998046875) then
        npc.ym = 2.998046875
    end

    npc:Move()

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 1) then
        rect.top = rect.top + (8 - (npc.act_wait / 2))
        rect.bottom = rect.bottom - (8 + (npc.act_wait / 2))
        view.top = npc.act_wait / 2
        view.bottom = npc.act_wait / 2
    end

    npc:SetRect(rect)
    npc:SetViewbox(view)
end

-- Bat (Misery)
ModCS.Npc.Act[290] = function(npc)
    local rcLeft = {
        ModCS.Rect.Create(112, 32, 128, 48),
        ModCS.Rect.Create(128, 32, 144, 48),
        ModCS.Rect.Create(144, 32, 160, 48),
    }

    local rcRight = {
        ModCS.Rect.Create(112, 48, 128, 64),
        ModCS.Rect.Create(128, 48, 144, 64),
        ModCS.Rect.Create(144, 48, 160, 64),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)
    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = 2

        if (npc.x > npc.tgt_mc.x) then
            npc.direct = 0
        else
            npc.direct = 2
        end
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1
        if (npc.act_wait > 16) then
            npc.act_no = 10
            view.top = 8
            view.bottom = 8
            npc.damage = 2
            npc:SetBit(5) -- Set shootable bit
            npc.tgt_y = npc.y
            npc.ym = 2
        end
    elseif (npc.act_no == 10) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 2) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 2) then
            npc.ani_no = 0
        end

        if (npc.y < npc.tgt_y) then
            npc.ym = npc.ym + 0.125
        else
            npc.ym = npc.ym - 0.125
        end

        if (npc.direct == 0) then
            npc.xm = npc.xm - 0.03125
        else
            npc.xm = npc.xm + 0.03125
        end

        if (npc.x < 0 or npc.y < 0 or npc.x > ModCS.Map.GetWidth() * 0x10 or npc.y > ModCS.Map.GetHeight() * 0x10) then
            npc:Vanish()
            return
        end
    end

    npc:Move()

    if (npc.direct == 0) then
        rect = rcLeft[npc.ani_no+1]
    else
        rect = rcRight[npc.ani_no+1]
    end

    if (npc.act_no == 1) then
        rect.top = rect.top + (8 - (npc.act_wait / 2))
        rect.bottom = rect.bottom - (8 + (npc.act_wait / 2))
        view.top = npc.act_wait / 2
        view.bottom = npc.act_wait / 2
    end

    npc:SetRect(rect)
    npc:SetViewbox(view)
end

-- Mini Undead Core (inactive)
ModCS.Npc.Act[291] = function(npc)
    local tc = {
        ModCS.Rect.Create(256, 80, 320, 120),
        ModCS.Rect.Create(256, 0, 320, 40),
    }

    if (npc.act_no == 0) then
        npc.act_no = 20

        if (npc.direct == 2) then
            npc:UnsetBit(6) -- Set solid hard bit
            npc.ani_no = 1
        end
    end

    npc:SetRect(tc[npc.ani_no+1])
end

-- Quake
ModCS.Npc.Act[292] = function(npc)
    ModCS.Camera.SetQuake(10)
end

-- Undead Core giant energy shot
ModCS.Npc.Act[293] = function(npc)
    local rect = {
        ModCS.Rect.Create(240, 200, 280, 240),
        ModCS.Rect.Create(280, 200, 320, 240),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = npc.ani_no + 1
        if (npc.ani_no > 1) then
            npc.ani_no = 0
        end

        ModCS.Npc.Spawn2(4, npc.x + ModCS.Game.Random(0, 0x10), npc.y + ModCS.Game.Random(-0x10, 0x10), 0, 0, 0)

        npc.x = npc.x - 8

        if (npc.x < -32) then
            npc.cond = 0
        end
    end

    npc:SetRect(rect[npc.ani_no+1])
end

-- Quake + falling block generator
ModCS.Npc.Act[294] = function(npc)
    local x = 0
    local y = 0
    local dir = 0

    if (npc.act_no == 0) then
        if (npc.tgt_mc.x < (ModCS.Map.GetWidth() - 6) * 0x10) then
            npc.act_no = 1
            npc.act_wait = 0
        end
    
    elseif (npc.act_no == 1) then
        npc.act_wait = npc.act_wait + 1

        if (ModCS.Player.HasEquipped(ModCS.Const.EQUIP_BOOSTER_2_0)) then
            npc.x = npc.tgt_mc.x + 64

            if (npc.x < 416) then
                npc.x = 416
            end
        else
            npc.x = npc.tgt_mc.x + 96

            if (npc.x < 368) then
                npc.x = 368
            end
        end

        if (npc.x > (ModCS.Map.GetWidth() - 10) * 0x10) then
            npc.x = (ModCS.Map.GetWidth() - 10) * 0x10
        end

        if (npc.act_wait > 24) then
            if (ModCS.Player.HasEquipped(ModCS.Const.EQUIP_BOOSTER_2_0)) then
                x = npc.x + ModCS.Game.Random(-14, 14) * 0x10
            else
                x = npc.x + ModCS.Game.Random(-11, 11) * 0x10
            end

            y = npc.tgt_mc.y - 224

            if ModCS.Game.Random(0, 10) % 2 == 1 then
                dir = 0
            else
                dir = 2
            end

            ModCS.Npc.Spawn2(279, x, y, 0, 0, dir)

            npc.act_wait = ModCS.Game.Random(0, 15)
        end
    end
end

-- Cloud
ModCS.Npc.Act[295] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 0, 208, 64),
        ModCS.Rect.Create(32, 64, 144, 96),
        ModCS.Rect.Create(32, 96, 104, 128),
        ModCS.Rect.Create(104, 96, 144, 128),
    }

    local view = npc:GetViewbox()

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.ani_no = npc.direct % 4
        if (npc.direct == 0) then
            npc.ym = -1.953125
            view.back = 104
            view.front = 104
        elseif (npc.direct == 1) then
            npc.ym = -4
            view.back = 56
            view.front = 56
        elseif (npc.direct == 2) then
            npc.ym = -2
            view.back = 32
            view.front = 32
        elseif (npc.direct == 3) then
            npc.ym = -1
            view.back = 20
            view.front = 20
        elseif (npc.direct == 4) then
            npc.xm = -2
            view.back = 104
            view.front = 104
        elseif (npc.direct == 5) then
            npc.xm = -1
            view.back = 56
            view.front = 56
        elseif (npc.direct == 6) then
            npc.xm = -0.5
            view.back = 32
            view.front = 32
        elseif (npc.direct == 7) then
            npc.xm = -0.25
            view.back = 20
            view.front = 20
        end
    elseif (npc.act_no == 1) then
        npc:Move()

        if (npc.x < -64) then
            npc.cond = 0
        end

        if (npc.x < -32) then
            npc.cond = 0
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
    npc:SetViewbox(view)
end

-- Cloud generator
ModCS.Npc.Act[296] = function(npc)
    local x = 0
    local y = 0
    local dir = 0
    local pri = 0

    npc.act_wait = npc.act_wait + 1
    if (npc.act_wait > 16) then
        npc.act_wait = ModCS.Game.Random(0, 16)
        dir = ModCS.Game.Random(0, 100) % 4

        if (npc.direct == 0) then
            if (dir == 0) then
                pri = 0x180
            elseif (dir == 1) then
                pri = 0x80
            elseif (dir == 2) then
                pri = 0x40
            elseif (dir == 3) then
                pri = 0
            end
        
            x = ModCS.Game.Random(-10, 10) * 0x10 + npc.x
            y = npc.y
            ModCS.Npc.Spawn2(295, x, y, 0, 0, dir, 0)
        else
            if (dir == 0) then
                pri = 0x80
            elseif (dir == 1) then
                pri = 0x55
            elseif (dir == 2) then
                pri = 0x40
            elseif (dir == 3) then
                pri = 0
            end

            x = npc.x
            y = ModCS.Game.Random(-7, 7) * 0x10 + npc.y
            ModCS.Npc.Spawn2(295, x, y, 0, 0, dir + 4, pri)
        end
    end
end

-- Sue in dragon's mouth
ModCS.Npc.Act[297] = function(npc)
    local rc = ModCS.Rect.Create(112, 48, 128, 64)

    npc.x = npc.pNpc.x + 16
    npc.y = npc.pNpc.y + 8

    npc:SetRect(rc)
end

-- Doctor (opening)
ModCS.Npc.Act[298] = function(npc)
    local rc = {
        ModCS.Rect.Create(72, 128, 88, 160),
        ModCS.Rect.Create(88, 128, 104, 160),
        ModCS.Rect.Create(104, 128, 120, 160),
        ModCS.Rect.Create(72, 128, 88, 160),
        ModCS.Rect.Create(120, 128, 136, 160),
        ModCS.Rect.Create(72, 128, 88, 160),
        ModCS.Rect.Create(104, 160, 120, 192),
        ModCS.Rect.Create(120, 160, 136, 192),
    }

    if (npc.act_no == 0) then
        npc.act_no = 1
        npc.y = npc.y - 8
        -- Fallthrough
    end

    if (npc.act_no == 1) then
        npc.ani_no = 0
    elseif (npc.act_no == 10) then
        npc.act_no = 11
        npc.ani_no = 0
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
            if (npc.count1 > 7) then
                npc.ani_no = 0
                npc.act_no = 1
            end
        end
    elseif (npc.act_no == 20) then
        npc.act_no = 21
        npc.ani_no = 2
        npc.ani_wait = 0
        -- Fallthrough
    end

    if (npc.act_no == 21) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 10) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 5) then
            npc.ani_no = 2
        end

        npc.x = npc.x + 0.5
    elseif (npc.act_no == 30) then
        npc.ani_no = 6
    elseif (npc.act_no == 40) then
        npc.act_no = 41
        npc.ani_no = 6
        npc.ani_wait = 0
        npc.count1 = 0
        -- Fallthrough
    end

    if (npc.act_no == 41) then
        npc.ani_wait = npc.ani_wait + 1
        if (npc.ani_wait > 6) then
            npc.ani_wait = 0
            npc.ani_no = npc.ani_no + 1
        end

        if (npc.ani_no > 7) then
            npc.ani_no = 6

            npc.count1 = npc.count1 + 1
            if (npc.count1 > 7) then
                npc.ani_no = 6
                npc.act_no = 30
            end
        end
    end

    npc:SetRect(rc[npc.ani_no+1])
end

-- Balrog/Misery (opening)
ModCS.Npc.Act[299] = function(npc)
    local rc = {
        ModCS.Rect.Create(0, 0, 48, 48), -- Balrog
        ModCS.Rect.Create(48, 0, 96, 48), -- Misery
    }

    if (npc.act_no == 0) then
        npc.act_no = 1

        if (npc.direct == 0) then
            npc.ani_no = 1
            npc.act_wait = 25
            npc.y = npc.y - 0.125 * (50 / 2)
        else
            npc.ani_no = 0
            npc.act_wait = 0
        end
    end

    npc.act_wait = npc.act_wait + 1
    if (math.floor(npc.act_wait / 50) % 2 == 1) then
        npc.y = npc.y + 0.125
    else
        npc.y = npc.y - 0.125
    end

    npc:SetRect(rc[npc.ani_no+1])
end