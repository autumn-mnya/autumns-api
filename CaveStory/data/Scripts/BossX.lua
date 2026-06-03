local function ActBossChar03_01(boss)
    local rcUp = {
        ModCS.Rect.Create(0, 0, 72, 32),
        ModCS.Rect.Create(0, 32, 72, 64),
        ModCS.Rect.Create(72, 0, 144, 32),
        ModCS.Rect.Create(144, 0, 216, 32),
        ModCS.Rect.Create(72, 32, 144, 64),
        ModCS.Rect.Create(144, 32, 216, 64),
    }

    local rcDown = {
        ModCS.Rect.Create(0, 64, 72, 96),
        ModCS.Rect.Create(0, 96, 72, 128),
        ModCS.Rect.Create(72, 64, 144, 96),
        ModCS.Rect.Create(144, 64, 216, 96),
        ModCS.Rect.Create(72, 96, 144, 128),
        ModCS.Rect.Create(144, 96, 216, 128),
    }

    if (boss.act_no == 10) then
        boss.ani_no = 0
        boss:UnsetBit(4) -- Unset bouncy bit
    elseif (boss.act_no == 100) then
        boss:SetBit(4) -- Set bouncy bit
        boss.act_no = 101
        boss.act_wait = 0
        boss.ani_no = 2
        boss.ani_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 101) then
        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait > 30) then
            boss.act_no = 102
        end

        boss.ani_wait = boss.ani_wait + 1
        if (boss.ani_wait > 0) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no + 1
        end

        if (boss.ani_no > 3) then
            boss.ani_no = 2
        end

        boss.xm = boss.xm - 0.0625
    elseif (boss.act_no == 102) then
        boss:UnsetBit(4) -- Unset bouncy bit
        boss.act_no = 103
        boss.ani_no = 0
        boss.ani_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 103) then
        boss.act_wait = boss.act_wait + 1

        boss.ani_wait = boss.ani_wait + 1
        if (boss.ani_wait > 1) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no + 1
        end

        if (boss.ani_no > 1) then
            boss.ani_no = 0
        end

        boss.xm = boss.xm - 0.0625
    elseif (boss.act_no == 200) then
        boss:SetBit(4) -- Set bouncy bit
        boss:SetBit(7) -- Set 'rear and top don't hurt' bit
        boss.act_no = 201
        boss.act_wait = 0
        boss.ani_no = 4
        boss.ani_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 201) then
        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait > 30) then
            boss.act_no = 202
        end

        boss.ani_wait = boss.ani_wait + 1
        if (boss.ani_wait > 0) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no + 1
        end

        if (boss.ani_no > 5) then
            boss.ani_no = 4
        end

        boss.xm = boss.xm + 0.0625
    elseif (boss.act_no == 202) then
        boss:UnsetBit(4) -- Unset bouncy bit
        boss.act_no = 203
        boss.ani_no = 0
        boss.ani_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 203) then
        boss.act_wait = boss.act_wait + 1

        boss.ani_wait = boss.ani_wait + 1
        if (boss.ani_wait > 1) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no + 1
        end

        if (boss.ani_no > 1) then
            boss.ani_no = 0
        end

        boss.xm = boss.xm + 0.0625
    elseif (boss.act_no == 300) then
        boss.act_no = 301
        boss.ani_no = 4
        boss.ani_wait = 0
        boss:SetBit(4) -- Set bouncy bit
        -- Fallthrough
    end

    if (boss.act_no == 301) then
        boss.ani_wait = boss.ani_wait + 1
        if (boss.ani_wait > 0) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no + 1
        end

        if (boss.ani_no > 5) then
            boss.ani_no = 4
        end

        boss.xm = boss.xm + 0.0625

        if (boss.xm > 0) then
            boss.xm = 0
            boss.act_no = 10
        end
    elseif (boss.act_no == 400) then
        boss.act_no = 401
        boss.ani_no = 2
        boss.ani_wait = 0
        boss:SetBit(4) -- Set bouncy bit
        -- Fallthrough
    end

    if (boss.act_no == 401) then
        boss.ani_wait = boss.ani_wait + 1
        if (boss.ani_wait > 0) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no + 1
        end

        if (boss.ani_no > 3) then
            boss.ani_no = 2
        end

        boss.xm = boss.xm - 0.0625

        if (boss.xm < 0) then
            boss.xm = 0
            boss.act_no = 10
        end
    end

    if ((boss.act_no == 101 or boss.act_no == 201 or boss.act_no == 301 or boss.act_no == 401) and boss.act_wait % 2 == 1) then
        ModCS.Sound.Play(112)
    end

    if ((boss.act_no == 103 or boss.act_no == 203) and boss.act_wait % 4 == 1) then
        ModCS.Sound.Play(111)
    end

    if (boss.act_no >= 100 and boss.tgt_mc.y < boss.y + 4 and boss.tgt_mc.y > boss.y - 4) then
        boss.damage = 10
        boss:SetBit(7) -- Set 'rear and top don't hurt' bit
    else
        boss.damage = 0
        boss:UnsetBit(7) -- Unset 'rear and top don't hurt' bit
    end

    if (boss.xm > 2) then
        boss.xm = 2
    end

    if (boss.xm < -2) then
        boss.xm = -2
    end

    boss:Move()

    if (boss.direct == 1) then
        boss:SetRect(rcUp[boss.ani_no+1])
    else
        boss:SetRect(rcDown[boss.ani_no+1])
    end
