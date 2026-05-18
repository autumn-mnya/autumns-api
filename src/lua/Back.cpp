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

#include "Back.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static STRUCT_TABLE BackTable[] =
{
	{"width", offsetof(BACK, partsW), TYPE_NUMBER},
	{"height", offsetof(BACK, partsH), TYPE_NUMBER},
	{"numX", offsetof(BACK, numX), TYPE_NUMBER},
	{"numY", offsetof(BACK, numY), TYPE_NUMBER},
	{"type", offsetof(BACK, type), TYPE_NUMBER},
	{"fx", offsetof(BACK, fx), TYPE_NUMBER},
};

int lua_BackIndex(lua_State* L)
{
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, BackTable, &gBack, sizeof(BackTable) / sizeof(STRUCT_TABLE)))
		return 1;

	if (strcmp(x, "waterY") == 0)
	{
		lua_pushnumber(L, gWaterY / 512);
		return 1;
	}

	return 0;
}

int lua_BackNextIndex(lua_State* L)
{
	const char* x = luaL_checkstring(L, 2);

	if (Write2StructBasic(L, x, BackTable, &gBack, sizeof(BackTable) / sizeof(STRUCT_TABLE)))
		return 0;

	if (strcmp(x, "waterY") == 0)
	{
		gWaterY = (int)luaL_checknumber(L, 3) * 512;
		return 0;
	}

	lua_rawset(L, -3);

	return 0;
}

static int lua_InitBack(lua_State* L)
{
    const char* backName = luaL_checkstring(L, 1);
    int type = (int)luaL_checkinteger(L, 2);

    InitBack(backName, type);

    return 0;
}

static int lua_BackAct(lua_State* L)
{
	ActBack();
	return 0;
}

static int lua_BackPut(lua_State* L)
{
    int fx = (int)luaL_checknumber(L, 1);
    int fy = (int)luaL_checknumber(L, 2);

	PutBack(fx, fy);
	return 0;
}

static int lua_BackPutFront(lua_State* L)
{
    int fx = (int)luaL_checknumber(L, 1);
    int fy = (int)luaL_checknumber(L, 2);

	PutFront(fx, fy);
	return 0;
}

FUNCTION_TABLE BackFunctionTable[FUNCTION_TABLE_BACK_SIZE] =
{
	{"Set", lua_InitBack},
	{"ActMain", lua_BackAct},
	{"DrawMain", lua_BackPut},
	{"DrawFront", lua_BackPutFront},
};