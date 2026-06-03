local function ActBossCharA_Head(map_boss, boss)
    local head = {
        ModCS.Rect.Create(0, 0, 72, 112),
        ModCS.Rect.Create(0, 112, 72, 224),
        ModCS.Rect.Create(160, 0, 232, 112),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    local view = boss:GetViewbox()

    if (boss.act_no == 10) then
        boss.act_no = 11
        boss.ani_no = 2
        boss:SetBit(3) -- Set ignore tile collision bit
        view.front = 36
        view.top = 56
        -- Fallthrough
    end

    if (boss.act_no == 11) then
        boss.x = map_boss.x - 36
        boss.y = map_boss.y
    elseif (boss.act_no == 50) then
        boss.act_no = 51
        boss.act_wait = 112
        -- Fallthrough
    end

    if (boss.act_no == 51) then
        boss.act_wait = boss.act_wait - 1

        if (boss.act_wait == 0) then
            boss.act_no = 100
            boss.ani_no = 3
        end
    elseif (boss.act_no == 100) then
        boss.ani_no = 3
    end

    rect = head[boss.ani_no+1]

    if (boss.act_no == 51) then
        rect.bottom = rect.top + boss.act_wait
    end

    boss:SetRect(rect)
    boss:SetViewbox(view)
end

local function ActBossCharA_Tail(map_boss, boss)
    local tail = {
        ModCS.Rect.Create(72, 0, 160, 112),
        ModCS.Rect.Create(72, 112, 160, 224),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    local view = boss:GetViewbox()

    if (boss.act_no == 10) then
        boss.act_no = 11
        boss.ani_no = 0
        boss:SetBit(3) -- Set ignore tile collision bit
        view.front = 44
        view.top = 56
        -- Fallthrough
    end

    if (boss.act_no == 11) then
        boss.x = map_boss.x + 44
        boss.y = map_boss.y
    elseif (boss.act_no == 50) then
        boss.act_no = 51
        boss.act_wait = 112
        -- Fallthrough
    end

    if (boss.act_no == 51) then
        boss.act_wait = boss.act_wait - 1

        if (boss.act_wait == 0) then
            boss.act_no = 100
            boss.ani_no = 2
        end
    elseif (boss.act_no == 100) then
        boss.ani_no = 2
    end

    rect = tail[boss.ani_no+1]

    if (boss.act_no == 51) then
        rect.bottom = rect.top + boss.act_wait
    end

    boss:SetRect(rect)
    boss:SetViewbox(view)
end

local function ActBossCharA_Face(map_boss, boss)
    local rect = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(160, 112, 232, 152),
        ModCS.Rect.Create(160, 152, 232, 192),
        ModCS.Rect.Create(160, 192, 232, 232),
        ModCS.Rect.Create(248, 160, 320, 200),
    }

    local view = boss:GetViewbox()

    if (boss.act_no == 0) then
        boss.ani_no = 0
    elseif (boss.act_no == 10) then
        boss.ani_no = 1
    elseif (boss.act_no == 20) then
        boss.ani_no = 2
    elseif (boss.act_no == 30) then
        boss.act_no = 31
        boss.ani_no = 3
        boss.act_wait = 100
        -- Fallthrough
    end

    if (boss.act_no == 31) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 300) then
            boss.act_wait = 0
        end

        if (boss.act_wait > 250 and boss.act_wait % 16 == 1) then
            ModCS.Sound.Play(26)
        end

        if (boss.act_wait > 250 and boss.act_wait % 16 == 7) then
            ModCS.Npc.Spawn2(293, boss.x, boss.y, 0, 0, 0, 0x80)
            ModCS.Sound.Play(101)
        end

        if (boss.act_wait == 200) then
            ModCS.Sound.Play(116)
        end

        if (boss.act_wait > 200 and boss.act_wait % 2 ~= 0) then
            boss.ani_no = 4
        else
            boss.ani_no = 3
        end
    end

    view.back = 36
    view.front = 36
    view.top = 20

    boss.x = map_boss.x - 36
    boss.y = map_boss.y + 4

    boss:SetBit(3) -- Set ignore tile collision bit

    boss:SetRect(rect[boss.ani_no+1])
    boss:SetViewbox(view)
end