end

local function ActBossChar03_02(map_boss, boss)
    local rect = {
        ModCS.Rect.Create(0, 128, 72, 160),
        ModCS.Rect.Create(72, 128, 144, 160),
        ModCS.Rect.Create(0, 160, 72, 192),
        ModCS.Rect.Create(72, 160, 144, 192),
    }

    local direct = 0
    local x = 0
    local y = 0

    if (boss.act_no == 10) then
        boss.act_no = 11
        boss.act_wait = (boss.ani_no * 30) + 30
        -- Fallthrough
    end

    if (boss.act_no == 11) then
        if (boss.act_wait ~= 0) then
            boss.act_wait = boss.act_wait - 1
        else
            if (boss.ani_no == 0) then
                direct = 3
                x = -30
                y = 6
            elseif (boss.ani_no == 1) then
                direct = 2
                x = 30
                y = 6
            elseif (boss.ani_no == 2) then
                direct = 0
                x = -30
                y = -6
            elseif (boss.ani_no == 3) then
                direct = 1
                x = 30
                y = -6
            end

            ModCS.Npc.Spawn2(158, boss.x + x, boss.y + y, 0, 0, direct)
            ModCS.Sound.Play(39)
            boss.act_wait = 120
        end
    end

    local countBoss = ModCS.Boss.GetByBufferIndex(boss.count1, true)
    boss.x = (map_boss.x + countBoss.x) / 2
    boss.y = (map_boss.y + countBoss.y) / 2

    boss:SetRect(rect[boss.ani_no+1])
end

