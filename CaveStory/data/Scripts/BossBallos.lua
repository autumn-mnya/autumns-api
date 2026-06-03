local function ActBossChar_Eye(map_boss, boss)
    local rcLeft = {
        ModCS.Rect.Create(272, 0, 296, 16),
        ModCS.Rect.Create(272, 16, 296, 32),
        ModCS.Rect.Create(272, 32, 296, 48),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(240, 16, 264, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(296, 0, 320, 16),
        ModCS.Rect.Create(296, 16, 320, 32),
        ModCS.Rect.Create(296, 32, 320, 48),
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(240, 32, 264, 48),
    }

    if (boss.act_no == 100) then
        boss.act_no = 101
        boss.ani_no = 0
        boss.ani_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 101) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 2) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no + 1
        end

        if (boss.ani_no > 2) then
            boss.act_no = 102
        end
    elseif (boss.act_no == 102) then
        boss.ani_no = 3
    elseif (boss.act_no == 200) then
        boss.act_no = 201
        boss.ani_no = 3
        boss.ani_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 201) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 2) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no - 1
        end

        if (boss.ani_no <= 0) then
            boss.act_no = 202
        end
    elseif (boss.act_no == 300) then
        boss.act_no = 301
        boss.ani_no = 4

        if (boss.direct == 0) then
            ModCS.Npc.Explode(boss.x - 4, boss.y, 4, 10)
        else
            ModCS.Npc.Explode(boss.x + 4, boss.y, 4, 10)
        end
    end

    if (boss.direct == 0) then
        boss.x = map_boss.x - 24
    else
        boss.x = map_boss.x + 24
    end

    boss.y = map_boss.y - 36

    if (boss.act_no >= 0 and boss.act_no < 300) then
        if (boss.ani_no ~= 3) then
            boss:UnsetBit(5) -- Unset shootable bit
        else
            boss:SetBit(5) -- Set shootable bit
        end
    end

    if (boss.direct == 0) then
        boss:SetRect(rcLeft[boss.ani_no+1])
    else
        boss:SetRect(rcRight[boss.ani_no+1])
    end
end

local function ActBossChar_Body(map_boss, boss)
    local rc = {
        ModCS.Rect.Create(0, 0, 120, 120),
        ModCS.Rect.Create(120, 0, 240, 120),
        ModCS.Rect.Create(0, 120, 120, 240),
        ModCS.Rect.Create(120, 120, 240, 240),
    }

    boss.x = map_boss.x
    boss.y = map_boss.y

    boss:SetRect(rc[boss.ani_no+1])
end

local function ActBossChar_HITAI(map_boss, boss)
    boss.x = map_boss.x
    boss.y = map_boss.y - 44
end

local function ActBossChar_HARA(map_boss, boss)
    boss.x = map_boss.x
    boss.y = map_boss.y
end