local function ActBossCharA_Mini(boss)
    local rect = {
        ModCS.Rect.Create(256, 0, 320, 40),
        ModCS.Rect.Create(256, 40, 320, 80),
        ModCS.Rect.Create(256, 80, 320, 120),
    }

    local deg = 0

    if (boss.cond == 0) then
        return
    end

    boss.life = 1000

    if (boss.act_no == 0) then
        boss:UnsetBit(5) -- Unset shootable bit
    elseif (boss.act_no == 5) then
        boss.ani_no = 0
        boss:UnsetBit(5) -- Unset shootable bit
        boss.count2 = boss.count2 + 1
        boss.count2 = boss.count2 % 0x100
    elseif (boss.act_no == 10) then
        boss.ani_no = 0
        boss:UnsetBit(5) -- Unset shootable bit
        boss.count2 = boss.count2 + 2
        boss.count2 = boss.count2 % 0x100
    elseif (boss.act_no == 20) then
        boss.ani_no = 1
        boss:UnsetBit(5) -- Unset shootable bit
        boss.count2 = boss.count2 + 2
        boss.count2 = boss.count2 % 0x100
    elseif (boss.act_no == 30) then
        boss.ani_no = 0
        boss:UnsetBit(5) -- Unset shootable bit
        boss.count2 = boss.count2 + 4
        boss.count2 = boss.count2 % 0x100
    elseif (boss.act_no == 200) then
        boss.act_no = 201
        boss.ani_no = 2
        boss.xm = 0
        boss.ym = 0
        -- Fallthrough
    end

    if (boss.act_no == 201) then
        boss.xm = boss.xm + 0.0625

        boss:Move()

        if (boss.x > (ModCS.Map.GetWidth() * 0x10) + (2 * 0x10)) then
            boss.cond = 0
        end
    end

    if (boss.act_no < 50) then
        if (boss.count1 ~= 0) then
            deg = boss.count2 + 0x80
        else
            deg = boss.count2 + 0x180
        end

        boss.x = boss.pNpc.x - 8 + (ModCS.Triangle.GetCos(deg / 2) * 0x30)
        boss.y = boss.pNpc.y + (ModCS.Triangle.GetSin(deg / 2) * 0x50)
    end

    boss:SetRect(rect[boss.ani_no+1])
end

local function ActBossCharA_Hit(map_boss, boss)
    if (boss.count1 == 0) then
        boss.x = map_boss.x
        boss.y = map_boss.y - 32
    elseif (boss.count1 == 1) then
        boss.x = map_boss.x + 28
        boss.y = map_boss.y
    elseif (boss.count1 == 2) then
        boss.x = map_boss.x + 4
        boss.y = map_boss.y + 32
    elseif (boss.count1 == 3) then
        boss.x = map_boss.x - 28
        boss.y = map_boss.y + 4
    end
end

