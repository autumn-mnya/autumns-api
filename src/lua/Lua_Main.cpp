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

static int lua_ModSetOpening(lua_State* L)
{
	OpeningMap[0] = (int)luaL_checknumber(L, 1);
	OpeningMap[3] = (int)luaL_optnumber(L, 2, 0);
	OpeningMap[4] = (int)luaL_optnumber(L, 3, 500);

	ModLoader_WriteByte((void*)0x40F765, OpeningMap[0]);
	ModLoader_WriteByte((void*)0x40F763, OpeningMap[3]);
	ModLoader_WriteLong((void*)0x40F7A0, OpeningMap[4]);

	return 0;
}

static int lua_ModSetStart(lua_State* L)
{
	StartingMap[0] = (int)luaL_checknumber(L, 1);
	StartingMap[1] = (int)luaL_checknumber(L, 2);
	StartingMap[2] = (int)luaL_checknumber(L, 3);
	StartingMap[3] = (int)luaL_optnumber(L, 4, 0);

	ModLoader_WriteByte((void*)0x41D599, StartingMap[0]);
	ModLoader_WriteByte((void*)0x41D594, StartingMap[1]);
	ModLoader_WriteByte((void*)0x41D592, StartingMap[2]);
	ModLoader_WriteByte((void*)0x41D590, StartingMap[3]);

	return 0;
}

FUNCTION_TABLE ModFunctionTable[FUNCTION_TABLE_MOD_SIZE] =
{
	{"SetName", lua_ModSetName},
	{"SetAuthor", lua_ModSetAuthor},
	{"SetOpening", lua_ModSetOpening},
	{"SetStart", lua_ModSetStart}
};