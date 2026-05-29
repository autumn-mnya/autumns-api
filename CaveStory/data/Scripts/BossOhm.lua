local function ActBoss01_12(boss, boss1, boss2, boss3, boss4)
    local bosses = {
        [1] = boss1,
        [2] = boss2,
        [3] = boss3,
        [4] = boss4
    }

    local rcLeft = ModCS.Rect.Create(80, 56, 104, 72)
    local rcRight = ModCS.Rect.Create(104, 56, 128, 72)

    for i = 1, 2 do
        bosses[i].y = (boss.y + bosses[i + 2].y - 8) / 2

        if bosses[i].direct == 0 then
            bosses[i].x = boss.x - 16
            bosses[i]:SetRect(rcLeft)
        else
            bosses[i].x = boss.x + 16
            bosses[i]:SetRect(rcRight)
        end
    end
end

local function ActBoss01_34(boss, boss3, boss4)
    local bosses = {
        [3] = boss3,
        [4] = boss4
    }

    local rcLeft = {
        ModCS.Rect.Create(0, 56, 40, 88),
        ModCS.Rect.Create(40, 56, 80, 88),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 88, 40, 120),
        ModCS.Rect.Create(40, 88, 80, 120),
    }

    for i = 3, 4 do
        local b = bosses[i]

        if b.act_no == 0 then
            b.act_no = 1
            -- Fallthrough
        end

        if b.act_no == 1 then
            b.y = boss.y

            if i == 3 then
                b.x = boss.x - 16
            end

            if i == 4 then
                b.x = boss.x + 16
            end

        elseif b.act_no == 3 then
            b.tgt_y = boss.y + 24

            if i == 3 then
                b.x = boss.x - 16
            end

            if i == 4 then
                b.x = boss.x + 16
            end

            b.y = b.y + ((b.tgt_y - b.y) / 2)
        end

        if (b:TouchFloor()) or b.y <= b.tgt_y then
            b.ani_no = 0
        else
            b.ani_no = 1
        end

        if b.direct == 0 then
            b:SetRect(rcLeft[b.ani_no + 1])
        else
            b:SetRect(rcRight[b.ani_no + 1])
        end
    end
end

local function ActBoss01_5(boss, boss5)
    local hit = boss5:GetHitbox()

    if (boss5.act_no == 0) then
        boss5:SetBit(0) -- Set solid soft bit
        boss5:SetBit(3) -- Set ignore tile collision bit
        
        hit.front = 20
        hit.top = 36
        hit.back = 20
        hit.bottom = 16
        boss5:SetHitbox(hit)

        boss5.act_no = 1
        -- Fallthrough
    end

    if (boss5.act_no == 1) then
        boss5.x = boss.x
        boss5.y = boss.y
    end
end

