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

#include "Game.h"

#include "Lua.h"

#include "../Main.h"
#include "../mod_loader.h"
#include "../cave_story.h"
#include "../ModSettings.h"

static int lua_GameGetMode(lua_State* L)
{
	if (use_mode_overhaul)
		lua_pushnumber(L, (lua_Number)gGameMode);
	else
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

static int lua_GameRandom(lua_State* L)
{
	int min = (int)luaL_checknumber(L, 1);
	int max = (int)luaL_checknumber(L, 2);

	int val = (Random(min, max));
	lua_pushnumber(L, (lua_Number)val);
	return 1;
}

static int lua_GameRandom2(lua_State* L) 
{
    double min = luaL_checknumber(L, 1);
    double max = luaL_checknumber(L, 2);

    int min_fp = (int)(min * 512.0);
    int max_fp = (int)(max * 512.0);

    int val = Random(min_fp, max_fp);

    lua_pushnumber(L, (lua_Number)val / 512.0);
    return 1;
}

static int lua_GameSetBit(lua_State* L)
{
    int variable = (int)luaL_checknumber(L, 1);
    int bit = (int)luaL_checknumber(L, 2);

    variable |= bit;

    lua_pushinteger(L, variable);
    return 1;
}

static int lua_GameUnsetBit(lua_State* L)
{
    int variable = (int)luaL_checknumber(L, 1);
    int bit = (int)luaL_checknumber(L, 2);

    variable &= ~bit;

    lua_pushinteger(L, variable);
    return 1;
}

static int lua_GameCheckBit(lua_State* L)
{
    int variable = (int)luaL_checknumber(L, 1);
    int bit = (int)luaL_checknumber(L, 2);

    lua_pushboolean(L, (variable & bit) != 0);
    return 1;
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
	{"Random", lua_GameRandom},
	{"Random2", lua_GameRandom2},
	{"SetBit", lua_GameSetBit},
	{"UnsetBit", lua_GameUnsetBit},
	{"CheckBit", lua_GameCheckBit},
};