-- Drop this into your main.lua or a "required" file, and it should just work. The original vanilla code will not run and instead the Lua version will.

function ModCS.Player.Animation()
    local rcLeft = {
        ModCS.Rect.Create(0, 0, 16, 16),   -- standing
        ModCS.Rect.Create(16, 0, 32, 16),  -- falling
        ModCS.Rect.Create(0, 0, 16, 16),   -- standing (walk cycle)
        ModCS.Rect.Create(32, 0, 48, 16),  -- jumping
        ModCS.Rect.Create(0, 0, 16, 16),   -- standing (?)
        ModCS.Rect.Create(48, 0, 64, 16),  -- standing looking up
        ModCS.Rect.Create(64, 0, 80, 16),  -- falling looking up
        ModCS.Rect.Create(48, 0, 64, 16),  -- standing looking up (walk cycle)
        ModCS.Rect.Create(80, 0, 96, 16),  -- jumping looking up
        ModCS.Rect.Create(48, 0, 64, 16),  -- standing looking up (?)
        ModCS.Rect.Create(96, 0, 112, 16), -- looking down in air
        ModCS.Rect.Create(112, 0, 128, 16) -- interaction
    }

    local rcRight = {
        ModCS.Rect.Create(0, 16, 16, 32),   -- standing
        ModCS.Rect.Create(16, 16, 32, 32),  -- falling
        ModCS.Rect.Create(0, 16, 16, 32),   -- standing (walk cycle)
        ModCS.Rect.Create(32, 16, 48, 32),  -- jumping
        ModCS.Rect.Create(0, 16, 16, 32),   -- standing (?)
        ModCS.Rect.Create(48, 16, 64, 32),  -- standing looking up
        ModCS.Rect.Create(64, 16, 80, 32),  -- falling looking up
        ModCS.Rect.Create(48, 16, 64, 32),  -- standing looking up (walk cycle)
        ModCS.Rect.Create(80, 16, 96, 32),  -- jumping looking up
        ModCS.Rect.Create(48, 16, 64, 32),  -- standing looking up (?)
        ModCS.Rect.Create(96, 16, 112, 32), -- looking down in air
        ModCS.Rect.Create(112, 16, 128, 32) -- interaction
    }

    -- If the player is hidden, don't do animation
    if (ModCS.Player.CheckCond(2)) then
        return
    end

    if (ModCS.Player.TouchFloor()) then -- If on ground
        if (ModCS.Player.CheckCond(1)) then -- interaction
            ModCS.Player.ani_no = 11 -- set frame to interact state
        elseif (ModCS.Key.Up(true) and (ModCS.Key.Left(true) or ModCS.Key.Right(true)) and ModCS.Game.CanControl()) then -- If looking up and pressing left/right
            ModCS.Player.SetCond(4) -- unsure exactly what this does, but it appears multiple times and is checked

            ModCS.Player.ani_wait = ModCS.Player.ani_wait + 1
            if ModCS.Player.ani_wait > 4 then
                ModCS.Player.ani_wait = 0

                ModCS.Player.ani_no = ModCS.Player.ani_no + 1
                if ModCS.Player.ani_no == 7 or ModCS.Player.ani_no == 9 then -- walk cycle
                    ModCS.Sound.Play(24) -- walk sfx
                end
            end

            if ModCS.Player.ani_no > 9 or ModCS.Player.ani_no < 6 then
                ModCS.Player.ani_no = 6 -- falling
            end
        elseif ((ModCS.Key.Left(true) or ModCS.Key.Right(true)) and ModCS.Game.CanControl()) then -- If pressing left/right
            ModCS.Player.SetCond(4)

            ModCS.Player.ani_wait = ModCS.Player.ani_wait + 1
            if ModCS.Player.ani_wait > 4 then
                ModCS.Player.ani_wait = 0

                ModCS.Player.ani_no = ModCS.Player.ani_no + 1
                if ModCS.Player.ani_no == 2 or ModCS.Player.ani_no == 4 then -- walk cycle
                    ModCS.Sound.Play(24)
                end
            end

            if ModCS.Player.ani_no > 4 or ModCS.Player.ani_no < 1 then
                ModCS.Player.ani_no = 1 -- falling
            end
        elseif (ModCS.Key.Up(true) and ModCS.Game.CanControl()) then -- If looking up
            if (ModCS.Player.CheckCond(4)) then
                ModCS.Sound.Play(24) -- walk sfx
            end

            ModCS.Player.UnsetCond(4)
            ModCS.Player.ani_no = 5 -- standing looking up
        else -- Standing still
            if (ModCS.Player.CheckCond(4)) then
                ModCS.Sound.Play(24) -- walk sfx
            end

            ModCS.Player.UnsetCond(4)
            ModCS.Player.ani_no = 0 -- standing still
        end
    elseif (ModCS.Player.up == 1) then
        ModCS.Player.ani_no = 6 -- falling looking up
    elseif (ModCS.Player.down == 1) then
          ModCS.Player.ani_no = 10 -- looking down in air
    else
        if (ModCS.Player.ym > 0) then
            ModCS.Player.ani_no = 1 -- falling
        else
            ModCS.Player.ani_no = 3 -- jumping
        end
    end

    local rect = ModCS.Player.GetRect()

    if (ModCS.Player.direct == 0) then
        rect = rcLeft[ModCS.Player.ani_no+1]
    else
        rect = rcRight[ModCS.Player.ani_no+1]
    end

    ModCS.Player.SetRect(rect)
end