local function ActBossChar03_03(map_boss, boss, boss3, boss4, boss5, boss6, boss7, boss13, boss14, boss15, boss16)
    if (boss.act_no == 10) then
        boss.tgt_x = boss.tgt_x + 1

        if (boss.tgt_x > 32) then
            boss.tgt_x = 32
            boss.act_no = 0
            boss3.act_no = 10
            boss4.act_no = 10
            boss5.act_no = 10
            boss6.act_no = 10
        end
    elseif (boss.act_no == 20) then
        boss.tgt_x = boss.tgt_x - 1

        if (boss.tgt_x < 0) then
            boss.tgt_x = 0
            boss.act_no = 0
            boss3.act_no = 0
            boss4.act_no = 0
            boss5.act_no = 0
            boss6.act_no = 0
        end
    elseif (boss.act_no == 30) then
        boss.tgt_x = boss.tgt_x + 1

        if (boss.tgt_x > 20) then
            boss.tgt_x = 20
            boss.act_no = 0
            boss7.act_no = 10
            boss13.act_no = 10
            boss14.act_no = 10
            boss15.act_no = 10
            boss16.act_no = 10
        end
    elseif (boss.act_no == 40) then
        boss.tgt_x = boss.tgt_x - 1

        if (boss.tgt_x < 0) then
            boss.tgt_x = 0
            boss.act_no = 0
            boss7.act_no = 0
            boss13.act_no = 0
            boss14.act_no = 0
            boss15.act_no = 0
            boss16.act_no = 0
        end
    end

    local rcLeft = ModCS.Rect.Create(216, 96, 264, 144)
    local rcRight = ModCS.Rect.Create(264, 96, 312, 144)

    if (boss.direct == 0) then
        boss:SetRect(rcLeft)
        boss.x = map_boss.x - 24 - boss.tgt_x
        boss.y = map_boss.y
    else
        boss:SetRect(rcRight)
        boss.x = map_boss.x + 24 + boss.tgt_x
        boss.y = map_boss.y
    end
end

local function ActBossChar03_04(map_boss, boss)
    local xm = 0
    local ym = 0
    local deg = 0

    local rect = {
        ModCS.Rect.Create(0, 192, 16, 208),
        ModCS.Rect.Create(16, 192, 32, 208),
        ModCS.Rect.Create(32, 192, 48, 208),
        ModCS.Rect.Create(48, 192, 64, 208),
        ModCS.Rect.Create(0, 208, 16, 224),
        ModCS.Rect.Create(16, 208, 32, 224),
        ModCS.Rect.Create(32, 208, 48, 224),
        ModCS.Rect.Create(48, 208, 64, 224),
    }

    if (boss.act_no == 0) then
        boss:UnsetBit(5) -- Unset shootable bit
        boss.ani_no = 0
    elseif (boss.act_no == 10) then
        boss.act_no = 11
        boss.act_wait = (boss.tgt_x_cs * 10) + 40
        boss:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (boss.act_no == 11) then
        if (boss.act_wait < 16 and math.floor(boss.act_wait / 2) % 2 == 1) then
            boss.ani_no = 1
        else
            boss.ani_no = 0
        end

        if (boss.act_wait ~= 0) then
            boss.act_wait = boss.act_wait - 1
        else
            deg = ModCS.Triangle.GetArktan(boss.x - boss.tgt_mc.x, boss.y - boss.tgt_mc.y)
            deg = deg + ModCS.Game.Random(-2, 2)
            ym = ModCS.Triangle.GetSin(deg) * 3
            xm = ModCS.Triangle.GetCos(deg) * 3
            ModCS.Npc.Spawn2(156, boss.x, boss.y, xm, ym, 0)

            ModCS.Sound.Play(39)
            boss.act_wait = 40
        end
    end

    if (boss.tgt_x_cs == 0) then
        boss.x = map_boss.x - 22
        boss.y = map_boss.y - 16
    elseif (boss.tgt_x_cs == 1) then
        boss.x = map_boss.x + 28
        boss.y = map_boss.y - 16
    elseif (boss.tgt_x_cs == 2) then
        boss.x = map_boss.x - 15
        boss.y = map_boss.y + 14
    elseif (boss.tgt_x_cs == 3) then
        boss.x = map_boss.x + 17
        boss.y = map_boss.y + 14
    end

    boss:SetRect(rect[(boss.tgt_x_cs + 4 * boss.ani_no)+1])
end

local x_face_flash = 0

