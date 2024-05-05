--[[
Pollar Star Bullet Type in Lua recreation
by ilikebreadtoomuch

Free to use, no credit needed
--]]

--[[
BULLET CODE
--]]
local function BulletPolarStar(bul)
	-- Define a variable for storing the level of the Bullet
	local level

	-- Set the level variable based on the Bullet Type ID
	if (bul.id == 4) then
		level = 1
	elseif (bul.id == 5) then
		level = 2
	elseif (bul.id == 6) then
		level = 3
	end

	-- Define sprite rect variable
	local rect

	-- Set the sprite rect variable based on the level
	if (level == 1) then
		rect = {
			{128, 32, 144, 48}, -- Horizontal
			{144, 32, 160, 48} -- Vertical
		}
	elseif (level == 2) then
		rect = {
			{160, 32, 176, 48}, -- Horizontal
			{176, 32, 192, 48} -- Vertical
		}
	elseif (level == 3) then
		rect = {
			{128, 48, 144, 64}, -- Horizontal
			{144, 48, 160, 64} -- Vertical
		}
	end

	--[[
	Increase a counter and if the counter
	is bigger than the set life_count in
	the bullet table, destroy it
	]]--
	bul.count1 = bul.count1 + 1
	if (bul.count1 > bul.life_count) then
		bul:Delete()
		-- Spawn a Caret to mark the death of the Bullet
		ModCS.Caret.Spawn(3, bul.x, bul.y)
		return -- End function
	end

	-- Act state 0 - Initializing
	if (bul.act_no == 0) then
		bul.act_no = 1 -- Next Act State

		--[[
		Set the Vullet movement and speed
		based on its direction
		--]]
		if (bul.direct == 0) then
			bul.xm = -8
		elseif (bul.direct == 1) then
			bul.ym = -8
		elseif (bul.direct == 2) then
			bul.xm = 8
		elseif (bul.direct == 3) then
			bul.ym = 8
		end

		-- Set the Bullet hitbox based on its level
		if (level == 1) then
			-- If horizontal...
			if (bul.direct == 0 or bul.direct == 2) then
				bul.enemyhit_x = 2
			-- If vertical...
			elseif (bul.direct == 1 or bul.direct == 3) then
				bul.enemyhit_y = 2
			end
		elseif (level == 2) then
			-- If horizontal...
			if (bul.direct == 0 or bul.direct == 2) then
				bul.enemyhit_x = 4
			-- If vertical...
			elseif (bul.direct == 1 or bul.direct == 3) then
				bul.enemyhit_y = 4
			end
		end
		-- Fallback to Bullet table hitbox values
	end

	bul:Move() -- Apply velocity variables

	-- Set the Bullets's sprite depending on the direction
	-- If horizontal...
	if (bul.direct == 0 or bul.direct == 2) then
		bul:SetRect(rect[1][1], rect[1][2], rect[1][3], rect[1][4])
	-- If vertical...
	elseif (bul.direct == 1 or bul.direct == 3) then
		bul:SetRect(rect[2][1], rect[2][2], rect[2][3], rect[2][4])
	end	
end

-- Define functions in the ModCS.Bullet.Act array
ModCS.Bullet.Act[4] = BulletPolarStar
ModCS.Bullet.Act[5] = BulletPolarStar
ModCS.Bullet.Act[6] = BulletPolarStar

--[[
SHOOT CODE
--]]
--[[
Variable for checking if we can
spawn the 'Empty!' caret
--]]
empty = 0

ModCS.Arms.Shoot[2] = function()
	-- Decrease the 'Empty!' delay variable
	if (empty > 0) then
		empty = empty - 1
	end

	-- Define a variable for the Bullet ID we'll be shooting
	local bul_id

	-- Set the Bullet ID variable based on the weapon level
	if (ModCS.Arms.GetCurrent().level == 1) then
		bul_id = 4
	elseif (ModCS.Arms.GetCurrent().level == 2) then
		bul_id = 5
	elseif (ModCS.Arms.GetCurrent().level == 3) then
		bul_id = 6
	end

	--[[
	Count bullets, if there's more than
	two Polar Star bullets, stop code.
	--]]
	if (ModCS.Bullet.CountByID(4) > 1) or
		(ModCS.Bullet.CountByID(5) > 1) or
		(ModCS.Bullet.CountByID(6) > 1) then
		return -- End code
	end

	-- If the player presses the shoot key, shoot
	if (ModCS.Key.Shoot()) then
		-- If the player can't use any ammo...
		if (ModCS.Arms.UseAmmo() == false) then
			ModCS.Sound.Play(37) -- Play the 'No Ammo' sound

			--[[
			The original game doesn't do this, but
			spawn the 'Empty!' Caret/
			--]]
			if (empty == 0) then
				ModCS.Caret.Spawn(16, ModCS.Player.x, ModCS.Player.y)
				empty = 50
			end

			return -- End code
		end

		--[[
		Shoot bullet. Here we check for a buncg of
		different things, such as direction and if
		the player is looking up. This is messy,
		but it's what the original game does so
		¯\_(ツ)_/¯
		]]--
		if (ModCS.Player.IsLookingUp()) then
			if (ModCS.Player.direct == 0) then
				ModCS.Bullet.Spawn(bul_id, ModCS.Player.x - 1, ModCS.Player.y - 8, 1)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y - 8)
			else
				ModCS.Bullet.Spawn(bul_id, ModCS.Player.x + 1, ModCS.Player.y - 8, 1)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y - 8)
			end
		elseif (ModCS.Player.IsLookingDown()) then
			if (ModCS.Player.direct == 0) then
				ModCS.Bullet.Spawn(bul_id, ModCS.Player.x - 1, ModCS.Player.y + 8, 3)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 1, ModCS.Player.y - 8)
			else
				ModCS.Bullet.Spawn(bul_id, ModCS.Player.x + 1, ModCS.Player.y + 8, 3)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 1, ModCS.Player.y - 8)
			end
		else
			if (ModCS.Player.direct == 0) then
				ModCS.Bullet.Spawn(bul_id, ModCS.Player.x - 6, ModCS.Player.y + 3, 0)
				ModCS.Caret.Spawn(3, ModCS.Player.x - 12, ModCS.Player.y + 3)
			else
				ModCS.Bullet.Spawn(bul_id, ModCS.Player.x + 6, ModCS.Player.y + 3, 2)
				ModCS.Caret.Spawn(3, ModCS.Player.x + 12, ModCS.Player.y + 3)
			end
		end

		--[[
		Play shoot sound effect, Polar Star Level 3
		uses a different shoot sound.
		-]]
		if (ModCS.Arms.GetCurrent().level == 3) then
			ModCS.Sound.Play(49)
		else
			ModCS.Sound.Play(32)
		end
	end
end
