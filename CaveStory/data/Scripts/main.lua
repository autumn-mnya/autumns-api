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

function ModCS.Game.Act()
	if ModCS.Key.Shift() then
		if ModCS.Arms.GetCurrent().id >= 13 then
			ModCS.Arms.GetCurrent().id = 1
		else
			ModCS.Arms.GetCurrent().id = ModCS.Arms.GetCurrent().id + 1
		end
	end
	
	-- This needs to be here, just incase
	if ModCS.Game.CanControl() then
		if ModCS.Key.Arms() then
			ResetSpurCharge()
			ResetWait()
		elseif ModCS.Key.ArmsRev() then
			ResetSpurCharge()
			ResetWait()
		end
	end
	
	if ModCS.Key.Map() then
		ModCS.Arms.GetCurrent().id = ModCS.Arms.GetCurrent().id - 1
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
	end
end

function ModCS.Tsc.Command.FOO() -- Launch Geometry Dash via Steam
	if (os.execute("start steam://rungameid/322170") ~= 0) then os.execute('"C:/Program Files (x86)/Steam/steam.exe" steam://rungameid/322170')
	end
end