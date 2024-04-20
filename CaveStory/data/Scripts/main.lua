require("npc")

ModCS.Mod.SetName("AutPI")
ModCS.Mod.SetAuthor("autumn")

ModCS.AddEntity("MyNewEntity")
ModCS.AddCaret("MyNewCaret")

--function ModCS.Game.Act()
--	ModCS.Npc.Spawn(361, 10, 10)
--end

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

function ModCS.Tsc.Command.FOO()
    local no = ModCS.Tsc.GetArgument(1) -- Get the first argument of the running command
    ModCS.PrintNum(no)
end