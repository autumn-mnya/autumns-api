-- weapon variables
local bul = 0
local level = 0
wait = 0

-- Reset Wait timer
function ResetWait()
	wait = 0
end

-- Cleaner way for me to set bullets levels. Cleans up the code a slight bit.
function LevelCheck(a, b, c)
	level = ModCS.Arms.GetCurrent().level
	
	if level == 1 then
		bul = a
	elseif level == 2 then
		bul = b
	elseif level == 3 then
		bul = c
	end
end

-- Snake port
ModCS.Arms.Shoot[1] = function()
	LevelCheck(1, 2, 3)
	
	if ModCS.Arms.CountBullet(1) > 3 then
		return
	end
		
	if ModCS.Key.Shoot() then
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Arms.SwitchFirst()
		else
			if ModCS.Player.IsLookingUp() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y - 10, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 3, ModCS.Player.y - 10, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 3, ModCS.Player.y - 10, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 3, ModCS.Player.y - 10, 0)
				end
			elseif ModCS.Player.IsLookingDown() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y + 10, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 3, ModCS.Player.y + 10, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 3, ModCS.Player.y + 10, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 3, ModCS.Player.y + 10, 0)
				end
			else
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 6, ModCS.Player.y + 2, 0)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 2, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 6, ModCS.Player.y + 2, 2)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 2, 0)
				end
			end
			
			ModCS.Sound.Play(33)
		end
	end
end

-- Polar Star port
ModCS.Arms.Shoot[2] = function()
	LevelCheck(4, 5, 6)
	
	if ModCS.Arms.CountBullet(2) > 1 then
		return
	end
	
	if ModCS.Key.Shoot() then
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Sound.Play(37)
		else
			if ModCS.Player.IsLookingUp() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y - 8, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y - 8, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y - 8, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y - 8, 0)
				end
			elseif ModCS.Player.IsLookingDown() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y + 8, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y + 8, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y + 8, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y + 8, 0)
				end
			else
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 6, ModCS.Player.y + 3, 0)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 3, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 6, ModCS.Player.y + 3, 2)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 3, 0)
				end
			end
			
			if level == 3 then
				ModCS.Sound.Play(49)
			else
				ModCS.Sound.Play(32)
			end
		end
	end
end

-- Fireball port
ModCS.Arms.Shoot[3] = function()
	LevelCheck(7, 8, 9)
	
	if level == 1 then
		if ModCS.Arms.CountBullet(3) > 1 then
			return
		end
	elseif level == 2 then
		if ModCS.Arms.CountBullet(3) > 2 then
			return
		end
	elseif level == 3 then
		if ModCS.Arms.CountBullet(3) > 3 then
			return
		end
	end
	
	if ModCS.Key.Shoot() then
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Arms.SwitchFirst()
		else
			if ModCS.Player.IsLookingUp() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 4, ModCS.Player.y - 8, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 4, ModCS.Player.y - 8, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 4, ModCS.Player.y - 8, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 4, ModCS.Player.y - 8, 0)
				end
			elseif ModCS.Player.IsLookingDown() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 4, ModCS.Player.y + 8, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 4, ModCS.Player.y + 8, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 4, ModCS.Player.y + 8, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 4, ModCS.Player.y + 8, 0)
				end
			else
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 6, ModCS.Player.y + 2, 0)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 2, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 6, ModCS.Player.y + 2, 2)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 2, 0)
				end
			end
			
			ModCS.Sound.Play(34)
		end
	end
end

