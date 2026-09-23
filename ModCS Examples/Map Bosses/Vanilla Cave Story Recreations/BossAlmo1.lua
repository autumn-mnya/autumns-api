local function ActBossChar_Core_Face(map_boss, boss)
    local face = {
        ModCS.Rect.Create(0, 0, 72, 112),
        ModCS.Rect.Create(0, 112, 72, 224),
        ModCS.Rect.Create(160, 0 ,232, 112),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    local view = boss:GetViewbox()

    if (boss.act_no == 10) then
        boss.act_no = 11
        boss.ani_no = 2
        boss:SetBit(3) -- Set ignore solid bit
        view.front = 36
        view.top = 56
        boss:SetViewbox(view)
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

        boss.x = map_boss.x - 36
        boss.y = map_boss.y
    elseif (boss.act_no == 100) then
        boss.ani_no = 3
    end

    rect = face[boss.ani_no+1]
    
    if (boss.act_no == 51) then
        rect.bottom = rect.top + boss.act_wait
    end

    boss:SetRect(rect)
end

local function ActBossChar_Core_Tail(map_boss, boss)
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

        boss.x = map_boss.x + 44
        boss.y = map_boss.y
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

local function ActBossChar_Core_Mini(map_boss, boss)
    local rect = {
        ModCS.Rect.Create(256, 0, 320, 40),
        ModCS.Rect.Create(256, 40, 320, 80),
        ModCS.Rect.Create(256, 80, 320, 120),
    }

    local xm = 0
    local ym = 0
    local deg = 0

    boss.life = 1000

    if (boss.act_no == 10) then
        boss.ani_no = 2
        boss:UnsetBit(5) -- Unset shootable bit
    elseif (boss.act_no == 100) then
        boss.act_no = 101
        boss.ani_no = 2
        boss.act_wait = 0
        boss.tgt_x = map_boss.x + ModCS.Game.Random(-0x80, 0x20)
        boss.tgt_y = map_boss.y + ModCS.Game.Random(-0x40, 0x40)
        boss:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (boss.act_no == 101) then
        boss.x = boss.x + (boss.tgt_x - boss.x) / 0x10
        boss.y = boss.y + (boss.tgt_y - boss.y) / 0x10

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.ani_no = 0
        end
    elseif (boss.act_no == 120) then
        boss.act_no = 121
        boss.act_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 121) then
        boss.act_wait = boss.act_wait + 1

        if (math.floor(boss.act_wait / 2) % 2 == 1) then
            boss.ani_no = 0
        else
            boss.ani_no = 1
        end

        if (boss.act_wait > 20) then
            boss.act_no = 130
        end
    elseif (boss.act_no == 130) then
        boss.act_no = 131
        boss.ani_no = 2
        boss.act_wait = 0
        boss.tgt_x = boss.x + ModCS.Game.Random(24, 48)
        boss.tgt_y = boss.y + ModCS.Game.Random(-4, 4)
        -- Fallthrough
    end

    if (boss.act_no == 131) then
        boss.x = boss.x + (boss.tgt_x - boss.x) / 0x10
        boss.y = boss.y + (boss.tgt_y - boss.y) / 0x10

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.act_no = 140
            boss.ani_no = 0
        end

        if (boss.act_wait == 1 or boss.act_wait == 3) then
            deg = ModCS.Triangle.GetArktan(boss.x - boss.tgt_mc.x, boss.y - boss.tgt_mc.y)
            deg = deg + ModCS.Game.Random(-2, 2)
            ym = ModCS.Triangle.GetSin(deg) * 2
            xm = ModCS.Triangle.GetCos(deg) * 2
            ModCS.Npc.Spawn2(178, boss.x, boss.y, xm, ym, 0)
            ModCS.Sound.Play(39)
        end
    elseif (boss.act_no == 140) then
        boss.x = boss.x + (boss.tgt_x - boss.x) / 0x10
        boss.y = boss.y + (boss.tgt_y - boss.y) / 0x10
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

    if (boss:IsHit()) then
        boss.tgt_x = boss.tgt_x + 2
    end

    boss:SetRect(rect[boss.ani_no+1])
