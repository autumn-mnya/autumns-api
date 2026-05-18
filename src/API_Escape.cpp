#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_Escape.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

#include "lua/Lua.h"

/*
ArmsItem.cpp - CampLoop() - 0x401DF2
Ending.cpp - Scene_DownIsland() - 0x40DC2A
Game.cpp - ModeOpening() - 0x40F7CD
Game.cpp - ModeTitle() - 0x40FF6A
Game.cpp - ModeAction() - 0x4104E8
MiniMap.cpp - MiniMapLoop() - 0x4146D8
MiniMap.cpp - MiniMapLoop() - 0x41488B
MiniMap.cpp - MiniMapLoop() - 0x4149F0
SelStage.cpp - StageSelectLoop() - 0x41DAA0
*/

int Replacement_Call_Escape_ModCS()
{
    int ret = GamePauseModScript();

    if (ret == -1)
        return Call_Escape(ghWnd);

    return ret;
}