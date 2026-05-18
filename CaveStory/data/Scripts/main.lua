require("ActMyChar")
require("AnimationMyChar")
require("DamageMyChar")
require("Escape")
require("MiniMap")
require("MycParam")
require("Inventory")
require("NpcAct000")
require("NpcAct020")
require("NpcAct040")
require("NpcAct060")
require("NpcAct080")
require("NpcAct100")
require("NpcAct120")
require("NpcAct140")
require("NpcAct160")
require("NpcAct180")
require("NpcAct200")
require("NpcAct220")
require("PutMyChar")

ModCS.Mod.SetStart(13, 10, 8, 94)
ModCS.Mod.SetName("ModCS (" .. _VERSION .. ")")
ModCS.Stage.LoadTable("stage.tbl")

function LoadGenericData()
    ModCS.Surface.CreateResource(ModCS.Const.SURFACE_ID_PIXEL, "PIXEL")

    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_MY_CHAR, "MyChar")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_TITLE, "Title")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_ARMS_IMAGE, "ArmsImage")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_ARMS, "Arms")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_ITEM_IMAGE, "ItemImage")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_STAGE_ITEM, "StageImage")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_NPC_SYM, "Npc\\NpcSym")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_NPC_REGU, "Npc\\NpcRegu")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_TEXT_BOX, "TextBox")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_CARET, "Caret")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_BULLET, "Bullet")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_FACE, "Face")
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_FADE, "Fade")

    ModCS.Surface.CreateResource(ModCS.Const.SURFACE_ID_CREDITS_IMAGE, "CREDIT01")

    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_SCREEN_GRAB, ModCS.Const.WINDOW_WIDTH, ModCS.Const.WINDOW_HEIGHT, true)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_LEVEL_BACKGROUND, ModCS.Const.WINDOW_WIDTH, ModCS.Const.WINDOW_HEIGHT)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_MAP, ModCS.Const.WINDOW_WIDTH, ModCS.Const.WINDOW_HEIGHT, true)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_CASTS, ModCS.Const.WINDOW_WIDTH, ModCS.Const.WINDOW_HEIGHT)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_LEVEL_TILESET, 256, 256)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_ROOM_NAME, 160, 16)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_VALUE_VIEW, 40, 240)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_LEVEL_SPRITESET_1, 320, 240)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_LEVEL_SPRITESET_2, 320, 240)
    ModCS.Surface.Create(ModCS.Const.SURFACE_ID_CREDIT_CAST, 320, (16 * (ModCS.Const.MAX_STRIP-1)))
end

function ModCS.Mod.Init()
    --LoadGenericData()
    ModCS.Mod.Toggle60fps(true)
end

function ModCS.Game.Act()
    ModCSLog(ModCS.Const.EQUIP_AIR_TANK)
end

function ModCS.Game.Init()
end

function DebugArmsTableInfo()
    local levelDrawX = 48
    local levelDrawY = 32

    if (ModCS.Game.GetMode() == 3 and ModCS.Game.CanControl()) then
        ModCS.PutText("Current EXP", levelDrawX + 192, levelDrawY - 16)
        ModCS.PutNumber(ModCS.Arms.GetCurrent().exp, levelDrawX + 128, levelDrawY - 16)
    end

    local count = ModCS.Arms.GetAmount()

    for i = 0, count - 1 do
        local levels = ModCS.Arms.GetLevels(i)
        local y = levelDrawY + (i * 8)

        ModCS.PutNumber(levels[1], levelDrawX, y)
        ModCS.PutNumber(levels[2], levelDrawX + 64, y)
        ModCS.PutNumber(levels[3], levelDrawX + 128, y)

        ModCS.PutText("Arms ID " .. i, levelDrawX + 192, y)
    end
end

function ModCS.Game.Draw()
    --DebugArmsTableInfo()
end

function ModCS.Stage.OnTransfer()

end

function ModCSLog(...)
    local args = {...}
    local str = ""

    -- Convert all arguments to strings (like print does)
    for i = 1, #args do
        str = str .. tostring(args[i])
        if i < #args then
            str = str .. "\t" -- match print spacing
        end
    end

    -- Build full file path
    local path = ModCS.GetSavePath() .. "/log.txt"

    -- Open file in append mode
    local file = io.open(path, "a")
    if file then
        file:write(str .. "\n")
        file:close()
    end
end
