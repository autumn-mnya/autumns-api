--[[
Critter Rect Change script
by ilikebreadtoomuch

Free to use, no credit needed
--]]

--[[
This is an example for an advanced
Rect change. For just offsetting
a sprite from a spritesheet you may
want to use ModCS.Npc.OffsetRect
like so:

ModCS.Npc.Act[64] = function(npc)
	npc:ActCode()

	-- This will offset the rect by 16 on the X axis
	npc:OffsetRect(0, 16)
end
--]]

ModCS.Npc.Act[64] = function(npc)
	npc:ActCode()

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

	--[[
	Lua table indexes start at 1 and animation
	states start at 0, so we add +1 to the table
	access index
	--]]
	if (npc.direct == 0) then
		npc:SetRect(rcLeft[npc.ani_no+1][1], rcLeft[npc.ani_no+1][2], rcLeft[npc.ani_no+1][3], rcLeft[npc.ani_no+1][4])
	elseif (npc.direct == 2) then
		npc:SetRect(rcRight[npc.ani_no+1][1], rcRight[npc.ani_no+1][2], rcRight[npc.ani_no+1][3], rcRight[npc.ani_no+1][4])
	end
end