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

        boss.bits = 0
        boss:SetBit(3) -- Set ignore tile collision bit
        boss:SetBit(5) -- Set shootable bit
        boss:SetBit(9) -- Set run event when killed bit
        boss:SetBit(15) -- Set show damage # bit

        boss.smoke_size = 3
        boss.damage = 10
        boss.event = 1000
        boss.life = 400
    elseif (boss.act_no = 100) then
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
    end
end