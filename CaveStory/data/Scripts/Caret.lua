-- Null
ModCS.Caret.Act[0] = function(crt)
    -- Nothing!
end

-- Bubble
ModCS.Caret.Act[1] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(0, 64, 8, 72),
        ModCS.Rect.Create(8, 64, 16, 72),
        ModCS.Rect.Create(16, 64, 24, 72),
        ModCS.Rect.Create(24, 64, 32, 72),
    }

    local rcRight = {
        ModCS.Rect.Create(64, 24, 72, 32),
        ModCS.Rect.Create(72, 24, 80, 32),
        ModCS.Rect.Create(80, 24, 88, 32),
        ModCS.Rect.Create(88, 24, 96, 32),
    }

    if (crt.act_no == 0) then
        crt.act_no = 1
        crt.xm = ModCS.Game.Random2(-2, 2)
        crt.ym = ModCS.Game.Random2(-2, 0)
    end

    crt.ym = crt.ym + 0.125
    crt:Move()

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 5) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end
    end

    if (crt.direct == 0) then
        crt:SetRect(rcLeft[crt.ani_no+1])
    else
        crt:SetRect(rcRight[crt.ani_no+1])
    end
end

-- Projectile dissipation
ModCS.Caret.Act[2] = function(crt)
    local rect_left = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
        ModCS.Rect.Create(32, 32, 48, 48),
        ModCS.Rect.Create(48, 32, 64, 48),
    }

    local rect_right = {
        ModCS.Rect.Create(176, 0, 192, 16),
        ModCS.Rect.Create(192, 0, 208, 16),
        ModCS.Rect.Create(208, 0, 224, 16),
        ModCS.Rect.Create(224, 0, 240, 16),
    }

    local rect_up = {
        ModCS.Rect.Create(0, 32, 16, 48),
        ModCS.Rect.Create(32, 32, 48, 48),
        ModCS.Rect.Create(16, 32, 32, 48),
    }

    if (crt.direct == 0) then -- left
        crt.ym = crt.ym - 0.03125
        crt:Move()

        crt.ani_wait = crt.ani_wait + 1
        if (crt.ani_wait > 5) then
            crt.ani_wait = 0
            crt.ani_no = crt.ani_no + 1
        end

        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end

        crt:SetRect(rect_left[crt.ani_no+1])
    elseif (crt.direct == 2) then -- right
        crt.ani_wait = crt.ani_wait + 1
        if (crt.ani_wait > 2) then
            crt.ani_wait = 0
            crt.ani_no = crt.ani_no + 1
        end

        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end

        crt:SetRect(rect_right[crt.ani_no+1])
    elseif (crt.direct == 1) then -- up
        crt.ani_wait = crt.ani_wait + 1
        crt:SetRect(rect_up[(math.floor(crt.ani_wait / 2) % 3)+1])

        if (crt.ani_wait > 24) then
            crt.cond = 0
        end
    end
end

-- Shoot
ModCS.Caret.Act[3] = function(crt)
    local rect = {
        ModCS.Rect.Create(0, 48, 16, 64),
        ModCS.Rect.Create(16, 48, 32, 64),
        ModCS.Rect.Create(32, 48, 48, 64),
        ModCS.Rect.Create(48, 48, 64, 64),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 2) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rect[crt.ani_no+1])
end

-- Snake after-image? This doesn't seem to be used.
ModCS.Caret.Act[4] = function(crt)
    local rect = {
        -- Left
        ModCS.Rect.Create(64, 32, 80, 48),
        ModCS.Rect.Create(80, 32, 96, 48),
        ModCS.Rect.Create(96, 32, 112, 48),
        -- Up
        ModCS.Rect.Create(64, 48, 80, 64),
        ModCS.Rect.Create(80, 48, 96, 64),
        ModCS.Rect.Create(96, 48, 112, 64),
        -- Right
        ModCS.Rect.Create(64, 64, 80, 80),
        ModCS.Rect.Create(80, 64, 96, 80),
        ModCS.Rect.Create(96, 64, 112, 80),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 1) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 2) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rect[((crt.direct * 3) + crt.ani_no)+1])
