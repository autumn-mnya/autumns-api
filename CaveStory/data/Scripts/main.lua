--require("arms")
-- require("npc")
require("mychar")

print("Hello World!")

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

function ModCS.Game.Draw()
	if ModCS.Key.Arms() then
		ModCS.Profile.Load("Test.dat")
	end
	
	if ModCS.Key.ArmsRev() then
		ModCS.Profile.Save("Test.dat")
	end
	
	ModCS.PutNumber(ModCS.Player.x, 0, 0)
	ModCS.PutNumber(ModCS.Player.y, 0, 8)
end