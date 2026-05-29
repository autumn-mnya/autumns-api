-- Balfrog's mouth
local function ActBossChar02_01(main_boss, boss)
    local hit = boss:GetHitbox()

    local minus = 0

    if (main_boss.direct == 0) then
        minus = 1
    else
        minus = -1
    end

    if (main_boss.ani_no == 0) then
        boss.hit_voice = 52
        hit.front = 16
        hit.top = 16
        hit.back = 16
        hit.bottom = 16
        boss:SetHitbox(hit)
        boss.smoke_size = 3
        boss:SetBit(2) -- Set invulnerable bit
    elseif (main_boss.ani_no == 1) then
        boss.x = main_boss.x + -24 * minus
        boss.y = main_boss.y - 24
    elseif (main_boss.ani_no == 2) then
        boss.x = main_boss.x + -24 * minus
        boss.y = main_boss.y - 20
    elseif (main_boss.ani_no == 3 or main_boss.ani_no == 4) then
        boss.x = main_boss.x + -24 * minus
        boss.y = main_boss.y - 16
    elseif (main_boss.ani_no == 5) then
        boss.x = main_boss.x + -24 * minus
        boss.y = main_boss.y - 43
    end
end

local function ActBossChar02_02(main_boss, boss)
    local hit = boss:GetHitbox()
    if (main_boss.ani_no == 0) then
        boss.hit_voice = 52
        hit.front = 24
        hit.top = 16
        hit.back = 24
        hit.bottom = 16
        boss:SetHitbox(hit)
        boss.smoke_size = 3
        boss:SetBit(2) -- Set invulnerable bit
    elseif (main_boss.ani_no == 1 or main_boss.ani_no == 2 or main_boss.ani_no == 3 or main_boss.ani_no == 4 or main_boss.ani_no == 5) then
        boss.x = main_boss.x
        boss.y = main_boss.y
    end
end