end

local function ActBossChar_Core_Hit(map_boss, boss)
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

core_flash = 0

-- Core
ModCS.Boss.Act[4] = function(boss)
    local boss1 = ModCS.Boss.GetByBufferIndex(1, true)
    local boss2 = ModCS.Boss.GetByBufferIndex(2, true)
    local boss3 = ModCS.Boss.GetByBufferIndex(3, true)
    local boss4 = ModCS.Boss.GetByBufferIndex(4, true)
    local boss5 = ModCS.Boss.GetByBufferIndex(5, true)
    local boss6 = ModCS.Boss.GetByBufferIndex(6, true)
    local boss7 = ModCS.Boss.GetByBufferIndex(7, true)
    local boss8 = ModCS.Boss.GetByBufferIndex(8, true)
    local boss9 = ModCS.Boss.GetByBufferIndex(9, true)
    local boss10 = ModCS.Boss.GetByBufferIndex(10, true)
    local boss11 = ModCS.Boss.GetByBufferIndex(11, true)

    local hit1 = boss1:GetHitbox()
    local view1 = boss1:GetViewbox()

    local hit8 = boss8:GetHitbox()
    local view8 = boss8:GetViewbox()

    local hit9 = boss9:GetHitbox()

    local hit10 = boss10:GetHitbox()

    local hit11 = boss11:GetHitbox()

    local bShock = false
    local i = 0
    local deg = 0
    local xm = 0
    local ym = 0

    if (boss.act_no == 0) then
        boss.act_no = 10
        boss.exp = 1
        boss.cond = 0x80
        boss:SetBit(2) -- Set invulnerable bit
        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(15) -- Set show damage # bit
        boss.life = 650
        boss.hit_voice = 114
        boss.x = 77 * 0x10
        boss.y = 14 * 0x10
        boss.xm = 0
        boss.ym = 0
        boss.event = 1000
        boss:SetBit(9) -- Set run event when killed bit

        boss4.cond = 0x80
        boss4.act_no = 10

        boss5.cond = 0x80
        boss5.act_no = 10

        boss8.cond = 0x80
        boss8:SetBit(2) -- Set invulnerable bit
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
        hit9 = boss9:GetHitbox()
        hit9.back = 36
        hit9.top = 24
        hit9.bottom = 24
        boss9:SetHitbox(hit9)
        boss9.count1 = 1

        ModCS.Boss.Copy(boss8, boss10)
        hit10 = boss10:GetHitbox()
        hit10.back = 44
        hit10.top = 8
        hit10.bottom = 8
        boss10:SetHitbox(hit10)
        boss10.count1 = 2

        ModCS.Boss.Copy(boss8, boss11)
        boss11.cond = ModCS.Game.SetBit(boss11.cond, 0x10) -- Set "all damage is directed towards main map boss" condition
        hit11 = boss11:GetHitbox()
        hit11.back = 20
        hit11.top = 20
        hit11.bottom = 20
        boss11:SetHitbox(hit11)
        boss11.count1 = 3

        boss1.cond = 0x80
        boss1.act_no = 10
        boss1:SetBit(2) -- Set invulnerable bit
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
        boss1.x = boss.x - 8
        boss1.y = boss.y - 64

        ModCS.Boss.Copy(boss1, boss2)
        boss2.x = boss.x + 16
        boss2.y = boss.y

        ModCS.Boss.Copy(boss1, boss3)
        boss3.x = boss.x - 8
        boss3.y = boss.y + 64

        ModCS.Boss.Copy(boss1, boss6)
        boss6.x = boss.x - 48
        boss6.y = boss.y - 32

        ModCS.Boss.Copy(boss1, boss7)
        boss7.x = boss.x - 48
        boss7.y = boss.y + 32
    elseif (boss.act_no == 200) then
        boss.act_no = 201
        boss.act_wait = 0
        boss11:UnsetBit(5) -- Unset shootable bit
        ModCS.Npc.SetSuperY(0)
        ModCS.Sound.EndNoise()
        -- Fallthrough
    end

    if (boss.act_no == 201) then
        boss.tgt_x = boss.tgt_mc.x
        boss.tgt_y = boss.tgt_mc.y

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 400) then
            boss.count1 = boss.count1 + 1
            ModCS.Sound.Play(115)

            if (boss.count1 > 3) then
                boss.count1 = 0
                boss.act_no = 220
                boss4.ani_no = 0
                boss5.ani_no = 0
                bShock = true
            else
                boss.act_no = 210
                boss4.ani_no = 0
                boss5.ani_no = 0
                bShock = true
            end
        end
    elseif (boss.act_no == 210) then
        boss.act_no = 211
        boss.act_wait = 0
        boss.count2 = boss.life
        boss11:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (boss.act_no == 211) then
        boss.tgt_x = boss.tgt_mc.x
        boss.tgt_y = boss.tgt_mc.y

        if (boss:IsHit()) then
            core_flash = core_flash + 1
            if (math.floor(core_flash / 2) % 2 == 1) then
                boss4.ani_no = 0
                boss5.ani_no = 0
            else
                boss4.ani_no = 1
                boss5.ani_no = 1
            end
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

        if (boss.act_wait < 200 and boss.act_wait % 20 == 1) then
            ModCS.Npc.Spawn2(179, boss.x + ModCS.Game.Random(-48, -16), boss.y + ModCS.Game.Random(-64, 64), 0, 0, 0)
        end

        if (boss.act_wait > 400 or boss.life < boss.count2 - 200) then
            boss.act_no = 200
            boss4.ani_no = 2
            boss5.ani_no = 0
            bShock = true
        end
    elseif (boss.act_no == 220) then
        boss.act_no = 221
        boss.act_wait = 0
        ModCS.Npc.SetSuperY(1)
        boss11:SetBit(5) -- Set shootable bit
        ModCS.Camera.SetQuake(100)
        ModCS.Sound.SetNoise(1, 1000)
        -- Fallthrough
    end

    if (boss.act_no == 221) then
        boss.act_wait = boss.act_wait + 1
        ModCS.Npc.Spawn2(199, boss.tgt_mc.x + ModCS.Game.Random(-50, 150) * 2, boss.tgt_mc.y + ModCS.Game.Random(-160, 160), 0, 0, 0)
        -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or boss.tgt_mc
        -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
        -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
        -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
        for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
            local mychar = ModCS.Multiplayer.GetByID(i)
            if (mychar:IsPlaying()) then
                mychar.xm = mychar.xm - 0.0625
                mychar.cond = ModCS.Game.SetBit(mychar.cond, 0x20)
            end
        end

        if (boss:IsHit()) then
            core_flash = core_flash + 1
            if (math.floor(core_flash / 2) % 2 == 1) then
                boss4.ani_no = 0
                boss5.ani_no = 0
            else
                boss4.ani_no = 1
                boss5.ani_no = 1
            end
        else
            boss4.ani_no = 0
            boss5.ani_no = 0
        end

        if (boss.act_wait == 300 or boss.act_wait == 350 or boss.act_wait == 400) then
            deg = ModCS.Triangle.GetArktan(boss.x - boss.tgt_mc.x, boss.y - boss.tgt_mc.y)
            ym = ModCS.Triangle.GetSin(deg) * 3
            xm = ModCS.Triangle.GetCos(deg) * 3
            ModCS.Npc.Spawn2(218, boss.x - 40, boss.y, xm, ym, 0)
            ModCS.Sound.Play(101)
        end

        if (boss.act_wait > 400) then
            boss.act_no = 200
            boss4.ani_no = 2
            boss5.ani_no = 0
            bShock = true
        end
    elseif (boss.act_no == 500) then
        ModCS.Sound.EndNoise()

        boss.act_no = 501
        boss.act_wait = 0
        boss.xm = 0
        boss.ym = 0

        boss4.ani_no = 2
        boss5.ani_no = 0

        boss1.act_no = 200
        boss2.act_no = 200
        boss3.act_no = 200
        boss6.act_no = 200
        boss7.act_no = 200

        ModCS.Camera.SetQuake(20)

        for i = 0, 31 do
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-128, 128), boss.y + ModCS.Game.Random(-64, 64), ModCS.Game.Random3(-128, 128), ModCS.Game.Random3(-128, 128), 0)
        end

        for i = 0, 11 do
            local tempBoss = ModCS.Boss.GetByBufferIndex(i, true)
            tempBoss:UnsetBit(2) -- Unset invulnerable bit
            tempBoss:UnsetBit(5) -- Unset shootable bit
        end

        -- Fallthrough
    end

    if (boss.act_no == 501) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 16 ~= 0) then
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-64, 64), boss.y + ModCS.Game.Random(-32, 32), ModCS.Game.Random3(-128, 128), ModCS.Game.Random3(-128, 128), 0)
        end

        if (math.floor(boss.act_wait / 2) % 2 == 1) then
            boss.x = boss.x - 1
        else
            boss.x = boss.x + 1
        end

        if (boss.x < 63 * 0x10) then
            boss.x = boss.x + 0.25
        else
            boss.x = boss.x - 0.25
        end

        if (boss.y < 11 * 0x10) then
            boss.y = boss.y + 0.25
        else
            boss.y = boss.y - 0.25
        end
    elseif (boss.act_no == 600) then
        boss.act_no = 601
        boss4.act_no = 50
        boss5.act_no = 50
        boss8:UnsetBit(2) -- Unset invulnerable bit
        boss9:UnsetBit(2) -- Unset invulnerable bit
        boss10:UnsetBit(2) -- Unset invulnerable bit
        boss11:UnsetBit(2) -- Unset invulnerable bit
        -- Fallthrough
    end

    if (boss.act_no == 601) then
        boss.act_wait = boss.act_wait + 1

        if (math.floor(boss.act_wait / 2) % 2 == 1) then
            boss.x = boss.x - 4
        else
            boss.x = boss.x + 4
        end
    end

    if (bShock) then
        ModCS.Camera.SetQuake(20)

        boss1.act_no = 100
        boss2.act_no = 100
        boss3.act_no = 100
        boss6.act_no = 100
        boss7.act_no = 100

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, boss4.x + ModCS.Game.Random(-32, 16), boss4.y, ModCS.Game.Random2(-1, 1), ModCS.Game.Random2(-0.5, 0.5), 0)
        end
    end

    if (boss.act_no >= 200 and boss.act_no < 300) then
        if (boss.act_wait == 80) then
            boss1.act_no = 120
        elseif (boss.act_wait == 110) then
            boss2.act_no = 120
        elseif (boss.act_wait == 140) then
            boss3.act_no = 120
        elseif (boss.act_wait == 170) then
            boss6.act_no = 120
        elseif (boss.act_wait == 200) then
            boss7.act_no = 120
        end

        if (boss.x < boss.tgt_x + (10 * 0x10)) then
            boss.xm = boss.xm + 0.0078125
        else
            boss.xm = boss.xm - 0.0078125
        end

        if (boss.y < boss.tgt_y) then
            boss.ym = boss.ym + 0.0078125
        else
            boss.ym = boss.ym - 0.0078125
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

    ActBossChar_Core_Face(boss, boss4)

    ActBossChar_Core_Tail(boss, boss5)

    ActBossChar_Core_Mini(boss, boss1)
    ActBossChar_Core_Mini(boss, boss2)
    ActBossChar_Core_Mini(boss, boss3)
    ActBossChar_Core_Mini(boss, boss6)
    ActBossChar_Core_Mini(boss, boss7)

    ActBossChar_Core_Hit(boss, boss8)
    ActBossChar_Core_Hit(boss, boss9)
    ActBossChar_Core_Hit(boss, boss10)
    ActBossChar_Core_Hit(boss, boss11)
end