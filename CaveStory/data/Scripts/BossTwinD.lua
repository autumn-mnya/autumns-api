local function ActBossCharT_DragonBody(boss)
    local deg = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 0, 40, 40),
        ModCS.Rect.Create(40, 0, 80, 40),
        ModCS.Rect.Create(80, 0, 120, 40),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 40, 40, 80),
        ModCS.Rect.Create(40, 40, 80, 80),
        ModCS.Rect.Create(80, 40, 120, 80),
    }

    if (boss.pNpc == nil) then
        return
    end

    if (boss.act_no == 0) then
        deg = ((boss.pNpc.count1 / 4) + boss.count1) % 0x100
        boss.act_no = 10
        boss.x = boss.x + (boss.pNpc.x + (ModCS.Triangle.GetCos(deg) * boss.pNpc.tgt_x_cs))
        boss.y = boss.y + (boss.pNpc.y + (ModCS.Triangle.GetSin(deg) * boss.pNpc.tgt_y_cs))
        -- Fallthrough
    end

    if (boss.act_no == 10) then
        if (boss.x > boss.tgt_mc.x) then
            boss.direct = 0
        else
            boss.direct = 2
        end
    elseif (boss.act_no == 100) then
        deg = ((boss.pNpc.count1 / 4) + boss.count1) % 0x100
        boss.tgt_x = boss.pNpc.x + (ModCS.Triangle.GetCos(deg) * boss.pNpc.tgt_x_cs)
        boss.tgt_y = boss.pNpc.y + (ModCS.Triangle.GetSin(deg) * boss.pNpc.tgt_y_cs)

        boss.x = boss.x + (boss.tgt_x - boss.x) / 8
        boss.y = boss.y + (boss.tgt_y - boss.y) / 8

        if (boss.x > boss.tgt_mc.x) then
            boss.direct = 0
        else
            boss.direct = 2
        end
    elseif (boss.act_no == 1000) then
        boss.act_no = 1001
        boss:UnsetBit(5) -- Unset shootable bit
        -- Fallthrough
    end

    if (boss.act_no == 1001) then
        deg = ((boss.pNpc.count1 / 4) + boss.count1) % 0x100
        boss.tgt_x = boss.pNpc.x + (ModCS.Triangle.GetCos(deg) * boss.pNpc.tgt_x_cs)
        boss.tgt_y = boss.pNpc.y + (ModCS.Triangle.GetSin(deg) * boss.pNpc.tgt_y_cs)

        boss.x = boss.x + (boss.tgt_x - boss.x) / 8
        boss.y = boss.y + (boss.tgt_y - boss.y) / 8

        if (boss.x > boss.pNpc.x) then
            boss.direct = 0
        else
            boss.direct = 2
        end
    end

    boss.ani_wait = boss.ani_wait + 1
    if (boss.ani_wait > 2) then
        boss.ani_wait = 0
        boss.ani_no = boss.ani_no + 1
    end

    if (boss.ani_no > 2) then
        boss.ani_no = 0
    end

    if (boss.direct == 0) then
        boss:SetRect(rcLeft[boss.ani_no+1])
    else
        boss:SetRect(rcRight[boss.ani_no+1])
    end
end

