function ActMyChar_Normal()
	local max_move
	local max_dash
	local gravity1
	local gravity2
	local jump
	local dash1
	local dash2
	local resist

	local a, x

	-- Quit if hidden or dead
	if (ModCS.Player.CheckCond(2)) or ModCS.Player.cond == 0 then
		return
	end

	-- Set physics based on touching water or not
	if ModCS.Player.TouchWater() then
		max_dash = 0.79296875
		max_move = 1.4990234375
		gravity1 = 0.078125
		gravity2 = 0.03125
		jump = 1.25
		dash1 = 0.08333333333333333
		dash2 = 0.03125
		resist = 0.05
	else
		max_dash = 1.5859375
		max_move = 2.998046875
		gravity1 = 0.15625
		gravity2 = 0.0625
		jump = 2.5
		dash1 = 0.1666666666666667
		dash2 = 0.0625
		resist = 0.1
	end

	-- Don't create "?" effect
	ModCS.Player.ques = false

	-- If can't control player, stop boosting
	if not ModCS.Game.CanControl() then
		ModCS.Player.boost_sw = 0
	end

	-- Movement on the ground
	if (ModCS.Player.HitFlag(8)) or (ModCS.Player.HitFlag(0x10)) or (ModCS.Player.HitFlag(0x20)) then
		-- Stop boosting and refuel
		ModCS.Player.boost_sw = 0

		if ModCS.Player.HasEquipped(1) then
			ModCS.Player.boost_fuel = 50
		elseif ModCS.Player.HasEquipped(32) then
			ModCS.Player.boost_fuel = 50
		else
			ModCS.Player.boost_fuel = 0
		end

		-- Move in direction held
		if ModCS.Game.CanControl() then
			if ModCS.Key.GetKeyTrg() == 0x8 and ModCS.Key.GetKey() == 0x8 and not (ModCS.Player.CheckCond(1)) and not ModCS.Tsc.IsRunning() then
				ModCS.Player.SetCond(1)
				ModCS.Player.ques = true
			else
				if ModCS.Key.Left(true) and ModCS.Player.xm > -max_dash then
					ModCS.Player.xm = ModCS.Player.xm - dash1
				end

				if ModCS.Key.Right(true) and ModCS.Player.xm < max_dash then
					ModCS.Player.xm = ModCS.Player.xm + dash1
				end

				if ModCS.Key.Left(true) then
					ModCS.Player.direct = 0
				end

				if ModCS.Key.Right(true) then
					ModCS.Player.direct = 2
				end
			end
		end

		-- Friction
		if not (ModCS.Player.CheckCond(0x20)) then
			if ModCS.Player.xm < 0 then
				if ModCS.Player.xm > -resist then
					ModCS.Player.xm = 0
				else
					ModCS.Player.xm = ModCS.Player.xm + resist
				end
			end

			if ModCS.Player.xm > 0 then
				if ModCS.Player.xm < resist then
					ModCS.Player.xm = 0
				else
					ModCS.Player.xm = ModCS.Player.xm - resist
				end
			end
		end
	else -- In the air
		if ModCS.Game.CanControl() then
			if ModCS.Player.HasEquipped(1) or ModCS.Player.HasEquipped(32) then
				if ModCS.Key.Jump() and ModCS.Player.boost_fuel ~= 0 then
					-- Booster 0.8
					if ModCS.Player.HasEquipped(1) then
						ModCS.Player.boost_sw = 1

						if ModCS.Player.ym > 0.5 then
							ModCS.Player.ym = ModCS.Player.ym / 2
						end
					end

					-- Booster 2.0
					if ModCS.Player.HasEquipped(32) then
						if ModCS.Key.Up(true) then
							ModCS.Player.boost_sw = 2
							ModCS.Player.xm = 0
							ModCS.Player.ym = -2.998046875
						elseif ModCS.Key.Left(true) then
							ModCS.Player.boost_sw = 1
							ModCS.Player.ym = 0
							ModCS.Player.xm = -2.998046875
						elseif ModCS.Key.Right(true) then
							ModCS.Player.boost_sw = 1
							ModCS.Player.ym = 0
							ModCS.Player.xm = 2.998046875
						elseif ModCS.Key.Down(true) then
							ModCS.Player.boost_sw = 3
							ModCS.Player.xm = 0
							ModCS.Player.ym = 2.998046875
						else
							ModCS.Player.boost_sw = 2
							ModCS.Player.xm = 0
							ModCS.Player.ym = -2.998046875
						end
					end
				end
			end

			-- Move left and Right
			if ModCS.Key.Left(true) and ModCS.Player.xm > -max_dash then
				ModCS.Player.xm = ModCS.Player.xm - dash2
			end

			if ModCS.Key.Right(true) and ModCS.Player.xm < max_dash then
				ModCS.Player.xm = ModCS.Player.xm + dash2
			end

			if ModCS.Key.Left(true) then
				ModCS.Player.direct = 0
			end

			if ModCS.Key.Right(true) then
				ModCS.Player.direct = 2
			end
		end

		-- Slow down when stopped boosting (Booster 2.0)
		if ModCS.Player.HasEquipped(32) and ModCS.Player.boost_sw ~= 0 and not (ModCS.Key.Jump(true) and ModCS.Player.boost_fuel ~= 0) then
			if ModCS.Player.boost_sw == 1 then
				ModCS.Player.xm = ModCS.Player.xm / 2
			elseif ModCS.Player.boost_sw == 2 then
				ModCS.Player.ym = ModCS.Player.ym / 2
			end
		end

		-- Stop boosting
		if ModCS.Player.boost_fuel == 0 or not ModCS.Key.Jump(true) then
			ModCS.Player.boost_sw = 0
		end
	end

	-- Jumping
	if ModCS.Game.CanControl() then
		-- Look up and down
		if ModCS.Key.Up(true) then
			ModCS.Player.up = true
		else
			ModCS.Player.up = false
		end

		if ModCS.Key.Down(true) and not ModCS.Player.TouchFloor() then
			ModCS.Player.down = true
		else
			ModCS.Player.down = false
		end

		if ModCS.Key.Jump() and ((ModCS.Player.HitFlag(8)) or (ModCS.Player.HitFlag(0x10)) or (ModCS.Player.HitFlag(0x20))) then
			ModCS.Player.ym = -jump
			ModCS.Sound.Play(15)
		end
	end

	-- Stop interacting when moved
	if ModCS.Game.CanControl() then
		if ModCS.Key.Left(true) or ModCS.Key.Right(true) or ModCS.Key.Up(true) or ModCS.Key.Jump(true) or ModCS.Key.Shoot(true) then
			ModCS.Player.UnsetCond(1)
		end
	end

	-- Booster losing fuel
	if ModCS.Player.boost_sw ~= 0 and ModCS.Player.boost_fuel ~= 0 then
		ModCS.Player.boost_fuel = ModCS.Player.boost_fuel - 1
	end

	-- Wind / Current forces
	if (ModCS.Player.HitFlag(0x1000)) then
		ModCS.Player.xm = ModCS.Player.xm - 0.265625
	end

	if (ModCS.Player.HitFlag(0x2000)) then
		ModCS.Player.ym = ModCS.Player.ym - 0.25
	end

	if (ModCS.Player.HitFlag(0x4000)) then
		ModCS.Player.xm = ModCS.Player.xm + 0.265625
	end

	if (ModCS.Player.HitFlag(0x8000)) then
		ModCS.Player.ym = ModCS.Player.ym + 0.166015625
	end

	-- Booster 2.0 forces and effects
	if ModCS.Player.HasEquipped(32) and ModCS.Player.boost_sw ~= 0 then
		if ModCS.Player.boost_sw == 1 then
			-- Go up when going into a wall
			if (ModCS.Player.HitFlag(5)) then
				ModCS.Player.ym = -0.5
			end

			-- Move in direction facing
			if ModCS.Player.direct == 0 then
				ModCS.Player.xm = ModCS.Player.xm - 0.0625
			end

			if ModCS.Player.direct == 2 then
				ModCS.Player.xm = ModCS.Player.xm + 0.0625
			end

			-- Boost particles (and sound)
			if ModCS.Key.Jump() or ModCS.Player.boost_fuel % 3 == 1 then
				if ModCS.Player.direct == 0 then
					ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, ModCS.Player.x + 2, ModCS.Player.y + 2, 2)
				end

				if ModCS.Player.direct == 2 then
					ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, ModCS.Player.x - 2, ModCS.Player.y + 2, 0)
				end

				ModCS.Sound.Play(113)
			end
		elseif ModCS.Player.boost_sw == 2 then
			-- Move Upwards
			ModCS.Player.ym = ModCS.Player.ym - 0.0625

			-- Boost particles (and sound)
			if ModCS.Key.Jump() or ModCS.Player.boost_fuel % 3 == 1 then
				ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, ModCS.Player.x, ModCS.Player.y + 6, 3)
				ModCS.Sound.Play(113)
			end
		elseif ModCS.Player.boost_sw == 3 and (ModCS.Key.Jump() or ModCS.Player.boost_fuel % 3 == 1) then
			-- Boost particles (and sound)
			ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, ModCS.Player.x, ModCS.Player.y - 6, 1)
			ModCS.Sound.Play(113)
		end
	elseif (ModCS.Player.HitFlag(0x2000)) then
		-- Upwards wind/current
		ModCS.Player.ym = ModCS.Player.ym + gravity1
	elseif ModCS.Player.HasEquipped(1) and ModCS.Player.boost_sw ~= 0 and ModCS.Player.ym > -2 then
		-- Booster 0.8
		ModCS.Player.ym = ModCS.Player.ym - 0.0625

		if ModCS.Player.boost_fuel % 3 == 0 then
			ModCS.Caret.Spawn(ModCS.Const.CARET_EXHAUST, ModCS.Player.x, ModCS.Player.y + (ModCS.Player.GetHitbox().bottom / 2), 3) -- Could be finicky with ModCS!
			ModCS.Sound.Play(113)
		end
	elseif ModCS.Player.ym < 0 and ModCS.Game.CanControl() and ModCS.Key.Jump(true) then
		-- Gravity while jump is held
		ModCS.Player.ym = ModCS.Player.ym + gravity2
	else
		-- Normal Gravity
		ModCS.Player.ym = ModCS.Player.ym + gravity1
	end

	-- Keep player on slopes
	if not ModCS.Game.CanControl() or not ModCS.Key.Jump() then
		if ModCS.Player.HitFlag(0x10) and ModCS.Player.xm < 0 then
			ModCS.Player.ym = -ModCS.Player.xm
		end

		if ModCS.Player.HitFlag(0x20) and ModCS.Player.xm > 0 then
			ModCS.Player.ym = ModCS.Player.xm
		end

		if ModCS.Player.HitFlag(8) and ModCS.Player.HitFlag(0x80000) and ModCS.Player.xm < 0 then
			ModCS.Player.ym = 2
		end

		if ModCS.Player.HitFlag(8) and ModCS.Player.HitFlag(0x10000)and ModCS.Player.xm > 0 then
			ModCS.Player.ym = 2
		end

		if ModCS.Player.HitFlag(8) and ModCS.Player.HitFlag(0x20000) and ModCS.Player.HitFlag(0x40000) then
			ModCS.Player.ym = 2
		end
	end

	-- Limit speed
	if ModCS.Player.TouchWater() and not ModCS.Player.HitFlag(0xF000) then
		if ModCS.Player.xm < -1.498046875 then
			ModCS.Player.xm = -1.498046875
		end

		if ModCS.Player.xm > 1.498046875 then
			ModCS.Player.xm = 1.498046875
		end

		if ModCS.Player.ym < -1.498046875 then
			ModCS.Player.ym = -1.498046875
		end

		if ModCS.Player.ym > 1.498046875 then
			ModCS.Player.ym = 1.498046875
		end
	else
		if ModCS.Player.xm < -2.998046875 then
			ModCS.Player.xm = -2.998046875
		end

		if ModCS.Player.xm > 2.998046875 then
			ModCS.Player.xm = 2.998046875
		end

		if ModCS.Player.ym < -2.998046875 then
			ModCS.Player.ym = -2.998046875
		end

		if ModCS.Player.ym > 2.998046875 then
			ModCS.Player.ym = 2.998046875
		end
	end

	-- Water splashing
	if not ModCS.Player.splash and ModCS.Player.TouchWater() then
		local dir

		if (ModCS.Player.HitFlag(0x800)) then
			dir = 2
		else
			dir = 0
		end

		if not ModCS.Player.TouchFloor() and ModCS.Player.ym > 1 then
			for a = 0, 7 do
				x = ModCS.Player.x + ModCS.Game.Random2(-8, 8)
				ModCS.Npc.Spawn2(73, x, ModCS.Player.y, ModCS.Player.xm + ModCS.Game.Random2(-1, 1), ModCS.Game.Random2(-1, 0.25) - (ModCS.Player.ym / 2), dir, 0)
			end

			ModCS.Sound.Play(56)
		else
			if ModCS.Player.xm > 1 or ModCS.Player.xm < -1 then
				for a = 0, 7 do
					x = ModCS.Player.x + ModCS.Game.Random2(-8, 8)
					ModCS.Npc.Spawn2(73, x, ModCS.Player.y, ModCS.Player.xm + ModCS.Game.Random2(-1, 1), ModCS.Game.Random2(-1, 0.25) - (ModCS.Player.ym / 2), dir, 0)
				end

				ModCS.Sound.Play(56)
			end
		end

		ModCS.Player.splash = true
	end

	if not ModCS.Player.TouchWater() then
		ModCS.Player.splash = false
	end

	-- Spike damage
	if (ModCS.Player.HitFlag(0x400)) then
		ModCS.Player.Damage(10)
	end

	-- Camera
	if ModCS.Player.direct == 0 then
		ModCS.Player.index_x = ModCS.Player.index_x - 1
		if ModCS.Player.index_x < -64 then
			ModCS.Player.index_x = -64
		end
	else
		ModCS.Player.index_x = ModCS.Player.index_x + 1
		if ModCS.Player.index_x > 64 then
			ModCS.Player.index_x = 64
		end
	end

	if ModCS.Key.Up(true) and ModCS.Game.CanControl() then
		ModCS.Player.index_y = ModCS.Player.index_y - 1
		if ModCS.Player.index_y < -64 then
			ModCS.Player.index_y = -64
		end
	elseif ModCS.Key.Down(true) and ModCS.Game.CanControl() then
		ModCS.Player.index_y = ModCS.Player.index_y + 1
		if ModCS.Player.index_y > 64 then
			ModCS.Player.index_y = 64
		end
	else
		if ModCS.Player.index_y > 1 then
			ModCS.Player.index_y = ModCS.Player.index_y - 1
		end

		if ModCS.Player.index_y < -1 then
			ModCS.Player.index_y = ModCS.Player.index_y + 1
		end
	end

	ModCS.Player.tgt_x = ModCS.Player.x + ModCS.Player.index_x
	ModCS.Player.tgt_y = ModCS.Player.y + ModCS.Player.index_y

	-- Change position
	ModCS.Player.x = ModCS.Player.x + ModCS.Player.xm
	ModCS.Player.y = ModCS.Player.y + ModCS.Player.ym
