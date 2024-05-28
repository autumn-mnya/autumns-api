require("arms")
require("npc")

print(ModCS.GetModulePath())
print("Hello World!")

ModCS.Mod.SetAuthor("autumn")

ModCS.Mod.SetOpening(0x10, 100, 0x1000)
ModCS.Mod.SetStart(13, 94, 10, 8)

ModCS.AddEntity("MyNewEntity")
ModCS.AddCaret("MyNewCaret")

--function ModCS.Game.Act()
--	ModCS.Npc.Spawn(361, 10, 10)
--end

function ModCS.Game.Act()
	if ModCS.Key.Shift() then
		if ModCS.Arms.GetCurrent().id >= 13 then
			ModCS.Arms.GetCurrent().id = 1
		else
			ModCS.Arms.GetCurrent().id = ModCS.Arms.GetCurrent().id + 1
		end
	end
	
	if ModCS.Key.Shoot(true) then
		ModCS.Arms.AddExp(1)
	end
	
	-- This needs to be here, just incase
	if ModCS.Game.CanControl() then
		if ModCS.Key.Arms() then
			ResetSpurCharge()
			ResetWait()
		elseif ModCS.Key.ArmsRev() then
			ResetSpurCharge()
			ResetWait()
		end
	end
	
	if ModCS.Key.Map() then
		ModCS.Arms.GetCurrent().id = ModCS.Arms.GetCurrent().id - 1
	end
	
	-- Lunar Shadow swimming
	if ModCS.Player.TouchWater() then
		if ModCS.Key.Jump(true) then
			ModCS.Player.ym = ModCS.Player.ym - 88
		end
	end
end

function ModCS.Tsc.Command.FOO() -- Launch Geometry Dash via Steam
	if (os.execute("start steam://rungameid/322170") ~= 0) then os.execute('"C:/Program Files (x86)/Steam/steam.exe" steam://rungameid/322170')
	end
end

function GetModuleFilePath(filename)
    local Path = ModCS.GetModulePath()
    return Path .. "/" .. filename
end

function GetDataFilePath(filename)
    local Path = ModCS.GetDataPath()
    return Path .. "/" .. filename
end

function GetModuleFilePath(filename)
    local Path = ModCS.GetModulePath()
    return Path .. "/" .. filename
end

function luaSaveFile()
    local file = io.open(GetModuleFilePath("lua_savefile.txt"), "w")
    if not file then
        print("Error: Cannot open lua_savefile.txt for writing.")
        return
    end
    
    file:write("Wow, its a save file!")
    
    file:close()
end

function luaLoadFile(filePath)
    local file = io.open(filePath, "r") -- Open the file in read mode
    if not file then
        print("Error: Cannot open file for reading.")
        return nil
    end
    
    local contents = file:read("*all") -- Read the entire contents of the file
    file:close() -- Close the file
    
    return contents
end

function ModCS.Profile.DuringSave()
	print("Saving Game")
	luaSaveFile()
end

function ModCS.Profile.DuringLoad()
	print("Loading Game")
	local file = luaLoadFile(GetModuleFilePath("lua_savefile.txt"))
	print(file)
end

local texttoput = "No data!"

function ModCS.Game.Draw()
	ModCS.PutText(texttoput, 0, 0)
end

function ModCS.Tsc.Command.STR()
	texttoput = ModCS.Tsc.GetString() -- get string data :3
end

-- Just incase code needs to be ran before ModeOpening
function ModCS.Mod.Init()
	ModCS.Mod.SetName("AutPI")
	print("Mod is loading..")
end

-- prints everytime a transferstage call happens
function ModCS.Stage.OnTransfer()
	print("Transferred to stage ID: " .. ModCS.Stage.GetCurrentNo())
end