local function ActBossCharT_DragonHead(boss)
    local deg = 0
    local xm = 0
    local ym = 0

    local rcLeft = {
        ModCS.Rect.Create(0, 80, 40, 112),
        ModCS.Rect.Create(40, 80, 80, 112),
        ModCS.Rect.Create(80, 80, 120, 112),
        ModCS.Rect.Create(120, 80, 160, 112),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 112, 40, 144),
        ModCS.Rect.Create(40, 112, 80, 144),
        ModCS.Rect.Create(80, 112, 120, 144),
        ModCS.Rect.Create(120, 112, 160, 144),
    }

    local hit = boss:GetHitbox()

    if (boss.pNpc == nil) then
        return
    end

    if (boss.act_no == 0) then
        boss.act_no = 1
    elseif (boss.act_no == 100) then
        boss.act_no = 200
        -- Fallthrough
    end

    if (boss.act_no == 200) then
        boss:UnsetBit(5) -- Unset shootable bit
        boss.ani_no = 0
        hit.front = 16
        boss.act_no = 201
        boss.count1 = ModCS.Game.Random(100, 200)
        -- Fallthrough
    end

    if (boss.act_no == 201) then
        if (boss.count1 ~= 0) then
            boss.count1 = boss.count1 - 1
        else
            boss.act_no = 210
            boss.act_wait = 0
            boss.count2 = 0
        end
    elseif (boss.act_no == 210) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 3) then
            boss.ani_no = 1
        end

        if (boss.act_wait == 6) then
            boss.ani_no = 2
            hit.front = 8
            boss:SetBit(5) -- Set shootable bit
            boss.count2 = 0
        end

        if (boss.act_wait > 150) then
            boss.act_no = 220
            boss.act_wait = 0
        end

        if (boss:IsHit()) then
            boss.count2 = boss.count2 + 1
        end

        if (boss.count2 > 10) then
            ModCS.Sound.Play(51)
            ModCS.Npc.Explode(boss.x, boss.y, boss:GetViewbox().back, 4)
            boss.act_no = 300
            boss.act_Wait = 0
            boss.ani_no = 3
            hit.front = 16
        end
    elseif (boss.act_no == 220) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 8 == 1) then
            deg = ModCS.Triangle.GetArktan(boss.x - boss.tgt_mc.x, boss.y - boss.tgt_mc.y)
            deg = deg + ModCS.Game.Random(-6, 6)
            ym = ModCS.Triangle.GetSin(deg)
            xm = ModCS.Triangle.GetCos(deg)

            if (boss.direct == 0) then
                ModCS.Npc.Spawn2(202, boss.x - 8, boss.y, xm, ym, 0)
            else
                ModCS.Npc.Spawn2(202, boss.x + 8, boss.y, xm, ym, 0)
            end

            ModCS.Sound.Play(33)
        end

        if (boss.act_wait > 50) then
            boss.act_no = 200
        end
    elseif (boss.act_no == 300) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 100) then
            boss.act_no = 200
        end
    elseif (boss.act_no == 400) then
        boss.act_no = 401
        boss.act_wait = 0
        boss.ani_no = 0
        hit.front = 16
        boss:UnsetBit(5) -- Unset shootable bit
        -- Fallthrough
    end

    if (boss.act_no == 401) then
        boss.act_wait = boss.act_wait + 1
        
        if (boss.act_wait == 3) then
            boss.ani_no = 1
        end

        if (boss.act_wait == 6) then
            boss.ani_no = 2
            hit.front = 8
            boss:SetBit(5) -- Set shootable bit
            boss.count2 = 0
        end

        if (boss.act_wait > 20 and boss.act_wait % 32 == 1) then
            deg = ModCS.Triangle.GetArktan(boss.x - boss.tgt_mc.x, boss.y - boss.tgt_mc.y)
            deg = deg + ModCS.Game.Random(-6, 6)
            ym = ModCS.Triangle.GetSin(deg)
            xm = ModCS.Triangle.GetCos(deg)

            if (boss.direct == 0) then
                ModCS.Npc.Spawn2(202, boss.x - 8, boss.y, xm, ym, 0)
            else
                ModCS.Npc.Spawn2(202, boss.x + 8, boss.y, xm, ym, 0)
            end

            ModCS.Sound.Play(33)
        end
    elseif (boss.act_no == 1000) then
        boss:UnsetBit(5) -- Unset shootable bit
        boss.ani_no = 3
    end

    boss.direct = boss.pNpc.direct

    if (boss.direct == 0) then
        boss.x = boss.pNpc.x - 4
    else
        boss.x = boss.pNpc.x + 4
    end

    boss.y = boss.pNpc.y - 8

    if (boss.direct == 0) then
        boss:SetRect(rcLeft[boss.ani_no+1])
    else
        boss:SetRect(rcRight[boss.ani_no+1])
    end

    boss:SetHitbox(hit)