end

function ActMyChar_Stream()
	ModCS.Player.up = false
	ModCS.Player.down = false

	if ModCS.Game.CanControl() then
		if ModCS.Key.Left(true) or ModCS.Key.Right(true) then
			if ModCS.Key.Left(true) then
				ModCS.Player.xm = ModCS.Player.xm - 0.5
			end

			if ModCS.Key.Right(true) then
				ModCS.Player.xm = ModCS.Player.xm + 0.5
			end
		elseif ModCS.Player.xm < 0.25 and ModCS.Player.xm > -0.25 then
			ModCS.Player.xm = 0
		elseif ModCS.Player.xm > 0 then
			ModCS.Player.xm = ModCS.Player.xm - 0.25
		elseif ModCS.Player.xm < 0 then
			ModCS.Player.xm = ModCS.Player.xm + 0.25
		end

		if ModCS.Key.Up(true) or ModCS.Key.Down(true) then
			if ModCS.Key.Up(true) then
				ModCS.Player.ym = ModCS.Player.ym - 0.5
			end

			if ModCS.Key.Down(true) then
				ModCS.Player.ym = ModCS.Player.ym + 0.5
			end
		elseif ModCS.Player.ym < 0.25 and ModCS.Player.ym > -0.25 then
			ModCS.Player.ym = 0
		elseif ModCS.Player.ym > 0 then
			ModCS.Player.ym = ModCS.Player.ym - 0.25
		elseif ModCS.Player.ym < 0 then
			ModCS.Player.ym = ModCS.Player.ym + 0.25
		end
	else
		if ModCS.Player.xm < 0.25 and ModCS.Player.xm > -0.125 then
			ModCS.Player.xm = 0
		elseif ModCS.Player.xm > 0 then
			ModCS.Player.xm = ModCS.Player.xm - 0.25
		elseif ModCS.Player.xm < 0 then
			ModCS.Player.xm = ModCS.Player.xm + 0.25
		end

		if ModCS.Player.ym < 0.25 and ModCS.Player.ym > -0.125 then
			ModCS.Player.ym = 0
		elseif ModCS.Player.ym > 0 then
			ModCS.Player.ym = ModCS.Player.ym - 0.25
		elseif ModCS.Player.ym < 0 then
			ModCS.Player.ym = ModCS.Player.ym + 0.25
		end
	end

	if ModCS.Player.xm > 2 then
		ModCS.Player.xm = 2
	end

	if ModCS.Player.xm < -2 then
		ModCS.Player.xm = -2
	end

	if ModCS.Player.ym > 2 then
		ModCS.Player.ym = 2
	end

	if ModCS.Player.ym < -2 then
		ModCS.Player.ym = -2
	end

	-- left + up
	if ModCS.Key.Left(true) and ModCS.Key.Up(true) then
		if ModCS.Player.xm < -1.5234375 then
			ModCS.Player.xm = -1.5234375
		end
		if ModCS.Player.ym < -1.5234375 then
			ModCS.Player.ym = -1.5234375
		end
	end

	-- right + up
	if ModCS.Key.Right(true) and ModCS.Key.Up(true) then
		if ModCS.Player.xm > 1.5234375 then
			ModCS.Player.xm = 1.5234375
		end
		if ModCS.Player.ym < -1.5234375 then
			ModCS.Player.ym = -1.5234375
		end
	end

	-- left + down
	if ModCS.Key.Left(true) and ModCS.Key.Down(true) then
		if ModCS.Player.xm < -1.5234375 then
			ModCS.Player.xm = -1.5234375
		end
		if ModCS.Player.ym > 1.5234375 then
			ModCS.Player.ym = 1.5234375
		end
	end

	-- right + down
	if ModCS.Key.Right(true) and ModCS.Key.Down(true) then
		if ModCS.Player.xm > 1.5234375 then
			ModCS.Player.xm = 1.5234375
		end
		if ModCS.Player.ym > 1.5234375 then
			ModCS.Player.ym = 1.5234375
		end
	end

	ModCS.Player.x = ModCS.Player.x + ModCS.Player.xm
	ModCS.Player.y = ModCS.Player.y + ModCS.Player.ym
end

function ModCS.Player.Act()
    if not (ModCS.Player.CheckCond(0x80)) then
        return
    end

    if (ModCS.Player.exp_wait ~= 0) then
        ModCS.Player.exp_wait = ModCS.Player.exp_wait - 1
    end

    if (ModCS.Player.shock ~= 0) then
        ModCS.Player.shock = ModCS.Player.shock - 1
    elseif (ModCS.Player.exp_count ~= 0) then
        ModCS.ValueView.SetPlayer(ModCS.Player.exp_count)
        ModCS.Player.exp_count = 0
    end

    if (ModCS.Player.unit == 0) then
        if (not ModCS.Tsc.IsRunning()) and ModCS.Game.CanControl() then
            ModCS.Player.ProcessAir()
        end

        ActMyChar_Normal()
    elseif (ModCS.Player.unit == 1) then
        ActMyChar_Stream()
    end

	ModCS.Player.UnsetCond(0x20)
end