-- Machine Gun port
ModCS.Arms.Shoot[4] = function()
	LevelCheck(10, 11, 12)

	if not ModCS.Key.Shoot(true) then
		ModCS.Player.fire_rate = 5
	end
	
	if (ModCS.Key.Shoot(true)) then
		if ModCS.Player.fire_rate < 5 then
			ModCS.Player.fire_rate = ModCS.Player.fire_rate + 1
			return
		end

		ModCS.Player.fire_rate = 0
			
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Sound.Play(37)
			
			if ModCS.Player.ammo_empty == 0 then
				ModCS.Caret.Spawn(16, ModCS.Player.x, ModCS.Player.y, 0)
				ModCS.Player.ammo_empty = 50
			end
			
			return
		end
		
		if ModCS.Player.IsLookingUp() then
			if level == 3 then
				ModCS.Player.ym = ModCS.Player.ym + 256
			end
				
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y - 8 , 1)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 3, ModCS.Player.y - 8, 0)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x + 3 , ModCS.Player.y - 8 , 1)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 3, ModCS.Player.y - 8, 0)
			end
		elseif ModCS.Player.IsLookingDown() then
			if level == 3 then
				if ModCS.Player.ym > 0 then
					ModCS.Player.ym = ModCS.Player.ym / 2
				end
				
				if ModCS.Player.ym > -1024 then
					ModCS.Player.ym = ModCS.Player.ym - 512
					
					if ModCS.Player.ym < -1024 then
						ModCS.Player.ym = -1024
					end
				end
			end
			
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y + 8, 3)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 3, ModCS.Player.y + 8, 0)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y + 8, 3)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 3, ModCS.Player.y + 8, 0)
			end
		else
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 12, ModCS.Player.y + 3, 0)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 3, 0)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x + 12, ModCS.Player.y + 3, 2)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 3, 0)
			end
		end
		
		if level == 3 then
			ModCS.Sound.Play(49)
		else
			ModCS.Sound.Play(32)
		end
	else
		wait = wait + 1
		
		if ModCS.Player.HasEquipped(8) then
			if wait > 1 then
				wait = 0
				ModCS.Arms.AddAmmo(1)
			end
		else
			if wait == 4 then
				wait = 0
				ModCS.Arms.AddAmmo(1)
			end
		end
	end
end

function MissileLauncher(super)
	if super then
		LevelCheck(28, 29, 30)
		
		if level == 1 then
			if ModCS.Arms.CountBullet(10) > 0 then
				return
			end
			
			if ModCS.Arms.CountBullet(11) > 0 then
				return
			end
		elseif level == 2 then
			if ModCS.Arms.CountBullet(10) > 1 then
				return
			end
			
			if ModCS.Arms.CountBullet(11) > 1 then
				return
			end
		elseif level == 3 then
			if ModCS.Arms.CountBullet(10) > 3 then
				return
			end
			
			if ModCS.Arms.CountBullet(11) > 3 then
				return
			end
		end
	else
		LevelCheck(13, 14, 15)
		
		if level == 1 then
			if ModCS.Arms.CountBullet(5) > 0 then
				return
			end
			
			if ModCS.Arms.CountBullet(6) > 0 then
				return
			end
		elseif level == 2 then
			if ModCS.Arms.CountBullet(5) > 1 then
				return
			end
			
			if ModCS.Arms.CountBullet(6) > 1 then
				return
			end
		elseif level == 3 then
			if ModCS.Arms.CountBullet(5) > 3 then
				return
			end
			
			if ModCS.Arms.CountBullet(6) > 3 then
				return
			end
		end
	end
	
	if ModCS.Key.Shoot() then
		if level < 3 then
			if not ModCS.Arms.UseAmmo(1) then
				ModCS.Sound.Play(37)
				
				if ModCS.Player.ammo_empty == 0 then
					ModCS.Caret.Spawn(16, ModCS.Player.x, ModCS.Player.y, 0)
					ModCS.Player.ammo_empty = 50
				end
				
				return
			end
			
			if ModCS.Player.IsLookingUp() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y - 8, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y - 8, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y - 8, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y - 8, 0)
				end
			elseif ModCS.Player.IsLookingDown() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y + 8, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y + 8, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y + 8, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y + 8, 0)
				end
			else
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 6, ModCS.Player.y, 0)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 6, ModCS.Player.y, 2)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y, 0)
				end
			end
		else -- level is 3
			if not ModCS.Arms.UseAmmo(1) then
				ModCS.Sound.Play(37)
				
				if ModCS.Player.ammo_empty == 0 then
					ModCS.Caret.Spawn(16, ModCS.Player.x, ModCS.Player.y, 0)
					ModCS.Player.ammo_empty = 50
				end
				
				return
			end
			
			if ModCS.Player.IsLookingUp() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y - 8, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y - 8, 0)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 3, ModCS.Player.y, 1)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y, 1)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y - 8, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y - 8, 0)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 3, ModCS.Player.y, 1)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y, 1)
				end
			elseif ModCS.Player.IsLookingDown() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y + 8, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y + 8, 0)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 3, ModCS.Player.y, 3)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y, 3)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y + 8, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y + 8, 0)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 3, ModCS.Player.y, 3)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 3, ModCS.Player.y, 3)
				end
			else
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 6, ModCS.Player.y + 1, 0)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 1, 0)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x, ModCS.Player.y - 8, 0)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 4, ModCS.Player.y - 1, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 6, ModCS.Player.y + 1, 2)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 1, 0)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x, ModCS.Player.y - 8, 2)
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 4, ModCS.Player.y - 1, 2)
				end
			end
		end
		
		ModCS.Sound.Play(32)
	end
end

-- Missile Launcher port
ModCS.Arms.Shoot[5] = function()
	MissileLauncher(false)