end

-- Twin Dragons
ModCS.Boss.Act[6] = function(boss)
    local boss1 = ModCS.Boss.GetByBufferIndex(1, true)
    local boss2 = ModCS.Boss.GetByBufferIndex(2, true)
    local boss3 = ModCS.Boss.GetByBufferIndex(3, true)
    local boss4 = ModCS.Boss.GetByBufferIndex(4, true)
    local boss5 = ModCS.Boss.GetByBufferIndex(5, true)

    local view = boss:GetViewbox()
    local view2 = boss2:GetViewbox()
    local view3 = boss3:GetViewbox()

    local hit = boss:GetHitbox()
    local hit2 = boss2:GetHitbox()
    local hit3 = boss3:GetHitbox()

    if (boss.act_no == 0) then
        boss.cond = 0x80
        boss.direct = 0
        boss.act_no = 10
        boss.exp = 0
        boss.x = 160
        boss.y = 128

        view.front = 8
        view.top = 8
        view.back = 128
        view.bottom = 8
        boss:SetViewbox(view)

        boss.hit_voice = 54

        hit.front = 8
        hit.top = 8
        hit.back = 8
        hit.bottom = 8
        boss:SetHitbox(hit)

        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(9) -- Set run event when killed bit

        boss.smoke_size = 3
        boss.damage = 0
        boss.event = 1000
        boss.life = 500
        boss.count2 = ModCS.Game.Random(700, 1200)
        boss.tgt_x_cs = 180
        boss.tgt_y_cs = 61

        boss2.cond = 0x80

        view2.back = 20
        view2.front = 20
        view2.top = 16
        view2.bottom = 16
        boss2:SetViewbox(view2)

        hit2.back = 12
        hit2.front = 12
        hit2.top = 10
        hit2.bottom = 10
        boss2:SetHitbox(hit2)
        
        boss2:SetBit(2) -- Set invulnerable bit
        boss2:SetBit(3) -- Set ignore tile collision bit
        boss2.pNpc = boss3
        boss2.cond = ModCS.Game.SetBit(boss2.cond, 0x10) -- Set "all damage is directed towards main map boss" condition
        boss2.damage = 10

        boss3.cond = 0x80
        
        view3.back = 20
        view3.front = 20
        view3.top = 20
        view3.bottom = 20
        boss3:SetViewbox(view3)

        hit3.back = 12
        hit3.front = 12
        hit3.top = 2
        hit3.bottom = 16
        boss3:SetHitbox(hit3)
        
        boss3:SetBit(3) -- Set ignore tile collision bit
        boss3.pNpc = boss
        boss3.damage = 10

        ModCS.Boss.Copy(boss2, boss4)
        boss4.pNpc = boss5

        ModCS.Boss.Copy(boss3, boss5)
        boss5.count1 = 128
    elseif (boss.act_no == 20) then
        boss.tgt_x_cs = boss.tgt_x_cs - 1
        if (boss.tgt_x_cs <= 0x70) then
            boss.act_no = 100
            boss.act_wait = 0
            boss2.act_no = 100
            boss4.act_no = 100
            boss3.act_no = 100
            boss5.act_no = 100
        end
    elseif (boss.act_no == 100) then
        local done = false

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait < 100) then
            boss.count1 = boss.count1 + 1
        elseif (boss.act_wait < 120) then
            boss.count1 = boss.count1 + 2
        elseif (boss.act_wait < boss.count2) then
            boss.count1 = boss.count1 + 4
        elseif (boss.act_wait < boss.count2 + 40) then
            boss.count1 = boss.count1 + 2
        elseif (boss.act_wait < boss.count2 + 60) then
            boss.count1 = boss.count1 + 1
        else
            boss.act_wait = 0
            boss.act_no = 110
            boss.count2 = ModCS.Game.Random(400, 700)
            done = true
        end

        if not done then
            if (boss.count1 > 0x3FF) then
                boss.count1 = boss.count1 - 0x400
            end
        end
    elseif (boss.act_no == 110) then
        local done = false

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait < 20) then
            boss.count1 = boss.count1 - 1
        elseif (boss.act_wait < 60) then
            boss.count1 = boss.count1 - 2
        elseif (boss.act_wait < boss.count2) then
            boss.count1 = boss.count1 - 4
        elseif (boss.act_wait < boss.count2 + 40) then
            boss.count1 = boss.count1 - 2
        elseif (boss.act_wait < boss.count2 + 60) then
            boss.count1 = boss.count1 - 1
        else
            if (boss.life < 300) then
                boss.act_wait = 0
                boss.act_no = 400
                boss2.act_no = 400
                boss4.act_no = 400
            else
                boss.act_wait = 0
                boss.act_no = 100
                boss.count2 = ModCS.Game.Random(400, 700)
            end

            done = true
        end

        if not done then
            if (boss.count1 <= 0) then
                boss.count1 = boss.count1 + 0x400
            end
        end
    elseif (boss.act_no == 400) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 100) then
            boss.act_wait = 0
            boss.act_no = 401
        end
    elseif (boss.act_no == 401) then
        local done = false

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait < 100) then
            boss.count1 = boss.count1 + 1
        elseif (boss.act_wait < 120) then
            boss.count1 = boss.count1 + 2
        elseif (boss.act_wait < 500) then
            boss.count1 = boss.count1 + 4
        elseif (boss.act_wait < 540) then
            boss.count1 = boss.count1 + 2
        elseif (boss.act_wait < 560) then
            boss.count1 = boss.count1 + 1
        else
            boss.act_no = 100
            boss.act_wait = 0
            boss2.act_no = 100
            boss4.act_no = 100
            done = true
        end

        if not done then
            if (boss.count1 > 0x3FF) then
                boss.count1 = boss.count1 - 0x400
            end
        end
    elseif (boss.act_no == 1000) then
        boss.act_no = 1001
        boss.act_wait = 0
        boss2.act_no = 1000
        boss3.act_no = 1000
        boss4.act_no = 1000
        boss5.act_no = 1000
        ModCS.Npc.Explode(boss.x, boss.y, boss:GetViewbox().back, 40)
        -- Fallthrough
    end

    if (boss.act_no == 1001) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 100) then
            boss.act_no = 1010
        end

        ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-128, 128), boss.y + ModCS.Game.Random(-70, 70), 0, 0, 0)
    elseif (boss.act_no == 1010) then
        boss.count1 = boss.count1 + 4

        if (boss.count1 > 0x3FF) then
            boss.count1 = boss.count1 - 0x400
        end

        if (boss.tgt_x_cs > 8) then
            boss.tgt_x_cs = boss.tgt_x_cs - 1
        end

        if (boss.tgt_y_cs > 0) then
            boss.tgt_y_cs = boss.tgt_y_cs - 1
        end

        if (boss.tgt_x_cs < -8) then
            boss.tgt_x_cs = boss.tgt_x_cs + 1
        end

        if (boss.tgt_y_cs < 0) then
            boss.tgt_y_cs = boss.tgt_y_cs + 1
        end

        if (boss.tgt_y_cs == 0) then
            boss.act_no = 1020
            boss.act_wait = 0
            ModCS.Flash.Spawn(true, boss.x, boss.y)
            ModCS.Sound.Play(35)
        end
    elseif (boss.act_no == 1020) then
        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait > 50) then
            ModCS.Npc.KillEveryID(211, true)
            boss.cond = 0
            boss1.cond = 0
            boss2.cond = 0
            boss3.cond = 0
            boss4.cond = 0
            boss5.cond = 0
            boss.act_no = 0
        end
    end

    ActBossCharT_DragonHead(boss2)
    ActBossCharT_DragonBody(boss3)
    ActBossCharT_DragonHead(boss4)
    ActBossCharT_DragonBody(boss5)

    local rc = ModCS.Rect.Create(0, 0, 0, 0)
    boss:SetRect(rc)
end