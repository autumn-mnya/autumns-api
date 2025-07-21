--require("arms")
-- require("npc")
require("mychar")

print("Hello World!")

ModCS.Mod.SetOpening(72, 3, 3, 100, 500)
ModCS.Mod.SetStart(13, 10, 8, 200)

function ModCS.Game.Act2()
	if ModCS.Player.unit == 2 then
		ModCS.Player.ProcessAir()
		PlayerMovementRecreation()
	else
		if ModCS.Key.Map() then
			ModCS.Player.Equip(32)
			ModCS.Player.unit = 2
		end
	end
	
end

function ModCS.Game.Act()
	if ModCS.Key.Jump() and not ModCS.Player.TouchFloor() then
		ModCS.Player.ym = -1280
	end
end

function ModCS.Game.Draw()
	ModCS.PutNumber(ModCS.Player.x, 0, 0)
	ModCS.PutNumber(ModCS.Player.y, 0, 8)
end