end

-- Bubbler Level 1 code
function Bubbler1()
	bul = 19
	
	if ModCS.Arms.CountBullet(7) > 3 then
		return
	end
	
	if ModCS.Key.Shoot() then
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Sound.Play(37)
			
			if ModCS.Player.ammo_empty == 0 then
				ModCS.Caret.Spawn(16, ModCS.Player.x, ModCS.Player.y, 0)
				ModCS.Player.ammo_empty = 50
			end
				
			return
		end
		
		if ModCS.Player.IsLookingUp() then
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y - 2, 1)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y - 2, 0)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y - 2, 1)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y - 2, 0)
			end
		elseif ModCS.Player.IsLookingDown() then
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y + 2, 3)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y + 2, 0)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y + 2, 3)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y + 2, 0)
			end
		else
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 6, ModCS.Player.y + 3, 0)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 3, 0)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x + 6, ModCS.Player.y + 3, 2)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 3, 0)
			end
		end
		
		ModCS.Sound.Play(48)
	elseif wait ~= nil then
		wait = wait + 1
		if wait > 20 then
			wait = 0
			ModCS.Arms.AddAmmo(1)
		end
	end
end

-- Bubbler Level 2 and 3 code
function Bubbler2(num)
	if ModCS.Arms.CountBullet(7) > 15 then
		return
	end
	
	num = num + 18
	
	if not ModCS.Key.Shoot(true) then
		ModCS.Player.fire_rate = 5
	end
	
	if ModCS.Key.Shoot(true) then
		if ModCS.Player.fire_rate < 6 then
			ModCS.Player.fire_rate = ModCS.Player.fire_rate + 1
			return
		end
		
		ModCS.Player.fire_rate = 0
		
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Sound.Play(37)
			
			if ModCS.Player.ammo_empty == 0 then
				ModCS.Caret.Spawn(16, ModCS.Player.x, ModCS.Player.y, 0)
				ModCS.Player.ammo_empty = 50
			end
				
			return
		end
		
		if ModCS.Player.IsLookingUp() then
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(num, ModCS.Player.x - 3, ModCS.Player.y - 8, 1)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 3, ModCS.Player.y - 16, 0)
			else
				ModCS.Bullet.Spawn(num, ModCS.Player.x + 3, ModCS.Player.y - 8, 1)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 3, ModCS.Player.y - 16, 0)
			end
		elseif ModCS.Player.IsLookingDown() then
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(num, ModCS.Player.x - 3, ModCS.Player.y + 8, 3)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 3, ModCS.Player.y + 16, 0)
			else
				ModCS.Bullet.Spawn(num, ModCS.Player.x + 3, ModCS.Player.y + 8, 3)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 3, ModCS.Player.y + 16, 0)
			end
		else
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(num, ModCS.Player.x - 6, ModCS.Player.y + 3, 0)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 3, 0)
			else
				ModCS.Bullet.Spawn(num, ModCS.Player.x + 6, ModCS.Player.y + 3, 2)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 3, 0)
			end
		end
		
		ModCS.Sound.Play(48)
	elseif wait ~= nil then
		wait = wait + 1
		if wait > 1 then
			wait = 0
			ModCS.Arms.AddAmmo(1)
		end
	end
end

-- Bubbler port
ModCS.Arms.Shoot[7] = function()
	level = ModCS.Arms.GetCurrent().level
	
	if level == 1 then
		Bubbler1()
	else
		Bubbler2(level)
	end
end

-- Blade port
ModCS.Arms.Shoot[9] = function()
	if ModCS.Arms.CountBullet(9) > 0 then
		return
	end
	
	LevelCheck(25, 26, 27)
	
	if ModCS.Key.Shoot() then
		if ModCS.Player.IsLookingUp() then
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y + 4, 1)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y + 4, 1)
			end
		elseif ModCS.Player.IsLookingDown() then
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y - 4, 3)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y - 4, 3)
			end
		else
			if ModCS.Player.direct == 0 then
				ModCS.Bullet.Spawn(bul, ModCS.Player.x + 6, ModCS.Player.y - 3, 0)
			else
				ModCS.Bullet.Spawn(bul, ModCS.Player.x - 6, ModCS.Player.y - 3, 2)
			end
		end
		
		ModCS.Sound.Play(34)
	end
end

-- Super Missile port
ModCS.Arms.Shoot[10] = function()
	MissileLauncher(true)
end

