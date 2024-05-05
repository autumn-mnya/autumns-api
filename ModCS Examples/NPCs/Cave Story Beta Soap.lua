--[[
Cave Story Beta Soap NPC
by ilikebreadtoomuch

Free to use, no credit needed
--]]

--[[
==Recommended NPC Table settings==
Hitbox:
Up - 3
Sides - 6
Down - 8

Viewbox:
All - 8
--]]

local function SoapNpcAct(npc)
	-- Left direction example sprite rects
	local rcLeft = {
		{0, 0, 16, 16}, -- Walking 1
		{16, 0, 32, 16}, -- Walking 2
		{0, 0, 16, 16}, -- Walking 3 (Repeated from frame 1)
		{32, 0, 48, 16}, -- Walking 4
		{48, 0, 64, 16} -- Jumping
	}

	-- Right direction example sprite rects
	local rcRight = {
		{0, 16, 16, 32}, -- Walking 1
		{16, 16, 32, 32}, -- Walking 2
		{0, 16, 16, 32}, -- Walking 3 (Repeated from frame 1)
		{32, 16, 48, 32}, -- Walking 4
		{48, 16, 64, 32} -- Jumping
	}

	-- Act state 0 - Initializing
	if (npc.act_no == 0) then
		--[[
		Set the starting ani_no number to 1 to
		comply with Lua table access rules
		--]]
		npc.ani_no = 1
		npc.act_no = 1 -- Next Act State
	-- Act state 1 - Walking
	elseif (npc.act_no == 1) then
		-- Turn around if hitting a wall
		if (npc:TouchRightWall()) then
			npc.direct = 0
		end

		if (npc:TouchLeftWall()) then
			npc.direct = 2
		end

		-- Walking
		if (npc.direct == 0) then
			npc.xm = -0.65
		elseif (npc.direct == 2) then
			npc.xm = 0.65
		end

		-- Jump randomly
		if (math.random(0, 120) == 10 and npc:TouchFloor()) then
			npc.ym = npc.ym - 2
			npc.act_no = 2 -- Next act state
		end

		-- Animate
		if (npc:TouchFloor()) then
			-- Increase animation frame every 5 frames
			npc.ani_wait = npc.ani_wait + 1
			if (npc.ani_wait > 5) then
				npc.ani_wait = 0 -- Reset timer
				npc.ani_no = npc.ani_no + 1

				-- Loop walking animation
				if (npc.ani_no > 4) then
					npc.ani_no = 1
				end
			end
		else
			--[[
			If not touching the floor then
			set the animation frame to falling
			--]]
			npc.ani_no = 5
		end
	-- Act state 2 - Jumping
	elseif (npc.act_no == 2) then
		npc.ani_no = 5
		npc.ani_wait = 0 -- Reset animation timer

		-- If the NPC lands - Reset it
		if (npc:TouchFloor()) then
			npc.act_no = 1
		end
	end

	-- Gravity
	npc.ym = npc.ym + 0.06
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

-- ModCS.Npc.Act[...] = SoapNpcAct