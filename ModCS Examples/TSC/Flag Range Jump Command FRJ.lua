--[[
Flag Range Jump command (<FRJ)
by autumn_mnya

Free to use, no credit needed

To use this, run <FRJxxxx:yyyy:zzzz
x - start flag
y - end flag
z - event to run if all flags in the set range are true

it will continue the current event rather than jumping if one of the flags is false.
--]]

function ModCS.Tsc.Command.FRJ()
    local start_range = ModCS.Tsc.GetArgument(1)
    local end_range = ModCS.Tsc.GetArgument(2)
    local event = ModCS.Tsc.GetArgument(3)

    local allFlagsTrue = true

    for i = start_range, end_range do
        if not ModCS.Flag.Get(i) then
            allFlagsTrue = false
            break
        end
    end

    if allFlagsTrue then
        ModCS.Tsc.Jump(event)
    end
end