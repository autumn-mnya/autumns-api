--require("arms")
-- require("npc")

print("Hello World!")

function ModCS.Game.Act()
	if ModCS.Key.Jump() then
		if ModCS.Player.direct == 0 then
			ModCS.Player.xm = -1535
		else
			ModCS.Player.xm = 1535
		end
	end
end