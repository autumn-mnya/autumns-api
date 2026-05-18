local start_mode = 1
local mode_after_opening = 2
local mode_after_title = 3

local black_color = ModCS.Color.Create(0, 0, 0)
local bContinue = false

-- Mode Opening
ModCS.Mode[1] = function()
    local wait = 0
    local waitTimer = 500

    ModCS.Mode.InitNpChar()
    ModCS.Mode.InitCaret()
    ModCS.Mode.InitStar()
    ModCS.Mode.InitFade()
    ModCS.Mode.InitFlash()
    ModCS.Mode.InitBossLife()
    ModCS.Mode.ExecuteOpeningInit()
    ModCS.Music.Play(0) -- Change music to silence
    ModCS.Stage.Transfer(72, 3, 3, 100)
    ModCS.Camera.SetTargetPlayer(16)
    ModCS.Mode.SetFadeMask()

    -- Reset cliprect and flags
    ModCS.Mode.ResetGameRect()
    ModCS.Game.SetGameFlags(3)

    ModCS.Mode.CutNoise()

    if not ModCS.Mode.GameInitLua() then
        return 0
    end

    while (wait < waitTimer) do
        -- Increase timer
        wait = wait + 1

        ModCS.Mode.GetTrg()

        if ModCS.Key.Pause() then
            ModCS.Surface.Screenshot(10, ModCS.GetGameRect())

            local pause_result = ModCS.Mode.CallPause()

            if pause_result == 0 then
                return 0
            elseif pause_result == 2 then
                return start_mode
            end
        end

        if ModCS.Key.Ok() then
           break
        end

        if not ModCS.Mode.GameActLua() then
           return 0
        end

        ModCS.Mode.ExecuteOpeningEarlyAction()
        if not ModCS.Mode.ActNpChar() then
            return 0
        end
        ModCS.Mode.ActBossChar()
        ModCS.Mode.ActBack()
        ModCS.Mode.ResetMyCharFlag()
        ModCS.Mode.HitMyCharMap()
        ModCS.Mode.HitMyCharNpChar()
        ModCS.Mode.HitMyCharBoss()
        ModCS.Mode.HitNpCharMap()
        ModCS.Mode.HitBossMap()
        ModCS.Mode.HitBossBullet()
        if not ModCS.Mode.ActCaret() then
            return 0
        end
        ModCS.Mode.ExecuteOpeningAction()
        ModCS.Mode.MoveFrame3()
        ModCS.Mode.ProcFade()
        if not ModCS.Mode.GameUpdateLua() then
            return 0
        end

        -- Draw everything
        ModCS.Color.Box(black_color, ModCS.GetFullRect())

        ModCS.Mode.GetFramePosition()
        ModCS.Mode.ExecuteOpeningBelowPutBack()
        ModCS.Mode.PutBack()
        ModCS.Mode.ExecuteOpeningAbovePutBack()
        ModCS.Mode.ExecuteOpeningBelowPutStage_Back()
        ModCS.Mode.PutStage_Back()
        ModCS.Mode.ExecuteOpeningAbovePutStage_Back()
        ModCS.Mode.PutBossChar()
        ModCS.Mode.PutNpChar()
        ModCS.Mode.PutMapDataVector()
        ModCS.Mode.ExecuteOpeningBelowPutStage_Front()
        ModCS.Mode.PutStage_Front()
        ModCS.Mode.ExecuteOpeningAbovePutStage_Front()
        ModCS.Mode.PutFront()
        ModCS.Mode.ExecuteOpeningBelowPutCaret()
        ModCS.Mode.PutCaret()
        ModCS.Mode.ExecuteOpeningAbovePutCaret()
        ModCS.Mode.ExecuteOpeningBelowFade()
        ModCS.Mode.PutFade()
        ModCS.Mode.ExecuteOpeningAboveFade()

        local tsc_result = ModCS.Mode.TextScriptProc()

        if tsc_result == 0 then
            return 0
        elseif tsc_result == 2 then
            return start_mode
        end

        ModCS.Mode.PutMapName(false)

        ModCS.Mode.ExecuteOpeningBelowTextBox()
        ModCS.Mode.PutTextScript()
        ModCS.Mode.ExecuteOpeningAboveTextBox()

        if not ModCS.Mode.GameDrawLua() then
            return 0
        end

        if not ModCS.Mode.FlipSystemTask() then
            return 0
        end

        ModCS.Mode.IncrementgCounter()
    end

    wait = ModCS.Mode.Backend_GetTicks()

    while ModCS.Mode.Backend_GetTicks() < wait + 500 do
        ModCS.Color.Box(black_color, ModCS.GetGameRect())
        ModCS.Mode.PutFPS()
        if not ModCS.Mode.FlipSystemTask() then
            return 0
        end
    end

    return mode_after_opening
