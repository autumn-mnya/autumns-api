-- Falling spike that deals 127 damage
ModCS.Bullet.Act[24] = function(bul)
    local rc = ModCS.Rect.Create(0, 0, 0, 0)

    bul.act_wait = bul.act_wait + 1
    if (bul.act_wait > 2) then
        bul.cond = 0
    end

    bul:SetRect(rc)
end

-- Screen-nuke that kills all enemies
ModCS.Bullet.Act[44] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        return
    end

    bul.damage = 10000
    bul.enemyhit_x = 1600
    bul.enemyhit_y = 1600
end

-- Whimsical Star
ModCS.Bullet.Act[45] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
    end
end
