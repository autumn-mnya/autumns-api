-- Opposite of <FLJ, check if a flag is *not* set, then jump to event if it isn't set.

function ModCS.Tsc.Command.FNJ()
	local flag = ModCS.Tsc.GetArgument(1)
	local event = ModCS.Tsc.GetArgument(2)

	if not (ModCS.Flag.Get(flag)) then
		ModCS.Tsc.Jump(event)
	end
end
