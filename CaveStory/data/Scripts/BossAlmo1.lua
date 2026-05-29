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
        boss.ani-no = 2
        boss.bits = 0
        boss:SetBit(3) -- Set ignore solid bit
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
    boss:SetViewbox(view)
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
        boss.bits = 0
        boss:SetBit(3) -- Set ignore tile collision bit
        view.front = 44
        view.top = 56
        -- Fallthrough
    end

    if (boss.act_no == 11) then
        boss.x = map_boss.x + 44
        boss.y = map_boss.y
    elseif (boss.act_no == 50) then
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

    if (boss.ani_no == 51) then
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

    local bShock = false
    local i = 0
    local deg = 0
    local xm = 0
    local ym = 0

    if (boss.act_no == 0) then

    elseif (boss.act_no == 200) then
        -- Fallthrough
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
        elseif (bos.act_wait == 200) then
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