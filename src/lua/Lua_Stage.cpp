#include <Windows.h>
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

#include "Lua_Stage.h"

#include "Lua.h"

#include "Lua_TextScr.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"
#include "../API_TransferStage.h"

static int lua_StageGetCurrentNo(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gStageNo);

	return 1;
}

static int lua_StageGetTileset(lua_State* L)
{
	int no = (int)luaL_optnumber(L, 1, gStageNo);

	lua_pushstring(L, gTMT[no].parts);

	return 1;
}

static int lua_StageGetFilename(lua_State* L)
{
	int no = (int)luaL_optnumber(L, 1, gStageNo);

	lua_pushstring(L, gTMT[no].map);

	return 1;
}

static int lua_StageGetBackgroundMode(lua_State* L)
{
	int no = (int)luaL_optnumber(L, 1, gStageNo);

	lua_pushnumber(L, gTMT[no].bkType);

	return 1;
}

static int lua_StageGetBackground(lua_State* L)
{
	int no = (int)luaL_optnumber(L, 1, gStageNo);

	lua_pushstring(L, gTMT[no].back);

	return 1;
}

static int lua_StageGetNpcSheet1(lua_State* L)
{
	int no = (int)luaL_optnumber(L, 1, gStageNo);

	lua_pushstring(L, gTMT[no].npc);

	return 1;
}

static int lua_StageGetNpcSheet2(lua_State* L)
{
	int no = (int)luaL_optnumber(L, 1, gStageNo);

	lua_pushstring(L, gTMT[no].boss);

	return 1;
}

static int lua_StageGetBossNo(lua_State* L)
{
	int no = (int)luaL_optnumber(L, 1, gStageNo);

	lua_pushnumber(L, gTMT[no].boss_no);

	return 1;
}

static int lua_StageGetName(lua_State* L)
{
	int no = (int)luaL_optnumber(L, 1, gStageNo);

	lua_pushstring(L, gTMT[no].name);

	return 1;
}

static int lua_StageTransfer(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);
	int x = (int)luaL_optnumber(L, 2, gMC.x / 0x200 / 16);
	int y = (int)luaL_optnumber(L, 3, gMC.y / 0x200 / 16);
	int eve = (int)luaL_optnumber(L, 4, 0);

	gReadValue = 0;

	TransferStage(no, eve, x, y);

	return 0;
}

FUNCTION_TABLE StageFunctionTable[FUNCTION_TABLE_STAGE_SIZE] =
{
	{"GetCurrentNo", lua_StageGetCurrentNo},
	{"GetTileset", lua_StageGetTileset},
	{"GetFilename", lua_StageGetFilename},
	{"GetBackgroundMode", lua_StageGetBackgroundMode},
	{"GetBackground", lua_StageGetBackground},
	{"GetNpcSheet1", lua_StageGetNpcSheet1},
	{"GetNpcSheet2", lua_StageGetNpcSheet2},
	{"GetBossNo", lua_StageGetBossNo},
	{"GetName", lua_StageGetName},
	{"Transfer", lua_StageTransfer},
};

static int lua_MapGetWidth(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gMap.width);

	return 1;
}

static int lua_MapGetHeight(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gMap.length);

	return 1;
}

static int lua_MapGetAttribute(lua_State* L)
{
	int x = (int)luaL_checknumber(L, 1);
	int y = (int)luaL_checknumber(L, 2);
	int attribute = GetAttribute(x, y);
	lua_pushnumber(L, (lua_Number)attribute);

	return 1;
}

static int lua_MapChangeTile(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);
	int x = (int)luaL_checknumber(L, 2);
	int y = (int)luaL_checknumber(L, 3);

	ChangeMapParts(x, y, no);

	return 0;
}

FUNCTION_TABLE MapFunctionTable[FUNCTION_TABLE_MAP_SIZE] =
{
	{"GetWidth", lua_MapGetWidth},
	{"GetHeight", lua_MapGetHeight},
	{"GetAttribute", lua_MapGetAttribute},
	{"ChangeTile", lua_MapChangeTile},
};

BOOL StageOnTransferModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Stage");
	lua_getfield(gL, -1, "OnTransfer");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute stage transfer function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

bool modcs_has_transferred_stage;

void OnTransfer_Init()
{
	modcs_has_transferred_stage = false;
}

void OnTransfer()
{
	modcs_has_transferred_stage = true;
}

void OnTransfer_Act()
{
	if (modcs_has_transferred_stage)
	{
		if (!StageOnTransferModScript())
			return;

		modcs_has_transferred_stage = false;
	}
}

// To run lua code during a TransferStage call
void RegisterOnTransferStage()
{
	RegisterTransferStageInitElement(OnTransfer);
	RegisterOpeningInitElement(OnTransfer_Init);
	RegisterInitElement(OnTransfer_Init);
	RegisterOpeningActionElement(OnTransfer_Act);
	RegisterActionElement(OnTransfer_Act);
}