end

-- Mode Title
ModCS.Mode[2] = function()
    local gb60fps = false -- set this to whatever fps the mod is
    local fps
    if gb60fps then
        fps = 60
    else
        fps = 50
    end

    local rcTitle = ModCS.Rect.Create(0, 0, 144, 40)
    local rcPixel = ModCS.Rect.Create(0, 0, 160, 16)
    local rcNew = ModCS.Rect.Create(144, 0, 192, 16)
    local rcContinue = ModCS.Rect.Create(144, 16, 192, 32)

    local rcVersion = ModCS.Rect.Create(152, 80, 208, 88)
    local rcPeriod = ModCS.Rect.Create(152, 88, 208, 96)

    local rcMyChar = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(16, 16, 32, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(32, 16, 48, 32)
    }

    local rcCurly = {
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(16, 112, 32, 128),
        ModCS.Rect.Create(0, 112, 16, 128),
        ModCS.Rect.Create(32, 112, 48, 128),
    }

    local rcToroko = {
        ModCS.Rect.Create(64, 80, 80, 96),
        ModCS.Rect.Create(80, 80, 96, 96),
        ModCS.Rect.Create(64, 80, 80, 96),
        ModCS.Rect.Create(96, 80, 112, 96),
    }

    local rcKing = {
        ModCS.Rect.Create(224, 48, 240, 64),
        ModCS.Rect.Create(288, 48, 304, 64),
        ModCS.Rect.Create(224, 48, 240, 64),
        ModCS.Rect.Create(304, 48, 320, 64),
    }

    local rcSu = {
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(32, 16, 48, 32),
        ModCS.Rect.Create(0, 16, 16, 32),
        ModCS.Rect.Create(48, 16, 64, 32),
    }

    local wait
    local anime
    local v1, v2, v3, v4 = 1, 0, 0, 6
    local char_rc
    local char_type
    local time_counter
    local char_y
    local char_surf
    local back_color

    -- Reset everything
    ModCS.Mode.InitCaret()
    ModCS.Mode.InitStar()
    ModCS.Mode.CutNoise()
    ModCS.Mode.ExecuteTitleInit()

    -- Create variables
    anime = 0
    char_type = 0
    time_counter = 0
    back_color = ModCS.Color.Create(0x20, 0x20, 0x20)

    -- Set state
    bContinue = ModCS.Profile.Exists()

    -- Set character
    time_counter = ModCS.Mode.LoadTimeCounter()

    if time_counter > 0 and time_counter < 6 * 60 * fps then -- 6 minutes
        char_type = 1
    end

    if time_counter > 0 and time_counter < 5 * 60 * fps then -- 5 minutes
        char_type = 2
    end

    if time_counter > 0 and time_counter < 4 * 60 * fps then -- 4 minutes
        char_type = 3
    end

    if time_counter > 0 and time_counter < 3 * 60 * fps then -- 3 minutes
        char_type = 4
    end

    -- Set music to character's specific music
    if char_type == 1 then
        ModCS.Music.Play(36) -- Running Hell
    elseif char_type == 2 then
        ModCS.Music.Play(40) -- Torokos Theme
    elseif char_type == 3 then
        ModCS.Music.Play(41) -- White
    elseif char_type == 4 then
        ModCS.Music.Play(2) -- Safety
    else
        ModCS.Music.Play(24) -- Cave Story
    end

    -- Reset cliprect, flags, and give the player the Nikumaru counter
    ModCS.Mode.ResetGameRect()
    ModCS.Game.SetGameFlags(0)
    ModCS.Player.Equip(256)

    wait = 0

    while (1) do
        -- Don't accept selection for 10 ticks
        if wait < 10 then
            wait = wait + 1
        end

        -- Get pressed keys
        ModCS.Mode.GetTrg()

        -- Quit when OK is pressed
        if wait >= 10 then
            if ModCS.Key.Ok() then
                ModCS.Sound.Play(18)
                break
            end
        end

        if ModCS.Key.Pause() then
            ModCS.Surface.Screenshot(10, ModCS.GetGameRect())

            local pause_result = ModCS.Mode.CallPause()

            if pause_result == 0 then
                return 0
            elseif pause_result == 2 then
                return 4
            end
        end

        if not ModCS.Mode.GameActLua() then
            return 0
        end

        -- Move cursor
        if ModCS.Key.Up() or ModCS.Key.Down() then
            ModCS.Sound.Play(1)
            if bContinue then
                bContinue = false
                ModCS.Game.SetNew(true)
            else
                bContinue = true
                ModCS.Game.SetNew(false)
            end
        end

        -- Update carets
        ModCS.Mode.ExecuteTitleAction()
        if not ModCS.Mode.ActCaret() then
            return 0
        end
        if not ModCS.Mode.GameUpdateLua() then
            return 0
        end

        -- Animate character cursor
        anime = anime + 1
        if anime >= 40 then
            anime = 0
        end

        -- Draw title
        ModCS.Color.Box(back_color, ModCS.GetGameRect())

        -- Draw version
        ModCS.Rect.Put(rcVersion, (ModCS.GetWindowWidth() / 2) - 60, ModCS.GetWindowHeight() - 24, 26)
        ModCS.Rect.Put(rcPeriod, (ModCS.GetWindowWidth() / 2) - 4, ModCS.GetWindowHeight() - 24, 26)

        ModCS.PutNumber(v1, (ModCS.GetWindowWidth() / 2) - 20, ModCS.GetWindowHeight() - 24)
        ModCS.PutNumber(v2, (ModCS.GetWindowWidth() / 2) - 4, ModCS.GetWindowHeight() - 24)
        ModCS.PutNumber(v3, (ModCS.GetWindowWidth() / 2) + 12, ModCS.GetWindowHeight() - 24)
        ModCS.PutNumber(v4, (ModCS.GetWindowWidth() / 2) + 28, ModCS.GetWindowHeight() - 24)

        -- Draw main title
        ModCS.Rect.Put(rcTitle, (ModCS.GetWindowWidth() / 2) - 72, 40, 0)
        ModCS.Rect.Put(rcNew, (ModCS.GetWindowWidth() / 2) - 24, (ModCS.GetWindowHeight() / 2) + 8, 0)
        ModCS.Rect.Put(rcContinue, (ModCS.GetWindowWidth() / 2) - 24, (ModCS.GetWindowHeight() / 2) + 28, 0)
        ModCS.Rect.Put(rcPixel, (ModCS.GetWindowWidth() / 2) - 80, (ModCS.GetWindowHeight() - 48), 1)

        -- Draw character cursor
        if char_type == 0 then
            char_rc = rcMyChar[math.floor(anime / 10) % 4 + 1]
            char_surf = 16
        elseif char_type == 1 then
            char_rc = rcCurly[math.floor(anime / 10) % 4 + 1]
            char_surf = 23
        elseif char_type == 2 then
            char_rc = rcToroko[math.floor(anime / 10) % 4 + 1]
            char_surf = 23
        elseif char_type == 3 then
            char_rc = rcKing[math.floor(anime / 10) % 4 + 1]
            char_surf = 23
        elseif char_type == 4 then
            char_rc = rcSu[math.floor(anime / 10) % 4 + 1]
            char_surf = 23
        end


        if not bContinue then
            char_y = (ModCS.GetWindowHeight() / 2) + 7
        else
            char_y = (ModCS.GetWindowHeight() / 2) + 27
        end
        ModCS.Rect.Put(char_rc, (ModCS.GetWindowWidth() / 2) - 44, char_y, char_surf)

        -- Draw carets
        ModCS.Mode.PutCaret()
        ModCS.Mode.ExecuteTitleBelowCounter()

        if time_counter > 0 then
            ModCS.Mode.PutTimeCounter(16, 8)
        end

        ModCS.Mode.ExecuteTitleBelowPutFPS()
        ModCS.Mode.PutFPS()
        ModCS.Mode.ExecuteTitleAbovePutFPS()

        if not ModCS.Mode.GameDrawLua() then
            return 0
        end

        if not ModCS.Mode.FlipSystemTask() then
            return 0
        end
    end

    ModCS.Music.Play(0)

    local wait = ModCS.Mode.Backend_GetTicks()

    while ModCS.Mode.Backend_GetTicks() < wait + 1000 do
        ModCS.Color.Box(black_color, ModCS.GetGameRect())
        ModCS.Mode.PutFPS()
        if not ModCS.Mode.FlipSystemTask() then
            return 0
        end
    end

    return mode_after_title
