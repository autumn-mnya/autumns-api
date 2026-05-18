#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include "SelStage.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_SelStageClear(lua_State* L)
{
	ClearPermitStage();
	return 0;
}

static int lua_SelStageAdd(lua_State* L)
{
    int index = (int)luaL_checknumber(L, 1);
    int event = (int)luaL_checknumber(L, 2);
	AddPermitStage(index, event);
	return 0;
}

static int lua_SelStageRemove(lua_State* L)
{
    int index = (int)luaL_checknumber(L, 1);
	SubPermitStage(index);
	return 0;
}

FUNCTION_TABLE SelStageFunctionTable[FUNCTION_TABLE_SELSTAGE_SIZE] =
{
    {"Clear", lua_SelStageClear},
    {"Add", lua_SelStageAdd},
    {"Remove", lua_SelStageRemove},
};