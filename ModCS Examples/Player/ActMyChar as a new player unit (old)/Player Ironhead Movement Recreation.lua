--[[
Port of vanilla Cave Story's ironhead movement code (<UNI0001) to a lua function.
by autpod

For AutPI 1.3+

Free to use, no credit needed

To use, run this code in a ModCS.Game.Act2() function preferably:

if ModCS.Player.unit == 3 then
	PlayerIronheadMovementRecreation()
end
--]]

function PlayerIronheadMovementRecreation()
	ModCS.Player.up = 0
	ModCS.Player.down = 0

	if ModCS.Game.CanControl() then
		if ModCS.Key.Left(true) or ModCS.Key.Right(true) then
			if ModCS.Key.Left(true) then
				ModCS.Player.xm = ModCS.Player.xm - 0x100
			end

			if ModCS.Key.Right(true) then
				ModCS.Player.xm = ModCS.Player.xm + 0x100
			end
		elseif ModCS.Player.xm < 0x80 and ModCS.Player.xm > -0x80 then
			ModCS.Player.xm = 0
		elseif ModCS.Player.xm > 0 then
			ModCS.Player.xm = ModCS.Player.xm - 0x80
		elseif ModCS.Player.xm < 0 then
			ModCS.Player.xm = ModCS.Player.xm + 0x80
		end

		if ModCS.Key.Up(true) or ModCS.Key.Down(true) then
			if ModCS.Key.Up(true) then
				ModCS.Player.ym = ModCS.Player.ym - 0x100
			end

			if ModCS.Key.Down(true) then
				ModCS.Player.ym = ModCS.Player.ym + 0x100
			end
		elseif ModCS.Player.ym < 0x80 and ModCS.Player.ym > -0x80 then
			ModCS.Player.ym = 0
		elseif ModCS.Player.ym > 0 then
			ModCS.Player.ym = ModCS.Player.ym - 0x80
		elseif ModCS.Player.ym < 0 then
			ModCS.Player.ym = ModCS.Player.ym + 0x80
		end
	else
		if ModCS.Player.xm < 0x80 and ModCS.Player.xm > -0x40 then
			ModCS.Player.xm = 0
		elseif ModCS.Player.xm > 0 then
			ModCS.Player.xm = ModCS.Player.xm - 0x80
		elseif ModCS.Player.xm < 0 then
			ModCS.Player.xm = ModCS.Player.xm + 0x80
		end

		if ModCS.Player.ym < 0x80 and ModCS.Player.ym > -0x40 then
			ModCS.Player.ym = 0
		elseif ModCS.Player.ym > 0 then
			ModCS.Player.ym = ModCS.Player.ym - 0x80
		elseif ModCS.Player.ym < 0 then
			ModCS.Player.ym = ModCS.Player.ym + 0x80
		end
	end

	if ModCS.Player.xm > 0x400 then
		ModCS.Player.xm = 0x400
	end

	if ModCS.Player.xm < -0x400 then
		ModCS.Player.xm = -0x400
	end

	if ModCS.Player.ym > 0x400 then
		ModCS.Player.ym = 0x400
	end

	if ModCS.Player.ym < -0x400 then
		ModCS.Player.ym = -0x400
	end

	-- left + up
	if ModCS.Key.Left(true) and ModCS.Key.Up(true) then
		if ModCS.Player.xm < -780 then
			ModCS.Player.xm = -780
		end
		if ModCS.Player.ym < -780 then
			ModCS.Player.ym = -780
		end
	end

	-- right + up
	if ModCS.Key.Right(true) and ModCS.Key.Up(true) then
		if ModCS.Player.xm > 780 then
			ModCS.Player.xm = 780
		end
		if ModCS.Player.ym < -780 then
			ModCS.Player.ym = -780
		end
	end

	-- left + down
	if ModCS.Key.Left(true) and ModCS.Key.Down(true) then
		if ModCS.Player.xm < -780 then
			ModCS.Player.xm = -780
		end
		if ModCS.Player.ym > 780 then
			ModCS.Player.ym = 780
		end
	end

	-- right + down
	if ModCS.Key.Right(true) and ModCS.Key.Down(true) then
		if ModCS.Player.xm > 780 then
			ModCS.Player.xm = 780
		end
		if ModCS.Player.ym > 780 then
			ModCS.Player.ym = 780
		end
	end

	ModCS.Player.x = ModCS.Player.x + ModCS.Player.xm / 512
	ModCS.Player.y = ModCS.Player.y + ModCS.Player.ym / 512
end
