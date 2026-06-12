-- Blade slashes
ModCS.Bullet.Act[23] = function(bul)
    if (bul.act_no == 0) then
        bul.act_no = 1
        bul.y = bul.y - 12

        if (bul.direct == 0) then
            bul.x = bul.x + 16
        else
            bul.x = bul.x - 16
        end
        -- Fallthrough
    end

    if (bul.act_no == 1) then
        bul.ani_wait = bul.ani_wait + 1
        if (bul.ani_wait > 2) then
            bul.ani_wait = 0
            bul.ani_no = bul.ani_no + 1
        end

        if (bul.direct == 0) then
            bul.x = bul.x - 2
        else
            bul.x = bul.x + 2
        end

        bul.y = bul.y + 2

        if (bul.ani_no == 1) then
            bul.damage = 2
        else
            bul.damage = 1
        end

        if (bul.ani_no > 4) then
            bul.cond = 0
            return
        end
    end

    local rcLeft = {
        ModCS.Rect.Create(0, 64, 24, 88),
        ModCS.Rect.Create(24, 64, 48, 88),
        ModCS.Rect.Create(48, 64, 72, 88),
        ModCS.Rect.Create(72, 64, 96, 88),
        ModCS.Rect.Create(96, 64, 120, 88),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 88, 24, 112),
        ModCS.Rect.Create(24, 88, 48, 112),
        ModCS.Rect.Create(48, 88, 72, 112),
        ModCS.Rect.Create(72, 88, 96, 112),
        ModCS.Rect.Create(96, 88, 120, 112),
    }

    if (bul.direct == 0) then
        bul:SetRect(rcLeft[bul.ani_no+1])
    else
        bul:SetRect(rcRight[bul.ani_no+1])
    end
end

-- Blade Level 1
ModCS.Bullet.Act[25] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.count1 == 3) then
        bul.bits = ModCS.Game.UnsetBit(bul.bits, 4)
    end

    if (bul.count1 % 5 == 1) then
        ModCS.Sound.Play(34)
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -4
        elseif (bul.direct == 1) then
            bul.ym = -4
        elseif (bul.direct == 2) then
            bul.xm = 4
        elseif (bul.direct == 3) then
            bul.ym = 4
        end
    else
        bul:Move()
    end

    local rcLeft = {
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
        ModCS.Rect.Create(32, 48, 48, 64),
        ModCS.Rect.Create(48, 48, 64, 64),
    }

    local rcRight = {
        ModCS.Rect.Create(64, 48, 80, 64),
        ModCS.Rect.Create(80, 48, 96, 64),
        ModCS.Rect.Create(96, 48, 112, 64),
        ModCS.Rect.Create(112, 48, 128, 64),
    }

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 1) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 3) then
        bul.ani_no = 0
    end

    if (bul.direct == 0) then
        bul:SetRect(rcLeft[bul.ani_no+1])
    else
        bul:SetRect(rcRight[bul.ani_no+1])
    end
end

-- Blade Level 2
ModCS.Bullet.Act[26] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.count1 == 3) then
        bul.bits = ModCS.Game.UnsetBit(bul.bits, 4)
    end

    if (bul.count1 % 7 == 1) then
        ModCS.Sound.Play(106)
    end

    if (bul.act_no == 0) then
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -4
        elseif (bul.direct == 1) then
            bul.ym = -4
        elseif (bul.direct == 2) then
            bul.xm = 4
        elseif (bul.direct == 3) then
            bul.ym = 4
        end
    else
        bul:Move()
    end

    local rcLeft = {
        ModCS.Rect.Create(160, 48, 184, 72),
        ModCS.Rect.Create(184, 48, 208, 72),
        ModCS.Rect.Create(208, 48, 232, 72),
        ModCS.Rect.Create(232, 48, 256, 72),
    }

    local rcRight = {
        ModCS.Rect.Create(160, 72, 184, 96),
        ModCS.Rect.Create(184, 72, 208, 96),
        ModCS.Rect.Create(208, 72, 232, 96),
        ModCS.Rect.Create(232, 72, 256, 96),
    }

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 1) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 3) then
        bul.ani_no = 0
    end

    if (bul.direct == 0) then
        bul:SetRect(rcLeft[bul.ani_no+1])
    else
        bul:SetRect(rcRight[bul.ani_no+1])
    end
end

-- Blade Level 3
ModCS.Bullet.Act[27] = function(bul)
    local rect = ModCS.Rect.Create(0, 0, 0, 0)

    local rcLeft = {
        ModCS.Rect.Create(272, 0, 296, 24),
        ModCS.Rect.Create(296, 0, 320, 24),
    }

    local rcUp = {
        ModCS.Rect.Create(272, 48, 296, 72),
        ModCS.Rect.Create(296, 0, 320, 24),
    }

    local rcRight = {
        ModCS.Rect.Create(272, 24, 296, 48),
        ModCS.Rect.Create(296, 24, 320, 48),
    }

    local rcDown = {
        ModCS.Rect.Create(296, 48, 320, 72),
        ModCS.Rect.Create(296, 24, 320, 48),
    }

    if (bul.act_no == 0) then
        bul.act_no = 1
        bul.xm = 0
        bul.ym = 0
        -- Fallthrough
    end

    if (bul.act_no == 1) then
        if (bul.direct == 0) then
            bul.xm = -4
        elseif (bul.direct == 1) then
            bul.ym = -4
        elseif (bul.direct == 2) then
            bul.xm = 4
        elseif (bul.direct == 3) then
            bul.ym = 4
        end

        if (bul.life ~= 100) then
            bul.act_no = 2
            bul.ani_no = 1
            bul.damage = -1
            bul.act_wait = 0
        end

        bul.act_wait = bul.act_wait + 1

        if (bul.act_wait % 4 == 1) then
            ModCS.Sound.Play(106)

            bul.count1 = bul.count1 + 1
            if (bul.count1 % 2 == 1) then
                ModCS.Bullet.Spawn(23, bul.x, bul.y, 0)
            else
                ModCS.Bullet.Spawn(23, bul.x, bul.y, 2)
            end
        end

        bul.count1 = bul.count1 + 1
        if (bul.count1 == 5) then
            bul.bits = ModCS.Game.UnsetBit(bul.bits, 4)
        end

        if (bul.count1 > bul.life_count) then
            bul.cond = 0
            ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
            return
        end
    elseif (bul.act_no == 2) then
        bul.xm = 0
        bul.ym = 0
        bul.act_wait = bul.act_wait + 1

        if (ModCS.Game.Random(-1, 1) == 0) then
            ModCS.Sound.Play(106)

            if (ModCS.Game.Random(0, 1) % 2 == 1) then
                ModCS.Bullet.Spawn(23, bul.x + ModCS.Game.Random(-64, 64), bul.y + ModCS.Game.Random(-64, 64), 0)
            else
                ModCS.Bullet.Spawn(23, bul.x + ModCS.Game.Random(-64, 64), bul.y + ModCS.Game.Random(-64, 64), 2)
            end

            if (bul.act_wait > 50) then
                bul.cond = 0
            end
        end
    end

    bul:Move()

    if (bul.direct == 0) then
        rect = rcLeft[bul.ani_no+1]
    elseif (bul.direct == 1) then
        rect = rcUp[bul.ani_no+1]
    elseif (bul.direct == 2) then
        rect = rcRight[bul.ani_no+1]
    elseif (bul.direct == 3) then
        rect = rcDown[bul.ani_no+1]
    end

    if (bul.act_wait % 2 == 1) then
        rect.right = 0
    end

    bul:SetRect(rect)
end

