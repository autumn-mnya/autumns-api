-- Snake Level 1
ModCS.Bullet.Act[1] = function(bul)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.ani_no = ModCS.Game.Random(0, 2)
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -3
        elseif (bul.direct == 1) then
            bul.ym = -3
        elseif (bul.direct == 2) then
            bul.xm = 3
        elseif (bul.direct == 3) then
            bul.ym = 3
        end
    else
        bul:Move()
    end

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 0) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 3) then
        bul.ani_no = 0
    end

    local rcLeft = {
        ModCS.Rect.Create(136, 80, 152, 80),
        ModCS.Rect.Create(120, 80, 136, 96),
        ModCS.Rect.Create(136, 64, 152, 80),
        ModCS.Rect.Create(120, 64, 136, 80),
    }

    local rcRight = {
        ModCS.Rect.Create(120, 64, 136, 80),
        ModCS.Rect.Create(136, 64, 152, 80),
        ModCS.Rect.Create(120, 80, 136, 96),
        ModCS.Rect.Create(136, 80, 152, 80),
    }

    if (bul.direct == 0) then
        bul:SetRect(rcLeft[bul.ani_no+1])
    else
        bul:SetRect(rcRight[bul.ani_no+1])
    end
end

-- Snake Level 2 & 3 code
local snake_inc = 0
local function SnakeBullet2(bul, level)
    bul.count1 = bul.count1 + 1
    if (bul.count1 > bul.life_count) then
        bul.cond = 0
        ModCS.Caret.Spawn(ModCS.Const.CARET_SHOOT, bul.x, bul.y, 0)
        return
    end

    if (bul.act_no == 0) then
        bul.ani_no = ModCS.Game.Random(0, 2)
        bul.act_no = 1

        if (bul.direct == 0) then
            bul.xm = -1
        elseif (bul.direct == 1) then
            bul.ym = -1
        elseif (bul.direct == 2) then
            bul.xm = 1
        elseif (bul.direct == 3) then
            bul.ym = 1
        end

        snake_inc = snake_inc + 1

        if (bul.direct == 0 or bul.direct == 2) then
            if (snake_inc % 2 == 1) then
                bul.ym = 2
            else
                bul.ym = -2
            end
        elseif (bul.direct == 1 or bul.direct == 3) then
            if (snake_inc % 2 == 1) then
                bul.xm = 2
            else
                bul.xm = -2
            end
        end
    else
        if (bul.direct == 0) then
            bul.xm = bul.xm - 0.25
        elseif (bul.direct == 1) then
            bul.ym = bul.ym - 0.25
        elseif (bul.direct == 2) then
            bul.xm = bul.xm + 0.25
        elseif (bul.direct == 3) then
            bul.ym = bul.ym + 0.25
        end

        if (bul.direct == 0 or bul.direct == 2) then
            if (bul.count1 % 5 == 2) then
                if (bul.ym < 0) then
                    bul.ym = 2
                else
                    bul.ym = -2
                end
            end
        elseif (bul.direct == 1 or bul.direct == 3) then
            if (bul.count1 % 5 == 2) then
                if (bul.xm < 0) then
                    bul.xm = 2
                else
                    bul.xm = -2
                end
            end
        end

        bul:Move()
    end

    bul.ani_wait = bul.ani_wait + 1
    if (bul.ani_wait > 0) then
        bul.ani_wait = 0
        bul.ani_no = bul.ani_no + 1
    end

    if (bul.ani_no > 2) then
        bul.ani_no = 0
    end

    local rect = {
        ModCS.Rect.Create(192, 16, 208, 32),
        ModCS.Rect.Create(208, 16, 224, 32),
        ModCS.Rect.Create(224, 16, 240, 32),
    }

    bul:SetRect(rect[bul.ani_no+1])

    if (level == 2) then
        ModCS.Npc.Spawn2(129, bul.x, bul.y, 0, -1, bul.ani_no)
    else
        ModCS.Npc.Spawn2(129, bul.x, bul.y, 0, -1, bul.ani_no + 3)
    end
end

-- Snake Level 2
ModCS.Bullet.Act[2] = function(bul)
    SnakeBullet2(bul, 2)
end

-- Snake Level 3
ModCS.Bullet.Act[3] = function(bul)
    SnakeBullet2(bul, 3)
end
