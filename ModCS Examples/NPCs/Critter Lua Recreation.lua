--[[
Critter NPC Type in Lua recreation
by ilikebreadtoomuch

Free to use, no credit needed
--]]

ModCS.Npc.Act[64] = function(npc)
	-- Left direction sprite rects
	local rcLeft = {
		{0, 0, 16, 16}, -- Closed eyes
		{16, 0, 32, 16}, -- Opened eyes
		{32, 0, 48, 16} -- Jumping
	}

	-- Right direction sprite rects
	local rcRight = {
		{0, 16, 16, 32}, -- Closed eyes
		{16, 16, 32, 32}, -- Opened eyes
		{32, 16, 48, 32} -- Jumping
	}

	-- Act state 0 - Initializing
	if (npc.act_no == 0) then
		npc.y = npc.y + 3 -- Offset position by 3 pixels
		--[[
		Set the starting ani_no number to 1 to
		comply with Lua table access rules
		--]]
		npc.ani_no = 1
		npc.act_no = 1 -- Next Act State
	-- Act state 1 - Wating for player
	elseif (npc.act_no == 1) then
		-- Look at player
		if (npc.x > ModCS.Player.x) then
			npc.direct = 0
		else 
			npc.direct = 2
		end

		-- If player is close open eyes
		if (npc.act_wait >= 8 and npc:TriggerBox(112, 80, 112, 80)) then
			npc.ani_no = 2 -- Set sprite to '2'
		else
			-- Increase delay timer
			if (npc.act_wait < 8) then
				npc.act_wait = npc.act_wait + 1
			end

			npc.ani_no = 1 -- Set sprite to '1'
		end

		-- If player is even closer *or* if the enemy has been hit: Jump
		if ((npc.act_wait >= 8 and npc:TriggerBox(64, 80, 64, 48)) or
			npc:IsHit()) then
			npc.act_no = 2 -- Next act state
			npc.ani_no = 1 -- Set sprite to '1'
			npc.act_wait = 0 -- Reset delay timer
		end
	-- Act state 2 - Going to jump
	elseif (npc.act_no == 2) then
		-- Increase delay timer and if delay timer is bigger than 8 jump
		npc.act_wait = npc.act_wait + 1
		if (npc.act_wait > 8) then
			npc.act_no = 3 -- Next act state
			npc.ani_no = 3 -- Set sprite to '3'

			-- Jump - Vertical velocity
			npc.ym = -3
			ModCS.Sound.Play(30)

			-- Set horizontal velocity based on the NPC's direction
			if (npc.direct == 0) then
				npc.xm = -0.5
			else
				npc.xm = 0.5
			end
		end
	-- Act state 3 - Jumping
	elseif (npc.act_no == 3) then
		-- If the NPC lands - Reset it
		if (npc:TouchFloor()) then
			ModCS.Sound.Play(23)
			npc.xm = 0
			npc.act_wait = 0
			npc.ani_no = 1
			npc.act_no = 1
		end
	end

	-- Gravity
	npc.ym = npc.ym + 0.125 -- Add 0.125 to the Y velocity of the NPC
	-- Terminal Y velocity should be 3 pixels per frame 
	if (npc.ym > 3) then
		npc.ym = 3
	end

	npc:Move() -- Apply velocity variables

	-- Set the NPC's sprite depending on the direction
	if (npc.direct == 0) then
		npc:SetRect(rcLeft[npc.ani_no][1], rcLeft[npc.ani_no][2], rcLeft[npc.ani_no][3], rcLeft[npc.ani_no][4])
	else
		npc:SetRect(rcRight[npc.ani_no][1], rcRight[npc.ani_no][2], rcRight[npc.ani_no][3], rcRight[npc.ani_no][4])
	end	
end