-- Omega
ModCS.Boss.Act[1] = function(boss)
    local view = boss:GetViewbox()
    local hit = boss:GetHitbox()

    local boss1 = ModCS.Boss.GetByBufferIndex(1, true)
    local boss2 = ModCS.Boss.GetByBufferIndex(2, true)
    local boss3 = ModCS.Boss.GetByBufferIndex(3, true)
    local boss4 = ModCS.Boss.GetByBufferIndex(4, true)
    local boss5 = ModCS.Boss.GetByBufferIndex(5, true)

    local view1 = boss1:GetViewbox()

    local view3 = boss3:GetViewbox()
    local hit3 = boss3:GetHitbox()

    local hit5 = boss5:GetHitbox()

    if (boss.act_no == 0) then
        boss.x = 219 * 0x10
        boss.y = 16 * 0x10

        view.front = 40
        view.top = 40
        view.back = 40
        view.bottom = 16
        boss:SetViewbox(view)

        boss.tgt_x = boss.x
        boss.tgt_y = boss.y

        boss.hit_voice = 52

        hit.front = 8
        hit.top = 24
        hit.back = 8
        hit.bottom = 16
        boss:SetHitbox(hit)

        boss.bits = 0
        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(9) -- Set run event when killed bit
        boss:SetBit(15) -- Set show damage # on hit bit

        boss.smoke_size = 3
        boss.exp = 1
        boss.event = 210
        boss.life = 400

        boss1.cond = 0x80

        view1.front = 12
        view1.top = 8
        view1.back = 12
        view1.bottom = 8
        boss1:SetViewbox(view1)

        boss1.bits = 0
        boss1:SetBit(3) -- Set ignore tile collision bit

        boss2.cond = 0x80

        boss2:SetViewbox(view1)

        boss2.bits = 0
        boss2:SetBit(3)

        boss1.direct = 0
        boss2.direct = 2

        boss3.cond = 0x80

        view3.front = 24
        view3.top = 16
        view3.back = 16
        view3.bottom = 16
        boss3:SetViewbox(view3)

        boss3.hit_voice = 52

        hit3.front = 8
        hit3.top = 8
        hit3.back = 8
        hit3.bottom = 8
        boss3:SetHitbox(hit3)

        boss3.bits = 0
        boss3:SetBit(3) -- Set ignore tile collision bit

        boss3.x = boss.x - 16
        boss3.y = boss.y
        boss3.direct = 0

        boss4.cond = 0x80

        boss4:SetViewbox(view3)
        boss4:SetHitbox(hit3)

        boss4.hit_voice = 52

        boss4.bits = 0
        boss4:SetBit(3)

        boss4.x = boss.x + 16
        boss4.y = boss.y
        boss4.direct = 2
        boss5.cond = 0x80
    elseif (boss.act_no == 20) then -- Rising out of the ground
        boss.act_no = 30
        boss.act_wait = 0
        boss.ani_no = 0
        -- Fallthrough
    end

    if (boss.act_no == 30) then
        local done = false
        ModCS.Camera.SetQuake(2)
        boss.y = boss.y - 1

        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait % 4 == 0) then
            ModCS.Sound.Play(26)
        end

        if (boss.act_wait == 48) then
            boss.act_wait = 0
            boss.act_no = 40

            if (boss.life > 280) then
                done = true
            end

            if not done then
                boss.act_no = 110

                boss:SetBit(5) -- Set shootable bit
                boss:UnsetBit(3) -- Unset ignore tile collision bit
                boss3:UnsetBit(3) -- Unset ignore tile collision bit
                boss4:UnsetBit(3) -- Unset ignore tile collision bit

                boss3.act_no = 3
                boss4.act_no = 3
                hit5.top = 16
                boss5:SetHitbox(hit5)
            end
        end
    elseif (boss.act_no == 40) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 48) then
            boss.act_wait = 0
            boss.act_no = 50
            boss.count1 = 0
            hit5.top = 16
            boss5:SetHitbox(hit5)
            ModCS.Sound.Play(102)
        end
    elseif (boss.act_no == 50) then -- Open mouth
        boss.count1 = boss.count1 + 1

        if (boss.count1 > 2) then
            boss.count1 = 0
            boss.count2 = boss.count2 + 1
        end

        if (boss.count2 == 3) then
            boss.act_no = 60
            boss.act_wait = 0
            boss:SetBit(5) -- Set shootable bit
            hit.front = 16
            hit.back = 16
            boss:SetHitbox(hit)
        end
    elseif (boss.act_no == 60) then -- Shoot out of mouth
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 20 and boss.act_wait < 80 and boss.act_wait % 3 == 0) then
            if (ModCS.Game.Random(0, 9) < 8) then
                ModCS.Npc.Spawn2(48, boss.x, boss.y - 16, ModCS.Game.Random2(-0.5, 0.5), -1.6, 0)
            else
                ModCS.Npc.Spawn2(48, boss.x, boss.y - 16, ModCS.Game.Random2(-0.5, 0.5), -1.6, 2)
            end

            ModCS.Sound.Play(39)
        end

        if (boss.act_wait == 200 or ModCS.Arms.CountBullet(6) ~= 0) then
            boss.count1 = 0
            boss.act_no = 70
            ModCS.Sound.Play(102)
        end
    elseif (boss.act_no == 70) then -- Close mouth
        boss.count1 = boss.count1 + 1

        if (boss.count1 > 2) then
            boss.count1 = 0
            boss.count2 = boss.count2 - 1
        end

        if (boss.count2 == 1) then
            boss.damage = 20
        end

        if (boss.count2 == 0) then
            ModCS.Sound.Stop(102)
            ModCS.Sound.Play(12)

            boss.act_no = 80
            boss.act_wait = 0

            boss:UnsetBit(5) -- Unset shootable bit

            hit.front = 24
            hit.back = 24
            hit5.top = 36
            boss:SetHitbox(hit)
            boss5:SetHitbox(hit5)

            boss.damage = 0
        end
    elseif (boss.act_no == 80) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 48) then
            boss.act_wait = 0
            boss.act_no = 90
        end
    elseif (boss.act_no == 90) then -- Go back into the ground
        ModCS.Camera.SetQuake(2)
        boss.y = boss.y + 1

        boss.act_wait = boss.act_wait + 1
        
        if (boss.act_wait % 4 == 0) then
            ModCS.Sound.Play(26)
        end

        if (boss.act_wait == 48) then
            boss.act_wait = 0
            boss.act_no = 100
        end
    elseif (boss.act_no == 100) then -- Move to proper position for coming out of the ground
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 120) then
            boss.act_wait = 0
            boss.act_no = 30

            boss.x = boss.tgt_x + ModCS.Game.Random(-64, 64)
            boss.y = boss.tgt_y
        end
    elseif (boss.act_no == 110) then
        boss.count1 = boss.count1 + 1

        if (boss.count1 > 2) then
            boss.count1 = 0
            boss.count2 = boss.count2 + 1
        end

        if (boss.count2 == 3) then
            boss.act_no = 120
            boss.act_wait = 0
            hit.front = 16
            hit.back = 16
            boss:SetHitbox(hit)
        end
    elseif (boss.act_no == 120) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait == 50 or ModCS.Arms.CountBullet(6) ~= 0) then
            boss.act_no = 130
            ModCS.Sound.Play(102)
            boss.act_wait = 0
            boss.count1 = 0
        end

        if (boss.act_wait < 30 and boss.act_wait % 5 == 0) then
            ModCS.Npc.Spawn2(48, boss.x, boss.y - 16, ModCS.Game.Random2(-0.666015625, 0.666015625), -1.6, 0)
            ModCS.Sound.Play(39)
        end
    elseif (boss.act_no == 130) then
        boss.count1 = boss.count1 + 1

        if (boss.count1 > 2) then
            boss.count1 = 0
            boss.count2 = boss.count2 - 1
        end

        if (boss.count2 == 1) then
            boss.damage = 20
        end

        if (boss.count2 == 0) then
            boss.act_no = 140
            boss:SetBit(5) -- Set shootable bit

            hit.front = 16
            hit.back = 16
            boss:SetHitbox(hit)

            boss.ym = -2.998046875

            ModCS.Sound.Stop(102)
            ModCS.Sound.Play(12)
            ModCS.Sound.Play(25)

            if (boss.x < boss.tgt_mc.x) then
                boss.xm = 0.5
            end

            if (boss.x > boss.tgt_mc.x) then
                boss.xm = -0.5
            end

            boss.damage = 0
            hit5.top = 36
            boss5:SetHitbox(hit5)
        end
    elseif (boss.act_no == 140) then
        if (boss.tgt_mc:TouchFloor() and boss.ym > 0) then
            boss5.damage = 20
        else
            boss5.damage = 0
        end

        boss.ym = boss.ym + 0.0703125
        if (boss.ym > 2.998046875) then
            boss.ym = 2.998046875
        end

        boss:Move()

        if (boss:TouchFloor()) then
            boss.act_no = 110
            boss.act_wait = 0
            boss.count1 = 0

            hit5.top = 16
            boss5:SetHitbox(hit5)
            boss5.damage = 0

            ModCS.Sound.Play(26)
            ModCS.Sound.Play(12)

            ModCS.Camera.SetQuake(30)
        end
    elseif (boss.act_no == 150) then
        ModCS.Camera.SetQuake(2)

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait % 12 == 0) then
            ModCS.Sound.Play(52)
        end

        ModCS.Npc.Explode(boss.x + ModCS.Game.Random(-0x30, 0x30), boss.y + ModCS.Game.Random(-0x30, 0x18), 0.001953125, 1)

        if (boss.act_wait > 100) then
            boss.act_wait = 0
            boss.act_no = 160
            ModCS.Flash.Spawn(true, boss.x, boss.y)
            ModCS.Sound.Play(35)
        end
    elseif (boss.act_no == 160) then
        ModCS.Camera.SetQuake(40)

        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.cond = 0
            boss1.cond = 0
            boss2.cond = 0
            boss3.cond = 0
            boss4.cond = 0
            boss5.cond = 0
        end
    end

    local rect = {
        ModCS.Rect.Create(0, 0, 80, 56),
        ModCS.Rect.Create(80, 0, 160, 56),
        ModCS.Rect.Create(160, 0, 240, 56),
        ModCS.Rect.Create(80, 0, 160, 56),
    }

    boss:SetRect(rect[boss.count2+1])

    boss1.shock = boss.shock
    boss2.shock = boss.shock
    boss3.shock = boss.shock
    boss4.shock = boss.shock

    ActBoss01_34(boss, boss3, boss4)
    ActBoss01_12(boss, boss1, boss2, boss3, boss4)
    ActBoss01_5(boss, boss5)

    if (boss.life == 0 and boss.act_no < 150) then
        boss.act_no = 150
        boss.act_wait = 0
        boss.damage = 0
        boss5.damage = 0
        ModCS.Npc.KillEveryID(48, true)
    end
end