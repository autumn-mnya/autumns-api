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

#include "Lua_Game.h"

#include "Lua.h"

#include "../Main.h"
#include "../mod_loader.h"
#include "../cave_story.h"

static int lua_GameGetMode(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gCurrentGameMode);

	return 1;
}

static int lua_GameSetMode(lua_State* L)
{
	gCurrentGameMode = (int)luaL_checkinteger(L, 1);
	gModeSetted = TRUE;

	return 0;
}

static int lua_GameIsNew(lua_State* L)
{
	lua_pushboolean(L, !bContinue);

	return 1;
}

static int lua_GameSetNew(lua_State* L)
{
	bContinue = !lua_toboolean(L, 1);

	return 0;
}

static int lua_GameCanAct(lua_State* L)
{
	if (g_GameFlags & 1)
		lua_pushboolean(L, TRUE);
	else
		lua_pushboolean(L, FALSE);

	return 1;
}

static int lua_GameCanControl(lua_State* L)
{
	if (g_GameFlags & 2)
		lua_pushboolean(L, TRUE);
	else
		lua_pushboolean(L, FALSE);

	return 1;
}

static int lua_GameGetGameFlags(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)g_GameFlags);
	return 1;
}

static int lua_GameSetGameFlags(lua_State* L)
{
	g_GameFlags = luaL_checknumber(L, 1);
	return 0;
}

FUNCTION_TABLE GameFunctionTable[FUNCTION_TABLE_GAME_SIZE] =
{
	{"GetMode", lua_GameGetMode},
	{"SetMode", lua_GameSetMode},
	{"IsNew", lua_GameIsNew},
	{"SetNew", lua_GameSetNew},
	{"CanAct", lua_GameCanAct},
	{"CanControl", lua_GameCanControl},
	{"GetGameFlags", lua_GameGetGameFlags},
	{"SetGameFlags", lua_GameSetGameFlags},
};