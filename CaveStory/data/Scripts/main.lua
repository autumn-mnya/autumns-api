require("arms")
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

glidecooldown = 0
glidestate = 0

ModCS.Arms.Shoot[1] = function()
	-- glider from Modfest36 Mod
	if ModCS.Key.Shoot(true) then
		print("shooting")
		glidestate = 1
	else
		glidestate = 0
	end
end

function ModCS.Game.Act()
    if (ModCS.Key.Map()) then -- If map key is pressed...
        number = number + 1 -- Add 1 to number
		ModCS.Player.AddMaxLife(44)
        print(number) -- Print the result
    end
	
	if glidestate == 1 then
		if ModCS.Player.ym > 0 then
			if not glidecooldown == 60 then
				if ModCS.Player.direct == 0 then
					ModCS.Caret.Spawn(13, ModCS.Player.x + 16, ModCS.Player.y, 0)
				else
					ModCS.Caret.Spawn(13, ModCS.Player.x - 16, ModCS.Player.y, 0)
				end
				
				print("THE GLIDER ACTIVATE")
				
				glidecooldown = glidecooldown + 1
				ModCS.Player.ym = 128
			end
		end
	end
	
	if ModCS.Player.TouchFloor() then
		glidecooldown = 0
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
	
	ModCS.PutNumber(math.abs(ModCS.Player.ym), 0, 128) 
end

function ModCS.Tsc.Command.FOO() -- Launch Geometry Dash via Steam
	if (os.execute("start steam://rungameid/322170") ~= 0) then os.execute('"C:/Program Files (x86)/Steam/steam.exe" steam://rungameid/322170')
	end
end