end

-- 'Zzz' - snoring
ModCS.Caret.Act[5] = function(crt)
    local rect = {
        ModCS.Rect.Create(32, 64, 40, 72),
        ModCS.Rect.Create(32, 72, 40, 80),
        ModCS.Rect.Create(40, 64, 48, 72),
        ModCS.Rect.Create(40, 72, 48, 80),
        ModCS.Rect.Create(40, 64, 48, 72),
        ModCS.Rect.Create(40, 72, 48, 80),
        ModCS.Rect.Create(40, 64, 48, 72),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 4) then
        crt.ani_wait = 0
        crt.ani_no = crt.ani_no + 1
    end

    if (crt.ani_no > 6) then
        crt.cond = 0
        return
    end

    crt.x = crt.x + 0.25
    crt.y = crt.y + 0.25

    crt:SetRect(rect[crt.ani_no+1])
end

-- There is no ModCS.Caret.Act[6], however, in the original games function table, Snake after-image appears there.
ModCS.Caret.Act[6] = ModCS.Caret.Act[4]

-- Exhaust (used by the Booster and hoverbike)
ModCS.Caret.Act[7] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(56, 0, 64, 8),
        ModCS.Rect.Create(64, 0, 72, 8),
        ModCS.Rect.Create(72, 0, 80, 8),
        ModCS.Rect.Create(80, 0, 88, 8),
        ModCS.Rect.Create(88, 0, 96, 8),
        ModCS.Rect.Create(96, 0, 104, 8),
        ModCS.Rect.Create(104, 0, 112, 8),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 1) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 6) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rcLeft[crt.ani_no+1])

    if (crt.direct == 0) then
        crt.x = crt.x - 2
    elseif (crt.direct == 1) then
        crt.y = crt.y - 2
    elseif (crt.direct == 2) then
        crt.x = crt.x + 2
    elseif (crt.direct == 3) then
        crt.y = crt.y + 2
    end
end

-- Drowned Quote
ModCS.Caret.Act[8] = function(crt)
    local rcLeft = ModCS.Rect.Create(16, 80, 32, 96)
    local rcRight = ModCS.Rect.Create(32, 80, 48, 96)

    if (crt.direct == 0) then
        crt:SetRect(rcLeft)
    else
        crt:SetRect(rcRight)
    end
end

-- The '?' that appears when you press the down key
ModCS.Caret.Act[9] = function(crt)
    local rcLeft = ModCS.Rect.Create(0, 80, 16, 96)
    local rcRight = ModCS.Rect.Create(48, 64, 64, 80)

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait < 5) then
        crt.y = crt.y - 4
    end

    if (crt.ani_wait == 32) then
        crt.cond = 0
    end

    if (crt.direct == 0) then
        crt:SetRect(rcLeft)
    else
        crt:SetRect(rcRight)
    end
end

-- 'Level Up!'
ModCS.Caret.Act[10] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 56, 16),
        ModCS.Rect.Create(0, 16, 56, 32),
    }

    local rcRight = {
        ModCS.Rect.Create(0, 96, 56, 112),
        ModCS.Rect.Create(0, 112, 56, 128),
    }

    crt.ani_wait = crt.ani_wait + 1

    if (crt.direct == 0) then
        if (crt.ani_wait < 20) then
            crt.y = crt.y - 2
        end

        if (crt.ani_wait == 80) then
            crt.cond = 0
        end
    else
        if (crt.ani_wait < 20) then
            crt.y = crt.y - 1
        end

        if (crt.ani_wait == 80) then
            crt.cond = 0
        end
    end

    if (crt.direct == 0) then
        crt:SetRect(rcLeft[(math.floor(crt.ani_wait / 2) % 2)+1])
    else
        crt:SetRect(rcRight[(math.floor(crt.ani_wait / 2) % 2)+1])
    end
end

