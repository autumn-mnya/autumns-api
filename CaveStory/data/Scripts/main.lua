--require("arms")
-- require("npc")
require("mychar")

print("Hello World!")

function ModCS.Game.Act2()
	if ModCS.Key.Map() then
		ModCS.Player.Equip(32)
	end
end

function ModCS.Game.Draw()
	ModCS.PutNumber(ModCS.Player.x, 0, 0)
	ModCS.PutNumber(ModCS.Player.y, 0, 8)
end