-- Ballos
ballos_flash = 0
ModCS.Boss.Act[9] = function(boss)
    local boss1 = ModCS.Boss.GetByBufferIndex(1, true)
    local boss2 = ModCS.Boss.GetByBufferIndex(2, true)
    local boss3 = ModCS.Boss.GetByBufferIndex(3, true)
    local boss4 = ModCS.Boss.GetByBufferIndex(4, true)
    local boss5 = ModCS.Boss.GetByBufferIndex(5, true)

    local i = 0
    local x = 0
    local y = 0

    local hit = boss:GetHitbox()
    local hit1 = boss1:GetHitbox()
    local hit3 = boss3:GetHitbox()
    local hit4 = boss4:GetHitbox()
    local hit5 = boss5:GetHitbox()

    local view1 = boss1:GetViewbox()
    local view3 = boss3:GetViewbox()

    if (boss.act_no == 0) then
        -- Initialize main boss
        boss.act_no = 1
        boss.cond = 0x80
        boss.exp = 1
        boss.direct = 0
        boss.x = 320
        boss.y = -64
        boss.hit_voice = 54

        hit.front = 32
        hit.top = 48
        hit.back = 32
        hit.bottom = 48
        boss:SetHitbox(hit)

        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(6) -- Set solid bit
        boss:SetBit(9) -- Set run event when killed bit
        boss:SetBit(15) -- Set show damage number bit

        boss.smoke_size = 3
        boss.damage = 0
        boss.event = 1000
        boss.life = 800

        -- Initialize eyes
        boss1.cond = 0x90
        boss1.direct = 0
        boss1:SetBit(3) -- Set ignore tile collision bit
        boss1.life = 10000

        view1.front = 12
        view1.top = 0
        view1.back = 12
        view1.bottom = 16
        boss1:SetViewbox(view1)

        hit1.front = 12
        hit1.top = 0
        hit1.back = 12
        hit1.bottom = 16
        boss1:SetHitbox(hit1)

        ModCS.Boss.Copy(boss1, boss2)
        boss2.direct = 2

        -- Initialize the body
        boss3.cond = 0x90
        boss3:SetBit(0) -- Set solid soft bit
        boss3:SetBit(2) -- Set invulnerable bit
        boss3:SetBit(3) -- Set ignore tile collision bit

        view3.front = 60
        view3.top = 60
        view3.back = 60
        view3.bottom = 60
        boss3:SetViewbox(view3)

        hit3.front = 48
        hit3.top = 24
        hit3.back = 48
        hit3.bottom = 32
        boss3:SetHitbox(hit3)

        boss4.cond = 0x90
        boss4:SetBit(0) -- Set solid soft bit
        boss4:SetBit(2) -- Set invulnerable bit
        boss4:SetBit(3) -- Set ignore tile collision bit

        hit4.front = 32
        hit4.top = 8
        hit4.back = 32
        hit4.bottom = 8
        boss4:SetHitbox(hit4)

        boss5.cond = 0x90
        boss5:SetBit(2) -- Set invulnerable bit
        boss5:SetBit(3) -- Set ignore tile collision bit
        boss5:SetBit(6) -- Set solid bit

        hit5.front = 32
        hit5.top = 0
        hit5.back = 32
        hit5.bottom = 48
        boss5:SetHitbox(hit5)
    elseif (boss.act_no == 100) then
        boss.act_no = 101
        boss.ani_no = 0
        boss.x = boss.tgt_mc.x
        ModCS.Npc.Spawn2(333, boss.tgt_mc.x, 304, 0, 0, 2)
        boss.act_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 101) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 30) then
            boss.act_no = 102
        end
    elseif (boss.act_no == 102) then
        boss.ym = boss.ym + 0.125
        if (boss.ym > 6) then
            boss.ym = 6
        end

        boss:Move()

        if (boss.y > 304 - boss:GetHitbox().bottom) then
            boss.y = 304 - boss:GetHitbox().bottom
            boss.ym = 0
            boss.act_no = 103
            boss.act_wait = 0
            ModCS.Camera.SetAltQuake(30)
            ModCS.Sound.Play(44)

            -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or boss.tgt_mc
            -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
            -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
            -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
            for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
                local mychar = ModCS.Multiplayer.GetByID(i)
                if (mychar:IsPlaying()) then
                    if (mychar.y > boss.y + 48 and mychar.x < boss.x + 24 and mychar.x > boss.x - 24) then
                        mychar:DamageMyID(16)
                    end
                end
            end

            for i = 0, 15 do
                x = boss.x + ModCS.Game.Random(-40, 40)
                ModCS.Npc.Spawn2(4, x, boss.y + 40, 0, 0, 0)
            end

            -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or boss.tgt_mc
            -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
            -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
            -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
            for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
                local mychar = ModCS.Multiplayer.GetByID(i)
                if (mychar:IsPlaying()) then
                    if (mychar:TouchFloor()) then
                        mychar.ym = -1
                    end
                end
            end
        end
    elseif (boss.act_no == 103) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 50) then
            boss.act_no = 104
            boss1.act_no = 100
            boss2.act_no = 100
        end
    elseif (boss.act_no == 200) then
        boss.act_no = 201
        boss.count1 = 0
        -- Fallthrough
    end

    if (boss.act_no == 201) then
        boss.act_no = 203
        boss.xm = 0
        boss.count1 = boss.count1 + 1
        hit.bottom = 48
        boss:SetHitbox(hit)
        boss.damage = 0

        if (boss.count1 % 3 == 0) then
            boss.act_wait = 150
        else
            boss.act_wait = 50
        end
        -- Fallthrough
    end

    if (boss.act_no == 203) then
        boss.act_wait = boss.act_wait - 1

        if (boss.act_wait <= 0) then
            boss.act_no = 204
            boss.ym = -6

            if (boss.x < boss.tgt_mc.x) then
                boss.xm = 1
            else
                boss.xm = -1
            end
        end
    elseif (boss.act_no == 204) then
        if (boss.x < 80) then
            boss.xm = 1
        end

        if (boss.x > 544) then
            boss.xm = -1
        end

        boss.ym = boss.ym + 0.166015625
        if (boss.ym > 6) then
            boss.ym = 6
        end

        boss:Move()

        if (boss.y > 304 - boss:GetHitbox().bottom) then
            boss.y = 304 - boss:GetHitbox().bottom
            boss.ym = 0
            boss.act_no = 201
            boss.act_wait = 0

            -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or boss.tgt_mc
            -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
            -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
            -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
            for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
                local mychar = ModCS.Multiplayer.GetByID(i)
                if (mychar:IsPlaying()) then
                    if (mychar.y > boss.y + 48 and mychar.x < boss.x + 24 and mychar.x > boss.x - 24) then
                        mychar:DamageMyID(16)
                    end

                    if (mychar:TouchFloor()) then
                        mychar.ym = -1
                    end
                end
            end

            ModCS.Camera.SetAltQuake(30)
            ModCS.Sound.Play(26)
            ModCS.Npc.Spawn2(332, boss.x - 12, boss.y + 52, 0, 0, 0)
            ModCS.Npc.Spawn2(332, boss.x + 12, boss.y + 52, 0, 0, 2)
            ModCS.Sound.Play(44)

            for i = 0, 15 do
                x = boss.x + ModCS.Game.Random(-40, 40)
                ModCS.Npc.Spawn2(4, x, boss.y + 40, 0, 0, 0)
            end
        end
    elseif (boss.act_no == 220) then
        boss.act_no = 221
        boss.life = 1200
        boss1.act_no = 200
        boss2.act_no = 200
        boss.xm = 0
        boss.ani_no = 0
        boss.shock = 0
        ballos_flash = 0
        -- Fallthrough
    end

    if (boss.act_no == 221) then
        boss.ym = boss.ym + 0.125
        if (boss.ym > 6) then
            boss.ym = 6
        end

        boss:Move()

        if (boss.y > 304 - boss:GetHitbox().bottom) then
            boss.y = 304 - boss:GetHitbox().bottom
            boss.ym = 0
            boss.act_no = 222
            boss.act_wait = 0
            ModCS.Camera.SetAltQuake(30)
            ModCS.Sound.Play(26)

            for i = 0, 15 do
                x = boss.x + ModCS.Game.Random(-40, 40)
                ModCS.Npc.Spawn2(4, x, boss.y + 40, 0, 0, 0)
            end

            -- Technically, if you're a freeware user, you can ignore this check and just use ModCS.Player or boss.tgt_mc
            -- The only reason this is here, is to make CSE2LE immediately compatible with this lua recreation.
            -- MULTIPLAYER FROM CSE2LE WILL NOT COME TO FREEWARE !!! too much needs altered to do it safely.
            -- This is only to make the code work on both ends, this *DOES NOT* do *ANYTHING* related to multiplayer in freeware!!
            for i = 1, ModCS.Multiplayer.GetMaxPlayerCount() do
                local mychar = ModCS.Multiplayer.GetByID(i)
                if (mychar:IsPlaying()) then
                    if (mychar:TouchFloor()) then
                        mychar.ym = -1
                    end
                end
            end
        end
    elseif (boss.act_no == 300) then
        boss.act_no = 301
        boss.act_wait = 0

        for i = 0, 255, 0x40 do
            ModCS.Npc.Spawn3(342, boss.x, boss.y, 0, 0, i, boss, 90)
            ModCS.Npc.Spawn3(342, boss.x, boss.y, 0, 0, i + 0x220, boss, 90)
        end

        ModCS.Npc.Spawn3(343, boss.x, boss.y, 0, 0, 0, boss, 0x18)
        ModCS.Npc.Spawn3(344, boss.x - 24, boss.y - 36, 0, 0, 0, boss, 0x20)
        ModCS.Npc.Spawn3(344, boss.x + 24, boss.y - 36, 0, 0, 2, boss, 0x20)
        -- Fallthrough
    end

    if (boss.act_no == 301) then
        boss.y = boss.y + ((225 - boss.y) / 8)

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.act_no = 310
            boss.act_wait = 0
        end
    elseif (boss.act_no == 311) then
        boss.direct = 0
        boss.xm = -1.83203125
        boss.ym = 0
        boss:Move()

        if (boss.x < 111) then
            boss.x = 111
            boss.act_no = 312
        end
    elseif (boss.act_no == 312) then
        boss.direct = 1
        boss.ym = -1.83203125
        boss.xm = 0
        boss:Move()

        if (boss.y < 111) then
            boss.y = 111
            boss.act_no = 313
        end
    elseif (boss.act_no == 313) then
        boss.direct = 2
        boss.xm = 1.83203125
        boss.ym = 0
        boss:Move()

        if (boss.x > 513) then
            boss.x = 513
            boss.act_no = 314
        end

        if (boss.count1 ~= 0) then
            boss.count1 = boss.count1 - 1
        end

        if (boss.count1 == 0 and boss.x > 304 and boss.x < 336) then
            boss.act_no = 400
        end
    elseif (boss.act_no == 314) then
        boss.direct = 3
        boss.ym = 1.83203125
        boss.xm = 0
        boss:Move()

        if (boss.y > 225) then
            boss.y = 225
            boss.act_no = 311
        end
    elseif (boss.act_no == 400) then
        boss.act_no = 401
        boss.act_wait = 0
        boss.xm = 0
        boss.ym = 0
        ModCS.Npc.KillEveryID(339, false)
        -- Fallthrough
    end

    if (boss.act_no == 401) then
        boss.y = boss.y + ((159 - boss.y) / 8)

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.act_wait = 0
            boss.act_no = 410

            for i = 0, 255, 0x20 do
                ModCS.Npc.Spawn3(346, boss.x, boss.y, 0, 0, i, boss, 0x50)
            end

            ModCS.Npc.Spawn3(343, boss.x, boss.y, 0, 0, 0, boss, 0x18)
            ModCS.Npc.Spawn3(344, boss.x - 24, boss.y - 36, 0, 0, 0, boss, 0x20)
            ModCS.Npc.Spawn3(344, boss.x + 24, boss.y - 36, 0, 0, 2, boss, 0x20)
        end
    elseif (boss.act_no == 410) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.act_wait = 0
            boss.act_no = 411
        end
    elseif (boss.act_no == 411) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 30 == 1) then
            x = (((boss.act_wait / 30) * 2) + 2) * 0x10
            ModCS.Npc.Spawn2(348, x, 336, 0, 0, 0, 0x180)
        end

        if (math.floor(boss.act_wait / 3) % 2 == 1) then
            ModCS.Sound.Play(26)
        end

        if (boss.act_wait > 540) then
            boss.act_no = 420
        end
    elseif (boss.act_no == 420) then
        boss.act_no = 421
        boss.act_wait = 0
        boss.ani_wait = 0
        ModCS.Camera.SetAltQuake(30)
        ModCS.Sound.Play(35)
        boss1.act_no = 102
        boss2.act_no = 102

        for i = 0, 255 do
            x = boss.x + ModCS.Game.Random(-60, 60)
            y = boss.y + ModCS.Game.Random(-60, 60)
            ModCS.Npc.Spawn2(4, x, y, 0, 0, 0, 0)
        end
        -- Fallthrough
    end

    if (boss.act_no == 421) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 500) then
            boss.ani_wait = 0
            boss.act_no = 422
        end
    elseif (boss.act_no == 422) then
        boss.ani_wait = boss.ani_wait + 1
        
        if (boss.ani_wait > 200) then
            boss.ani_wait = 0
            boss.act_no = 423
        end
    elseif (boss.act_no == 423) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 20) then
            boss.ani_wait = 0
            boss.act_no = 424
        end
    elseif (boss.act_no == 424) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 200) then
            boss.ani_wait = 0
            boss.act_no = 425
        end
    elseif (boss.act_no == 425) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 500) then
            boss.ani_wait = 0
            boss.act_no = 426
        end
    elseif (boss.act_no == 426) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 200) then
            boss.ani_wait = 0
            boss.act_no = 427
        end
    elseif (boss.act_no == 427) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 20) then
            boss.ani_wait = 0
            boss.act_no = 428
        end
    elseif (boss.act_no == 428) then
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 200) then
            boss.ani_wait = 0
            boss.act_no = 421
        end
    elseif (boss.act_no == 1000) then
        boss.act_no = 1001
        boss.act_wait = 0

        boss1.act_no = 300
        boss2.act_no = 300

        boss:UnsetBit(0) -- Unset solid soft bit
        boss:UnsetBit(6) -- Unset solid bit
        boss3:UnsetBit(0) -- Unset solid soft bit
        boss3:UnsetBit(6) -- Unset solid bit
        boss4:UnsetBit(0) -- Unset solid soft bit
        boss4:UnsetBit(6) -- Unset solid bit
        boss5:UnsetBit(0) -- Unset solid soft bit
        boss5:UnsetBit(6) -- Unset solid bit
        -- Fallthrough
    end

    if (boss.act_no == 1001) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 12 == 0) then
            ModCS.Sound.Play(44)
        end

        ModCS.Npc.Explode(boss.x + ModCS.Game.Random(-60, 60), boss.y + ModCS.Game.Random(-60, 60), 0.001953125, 1)

        if (boss.act_wait > 150) then
            boss.act_wait = 0
            boss.act_no = 1002
            ModCS.Flash.Spawn(true, boss.x, boss.y)
            ModCS.Sound.Play(35)
        end
    elseif (boss.act_no == 1002) then
        ModCS.Camera.SetAltQuake(40)

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 50) then
            boss.cond = 0
            boss1.cond = 0
            boss2.cond = 0
            boss3.cond = 0
            boss4.cond = 0
            boss5.cond = 0

            ModCS.Npc.KillEveryID(350, true)
            ModCS.Npc.KillEveryID(348, true)
        end
    end

    if (boss.act_no > 420 and boss.act_no < 500) then
        boss3:SetBit(5) -- Set shootable bit
        boss4:SetBit(5) -- Set shootable bit
        boss5:SetBit(5) -- Set shootable bit

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 300) then
            boss.act_wait = 0

            if (boss.tgt_mc.x > boss.x) then
                for i = 0, 7 do
                    x = ((156 + ModCS.Game.Random(-4, 4)) * 0x10) / 4
                    y = (ModCS.Game.Random(8, 68) * 0x10) / 4
                    ModCS.Npc.Spawn2(350, x, y, 0, 0, 0)
                end
            else
                for i = 0, 7 do
                    x = (ModCS.Game.Random(-4, 4) * 0x10) / 4
                    y = (ModCS.Game.Random(8, 68) * 0x10) / 4
                    ModCS.Npc.Spawn2(350, x, y, 0, 0, 2)
                end
            end
        end

        if (boss.act_wait == 270 or boss.act_wait == 280 or boss.act_wait == 290) then
            ModCS.Npc.Spawn2(353, boss.x, boss.y - 52, 0, 0, 1)
            ModCS.Sound.Play(39)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, boss.x, boss.y - 52, 0, 0, 0)
            end
        end

        if (boss.life > 500) then
            if (ModCS.Game.Random(0, 10) == 2) then
                x = boss.x + ModCS.Game.Random(-40, 40)
                y = boss.y + ModCS.Game.Random(0, 40)
                ModCS.Npc.Spawn2(270, x, y, 0, 0, 3)
            end
        else
            if (ModCS.Game.Random(0, 4) == 2) then
                x = boss.x + ModCS.Game.Random(-40, 40)
                y = boss.y + ModCS.Game.Random(0, 40)
                ModCS.Npc.Spawn2(270, x, y, 0, 0, 3)
            end
        end
    end

    if (boss:IsHit()) then
        ballos_flash = (ballos_flash + 1) % 256
        if (math.floor(ballos_flash / 2) % 2 == 1) then
            boss3.ani_no = 1
        else
            boss3.ani_no = 0
        end
    else
        boss3.ani_no = 0
    end

    if (boss.act_no > 420) then
        boss3.ani_no = boss3.ani_no + 2
    end

    ActBossChar_Eye(boss, boss1)
    ActBossChar_Eye(boss, boss2)
    ActBossChar_Body(boss, boss3)
    ActBossChar_HITAI(boss, boss4)
    ActBossChar_HARA(boss, boss5)
end