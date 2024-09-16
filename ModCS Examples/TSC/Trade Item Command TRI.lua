--[[
TRI Command to swap one item in inventory with another if it exists
by autumn_mnya

Free to use, no credit needed
--]]

function ModCS.Tsc.Command.TRI()
    local itemA = ModCS.Tsc.GetArgument(1)
    local itemB = ModCS.Tsc.GetArgument(2)
    
    if ModCS.Item.GetByID(itemA) then
        ModCS.Item.Remove(itemA)
        ModCS.Item.Add(itemB)
    end
end