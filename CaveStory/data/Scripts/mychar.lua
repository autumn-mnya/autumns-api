local splash = false

function PlayerMovementRecreation()
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
	if (ModCS.Player.cond & 2 ~= 0) or ModCS.Player.cond == 0 then
		return
	end

	-- Set physics based on touching water or not
	if ModCS.Player.TouchWater() then
		max_dash = 0x32C / 2
		max_move = 0x5FF / 2
		gravity1 = 0x50 / 2
		gravity2 = 0x20 / 2
		jump = 0x500 / 2
		dash1 = 0x200 / 6 / 2
		dash2 = 0x200 / 16 / 2
		resist = 0x200 / 10 / 2
	else
		max_dash = 0x32C
		max_move = 0x5FF
		gravity1 = 0x50
		gravity2 = 0x20
		jump = 0x500
		dash1 = 0x200 / 6
		dash2 = 0x200 / 16
		resist = 0x200 / 10
	end
	
	-- Don't create "?" effect
	ModCS.Player.ques = 0
	
	-- If can't control player, stop boosting
	if not ModCS.Game.CanControl() then
		ModCS.Player.boost_sw = 0
	end
	
	-- Movement on the ground
	if (ModCS.Player.hit_flag & 8 ~= 0) or (ModCS.Player.hit_flag & 0x10 ~= 0) or (ModCS.Player.hit_flag & 0x20 ~= 0) then
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
			if ModCS.Key.GetKeyTrg() == 0x8 and ModCS.Key.GetKey() == 0x8 and not (ModCS.Player.cond & 1 ~= 0) and not ModCS.Tsc.IsRunning() then
				ModCS.Player.cond = ModCS.Player.cond | 1
				ModCS.Player.ques = 1
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
		if not (ModCS.Player.cond & 0x20 ~= 0) then
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
						
						if ModCS.Player.ym > 0x100 then
							ModCS.Player.ym = ModCS.Player.ym / 2
						end
					end
					
					-- Booster 2.0
					if ModCS.Player.HasEquipped(32) then
						if ModCS.Key.Up(true) then
							ModCS.Player.boost_sw = 2
							ModCS.Player.xm = 0
							ModCS.Player.ym = -0x5FF
						elseif ModCS.Key.Left(true) then
							ModCS.Player.boost_sw = 1
							ModCS.Player.ym = 0
							ModCS.Player.xm = -0x5FF
						elseif ModCS.Key.Right(true) then
							ModCS.Player.boost_sw = 1
							ModCS.Player.ym = 0
							ModCS.Player.xm = 0x5FF
						elseif ModCS.Key.Down(true) then
							ModCS.Player.boost_sw = 3
							ModCS.Player.xm = 0
							ModCS.Player.ym = 0x5FF
						else
							ModCS.Player.boost_sw = 2
							ModCS.Player.xm = 0
							ModCS.Player.ym = -0x5FF	
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
			ModCS.Player.up = 1
		else
			ModCS.Player.up = 0
		end
		
		if ModCS.Key.Down(true) and not ModCS.Player.TouchFloor() then
			ModCS.Player.down = 1
		else
			ModCS.Player.down = 0
		end
		
		if ModCS.Key.Jump() and ((ModCS.Player.hit_flag & 8 ~= 0) or (ModCS.Player.hit_flag & 0x10 ~= 0) or (ModCS.Player.hit_flag & 0x20 ~= 0)) then
			ModCS.Player.ym = -jump
			ModCS.Sound.Play(15)
		end
	end

	-- Stop interacting when moved
	if ModCS.Game.CanControl() then
		if ModCS.Key.Left(true) or ModCS.Key.Right(true) or ModCS.Key.Up(true) or ModCS.Key.Jump(true) or ModCS.Key.Shoot(true) then
			ModCS.Player.cond = ModCS.Player.cond & ~1
		end
	end
	
	-- Booster losing fuel
	if ModCS.Player.boost_sw ~= 0 and ModCS.Player.boost_fuel ~= 0 then
		ModCS.Player.boost_fuel = ModCS.Player.boost_fuel - 1
	end
	
	-- Wind / Current forces
	if (ModCS.Player.hit_flag & 0x1000 ~= 0) then
		ModCS.Player.xm = ModCS.Player.xm - 0x88
	end
	
	if (ModCS.Player.hit_flag & 0x2000 ~= 0) then
		ModCS.Player.ym = ModCS.Player.ym - 0x80
	end
	
	if (ModCS.Player.hit_flag & 0x4000 ~= 0) then
		ModCS.Player.xm = ModCS.Player.xm + 0x88
	end
	
	if (ModCS.Player.hit_flag & 0x8000 ~= 0) then
		ModCS.Player.ym = ModCS.Player.ym + 0x55
	end
	
	-- Booster 2.0 forces and effects
	if ModCS.Player.HasEquipped(32) and ModCS.Player.boost_sw ~= 0 then
		if ModCS.Player.boost_sw == 1 then
			-- Go up when going into a wall
			if (ModCS.Player.hit_flag & 5 ~= 0) then
				ModCS.Player.ym = -0x100
			end
			
			-- Move in direction facing
			if ModCS.Player.direct == 0 then
				ModCS.Player.xm = ModCS.Player.xm - 0x20
			end
			
			if ModCS.Player.direct == 2 then
				ModCS.Player.xm = ModCS.Player.xm + 0x20
			end
			
			-- Boost particles (and sound)
			if ModCS.Key.Jump() or ModCS.Player.boost_fuel % 3 == 1 then
				if ModCS.Player.direct == 0 then
					ModCS.Caret.Spawn(7, ModCS.Player.x + 2, ModCS.Player.y + 2, 2)
				end
				
				if ModCS.Player.direct == 2 then
					ModCS.Caret.Spawn(7, ModCS.Player.x - 2, ModCS.Player.y + 2, 0)
				end
				
				ModCS.Sound.Play(113)
			end
		elseif ModCS.Player.boost_sw == 2 then
			-- Move Upwards
			ModCS.Player.ym = ModCS.Player.ym - 0x20
			
			-- Boost particles (and sound)
			if ModCS.Key.Jump() or ModCS.Player.boost_fuel % 3 == 1 then
				ModCS.Caret.Spawn(7, ModCS.Player.x, ModCS.Player.y + 6, 3)
				ModCS.Sound.Play(113)
			end
		elseif ModCS.Player.boost_sw == 3 and (ModCS.Key.Jump() or ModCS.Player.boost_fuel % 3 == 1) then
			-- Boost particles (and sound)
			ModCS.Caret.Spawn(7, ModCS.Player.x, ModCS.Player.y - 6, 1)
			ModCS.Sound.Play(113)
		end
	elseif (ModCS.Player.hit_flag & 0x2000 ~= 0) then
		-- Upwards wind/current
		ModCS.Player.ym = ModCS.Player.ym + gravity1
	elseif ModCS.Player.HasEquipped(1) and ModCS.Player.boost_sw ~= 0 and ModCS.Player.ym > -0x400 then
		-- Booster 0.8
		ModCS.Player.ym = ModCS.Player.ym - 0x20
		
		if ModCS.Player.boost_fuel % 3 == 0 then
			ModCS.Caret.Spawn(7, ModCS.Player.x, ModCS.Player.y + (ModCS.Player.GetHitbox().bottom / 2), 3) -- Could be finicky with ModCS!
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
		if (ModCS.Player.hit_flag & 0x10) ~= 0 and ModCS.Player.xm < 0 then
			ModCS.Player.ym = -ModCS.Player.xm
		end

		if (ModCS.Player.hit_flag & 0x20) ~= 0 and ModCS.Player.xm > 0 then
			ModCS.Player.ym = ModCS.Player.xm
		end
		
		if (ModCS.Player.hit_flag & 0x8) ~= 0 and (ModCS.Player.hit_flag & 0x80000) ~= 0 and ModCS.Player.xm < 0 then
			ModCS.Player.ym = 0x400
		end
		
		if (ModCS.Player.hit_flag & 0x8) ~= 0 and (ModCS.Player.hit_flag & 0x10000) ~= 0 and ModCS.Player.xm > 0 then
			ModCS.Player.ym = 0x400
		end
		
		if (ModCS.Player.hit_flag & 0x8) ~= 0 and (ModCS.Player.hit_flag & 0x20000) ~= 0 and (ModCS.Player.hit_flag & 0x40000) ~= 0 then
			ModCS.Player.ym = 0x400
		end
	end

	-- Limit speed
	if ModCS.Player.TouchWater() and not (ModCS.Player.hit_flag & 0xF000 ~= 0) then
		if ModCS.Player.xm < -0x2FF then
			ModCS.Player.xm = -0x2FF
		end
		
		if ModCS.Player.xm > 0x2FF then
			ModCS.Player.xm = 0x2FF
		end
		
		if ModCS.Player.ym < -0x2FF then
			ModCS.Player.ym = -0x2FF
		end
		
		if ModCS.Player.ym > 0x2FF then
			ModCS.Player.ym = 0x2FF
		end
	else
		if ModCS.Player.xm < -0x5FF then
			ModCS.Player.xm = -0x5FF
		end
		
		if ModCS.Player.xm > 0x5FF then
			ModCS.Player.xm = 0x5FF
		end
		
		if ModCS.Player.ym < -0x5FF then
			ModCS.Player.ym = -0x5FF
		end
		
		if ModCS.Player.ym > 0x5FF then
			ModCS.Player.ym = 0x5FF
		end
	end
	
	-- Water splashing
	if not splash and ModCS.Player.TouchWater() then
		local dir
		
		if (ModCS.Player.hit_flag & 0x800 ~= 0) then
			dir = 2
		else
			dir = 0
		end
		
		if not ModCS.Player.TouchFloor() and ModCS.Player.ym > 0x200 then
			for a = 0, 7 do
				x = ModCS.Player.x + math.random(-8, 8)
				ModCS.Npc.Spawn2(73, x, ModCS.Player.y, ModCS.Player.xm + math.random(-0x200, 0x200), math.random(-0x200, 0x80) - (ModCS.Player.ym / 2), dir, 0)
			end
			
			ModCS.Sound.Play(56)
		else
			if ModCS.Player.xm > 0x200 or ModCS.Player.xm < -0x200 then
				for a = 0, 7 do
					x = ModCS.Player.x + math.random(-8, 8)
					ModCS.Npc.Spawn2(73, x, ModCS.Player.y, ModCS.Player.xm + math.random(-0x200, 0x200), math.random(-0x200, 0x80) - (ModCS.Player.ym / 2), dir, 0)
				end
				
				ModCS.Sound.Play(56)
			end
		end
		
		splash = true
	end
	
	if not ModCS.Player.TouchWater() then
		splash = false
	end
	
	-- Spike damage
	if (ModCS.Player.hit_flag & 0x400 ~= 0) then
		ModCS.Player.Damage(10)
	end
	
	-- Camera
	if ModCS.Player.direct == 0 then
		ModCS.Player.index_x = ModCS.Player.index_x - 0x200
		if ModCS.Player.index_x < -0x8000 then
			ModCS.Player.index_x = -0x8000
		end
	else
		ModCS.Player.index_x = ModCS.Player.index_x + 0x200
		if ModCS.Player.index_x > 0x8000 then
			ModCS.Player.index_x = 0x8000
		end
	end
	
	if ModCS.Key.Up(true) and ModCS.Game.CanControl() then
		ModCS.Player.index_y = ModCS.Player.index_y - 0x200
		if ModCS.Player.index_y < -0x8000 then
			ModCS.Player.index_y = -0x8000
		end
	elseif ModCS.Key.Down(true) and ModCS.Game.CanControl() then
		ModCS.Player.index_y = ModCS.Player.index_y + 0x200
		if ModCS.Player.index_y > 0x8000 then
			ModCS.Player.index_y = 0x8000
		end
	else
		if ModCS.Player.index_y > 0x200 then
			ModCS.Player.index_y = ModCS.Player.index_y - 0x200
		end
		
		if ModCS.Player.index_y < -0x200 then
			ModCS.Player.index_y = ModCS.Player.index_y + 0x200
		end
	end
	
	ModCS.Player.tgt_x = (ModCS.Player.x * 512) + ModCS.Player.index_x
	ModCS.Player.tgt_y = (ModCS.Player.y * 512) + ModCS.Player.index_y
	
	-- Change position
	ModCS.Player.x = ModCS.Player.x + ModCS.Player.xm / 512
	ModCS.Player.y = ModCS.Player.y + ModCS.Player.ym / 512
end