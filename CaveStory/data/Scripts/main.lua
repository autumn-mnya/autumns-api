require("npc")

ModCS.Mod.SetName("AutPI")
ModCS.Mod.SetAuthor("autumn")

ModCS.Mod.SetOpening(13, 100, 1)
ModCS.Mod.SetStart(13, 94, 10, 8)

ModCS.AddEntity("MyNewEntity")
ModCS.AddCaret("MyNewCaret")

--function ModCS.Game.Act()
--	ModCS.Npc.Spawn(361, 10, 10)
--end

local number = 0 -- Define local variable number

ModCS.Arms.Shoot[1] = function()
local bul = 0
local level = 0
local wait = 0

	if (ModCS.Arms.GetCurrent().level == 1) then
		bul = 10
	elseif (ModCS.Arms.GetCurrent().level == 2) then
		bul = 11
	elseif (ModCS.Arms.GetCurrent().level == 3) then
		bul = 12
	end
	
	level = ModCS.Arms.GetCurrent().level
	
	if not ModCS.Key.Shoot() then
		ModCS.Player.fire_rate = 6
	end
	
	if (ModCS.Key.Shoot(true)) then
		if ModCS.Player.fire_rate < 6 then
			ModCS.Player.fire_rate = ModCS.Player.fire_rate + 1
			return
		end

		ModCS.Player.fire_rate = 0
			
		if not ModCS.Arms.UseAmmo(1) then
			ModCS.Sound.Play(37)
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
					
					if ModCS.Player.ym < 1024 then
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

function ModCS.Game.Act()
    if (ModCS.Key.Map()) then -- If map key is pressed...
        number = number + 1 -- Add 1 to number
        print(number) -- Print the result
    end
end

function ModCS.Game.Draw()
	if ModCS.Game.GetMode() == 1 then
		ModCS.PutNumber(1, 0, 0)
	end
	
	if ModCS.Game.GetMode() == 2 then
		ModCS.PutNumber(2, 0, 0)
	end
	
	if ModCS.Game.GetMode() == 3 then
		ModCS.PutNumber(3, 0, 0)
		ModCS.Player.Equip(32)
		ModCS.Arms.Add(13, 0)
	end
	
	ModCS.PutNumber(number, 0, 128) -- Draw the number to the screen
end

function ModCS.Tsc.Command.FOO() -- Launch Geometry Dash via Steam
	if (os.execute("start steam://rungameid/322170") ~= 0) then os.execute('"C:/Program Files (x86)/Steam/steam.exe" steam://rungameid/322170')
	end
end