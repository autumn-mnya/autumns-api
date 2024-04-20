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

#include "Lua_Main.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

char gModName[256] = "LuaApi";
char gModAuthor[256] = "DllMod";

int gSpikeDamage = 10;

static int ModVersion[4] = { 1, 0, 0, 6 };

static int OpeningMap[5] = { 72, 3, 3, 100, 500 };
static int StartingMap[4] = { 13, 10, 8, 200 };

static int lua_ModSetName(lua_State* L)
{
	strcpy(gModName, luaL_checkstring(L, 1));

	return 0;
}

static int lua_ModSetAuthor(lua_State* L)
{
	strcpy(gModAuthor, luaL_checkstring(L, 1));
	return 0;
}

FUNCTION_TABLE ModFunctionTable[FUNCTION_TABLE_MOD_SIZE] =
{
	{"SetName", lua_ModSetName},
	{"SetAuthor", lua_ModSetAuthor},
};