-- Undead Core
undeadcore_flash = 0
undeadcore_life = 0
ModCS.Boss.Act[7] = function(boss)
    local bShock = false
    local x = 0
    local y = 0
    local i = 0

    local boss3 = ModCS.Boss.GetByBufferIndex(3, true)
    local boss4 = ModCS.Boss.GetByBufferIndex(4, true)
    local boss5 = ModCS.Boss.GetByBufferIndex(5, true)
    local boss8 = ModCS.Boss.GetByBufferIndex(8, true)
    local boss9 = ModCS.Boss.GetByBufferIndex(9, true)
    local boss10 = ModCS.Boss.GetByBufferIndex(10, true)
    local boss11 = ModCS.Boss.GetByBufferIndex(11, true)
    local boss1 = ModCS.Boss.GetByBufferIndex(1, true)
    local boss2 = ModCS.Boss.GetByBufferIndex(2, true)
    local boss6 = ModCS.Boss.GetByBufferIndex(6, true)
    local boss7 = ModCS.Boss.GetByBufferIndex(7, true)

    local view1 = boss1:GetViewbox()
    local view8 = boss8:GetViewbox()
    
    local hit1 = boss1:GetHitbox()
    local hit8 = boss8:GetHitbox()
    local hit9 = boss9:GetHitbox()
    local hit10 = boss10:GetHitbox()
    local hit11 = boss11:GetHitbox()

    if (boss.act_no == 1) then
        boss.act_no = 10
        boss.exp = 1
        boss.cond = 0x80

        boss:SetBit(2) -- Set invulnerable bit
        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(15) -- Set show damage # bit
        
        boss.life = 700
        boss.hit_voice = 114

        boss.x = 592
        boss.y = 120

        boss.xm = 0
        boss.ym = 0
        
        boss.event = 1000
        boss:SetBit(9) -- Set run event when killed bit

        boss3.cond = 0x80
        boss3.act_no = 0

        boss4.cond = 0x80
        boss4.act_no = 10

        boss5.cond = 0x80
        boss5.act_no = 10

        boss8.cond = 0x80
        boss8:SetBit(3) -- Set ignore tile collision bit

        view8.front = 0
        view8.top = 0
        boss8:SetViewbox(view8)

        hit8.back = 40
        hit8.top = 16
        hit8.bottom = 16
        boss8:SetHitbox(hit8)

        boss8.count1 = 0

        ModCS.Boss.Copy(boss8, boss9)

        hit9.back = 36
        hit9.top = 24
        hit9.bottom = 24
        boss9:SetHitbox(hit9)

        boss9.count1 = 1

        ModCS.Boss.Copy(boss8, boss10)

        hit10.back = 44
        hit10.top = 8
        hit10.bottom = 8
        boss10:SetHitbox(hit10)

        boss10.count1 = 2

        ModCS.Boss.Copy(boss8, boss11)
        boss11.cond = ModCS.Game.SetBit(boss11.cond, 0x10) -- Set "all damage is directed towards main map boss" condition

        hit11.back = 20
        hit11.top = 20
        hit11.bottom = 20
        boss11:SetHitbox(hit11)

        boss11.count1 = 3

        boss1.cond = 0x80
        boss1.act_no = 0
        
        boss1:SetBit(3) -- Set ignore tile collision bit
        boss1:SetBit(5) -- Set shootable bit
        boss1.life = 1000
        boss1.hit_voice = 54

        hit1.back = 24
        hit1.top = 16
        hit1.bottom = 16
        boss1:SetHitbox(hit1)

        view1.front = 32
        view1.top = 20
        boss1:SetViewbox(view1)

        boss1.pNpc = boss

        ModCS.Boss.Copy(boss1, boss2)
        boss2.count2 = 0x80

        ModCS.Boss.Copy(boss1, boss6)
        boss6.count1 = 1

        ModCS.Boss.Copy(boss1, boss7)
        boss7.count1 = 1
        boss7.count2 = 0x80

        undeadcore_life = boss.life
    elseif (boss.act_no == 15) then
        boss.act_no = 16
        bShock = true
        boss.direct = 0
        boss3.act_no = 10
        boss4.ani_no = 0
    elseif (boss.act_no == 20) then
        boss.act_no = 210
        bShock = true
        boss.direct = 0
        boss1.act_no = 5
        boss2.act_no = 5
        boss6.act_no = 5
        boss7.act_no = 5
    elseif (boss.act_no == 200) then
        boss.act_no = 201
        boss.act_wait = 0
        boss3.act_no = 0
        boss4.ani_no = 2
        boss5.ani_no = 0
        boss8:UnsetBit(2) -- Unset invulnerable bit
        boss9:UnsetBit(2) -- Unset invulnerable bit
        boss10:UnsetBit(2) -- Unset invulnerable bit
        boss11:UnsetBit(5) -- Unset shootable bit
        ModCS.Npc.SetSuperY(0)
        ModCS.Sound.EndNoise()
        bShock = true
        -- Fallthrough
    end

    if (boss.act_no == 201) then
        boss.act_wait = boss.act_wait + 1

        if (boss.direct == 2 or boss.ani_no > 0 or boss.life < 200) then
            if (boss.act_wait > 200) then
                boss.count1 = boss.count1 + 1
                ModCS.Sound.Play(115)

                if (boss.life < 200) then
                    boss.act_no = 230
                else
                    if (boss.count1 > 2) then
                        boss.act_no = 220
                    else
                        boss.act_no = 210
                    end
                end
            end
        end
    elseif (boss.act_no == 210) then
        boss.act_no = 211
        boss.act_wait = 0
        boss3.act_no = 10
        boss8:SetBit(2) -- Set invulnerable bit
        boss9:SetBit(2) -- Set invulnerable bit
        boss10:SetBit(2) -- Set invulnerable bit
        boss11:SetBit(5) -- Set shootable bit
        undeadcore_life = boss.life
        bShock = true
        -- Fallthrough
    end

    if (boss.act_no == 211) then
        undeadcore_flash = undeadcore_flash + 1

        if (boss:IsHit() and math.floor(undeadcore_flash / 2) % 2 == 1) then
            boss4.ani_no = 1
            boss5.ani_no = 1
        else
            boss4.ani_no = 0
            boss5.ani_no = 0
        end
        
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 100 == 1) then
            ModCS.Npc.SetCurlyShootWait(ModCS.Game.Random(80, 100))
            ModCS.Npc.SetCurlyShootX(boss11.x)
            ModCS.Npc.SetCurlyShootY(boss11.y)
        end

        if (boss.act_wait < 300) then
            if (boss.act_wait % 120 == 1) then
                ModCS.Npc.Spawn2(288, boss.x - 32, boss.y - 16, 0, 0, 1, 0x20)
            end

            if (boss.act_wait % 120 == 61) then
                ModCS.Npc.Spawn2(288, boss.x - 32, boss.y + 16, 0, 0, 3, 0x20)
            end
        end

        if (boss.life < undeadcore_life - 50 or boss.act_wait > 400) then
            boss.act_no = 200
        end
    elseif (boss.act_no == 220) then
        boss.act_no = 221
        boss.act_wait = 0
        boss.count1 = 0
        ModCS.Npc.SetSuperY(1)
        boss3.act_no = 20
        boss8:SetBit(2) -- Set invulnerable bit
        boss9:SetBit(2) -- Set invulnerable bit
        boss10:SetBit(2) -- Set invulnerable bit
        boss11:SetBit(5) -- Set shootable bit
        ModCS.Camera.SetQuake(100)
        undeadcore_life = boss.life
        bShock = true
        -- Fallthrough
    end

    if (boss.act_no == 221) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 40 == 1) then
            local rng = ModCS.Game.Random(0, 3)

            if (rng == 0) then
                x = boss1.x
                y = boss1.y
            elseif (rng == 1) then
                x = boss2.x
                y = boss2.y
            elseif (rng == 2) then
                x = boss6.x
                y = boss6.y
            elseif (rng == 3) then
                x = boss7.x
                y = boss7.y
            end

            ModCS.Sound.Play(25)
            ModCS.Npc.Spawn2(285, x - 16, y, 0, 0, 0)
            ModCS.Npc.Spawn2(285, x - 16, y, 0, 0, 0x400)
        end

        undeadcore_flash = undeadcore_flash + 1

        if (boss:IsHit() and math.floor(undeadcore_flash / 2) % 2 == 1) then
            boss4.ani_no = 1
            boss5.ani_no = 1
        else
            boss4.ani_no = 0
            boss5.ani_no = 0
        end

        if (boss.life < undeadcore_life - 150 or boss.act_wait > 400 or boss.life < 200) then
            boss.act_no = 200
        end
    elseif (boss.act_no == 230) then
        boss.act_no = 231
        boss.act_wait = 0

        boss3.act_no = 30

        boss8:SetBit(2) -- Set invulnerable bit
        boss9:SetBit(2) -- Set invulnerable bit
        boss10:SetBit(2) -- Set invulnerable bit
        boss11:SetBit(5) -- Set shootable bit

        ModCS.Sound.Play(25)

        ModCS.Npc.Spawn2(285, boss3.x - 16, boss3.y, 0, 0, 0)
        ModCS.Npc.Spawn2(285, boss3.x - 16, boss3.y, 0, 0, 0x400)
        ModCS.Npc.Spawn2(285, boss3.x, boss3.y - 16, 0, 0, 0)
        ModCS.Npc.Spawn2(285, boss3.x, boss3.y - 16, 0, 0, 0x400)
        ModCS.Npc.Spawn2(285, boss3.x, boss3.y + 16, 0, 0, 0)
        ModCS.Npc.Spawn2(285, boss3.x, boss3.y + 16, 0, 0, 0x400)

        undeadcore_life = boss.life
        bShock = true
        -- Fallthrough
    end

    if (boss.act_no == 231) then
        undeadcore_flash = undeadcore_flash + 1

        if (boss:IsHit() and math.floor(undeadcore_flash / 2) % 2 == 1) then
            boss4.ani_no = 1
            boss5.ani_no = 1
        else
            boss4.ani_no = 0
            boss5.ani_no = 0
        end

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 100 == 1) then
            ModCS.Npc.SetCurlyShootWait(ModCS.Game.Random(80, 100))
            ModCS.Npc.SetCurlyShootX(boss11.x)
            ModCS.Npc.SetCurlyShootY(boss11.y)
        end

        if (boss.act_wait % 120 == 1) then
            ModCS.Npc.Spawn2(288, boss.x - 32, boss.y - 16, 0, 0, 1, 0x20)
        end

        if (boss.act_wait % 120 == 61) then
            ModCS.Npc.Spawn2(288, boss.x - 32, boss.y + 16, 0, 0, 3, 0x20)
        end
    elseif (boss.act_no == 500) then
        ModCS.Sound.EndNoise()
        boss.act_no = 501
        boss.act_wait = 0
        boss.xm = 0
        boss.ym = 0

        boss3.act_no = 0
        boss4.ani_no = 2
        boss5.ani_no = 0

        boss1.act_no = 5
        boss2.act_no = 5
        boss6.act_no = 5
        boss7.act_no = 5

        ModCS.Camera.SetQuake(20)

        for i = 0, 99 do
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-128, 128), boss.y + ModCS.Game.Random(-64, 64), ModCS.Game.Random2(-128, 128), ModCS.Game.Random2(-128, 128), 0, 0)
        end

        ModCS.Npc.KillEveryID(282, true)
        boss11:UnsetBit(5) -- Unset shootable bit

        for i = 0, 11 do
            local tempBoss = ModCS.Boss.GetByBufferIndex(i, true)
            tempBoss:UnsetBit(2) -- Unset invulnerable bit
        end
        -- Fallthrough
    end

    if (boss.act_no == 501) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 16 ~= 0) then
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-64, 64), boss.y + ModCS.Game.Random(-32, 32), ModCS.Game.Random2(-128, 128), ModCS.Game.Random2(-128, 128), 0)
        end

        boss.x = boss.x + 0.125
        boss.y = boss.y + 0.125

        if (boss.act_wait > 200) then
            boss.act_wait = 0
            boss.act_no = 1000
        end
    elseif (boss.act_no == 1000) then
        ModCS.Camera.SetQuake(100)

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 8 == 0) then
            ModCS.Sound.Play(44)
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
            ModCS.Npc.KillEveryID(301, true)
        end
    end

    if (bShock) then
        ModCS.Camera.SetQuake(20)

        if (boss.act_no == 201) then
            boss1.act_no = 10
            boss2.act_no = 10
            boss6.act_no = 10
            boss7.act_no = 10
        end

        if (boss.act_no == 221) then
            boss1.act_no = 20
            boss2.act_no = 20
            boss6.act_no = 20
            boss7.act_no = 20
        end

        if (boss.act_no == 231) then
            boss1.act_no = 30
            boss2.act_no = 30
            boss6.act_no = 30
            boss7.act_no = 30
        end

        ModCS.Sound.Play(26)

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, boss4.x + ModCS.Game.Random(-32, 16), boss4.y, ModCS.Game.Random2(-1, 1), ModCS.Game.Random2(-0.5, 0.5), 0)
        end
    end

    if (boss.act_no >= 200 and boss.act_no < 300) then
        if (boss.x < 192) then
            boss.direct = 2
        end

        if (boss.x > (ModCS.Map.GetWidth() - 4) * 0x10) then
            boss.direct = 0
        end

        if (boss.direct == 0) then
            boss.xm = boss.xm - 0.0078125
        else
            boss.xm = boss.xm + 0.0078125
        end
    end

    if (boss.act_no == 201 or boss.act_no == 211 or boss.act_no == 221 or boss.act_no == 231) then
        boss.count2 = boss.count2 + 1

        if (boss.count2 == 150) then
            boss.count2 = 0
            ModCS.Npc.Spawn2(282, (ModCS.Map.GetWidth() * 0x10) + 0x40, (ModCS.Game.Random(-1, 3) + 10) * 0x10, 0, 0, 0, 0x30)
        elseif (boss.count2 == 75) then
            ModCS.Npc.Spawn2(282, (ModCS.Map.GetWidth() * 0x10) + 0x40, (ModCS.Game.Random(-3, 0) + 3) * 0x10, 0, 0, 0, 0x30)
        end
    end

    if (boss.xm > 0.25) then
        boss.xm = 0.25
    end

    if (boss.xm < -0.25) then
        boss.xm = -0.25
    end

    if (boss.ym > 0.25) then
        boss.ym = 0.25
    end

    if (boss.ym < -0.25) then
        boss.ym = -0.25
    end

    boss:Move()

    ActBossCharA_Face(boss, boss3)

    ActBossCharA_Head(boss, boss4)

    ActBossCharA_Tail(boss, boss5)

    ActBossCharA_Mini(boss1)
    ActBossCharA_Mini(boss2)
    ActBossCharA_Mini(boss6)
    ActBossCharA_Mini(boss7)

    ActBossCharA_Hit(boss, boss8)
    ActBossCharA_Hit(boss, boss9)
    ActBossCharA_Hit(boss, boss10)
    ActBossCharA_Hit(boss, boss11)
end