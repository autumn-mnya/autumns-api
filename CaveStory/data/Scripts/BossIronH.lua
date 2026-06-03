-- Ironhead
ironhead_flash = 0
ModCS.Boss.Act[5] = function(boss)
    local i = 0
    local hit = boss:GetHitbox()
    local view = boss:GetViewbox()
    if (boss.act_no == 0) then
        boss.cond = 0x80
        boss.exp = 1
        boss.direct = 2
        boss.act_no = 100
        boss.x = 160
        boss.y = 128

        view.front = 40
        view.top = 12
        view.back = 24
        view.bottom = 12
        boss:SetViewbox(view)

        boss.hit_voice = 54

        hit.front = 16
        hit.top = 10
        hit.back = 16
        hit.bottom = 10
        boss:SetHitbox(hit)

        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(5) -- Set shootable bit
        boss:SetBit(9) -- Set run event when killed bit
        boss:SetBit(15) -- Set show damage # bit

        boss.smoke_size = 3
        boss.damage = 10
        boss.event = 1000
        boss.life = 400
    elseif (boss.act_no == 100) then
        boss.act_no = 101
        boss:UnsetBit(5) -- Unset shootable bit
        boss.act_wait = 0
        -- Fallthrough
    end

    if (boss.act_no == 101) then
        boss.act_wait = boss.act_wait + 1

        if (boss.act_wait > 50) then
            boss.act_no = 250
            boss.act_wait = 0
        end

        if (boss.act_wait % 4 == 0) then
            ModCS.Npc.Spawn2(197, ModCS.Game.Random(15, 18) * 0x10, ModCS.Game.Random2(2, 13) * 0x10, 0, 0, 0)
        end
    elseif (boss.act_no == 250) then
        boss.act_no = 251

        if (boss.direct == 2) then
            boss.x = 240
            boss.y = boss.tgt_mc.y
        else
            boss.x = 720
            boss.y = ModCS.Game.Random(2, 13) * 0x10
        end

        boss.tgt_x = boss.x
        boss.tgt_y = boss.y
        
        boss.ym = ModCS.Game.Random2(-1, 1)
        boss.xm = ModCS.Game.Random2(-1, 1)

        boss:SetBit(5) -- Set shootable bit
        -- Fallthrough
    end

    if (boss.act_no == 251) then
        if (boss.direct == 2) then
            boss.tgt_x = boss.tgt_x + 2
        else
            boss.tgt_x = boss.tgt_x - 1

            if (boss.tgt_y < boss.tgt_mc.y) then
                boss.tgt_y = boss.tgt_y + 1
            else
                boss.tgt_y = boss.tgt_y - 1
            end
        end

        if (boss.x < boss.tgt_x) then
            boss.xm = boss.xm + 0.015625
        else
            boss.xm = boss.xm - 0.015625
        end

        if (boss.y < boss.tgt_y) then
            boss.ym = boss.ym + 0.015625
        else
            boss.ym = boss.ym - 0.015625
        end

        if (boss.ym > 1) then
            boss.ym = 1
        end

        if (boss.ym < -1) then
            boss.ym = -1
        end

        boss:Move()

        if (boss.direct == 2) then
            if (boss.x > 720) then
                boss.direct = 0
                boss.act_no = 100
            end
        else
            if (boss.x < 272) then
                boss.direct = 2
                boss.act_no = 100
            end
        end

        if (boss.direct == 0) then
            boss.act_wait = boss.act_wait + 1

            if (boss.act_wait == 300 or boss.act_wait == 310 or boss.act_wait == 320) then
                ModCS.Sound.Play(39)
                ModCS.Npc.Spawn2(198, boss.x + 10, boss.y + 1, ModCS.Game.Random2(-3, 0), ModCS.Game.Random2(-3, 3), 2)
            end
        end

        boss.ani_wait = boss.ani_wait + 1

        if (boss.ani_wait > 2) then
            boss.ani_wait = 0
            boss.ani_no = boss.ani_no + 1
        end

        if (boss.ani_no > 7) then
            boss.ani_no = 0
        end
    elseif (boss.act_no == 1000) then
        boss:UnsetBit(5) -- Unset shootable bit
        boss.ani_no = 8
        boss.damage = 0
        boss.act_no = 1001
        boss.tgt_x = boss.x
        boss.tgt_y = boss.y
        ModCS.Camera.SetQuake(20)

        for i = 0, 31 do
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-128, 128), boss.y + ModCS.Game.Random(-64, 64), ModCS.Game.Random2(-128, 128), ModCS.Game.Random2(-128, 128), 0)
        end

        ModCS.Npc.KillEveryID(197, true)
        ModCS.Npc.KillEveryID(271, true)
        ModCS.Npc.KillEveryID(272, true)
        -- Fallthrough
    end

    if (boss.act_no == 1001) then
        boss.tgt_x = boss.tgt_x - 1

        boss.x = boss.tgt_x + ModCS.Game.Random(-1, 1)
        boss.y = boss.tgt_y + ModCS.Game.Random(-1, 1)

        boss.act_wait = boss.act_wait + 1
        if (boss.act_wait % 4 == 0) then
            ModCS.Npc.Spawn2(4, boss.x + ModCS.Game.Random(-128, 128), boss.y + ModCS.Game.Random(-64, 64), ModCS.Game.Random2(-128, 128), ModCS.Game.Random2(-128, 128), 0)
        end
    end

    local rc = {
        ModCS.Rect.Create(0, 0, 64, 24),
        ModCS.Rect.Create(64, 0, 128, 24),
        ModCS.Rect.Create(128, 0, 192, 24),
        ModCS.Rect.Create(64, 0, 128, 24),
        ModCS.Rect.Create(0, 0, 64, 24),
        ModCS.Rect.Create(192, 0, 256, 24),
        ModCS.Rect.Create(256, 0, 320, 24),
        ModCS.Rect.Create(192, 0, 256, 24),
        ModCS.Rect.Create(256, 48, 320, 72),
    }

    local rcDamage = {
        ModCS.Rect.Create(0, 24, 64, 48),
        ModCS.Rect.Create(64, 24, 128, 48),
        ModCS.Rect.Create(128, 24, 192, 48),
        ModCS.Rect.Create(64, 24, 128, 48),
        ModCS.Rect.Create(0, 24, 64, 48),
        ModCS.Rect.Create(192, 24, 256, 48),
        ModCS.Rect.Create(256, 24, 320, 48),
        ModCS.Rect.Create(192, 24, 256, 48),
        ModCS.Rect.Create(256, 48, 320, 72),
    }

    if (boss:IsHit()) then
        ironhead_flash = ironhead_flash + 1
        if (math.floor(ironhead_flash / 2) % 2 == 1) then
            boss:SetRect(rc[boss.ani_no+1])
        else
            boss:SetRect(rcDamage[boss.ani_no+1])
        end
    else
        boss:SetRect(rc[boss.ani_no+1])
    end
end