-- Balfrog
ModCS.Boss.Act[2] = function(boss)
    local boss1 = ModCS.Boss.GetByBufferIndex(1, true)
    local boss2 = ModCS.Boss.GetByBufferIndex(2, true)
    
    local deg = 0
    local xm = 0
    local ym = 0
    local i = 0

    -- Rects 1-4 are for when Balfrog is a frog, 5-8 for when he reverts into Balrog and goes into the ceiling
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 0, 0),           -- Nothing
        ModCS.Rect.Create(0, 48, 80, 112),       -- Balfrog standing still
        ModCS.Rect.Create(0, 112, 80, 176),      -- Balfrog with his mouth barely open, crouching
        ModCS.Rect.Create(0, 176, 80, 240),      -- Balfrog with his mouth open, crouching
        ModCS.Rect.Create(160, 48, 240, 112),    -- Balfrog with his mouth open, crouching, flashing
        ModCS.Rect.Create(160, 112, 240, 200),   -- Balfrog jumping
        ModCS.Rect.Create(200, 0, 240, 24),      -- Balrog completely white
        ModCS.Rect.Create(80, 0, 120, 24),       -- Balrog crouching
        ModCS.Rect.Create(120, 0, 160, 24),      -- Balrog jumping
    }

    -- See above
    local rcRight = {
        ModCS.Rect.Create(0, 0, 0, 0),
        ModCS.Rect.Create(80, 48, 160, 112),
        ModCS.Rect.Create(80, 112, 160, 176),
        ModCS.Rect.Create(80, 176, 160, 240),
        ModCS.Rect.Create(240, 48, 320, 112),
        ModCS.Rect.Create(240, 112, 320, 200),
        ModCS.Rect.Create(200, 24, 240, 48),
        ModCS.Rect.Create(80, 24, 120, 48),
        ModCS.Rect.Create(120, 24, 160, 48),
    }

    local view = boss:GetViewbox()
    local hit = boss:GetHitbox()

    if (boss.act_no == 0) then -- Init
        boss.x = 6 * 0x10
        boss.y = (12 * 0x10) + 8
        boss.direct = 2

        view.front = 48
        view.top = 48
        view.back = 32
        view.bottom = 16
        boss:SetViewbox(view)

        boss.hit_voice = 52

        hit.front = 24
        hit.top = 16
        hit.back = 24
        hit.bottom = 16
        boss:SetHitbox(hit)

        boss.smoke_size = 3
        boss.exp = 1
        boss.event = 1000
        boss.bits = 0
        boss:SetBit(9) -- Set event with killed bit
        boss:SetBit(15) -- Set show damage # when hit bit
        boss.life = 300
    elseif (boss.act_no == 10) then -- Start
        boss.act_no = 1
        boss.ani_no = 3
        boss.cond = 0x80
        boss:SetRect(rcRight[1])

        boss1.cond = 0x80
        boss1.cond = ModCS.Game.SetBit(boss1.cond, 0x10)

        boss2.cond = 0x80

        boss1.damage = 5
        boss2.damage = 5

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-12, 12), boss.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end
    elseif (boss.act_no == 20) then -- Init Flicker
        boss.act_no = 21
        boss.act_wait = 0
        -- Fallthrough
    end
    
    if (boss.act_no == 21) then -- Flicker
        boss.act_wait = boss.act_wait + 1

        if (math.floor(boss.act_wait / 2) % 2 == 1) then
            boss.ani_no = 3
        else
            boss.ani_no = 0
        end
    elseif (boss.act_no == 100) then -- Wait
        boss.act_no = 101
        boss.act_wait = 0
        boss.ani_no = 1
        boss.xm = 0
        -- Fallthrough
    end
    
    if (boss.act_no == 101) then -- Init Hop 1
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.act_no = 102
            boss.ani_wait = 0
            boss.ani_no = 2
        end
    elseif (boss.act_no == 102) then -- Init Hop 2
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 10) then
            boss.act_no = 103
            boss.ani_wait = 0
            boss.ani_no = 1
        end
    elseif (boss.act_no == 103) then -- Hop
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 4) then
            boss.act_no = 104
            boss.ani_no = 5
            boss.ym = -2
            ModCS.Sound.Play(25)

            if (boss.direct == 0) then
                boss.xm = -1
            else
                boss.xm = 1
            end

            view.top = 64
            view.bottom = 24
            boss:SetViewbox(view)
        end
    elseif (boss.act_no == 104) then -- Midair
        if (boss.direct == 0 and boss:TouchLeftWall()) then
            boss.direct = 2
            boss.xm = 1
        end

        if (boss.direct == 2 and boss:TouchRightWall()) then
            boss.direct = 0
            boss.xm = -1
        end

        if (boss:TouchFloor()) then
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(30)
            boss.act_no = 100
            boss.ani_no = 1
            view.top = 48
            view.bottom = 16
            boss:SetViewbox(view)

            if (boss.direct == 0 and boss.x < boss.tgt_mc.x) then
                boss.direct = 2
                boss.act_no = 110
            end

            if (boss.direct == 2 and boss.x > boss.tgt_mc.x) then
                boss.direct = 0
                boss.act_no = 110
            end

            ModCS.Npc.Spawn2(110, ModCS.Game.Random(4, 16) * 0x10, ModCS.Game.Random(0, 4) * 0x10, 0, 0, 4, 0x80)

            for i = 0, 3 do
                ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-12, 12), boss.y + boss:GetHitbox().bottom, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end
        end
    elseif (boss.act_no == 110) then -- Init Land
        boss.ani_no = 1
        boss.act_wait = 0
        boss.act_no = 111
    elseif (boss.act_no == 111) then -- Land
        boss.act_wait = boss.act_wait + 1

        boss.xm = (boss.xm * 8) / 9

        if (boss.act_wait > 50) then
            boss.ani_no = 2
            boss.ani_wait = 0
            boss.act_no = 112
        end
    elseif (boss.act_no == 112) then -- Init shoot
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 4) then
            boss.act_no = 113
            boss.act_wait = 0
            boss.ani_no = 3
            boss.count1 = 16
            boss1:SetBit(5) -- Set shootable bit
            boss.tgt_x_cs = boss.life -- using "_cs" so its a proper number
        end
    elseif (boss.act_no == 113) then -- Shoot
        if (boss:IsHit()) then
            if (math.floor(boss.count2 / 2) % 2 == 1) then
                boss.ani_no = 4
            else
                boss.ani_no = 3
            end

            boss.count2 = boss.count2 + 1
        else
            boss.count2 = 0
            boss.ani_no = 3
        end

        boss.xm = (boss.xm * 10) / 11

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 16) then
            boss.act_wait = 0
            boss.count1 = boss.count1 - 1

            if (boss.direct == 0) then
                deg = ModCS.Triangle.GetArktan(boss.x - (2 * 0x10) - boss.tgt_mc.x, boss.y - 8 - boss.tgt_mc.y)
            else
                deg = ModCS.Triangle.GetArktan(boss.x + (2 * 0x10) - boss.tgt_mc.x, boss.y - 8 - boss.tgt_mc.y)
            end

            deg = deg + ModCS.Game.Random(-0x10, 0x10)

            ym = ModCS.Triangle.GetSin(deg)
            xm = ModCS.Triangle.GetCos(deg)

            if (boss.direct == 0) then
                ModCS.Npc.Spawn2(108, boss.x - (2 * 0x10), boss.y - 8, xm, ym, 0)
            else
                ModCS.Npc.Spawn2(108, boss.x + (2 * 0x10), boss.y - 8, xm, ym, 0)
            end

            ModCS.Sound.Play(39)

            if (boss.count1 == 0 or boss.life < boss.tgt_x_cs - 90) then -- using "_cs" so its a proper number
                boss.act_no = 114
                boss.act_wait = 0
                boss.ani_no = 2
                boss.ani_wait = 0
                boss1:UnsetBit(5) -- Unset shootable bit
            end
        end
    elseif (boss.act_no == 114) then -- Post-Shoot wait
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 10) then
            boss1.count1 = boss1.count1 + 1
            if (boss1.count1 > 2) then
                boss1.count1 = 0
                boss.act_no = 120
            else
                boss.act_no = 100
            end

            boss.ani_wait = 0
            boss.ani_no = 1
        end
    elseif (boss.act_no == 120) then -- Init Leap 1
        boss.act_no = 121
        boss.act_wait = 0
        boss.ani_no = 1
        boss.xm = 0
        -- Fallthrough
    end
    
    if (boss.act_no == 121) then -- Init Leap 2
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.act_no = 122
            boss.ani_wait = 0
            boss.ani_no = 2
        end
    elseif (boss.act_no == 122) then -- Init Leap 3
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 20) then
            boss.act_no = 123
            boss.ani_wait = 0
            boss.ani_no = 1
        end
    elseif (boss.act_no == 123) then -- Leap
        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 4) then
            boss.act_no = 124
            boss.ani_no = 5
            boss.ym = -5
            view.top = 64
            view.bottom = 24
            boss:SetViewbox(view)
            ModCS.Sound.Play(25)
        end
    elseif (boss.act_no == 124) then -- Leap Midair
        if (boss:TouchFloor()) then
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(60)
            boss.act_no = 100
            boss.ani_no = 1
            view.top = 48
            view.bottom = 16
            boss:SetViewbox(view)

            for i = 0, 1 do
                ModCS.Npc.Spawn2(104, ModCS.Game.Random(4, 16) * 0x10, ModCS.Game.Random(0, 4) * 0x10, 0, 0, 4, 0x80)
            end

            for i = 0, 5 do
                ModCS.Npc.Spawn2(110, ModCS.Game.Random(4, 16) * 0x10, ModCS.Game.Random(0, 4) * 0x10, 0, 0, 4, 0x80)
            end

            for i = 0, 7 do
                ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-12, 12), boss.y + boss:GetHitbox().bottom, ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
            end

            if (boss.direct == 0 and boss.x < boss.tgt_mc.x) then
                boss.direct = 2
                boss.act_no = 110
            end

            if (boss.direct == 2 and boss.x > boss.tgt_mc.x) then
                boss.direct = 0
                boss.act_no = 110
            end
        end
    elseif (boss.act_no == 130) then -- Die
        boss.act_no = 131
        boss.ani_no = 3
        boss.act_wait = 0
        boss.xm = 0
        ModCS.Sound.Play(72)

        for i = 0, 7 do
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-12, 12), boss.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        boss1.cond = 0
        boss2.cond = 0
        -- Fallthrough
    end
    
    if (boss.act_no == 131) then -- Die flashing
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 5 == 0) then
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-12, 12), boss.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        if (math.floor(boss.act_wait / 2) % 2 == 1) then
            boss.x = boss.x - 1
        else
            boss.x = boss.x + 1
        end

        if (boss.act_wait > 100) then
            boss.act_wait = 0
            boss.act_no = 132
        end
    elseif (boss.act_no == 132) then -- Revert
        boss.act_wait = boss.act_wait + 1

        if (math.floor(boss.act_wait / 2) % 2 == 1) then
            view.front = 20
            view.top = 12
            view.back = 20
            view.bottom = 12
            boss:SetViewbox(view)
            boss.ani_no = 6
        else
            view.front = 48
            view.top = 48
            view.back = 32
            view.bottom = 16
            boss:SetViewbox(view)
            boss.ani_no = 3
        end

        if (boss.act_wait % 9 == 0) then
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-12, 12), boss.y + ModCS.Game.Random(-12, 12), ModCS.Game.Random2(-0.666015625, 0.666015625), ModCS.Game.Random2(-3, 0), 0)
        end

        if (boss.act_wait > 150) then
            boss.act_no = 140
            hit.bottom = 12
            boss:SetHitbox(hit)
        end
    elseif (boss.act_no == 140) then -- Init Nop
        boss.act_no = 141
        -- Fallthrough
    end
    
    if (boss.act_no == 141) then -- Nop
        if (boss:TouchFloor()) then
            boss.act_no = 142
            boss.act_wait = 0
            boss.ani_no = 7
        end
    elseif (boss.act_no == 142) then -- Up into ceiling
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 30) then
            boss.ani_no = 8
            boss.ym = -5
            boss:SetBit(3) -- Set ignore tile collision bit
            boss.act_no = 143
        end
    elseif (boss.act_no == 143) then -- Gone in ceiling
        boss.ym = -5

        if (boss.y < 0) then
            boss.cond = 0
            ModCS.Sound.Play(26)
            ModCS.Camera.SetQuake(30)
        end
    end

    boss.ym = boss.ym + 0.125
    if (boss.ym > 2.998046875) then
        boss.ym = 2.998046875
    end

    boss:Move()

    if (boss.direct == 0) then
        boss:SetRect(rcLeft[boss.ani_no+1])
    else
        boss:SetRect(rcRight[boss.ani_no+1])
    end

    ActBossChar02_01(boss, boss1)
    ActBossChar02_02(boss, boss2)
end