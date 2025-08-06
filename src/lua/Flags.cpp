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

#include "Flags.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

static int lua_SetFlag(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (no < 0 || no > 8000)
		SerenaAlert(L, "Out of bounds flag set");

	SetNPCFlag(no);

	return 0;
}

static int lua_UnsetFlag(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (no < 0 || no > 8000)
		SerenaAlert(L, "Out of bounds flag unset");

	CutNPCFlag(no);

	return 0;
}

static int lua_GetFlag(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (no < 0 || no > 8000)
		SerenaAlert(L, "Out of bounds flag referenced");

	lua_pushboolean(L, GetNPCFlag(no));

	return 1;
}

FUNCTION_TABLE FlagFunctionTable[FUNCTION_TABLE_FLAG_SIZE] =
{
	{"Set", lua_SetFlag},
	{"Unset", lua_UnsetFlag},
	{"Get", lua_GetFlag},
};

static int lua_SetSkipFlag(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (no < 0 || no > 64)
		SerenaAlert(L, "Out of bounds skipflag set");

	SetSkipFlag(no);

	return 0;
}

static int lua_UnsetSkipFlag(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (no < 0 || no > 64)
		SerenaAlert(L, "Out of bounds skipflag unset");

	CutSkipFlag(no);

	return 0;
}

static int lua_GetSkipFlag(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (no < 0 || no > 64)
		SerenaAlert(L, "Out of bounds skipflag referenced");

	lua_pushboolean(L, GetSkipFlag(no));

	return 1;
}

FUNCTION_TABLE SkipFlagFunctionTable[FUNCTION_TABLE_SKIPFLAG_SIZE] =
{
	{"Set", lua_SetSkipFlag},
	{"Unset", lua_UnsetSkipFlag},
	{"Get", lua_GetSkipFlag},
};