-- Nemesis port
ModCS.Arms.Shoot[12] = function()
	LevelCheck(34, 35, 36)
	
	if ModCS.Arms.CountBullet(12) > 1 then
		return
	end
	
	if ModCS.Key.Shoot() then
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Sound.Play(37)
		else
			if ModCS.Player.IsLookingUp() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y - 12, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y - 12, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y - 12, 1)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y - 12, 0)
				end
			elseif ModCS.Player.IsLookingDown() then
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y + 12, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y + 12, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y + 12, 3)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y + 12, 0)
				end
			else
				if ModCS.Player.direct == 0 then
					ModCS.Bullet.Spawn(bul, ModCS.Player.x - 22, ModCS.Player.y + 3, 0)
					ModCS.Caret.Spawn(3, ModCS.Player.x - 16, ModCS.Player.y + 3, 0)
				else
					ModCS.Bullet.Spawn(bul, ModCS.Player.x + 22, ModCS.Player.y + 3, 2)
					ModCS.Caret.Spawn(3, ModCS.Player.x + 16, ModCS.Player.y + 3, 0)
				end
			end
			
			if level == 1 then
				ModCS.Sound.Play(117)
			elseif level == 2 then
				ModCS.Sound.Play(49)
			elseif level == 3 then
				ModCS.Sound.Play(60)
			end
		end
	end
end

spur_charge = 0
spur_id = 13

-- used elsewhere
function ResetSpurCharge()
	spur_charge = 0
	if ModCS.Arms.GetCurrent().id == spur_id then
		ModCS.Arms.ResetCurrentExp()
	end
end

local bshot = false
local bmax = false

-- Spur port
ModCS.Arms.Shoot[13] = function()
    level = ModCS.Arms.GetCurrent().level -- get the weapons level and set "level" to it
	bshot = false
    
    if ModCS.Key.Shoot(true) then
        -- exp adding when holding shoot
        if ModCS.Player.HasEquipped(8) then
            ModCS.Arms.AddExp(3)
        else
            ModCS.Arms.AddExp(2)
        end
        
        -- spur charge check
        if spur_charge ~= nil then
            spur_charge = spur_charge + 1
            
            if (spur_charge / 2 % 2) then
                if level == 1 then
                    ModCS.Sound.Play(59)
                elseif level == 2 then
                    ModCS.Sound.Play(60)
                elseif level == 3 then
                    if not ModCS.Arms.IsCurrentMaxExp() then
                        ModCS.Sound.Play(61)
                    end
                end
            end
        end -- end spur charge check
    else -- not holding shoot
        if spur_charge then
            bshot = true
        end
		
        spur_charge = 0
    end
    
    if ModCS.Arms.IsCurrentMaxExp() then
        if not bmax then
            bmax = true
            ModCS.Sound.Play(65)
        end
    else
        bmax = false
    end
    
    if not ModCS.Key.Shoot(true) then
        ModCS.Arms.ResetCurrentExp()
    end
    
    -- set bullet depending on level
    if level == 1 then
        bul = 6
        bshot = false
    elseif level == 2 then
        bul = 37
    else -- level == 3
        if bmax then
            bul = 39
        else
            bul = 38
        end
    end
    
    -- if pressing shoot, or bshot is true
    -- this part is weird ?
    if ModCS.Key.Shoot() or bshot then
        if not ModCS.Arms.UseAmmo(1) then
            ModCS.Sound.Play(37)
        else
            if ModCS.Player.IsLookingUp() then
                if ModCS.Player.direct == 0 then
                    ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y - 8, 1)
                    ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y - 8, 0)
                else
                    ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y - 8, 1)
                    ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y - 8, 0)
                end
            elseif ModCS.Player.IsLookingDown() then
                if ModCS.Player.direct == 0 then
                    ModCS.Bullet.Spawn(bul, ModCS.Player.x - 1, ModCS.Player.y + 8, 3)
                    ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y + 8, 0)
                else
                    ModCS.Bullet.Spawn(bul, ModCS.Player.x + 1, ModCS.Player.y + 8, 3)
                    ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y + 8, 0)
                end
            else
                if ModCS.Player.direct == 0 then
                    ModCS.Bullet.Spawn(bul, ModCS.Player.x - 6, ModCS.Player.y + 3, 0)
                    ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 3, 0)
                else
                    ModCS.Bullet.Spawn(bul, ModCS.Player.x + 6, ModCS.Player.y + 3, 2)
                    ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 3, 0)
                end
            end
            
            if bul == 6 then
                ModCS.Sound.Play(49)
            elseif bul == 37 then
                ModCS.Sound.Play(62)
            elseif bul == 38 then
                ModCS.Sound.Play(63)
            elseif bul == 39 then
                ModCS.Sound.Play(64)
            end
        end
    end
end