end

-- ModeAction
ModCS.Mode[3] = function()
    local color = ModCS.Color.Create(0, 0, 0x20)
    local swPlay = 1

    -- Reset stuff
    ModCS.Mode.SetgCounter(0)
    ModCS.Mode.ResetGameRect()
    ModCS.Game.SetGameFlags(3)

    -- Initialize everything
    ModCS.Mode.InitMyChar()
    ModCS.Mode.InitNpChar()
    ModCS.Mode.InitBullet()
    ModCS.Mode.InitCaret()
    ModCS.Mode.InitStar()
    ModCS.Mode.InitFade()
    ModCS.Mode.InitFlash()
    ModCS.Mode.ClearArmsData()
    ModCS.Mode.ClearItemData()
    ModCS.Mode.ClearPermitStage()
    ModCS.Mode.StartMapping()
    ModCS.Mode.InitFlags()
    ModCS.Mode.InitBossLife()
    ModCS.Mode.ExecuteGameplayInit() -- Execute any modded init elements in recreation mode too

    if bContinue then
        if not ModCS.Profile.Load() and not ModCS.Profile.Init() then
            return 0
        end
    else
        if not ModCS.Profile.Init() then
            return 0
        end
    end

    if not ModCS.Mode.GameInitLua() then
        return 0
    end

    while (1) do
        -- Get pressed keys
        ModCS.Mode.GetTrg()

        -- Pause menu
        if ModCS.Key.Pause() then
            ModCS.Surface.Screenshot(10, ModCS.GetGameRect())

            local pause_result = ModCS.Mode.CallPause()

            if pause_result == 0 then
                return 0
            elseif pause_result == 2 then
                return start_mode
            end
        end

        ModCS.Mode.GameActLua()

        if (swPlay % 2 ~= 0) and (ModCS.Game.GetGameFlags() & 1 ~= 0) then -- The "swPlay % 2" part is always true
            if ModCS.Game.CanControl() then
                ModCS.Mode.ActMyChar(true)
            else
                ModCS.Mode.ActMyChar(false)
            end

            -- Run action code
            ModCS.Mode.ExecuteGameplayEarlyAction()
            ModCS.Mode.ActStar()
            if not ModCS.Mode.ActNpChar() then
                return 0
            end
            ModCS.Mode.ActBossChar()
            ModCS.Mode.ActValueView()
            ModCS.Mode.ActBack()
            ModCS.Mode.ResetMyCharFlag()
            ModCS.Mode.HitMyCharMap()
            ModCS.Mode.HitMyCharNpChar()
            ModCS.Mode.HitMyCharBoss()
            ModCS.Mode.HitNpCharMap()
            ModCS.Mode.HitBossMap()
            ModCS.Mode.HitBulletMap()
            ModCS.Mode.HitNpCharBullet()
            ModCS.Mode.HitBossBullet()
            if ModCS.Game.CanControl() then
                if not ModCS.Mode.ShootBullet() then
                    return 0
                end
            end
            if not ModCS.Mode.ActBullet() then
                return 0
            end
            if not ModCS.Mode.ActCaret() then
                return 0
            end
            ModCS.Mode.ExecuteGameplayAction()
            ModCS.Mode.MoveFrame3()
            ModCS.Mode.GetFramePosition()
            ModCS.Mode.ActFlash()

            if ModCS.Game.CanControl() then
                ModCS.Mode.AnimationMyChar(true)
            else
                ModCS.Mode.AnimationMyChar(false)
            end
        end

        -- Credits
        if ModCS.Game.GetGameFlags() & 8 ~= 0 then
            ModCS.Mode.ActionCredit()
            ModCS.Mode.ActionIllust()
            ModCS.Mode.ActionStripper()
            ModCS.Mode.ExecuteCreditsAction()
        end

        ModCS.Mode.ProcFade()
        if not ModCS.Mode.GameUpdateLua() then
            return 0
        end

        -- Draw the game
        ModCS.Color.Box(color, ModCS.GetFullRect())
        ModCS.Mode.GetFramePosition()
        ModCS.Mode.ExecuteGameplayBelowPutBack()
        ModCS.Mode.PutBack()
        ModCS.Mode.ExecuteGameplayAbovePutBack()
        ModCS.Mode.ExecuteGameplayBelowPutStage_Back()
        ModCS.Mode.PutStage_Back()
        ModCS.Mode.ExecuteGameplayAbovePutStage_Back()
        ModCS.Mode.PutBossChar()
        ModCS.Mode.PutNpChar()
        ModCS.Mode.PutBullet()
        ModCS.Mode.ExecuteGameplayBelowPlayer()
        ModCS.Mode.PutMyChar()
        ModCS.Mode.ExecuteGameplayAbovePlayer()
        ModCS.Mode.PutStar()
        ModCS.Mode.PutMapDataVector()
        ModCS.Mode.ExecuteGameplayBelowPutStage_Front()
        ModCS.Mode.PutStage_Front()
        ModCS.Mode.ExecuteGameplayAbovePutStage_Front()
        ModCS.Mode.PutFront()
        ModCS.Mode.PutFlash()
        ModCS.Mode.ExecuteGameplayBelowPutCaret()
        ModCS.Mode.PutCaret()
        ModCS.Mode.ExecuteGameplayAbovePutCaret()
        ModCS.Mode.PutValueView()
        ModCS.Mode.PutBossLife()
        ModCS.Mode.ExecuteGameplayBelowFade()
        ModCS.Mode.PutFade()
        ModCS.Mode.ExecuteGameplayAboveFade()

        if not (ModCS.Game.GetGameFlags() & 4 ~= 0) then
            -- Open inventory
            if ModCS.Key.Item() then
                ModCS.Surface.Screenshot(10, ModCS.GetGameRect())

                local inv_result = ModCS.Mode.CampLoop()

                if inv_result == 0 then
                    return 0
                elseif inv_result == 2 then
                    return start_mode
                end
            end

            -- Open map system
            if ModCS.Player.HasEquipped(2) and ModCS.Key.Map() then
                ModCS.Surface.Screenshot(10, ModCS.GetGameRect())

                local map_result = ModCS.Mode.MiniMapLoop()

                if map_result == 0 then
                    return 0
                elseif map_result == 2 then
                    return start_mode
                end
            end
        end

        -- Switch weapons
        if ModCS.Game.CanControl() then
            if ModCS.Key.Arms() then
                ModCS.Arms.SwitchNext()
            elseif ModCS.Key.ArmsRev() then
                ModCS.Arms.SwitchPrev()
            end
        end

        if swPlay % 2 then -- this is always true
            local tsc_result = ModCS.Mode.TextScriptProc()

            if tsc_result == 0 then
                return 0
            elseif tsc_result == 2 then
                return start_mode
            end
        end

        ModCS.Mode.PutMapName(false)
        ModCS.Mode.PutTimeCounter(16, 8)

        if ModCS.Game.CanControl() then
            ModCS.Mode.PutMyLife(true)
            ModCS.Mode.PutArmsEnergy(true)
            ModCS.Mode.PutMyAir()
            ModCS.Mode.PutActiveArmsList()
            ModCS.Mode.ExecuteGameplayPlayerHud()
        end

        if ModCS.Game.GetGameFlags() & 8 ~= 0 then
            ModCS.Mode.PutIllust()
            ModCS.Mode.PutStripper()
            ModCS.Mode.ExecuteCreditsHud()
        end

        ModCS.Mode.ExecuteGameplayBelowTextBox()
        ModCS.Mode.PutTextScript()
        ModCS.Mode.ExecuteGameplayAboveTextBox()

        ModCS.Mode.ExecuteGameplayBelowPutFPS()
        ModCS.Mode.PutFPS()
        ModCS.Mode.ExecuteGameplayAbovePutFPS()

        if not ModCS.Mode.GameDrawLua() then
            return 0
        end

        if not ModCS.Mode.FlipSystemTask() then
            return 0
        end

        ModCS.Mode.IncrementgCounter()
    end

    return 0
end
