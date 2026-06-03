-- Heavy Press
heavypress_flash = 0
ModCS.Boss.Act[8] = function(boss)
    local i = 0
    local x = 0

    local boss1 = ModCS.Boss.GetByBufferIndex(1, true)
    local boss2 = ModCS.Boss.GetByBufferIndex(2, true)
    local boss3 = ModCS.Boss.GetByBufferIndex(3, true)

    local view = boss:GetViewbox()
    local hit = boss:GetHitbox()
    local hit1 = boss1:GetHitbox()
    local hit3 = boss1:GetHitbox()

    if (boss.act_no == 0) then
        boss.act_no = 10
        boss.cond = 0x80
        boss.exp = 1
        boss.direct = 2
        boss.x = 0
        boss.y = 0

        view.front = 40
        view.top = 60
        view.back = 40
        view.bottom = 60
        boss:SetViewbox(view)

        boss.hit_voice = 54
        
        hit.front = 49
        hit.top = 60
        hit.back = 40
        hit.bottom = 48
        boss:SetHitbox(hit)

        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(6) -- Set solid bit
        boss:SetBit(9) -- Set run event when killed bit
        boss:SetBit(15) -- Set show damage # bit

        boss.smoke_size = 3
        boss.damage = 10
        boss.event = 1000
        boss.life = 700
    elseif (boss.act_no == 5) then
        boss.act_no = 6
        boss.x = 0
        boss.y = 0
        boss1.cond = 0
        boss2.cond = 0
    elseif (boss.act_no == 10) then
        boss.act_no = 11
        boss.x = 160
        boss.y = 74
    elseif (boss.act_no == 20) then
        boss.damage = 0
        boss.act_no = 21
        boss.x = 160
        boss.y = 413
        boss:UnsetBit(6) -- Unset solid bit
        boss1.cond = 0
        boss2.cond = 0
        -- Fallthrough
    end

    if (boss.act_no == 21) then
        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait % 16 == 0) then
            ModCS.Npc.Explode(boss.x + ModCS.Game.Random(-40, 40), boss.y + ModCS.Game.Random(-60, 60), 0.001953125, 1)
        end
    elseif (boss.act_no == 30) then
        boss.act_no = 31
        boss.ani_no = 2
        boss.x = 160
        boss.y = 64
        -- Fallthrough
    end

    if (boss.act_no == 31) then
        boss.y = boss.y + 4

        if (boss.y >= 413) then
            boss.y = 413
            boss.ani_no = 0
            boss.act_no = 20
            ModCS.Sound.Play(44)

            for i = 0, 4 do
                x = boss.x + ModCS.Game.Random(-40, 40)
                ModCS.Npc.Spawn2(4, x, boss.y + 60, 0, 0, 0)
            end
        end
    elseif (boss.act_no == 100) then
        boss.act_no = 101
        boss.count2 = 9
        boss.act_wait = -100

        boss1.cond = 0x80

        hit1.front = 14
        hit1.back = 14
        hit1.top = 8
        hit1.bottom = 8
        boss1:SetHitbox(hit1)

        boss1:SetBit(2) -- Set invulnerable bit
        boss1:SetBit(3) -- Set ignore tile collision bit

        ModCS.Boss.Copy(boss1, boss2)

        boss3.cond = 0x90
        boss3:SetBit(5) -- Set shootable bit
        
        hit3.front = 6
        hit3.back = 6
        hit3.top = 8
        hit3.bottom = 8
        boss3:SetHitbox(hit3)

        ModCS.Npc.Spawn2(325, boss.x, boss.y + 60, 0, 0, 0)
        -- Fallthrough
    end

    if (boss.act_no == 101) then
        if (boss.count2 > 1 and boss.life < boss.count2 * 70) then
            boss.count2 = boss.count2 - 1

            for i = 0, 4 do
                ModCS.Map.ChangeTile(0, i + 8, boss.count2)
                ModCS.Npc.Explode((i + 8) * 0x10, boss.count2 * 0x10, 0, 4)
                ModCS.Sound.Play(12)
            end
        end

        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait == 81 or boss.act_wait == 241) then
            ModCS.Npc.Spawn2(323, 48, 240, 0, 0, 1)
        end

        if (boss.act_wait == 1 or boss.act_wait == 161) then
            ModCS.Npc.Spawn2(323, 272, 240, 0, 0, 1)
        end

        if (boss.act_wait >= 300) then
            boss.act_wait = 0
            ModCS.Npc.Spawn2(325, boss.x, boss.y + 60, 0, 0, 0)
        end
    elseif (boss.act_no == 500) then
        boss:UnsetBit(5) -- Unset shootable bit

        boss.act_no = 501
        boss.act_wait = 0
        boss.count1 = 0

        ModCS.Npc.KillEveryID(325, true)
        ModCS.Npc.KillEveryID(330, true)
        -- Fallthrough
    end

    if (boss.act_no == 501) then
        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait % 16 == 0) then
            ModCS.Sound.Play(12)
            ModCS.Npc.Explode(boss.x + ModCS.Game.Random(-40, 40), boss.y + ModCS.Game.Random(-60, 60), 0.001953125, 1)
        end

        if (boss.act_wait == 95) then
            boss.ani_no = 1
        end

        if (boss.act_wait == 98) then
            boss.ani_no = 2
        end

        if (boss.act_wait > 100) then
            boss.act_no = 510
        end
    elseif (boss.act_no == 510) then
        boss.ym = boss.ym + 0.125
        boss.damage = 0x7F
        boss:Move()

        if (boss.count1 == 0 and boss.y > 160) then
            boss.count1 = 1
            boss.ym = -1
            boss.damage = 0

            for i = 0, 6 do
                ModCS.Map.ChangeTile(0, i + 7, 14)
                ModCS.Npc.Explode((i + 7) * 0x10, 224, 0, 0)
                ModCS.Sound.Play(12)
            end
        end

        if (boss.y > 480) then
            boss.act_no = 520
        end
    end

    boss1.x = boss.x - 24
    boss1.y = boss.y + 52

    boss2.x = boss.x + 24
    boss2.y = boss.y + 52

    boss3.x = boss.x
    boss3.y = boss.y + 40

    local rc = {
        ModCS.Rect.Create(0, 0, 80, 120),
        ModCS.Rect.Create(80, 0, 160, 120),
        ModCS.Rect.Create(160, 0, 240, 120),
    }

    local rcDamage = {
        ModCS.Rect.Create(0, 120, 80, 240),
        ModCS.Rect.Create(80, 120, 160, 240),
        ModCS.Rect.Create(160, 120, 240, 240),
    }

    if (boss:IsHit()) then
        heavypress_flash = heavypress_flash + 1
        if (math.floor(heavypress_flash / 2) % 2 == 1) then
            boss:SetRect(rc[boss.ani_no+1])
        else
            boss:SetRect(rcDamage[boss.ani_no+1])
        end
    else
        boss:SetRect(rc[boss.ani_no+1])
    end
end