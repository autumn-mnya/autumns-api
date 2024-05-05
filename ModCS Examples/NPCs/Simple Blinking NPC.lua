--[[
Simple blinking NPC
by ilikebreadtoomuch

Free to use, no credit needed
--]]

local function BlinkingNpcAct(npc)
	-- Left direction example sprite rects
	local rcLeft = {
		{0, 0, 16, 16}, -- Opened eyes
		{16, 0, 32, 16} -- Closed eyes
	}

	-- Right direction example sprite rects
	local rcLeft = {
		{0, 16, 16, 32}, -- Opened eyes
		{16, 16, 32, 32} -- Closed eyes
	}

	-- Act state 0 - Initializing
	if (npc.act_no == 0) then
		npc.act_no = 1 -- Set act state to 1
		--[[
		Set the starting ani_no number to 1 to
		comply with Lua table access rules
		--]]
		npc.ani_no = 1
	-- Act state 1 - Idling
	elseif (npc.act_no == 1) then
		-- Every frame do a random number check...
		if (math.random(0, 120) == 10) then -- ...and if the check is successful...
			npc.act_no = 2 -- Set the act state to 2
			npc.ani_no = 2 -- Set the sprite to the "Closed eyes" one
		end
	-- Act state 2 - Blinking
	elseif (npc.act_no == 2) then
		npc.act_wait = npc.act_wait + 1 -- Increase act timer by 1 each frame

		-- If 8 frames have passed...
		if (npc.act_wait > 8) then
			npc.act_no = 1 -- Make the act state 1 again
			npc.ani_no = 1 -- Make the sprite the "Opened eyes" one again
			npc.act_wait = 0 -- Reset timer
		end
	end

	-- Gravity
	npc.ym = npc.ym + 0.125 -- Add 0.125 to the Y velocity of the NPC
	-- Terminal Y velocity should be 3 pixels per frame 
	if (npc.ym > 3) then
		npc.ym = 3
	end

	npc:Move() -- Apply velocity variables

	if (npc.direct == 0) then
		npc:SetRect(rcLeft[npc.ani_no][1], rcLeft[npc.ani_no][2], rcLeft[npc.ani_no][3], rcLeft[npc.ani_no][4])
	elseif (npc.direct == 2) then
		npc:SetRect(rcRight[npc.ani_no][1], rcRight[npc.ani_no][2], rcRight[npc.ani_no][3], rcRight[npc.ani_no][4])
	end
end

-- ModCS.Npc.Act[...] = BlinkingNpcAct