-- Red hurt particles (used by bosses and invisible hidden pickups)
ModCS.Caret.Act[11] = function(crt)
    local deg = 0

    if (crt.act_no == 0) then
        crt.act_no = 1
        deg = ModCS.Game.Random(0, 0xFF)
        crt.xm = ModCS.Triangle.GetCos(deg) * 2
        crt.ym = ModCS.Triangle.GetSin(deg) * 2
    end

    crt:Move()

    local rcRight = {
        ModCS.Rect.Create(56, 8, 64, 16),
        ModCS.Rect.Create(64, 8, 72, 16),
        ModCS.Rect.Create(72, 8, 80, 16),
        ModCS.Rect.Create(80, 8, 88, 16),
        ModCS.Rect.Create(88, 8, 96, 16),
        ModCS.Rect.Create(96, 8, 104, 16),
        ModCS.Rect.Create(104, 8, 112, 16),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 2) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 6) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rcRight[crt.ani_no+1])
end

-- Missile Launcher explosion flash
ModCS.Caret.Act[12] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(112, 0, 144, 32),
        ModCS.Rect.Create(144, 0, 176, 32),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 2) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 1) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rcLeft[crt.ani_no+1])
end

-- Particles used when Quote jumps into the ceiling, and also used by the Demon Crown and Ballo's puppy
ModCS.Caret.Act[13] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(56, 24, 64, 32),
        ModCS.Rect.Create(0, 0, 0, 0),
    }

    if (crt.act_no == 0) then
        crt.act_no = 1

        if (crt.direct == 0) then
            crt.xm = ModCS.Game.Random2(-3, 3)
            crt.ym = ModCS.Game.Random2(-1, 1)
        elseif (crt.direct == 1) then
            crt.ym = ModCS.Game.Random(-3, -1)
        end
    end

    if (crt.direct == 0) then
        crt.xm = (crt.xm * 4) / 5
        crt.ym = (crt.ym * 4) / 5
    end

    crt:Move()

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 20) then
        crt.cond = 0
    end

    crt:SetRect(rcLeft[(math.floor(crt.ani_wait / 2) % 2)+1])

    if (crt.direct == 4) then
        crt.x = crt.x - 4
    end
end

-- Broken (unknown and unused)
ModCS.Caret.Act[14] = function(crt)
	-- These rects are invalid.
	-- However, notably, there are 5 unused 40x40 sprites at the bottom of Caret.pbm.
	-- Perhaps those were originally at these coordinates.
    local rect = {
        ModCS.Rect.Create(0, 96, 40, 136),
        ModCS.Rect.Create(40, 96, 80, 136),
        ModCS.Rect.Create(80, 96, 120, 136),
        ModCS.Rect.Create(120, 96, 160, 136),
        ModCS.Rect.Create(160, 96, 200, 136),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 1) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 4) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rect[crt.ani_no+1])
end

-- Tiny version of the projectile dissipation effect
ModCS.Caret.Act[15] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(0, 72, 8, 80),
        ModCS.Rect.Create(8, 72, 16, 80),
        ModCS.Rect.Create(16, 72, 24, 80),
        ModCS.Rect.Create(24, 72, 32, 80),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait > 2) then
        crt.ani_wait = 0

        crt.ani_no = crt.ani_no + 1
        if (crt.ani_no > 3) then
            crt.cond = 0
            return
        end
    end

    crt:SetRect(rcLeft[crt.ani_no+1])
end

-- 'Empty!'
ModCS.Caret.Act[16] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(104, 96, 144, 104),
        ModCS.Rect.Create(104, 104, 144, 112),
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait < 10) then
        crt.y = crt.y - 2
    end

    if (crt.ani_wait == 40) then
        crt.cond = 0
    end

    crt:SetRect(rcLeft[(math.floor(crt.ani_wait / 2) % 2)+1])
end

-- 'PUSH JUMP KEY' (unused)
ModCS.Caret.Act[17] = function(crt)
    local rcLeft = {
        ModCS.Rect.Create(0, 144, 144, 152),
        ModCS.Rect.Create(0, 0, 0, 0)
    }

    crt.ani_wait = crt.ani_wait + 1
    if (crt.ani_wait >= 40) then
        crt.ani_wait = 0
    end

    if (crt.ani_wait < 30) then
        crt:SetRect(rcLeft[1])
    else
        crt:SetRect(rcLeft[2])
    end
end