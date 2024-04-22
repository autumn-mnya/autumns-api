-- machine gun variables
local bul = 0
local level = 0
local wait = 0

-- Machine Gun as weapon 14 port
ModCS.Arms.Shoot[14] = function()
	if (ModCS.Arms.GetCurrent().level == 1) then
		bul = 10
	elseif (ModCS.Arms.GetCurrent().level == 2) then
		bul = 11
	elseif (ModCS.Arms.GetCurrent().level == 3) then
		bul = 12
	end
	
	level = ModCS.Arms.GetCurrent().level
	
	-- gMC.rensha = 6;
	if not ModCS.Key.Shoot(true) then
		ModCS.Player.fire_rate = 6
	end
	
	if (ModCS.Key.Shoot(true)) then
		-- gMC.rensha check
		if ModCS.Player.fire_rate < 6 then
			ModCS.Player.fire_rate = ModCS.Player.fire_rate + 1
			return
		end

		-- gMC.rensha = 0;
		ModCS.Player.fire_rate = 0
			
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Sound.Play(37)
			
			-- if ammo is empty, spawn caret and set empty back to 50
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
						ModCS.Player.ym = ModCS.Player.ym - 1024
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