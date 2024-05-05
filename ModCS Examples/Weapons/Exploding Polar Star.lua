--[[
Exploding Polar Star port
by ilikebreadtoomuch

Free to use, no credit needed
--]]

local function ExplodingPolarStar(bul)
	-- Save the Bullet ID to a local variable
	local id = bul.id

	--[[
	Increase a counter and if the counter
	is bigger than the set life_count in
	the bullet table, destroy it.

	The original code for the Bullet does
	the exact same thing, but uses count1
	instead.
	]]--
	bul.count2 = bul.count2 + 1
	if (bul.count2 > bul.life_count) then
		bul:Delete()
		-- Spawn a Caret to mark the death of the Bullet
		ModCS.Caret.Spawn(3, bul.x, bul.y)

		-- Spawn 4 Bullets, all with a different direction
		for i=0,3,1 do
			ModCS.Bullet.Spawn(id - 1, bul.x, bul.y, i)
		end

		return -- End function
	end

	-- Run the vanilla game code for the Bullet
	bul:ActCode()
end

-- Define functions in the ModCS.Bullet.Act array
ModCS.Bullet.Act[5] = ExplodingPolarStar
ModCS.Bullet.Act[6] = ExplodingPolarStar