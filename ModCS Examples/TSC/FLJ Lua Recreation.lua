--[[
FLJ Command in Lua Recreation
by ilikebreadtoomuch

Free to use, no credit needed
--]]

function ModCS.Tsc.Command.LFJ()
	local flag = ModCS.Tsc.GetArgument(1)
	local event = ModCS.Tsc.GetArgument(2)

	if (ModCS.Flag.Get(flag)) then
		ModCS.Tsc.Jump(event)
	end
end