local function ActBossChar03_face(map_boss, boss)
    local rect = {
        ModCS.Rect.Create(216, 0, 320, 48),
        ModCS.Rect.Create(216, 48, 320, 96),
        ModCS.Rect.Create(216, 144, 320, 192),
    }

    if (boss.act_no == 0) then
        map_boss:UnsetBit(5) -- Unset shootable bit
        boss.ani_no = 0
    elseif (boss.act_no == 10) then
        boss.act_no = 11
        boss.act_wait = (boss.tgt_x_cs * 10) + 40
        map_boss:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (boss.act_no == 11) then
        if (map_boss:IsHit()) then
            if (math.floor(x_face_flash / 2) % 2 == 1) then
                boss.ani_no = 1
            else
                boss.ani_no = 0
            end

            x_face_flash = x_face_flash + 1
        else
            boss.ani_no = 0
        end
    end

    boss.x = map_boss.x
    boss.y = map_boss.y

    if (map_boss.act_no <= 10) then
        boss.ani_no = 2
    end

    boss:SetRect(rect[boss.ani_no+1])
end

-- Monster X
ModCS.Boss.Act[3] = function(boss)
    local i = 0

    local boss1 = ModCS.Boss.GetByBufferIndex(1, true)
    local boss2 = ModCS.Boss.GetByBufferIndex(2, true)
    local boss3 = ModCS.Boss.GetByBufferIndex(3, true)
    local boss4 = ModCS.Boss.GetByBufferIndex(4, true)
    local boss5 = ModCS.Boss.GetByBufferIndex(5, true)
    local boss6 = ModCS.Boss.GetByBufferIndex(6, true)
    local boss7 = ModCS.Boss.GetByBufferIndex(7, true)
    local boss9 = ModCS.Boss.GetByBufferIndex(9, true) -- Boss 8 is skipped
    local boss10 = ModCS.Boss.GetByBufferIndex(10, true)
    local boss11 = ModCS.Boss.GetByBufferIndex(11, true)
    local boss12 = ModCS.Boss.GetByBufferIndex(12, true)
    local boss13 = ModCS.Boss.GetByBufferIndex(13, true)
    local boss14 = ModCS.Boss.GetByBufferIndex(14, true)
    local boss15 = ModCS.Boss.GetByBufferIndex(15, true)
    local boss16 = ModCS.Boss.GetByBufferIndex(16, true)

    local hit = boss:GetHitbox()

    local view1 = boss1:GetViewbox()

    local hit3 = boss3:GetHitbox()
    local view3 = boss3:GetViewbox()

    local hit7 = boss7:GetHitbox()
    local view7 = boss7:GetViewbox()

    local hit9 = boss9:GetHitbox()
    local view9 = boss9:GetViewbox()

    local hit11 = boss11:GetHitbox()
    local view11 = boss11:GetViewbox()

    local view12 = boss12:GetViewbox()

    local view13 = boss13:GetViewbox()

    local view14 = boss14:GetViewbox()

    local view15 = boss15:GetViewbox()

    local view16 = boss16:GetViewbox()

    if (boss.act_no == 0) then
        boss.life = 1
        boss.x = -320
    end

    if (boss.act_no == 1) then
        boss.life = 700
        boss.exp = 1
        boss.act_no = 1

        boss.x = 2048
        boss.y = 200

        boss.hit_voice = 24

        hit.front = 24
        hit.top = 24
        hit.back = 24
        hit.bottom = 24
        boss:SetHitbox(hit)

        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(9) -- Set run event when killed bit
        boss:SetBit(15) -- Set show damage # on hit bit

        boss.smoke_size = 3
        boss.event = 1000
        boss.ani_no = 0

        boss1.cond = 0x80
        boss1.smoke_size = 3
        boss1.direct = 0
        view1.front = 24
        view1.top = 24
        view1.back = 24
        view1.bottom = 24
        boss1:SetViewbox(view1)
        boss1:SetBit(3) -- Set ignore tile collision bit

        ModCS.Boss.Copy(boss1, boss2)
        boss2.direct = 2

        boss3.cond = 0x80
        boss3.life = 60
        boss3.hit_voice = 54
        boss3.destroy_voice = 71
        boss3.smoke_size = 2

        view3.front = 8
        view3.top = 8
        view3.back = 8
        view3.bottom = 8
        boss3:SetViewbox(view3)

        hit.front = 5
        hit.back = 5
        hit.top = 5
        hit.bottom = 5
        boss3:SetHitbox(hit3)

        boss3:SetBit(3) -- Set ignore tile collision bit
        boss3.tgt_x_cs = 0

        ModCS.Boss.Copy(boss3, boss4)
        boss4.tgt_x_cs = 1

        ModCS.Boss.Copy(boss3, boss5)
        boss5.tgt_x_cs = 2
        boss5.life = 100

        ModCS.Boss.Copy(boss3, boss6)
        boss6.tgt_x_cs = 3
        boss6.life = 100

        boss7.cond = 0x80
        boss7.x = 2048
        boss7.y = 200

        view7.front = 52
        view7.top = 24
        view7.back = 52
        view7.bottom = 24
        boss7:SetViewbox(view7)

        boss7.hit_voice = 52

        hit7.front = 8
        hit7.top = 24
        hit7.back = 8
        hit7.bottom = 16
        boss7:SetHitbox(hit7)

        boss7:SetBit(3) -- Set ignore tile collision bit
        boss7.smoke_size = 3
        boss7.ani_no = 0

        boss9.cond = 0x80
        boss9.act_no = 0
        boss9.direct = 1
        boss9.x = 1984
        boss9.y = 144

        view9.front = 36
        view9.top = 8
        view9.back = 36
        view9.bottom = 24
        boss9:SetViewbox(view9)

        boss9.hit_voice = 52

        hit9.front = 28
        hit9.top = 8
        hit9.back = 28
        hit9.bottom = 16
        boss9:SetHitbox(hit9)

        boss9:SetBit(0) -- Set solid soft bit
        boss9:SetBit(2) -- Set invulnerable bit
        boss9:SetBit(3) -- Set ignore tile collision bit
        boss9:SetBit(7) -- Set 'rear and top don't hurt' bit
        
        boss9.smoke_size = 3

        ModCS.Boss.Copy(boss9, boss10)
        boss10.x = 2112

        ModCS.Boss.Copy(boss9, boss11)
        view11 = boss11:GetViewbox()
        hit11 = boss11:GetHitbox()
        
        boss11.direct = 3
        boss11.x = 1984
        boss11.y = 256
        
        view11.top = 24
        view11.bottom = 8
        hit11.top = 16
        hit11.bottom = 8
        boss11:SetViewbox(view11)
        boss11:SetHitbox(hit11)

        ModCS.Boss.Copy(boss11, boss12)
        boss12.x = 2112

        ModCS.Boss.Copy(boss9, boss13)
        boss13.cond = 0x80
        view13 = boss13:GetViewbox()
        view13.top = 16
        view13.bottom = 16
        view13.front = 30
        view13.back = 42
        boss13:SetViewbox(view13)
        boss13.count1 = 9
        boss13.ani_no = 0
        boss13:SetBit(3) -- Set ignore tile collision bit

        ModCS.Boss.Copy(boss13, boss14)
        view14 = boss14:GetViewbox()
        view14.front = 42
        view14.back = 30
        boss14:SetViewbox(view14)
        boss14.count1 = 10
        boss14.ani_no = 1
        boss14:SetBit(3) -- Set ignore tile collision bit

        ModCS.Boss.Copy(boss13, boss15)
        view15 = boss15:GetViewbox()
        view15.top = 16
        view15.bottom = 16
        boss15:SetViewbox(view15)
        boss15.count1 = 11
        boss15.ani_no = 2
        boss15:SetBit(3) -- Set ignore tile collision bit

        ModCS.Boss.Copy(boss15, boss16)
        view16 = boss16:GetViewbox()
        view16.front = 42
        view16.back = 30
        boss16:SetViewbox(view16)
        boss16.count1 = 12
        boss16.ani_no = 3
        boss16:SetBit(3) -- Set ignore tile collision bit

        boss.act_no = 2
    elseif (boss.act_no == 10) then
        boss.act_no = 11
        boss.act_wait = 0
        boss.count1 = 0
        -- Fallthrough
    end

    if (boss.act_no == 11) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 100) then
            boss.act_wait = 0

            if (boss.x > boss.tgt_mc.x) then
                boss.act_no = 100
            else
                boss.act_no = 200
            end
        end
    elseif (boss.act_no == 100) then
        boss.act_wait = 0
        boss.act_no = 101
        boss.count1 = boss.count1 + 1
        -- Fallthrough
    end

    if (boss.act_no == 101) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 4) then
            boss9.act_no = 100
        end

        if (boss.act_wait == 8) then
            boss10.act_no = 100
        end

        if (boss.act_wait == 10) then
            boss11.act_no = 100
        end

        if (boss.act_wait == 12) then
            boss12.act_no = 100
        end

        if (boss.act_wait > 120 and boss.count1 > 2) then
            boss.act_no = 300
        end

        if (boss.act_wait > 121 and boss.tgt_mc.x > boss.x) then
            boss.act_no = 200
        end
    elseif (boss.act_no == 200) then
        boss.act_wait = 0
        boss.act_no = 201
        boss.count1 = boss.count1 + 1
        -- Fallthrough
    end

    if (boss.act_no == 201) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 4) then
            boss9.act_no = 200
        end

        if (boss.act_wait == 8) then
            boss10.act_no = 200
        end

        if (boss.act_wait == 10) then
            boss11.act_no = 200
        end

        if (boss.act_wait == 12) then
            boss12.act_no = 200
        end

        if (boss.act_wait > 120 and boss.count1 > 2) then
            boss.act_no = 400
        end

        if (boss.act_wait > 121 and boss.tgt_mc.x < boss.x) then
            boss.act_no = 100
        end
    elseif (boss.act_no == 300) then
        boss.act_wait = 0
        boss.act_no = 301
        -- Fallthrough
    end

    if (boss.act_no == 301) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 4) then
            boss9.act_no = 300
        end

        if (boss.act_wait == 8) then
            boss10.act_no = 300
        end

        if (boss.act_wait == 10) then
            boss11.act_no = 300
        end

        if (boss.act_wait == 12) then
            boss12.act_no = 300
        end

        if (boss.act_wait > 50) then
            if (boss3.cond == 0 and boss4.cond == 0 and boss5.cond == 0 and boss6.cond == 0) then
                boss.act_no = 600
            else
                boss.act_no = 500
            end
        end
    elseif (boss.act_no == 400) then
        boss.act_wait = 0
        boss.act_no = 401
        -- Fallthrough
    end

    if (boss.act_no == 401) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 4) then
            boss9.act_no = 400
        end

        if (boss.act_wait == 8) then
            boss10.act_no = 400
        end

        if (boss.act_wait == 10) then
            boss11.act_no = 400
        end

        if (boss.act_wait == 12) then
            boss12.act_no = 400
        end

        if (boss.act_wait > 50) then
            if (boss3.cond == 0 and boss4.cond == 0 and boss5.cond == 0 and boss6.cond == 0) then
                boss.act_no = 600
            else
                boss.act_no = 500
            end
        end
    elseif (boss.act_no == 500) then
        boss.act_no = 501
        boss.act_wait = 0
        boss1.act_no = 10
        boss2.act_no = 10
        -- Fallthrough
    end

    if (boss.act_no == 501) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 300) then
            boss.act_no = 502
            boss.act_wait = 0
        end

        if (boss3.cond == 0 and boss4.cond == 0 and boss5.cond == 0 and boss6.cond == 0) then
            boss.act_no = 502
            boss.act_wait = 0
        end
    elseif (boss.act_no == 502) then
        boss.act_no = 503
        boss.act_wait = 0
        boss.count1 = 0
        boss1.act_no = 20
        boss2.act_no = 20
        -- Fallthrough
    end

    if (boss.act_no == 503) then -- Exactly identical to case 603
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            if (boss.x > boss.tgt_mc.x) then
                boss.act_no = 100
            else
                boss.act_no = 200
            end
        end
    elseif (boss.act_no == 600) then
        boss.act_no = 601
        boss.act_wait  = 0
        boss.count2 = boss.life
        boss1.act_no = 30
        boss2.act_no = 30
        -- Fallthrough
    end

    if (boss.act_no == 601) then
        boss.act_wait = boss.act_wait + 1

        if (boss.life < boss.count2 - 200 or boss.act_wait > 300) then
            boss.act_no = 602
            boss.act_wait = 0
        end
    elseif (boss.act_no == 602) then
        boss.act_no = 603
        boss.act_wait = 0
        boss.count1 = 0
        boss1.act_no = 40
        boss2.act_no = 40
        -- Fallthrough
    end

    if (boss.act_no == 603) then -- Exactly identical to case 503
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            if (boss.x > boss.tgt_mc.x) then
                boss.act_no = 100
            else
                boss.act_no = 200
            end
        end
    elseif (boss.act_no == 1000) then
        ModCS.Camera.SetQuake(2)

        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait % 8 == 0) then
            ModCS.Sound.Play(52)
        end

        ModCS.Npc.Explode(boss.x + ModCS.Game.Random(-72, 72), boss.y + ModCS.Game.Random(-64, 64), 0.001953125, 1)

        if (boss.act_wait > 100) then
            boss.act_wait = 0
            boss.act_no = 1001
            ModCS.Flash.Spawn(true, boss.x, boss.y)
            ModCS.Sound.Play(35)
        end
    elseif (boss.act_no == 1001) then
        ModCS.Camera.SetQuake(40)

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            for i = 0, 19 do
                local tempBoss = ModCS.Boss.GetByBufferIndex(i, true)
                tempBoss.cond = 0
            end

            ModCS.Npc.KillEveryID(158, true)
            ModCS.Npc.Spawn2(159, boss.x, boss.y - 24, 0, 0, 0)
        end
    end

    ActBossChar03_01(boss9)
    ActBossChar03_01(boss10)
    ActBossChar03_01(boss11)
    ActBossChar03_01(boss12)

    boss.x = boss.x + (((boss11.x + boss10.x + boss9.x + boss12.x) / 4) - boss.x) / 0x10

    ActBossChar03_face(boss, boss7)

    ActBossChar03_02(boss, boss13)
    ActBossChar03_02(boss, boss14)
    ActBossChar03_02(boss, boss15)
    ActBossChar03_02(boss, boss16)

    ActBossChar03_03(boss, boss1, boss3, boss4, boss5, boss6, boss7, boss13, boss14, boss15, boss16)
    ActBossChar03_03(boss, boss2, boss3, boss4, boss5, boss6, boss7, boss13, boss14, boss15, boss16)

    if (boss3.cond ~= 0) then
        ActBossChar03_04(boss, boss3)
    end

    if (boss4.cond ~= 0) then
        ActBossChar03_04(boss, boss4)
    end

    if (boss5.cond ~= 0) then
        ActBossChar03_04(boss, boss5)
    end

    if (boss6.cond ~= 0) then
        ActBossChar03_04(boss, boss6)
    end

    if (boss.life == 0 and boss.act_no < 1000) then
        boss.act_no = 1000
        boss.act_wait = 0
        boss.shock = 150
        boss9.act_no = 300
        boss10.act_no = 300
        boss11.act_no = 300
        boss12.act_no = 300
    end
end