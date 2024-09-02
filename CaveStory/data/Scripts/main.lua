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

local str = {""};
local line = 1;
local tick = 0;
local indx = 1;

function ModCS.Game.Draw()
    tick = tick + 1;
    for i = 1, #str do
        ModCS.PutText(str[i], 2, -10 + (i * 12));
    end
    local leng = indx - 1;
    if (ModCS.GetMag() == 2) then
        leng = leng * 5;
    else
        leng = leng * 6;
    end
    if (tick % 30 < 15) then
        ModCS.Color.Box(ModCS.Color.Create(0xFF, 0xFF, 0xFE), leng + 2, -10 + (line * 12), ModCS.GetMag() == 2 and 5 or 6, ModCS.GetMag() == 2 and 10 or 12);
        if (str[line] ~= nil) then
            ModCS.PutText(str[line]:sub(indx, indx), leng + 2, -10 + (line * 12), ModCS.Color.Create(0x00, 0x00, 0x01));
        end
    end
end

function ModCS.Key.KeyDown(kcode, kchar, krepeat)
    --print (krepeat)
    if (kcode == 0x08) then -- backspace
        if (indx == 1) then
            if (line > 1) then
                indx = #str[line - 1] + 2;
                str[line - 1] = str[line - 1] .. str[line];
                for i = line + 1, #str, 1 do
                    str[i] = str[i - 1];
                end
                str[#str] = nil;
                line = line - 1;
            else
                return;
            end
        else
            str[line] = str[line]:sub(1, indx - 2) .. str[line]:sub(indx);
        end
        
        indx = indx - 1;
        if (indx < 1) then
            indx = 1;
        end
    elseif (kcode == 0x2E) then -- delete
        if (indx == #str[line] + 1) then
            if (line < #str) then
                str[line] = str[line] .. str[line + 1];
                for i = line + 1, #str, 1 do
                    str[i] = str[i + 1];
                end
            else
                return;
            end
        else
            str[line] = str[line]:sub(1, indx - 1) .. str[line]:sub(indx + 1);
        end
        
        if (indx > #str[line] + 1) then
            indx = #str[line] + 1;
        end
    elseif (kcode == 0x25) then -- left
        if (indx == 1) then
            if (line > 1) then
                line = line - 1;
                indx = #str[line] + 1;
            end
            return;
        end
        indx = indx - 1;
        if (indx < 1) then
            indx = 1;
        end
    elseif (kcode == 0x27) then -- right
        if (indx == #str[line] + 1) then
            if (line < #str) then
                line = line + 1;
                indx = 1;
            end
            return;
        end
        indx = indx + 1;
        if (indx > #str[line] + 1) then
            indx = #str[line] + 1;
        end
    elseif (kcode == 0x0D) then -- return
        local capt = str[line]:sub(indx);
        str[line] = str[line]:sub(1, indx - 1);
        for i = #str + 1, line + 1, -1 do
            str[i] = str[i - 1];
        end
        line = line + 1;
        indx = 1;
        str[line] = capt;
        indx = math.min(indx, #str[line] + 1);
    elseif (kcode == 0x28) then -- down
        if (line == #str) then
            indx = #str[line] + 1;
            return;
        end
        
        line = line + 1;
        if (line > #str) then
            line = #str;
        end
        indx = math.min(indx, #str[line] + 1);
    elseif (kcode == 0x26) then -- up
        if (line == 1) then
            indx = 0;
            return;
        end
        
        line = line - 1;
        if (line < 1) then
            line = 1;
        end
        if (str[line] == nil) then
            str[line] = "";
        end
        indx = math.min(indx, #str[line] + 1);
    else -- other keys
        str[line] = str[line]:sub(1, indx - 1) .. kchar .. str[line]:sub(indx);
        indx = indx + #kchar;
    end
end

function ModCS.Key.KeyUp(kcode, kchar)
end

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
	
	ModCS.Npc.Spawn(1, ModCS.Mouse.GetWorldX() / 512, ModCS.Mouse.GetWorldY() / 512)
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

-- Just incase code needs to be ran before ModeOpening
function ModCS.Mod.Init()
	ModCS.Mod.SetName("AutPI")
	print("Mod is loading..")
end

-- prints everytime a transferstage call happens
function ModCS.Stage.OnTransfer()
	print("Transferred to stage ID: " .. ModCS.Stage.GetCurrentNo())
end