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

#include "Lua_Mod.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

char gModName[256] = "LuaApi";
char gModAuthor[256] = "DllMod";

int gSpikeDamage = 10;

static int ModVersion[4] = { 1, 0, 0, 6 };

static int OpeningMap[5] = { 72, 3, 3, 100, 500 };
static int StartingMap[4] = { 13, 10, 8, 200 };

int initMyChar[3] = { 3, 3, 2 };

static int lua_ModSetName(lua_State* L)
{
	strcpy(gModName, luaL_checkstring(L, 1));
	SetWindowTextA(ghWnd, gModName);
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

static int lua_ModSetBossHealth(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	int value = (int)luaL_checknumber(L, 2);
	int address = 0;

	switch (id)
	{
		// Omega
		case 1:
			address = 0x47b7cf;
			break;

		// Balfrog
		case 2:
			address = 0x4793e7;
			break;

		// Monster X
		case 3:
			address = 0x47e816;
			break;

		// Core
		case 4:
			address = 0x4744d0;
			break;

		// Ironhead
		case 5:
			address = 0x47aa4e;
			break;

		// Dragon Sisters
		case 6:
			address = 0x47d2f1;
			break;

		// Undead Core
		case 7:
			address = 0x4754c3;
			break;

		// Heavy Press
		case 8:
			address = 0x47c988;
			break;

		// Ballos Ball (phase 2)
		case 9:
			address = 0x4774c7;
			break;

		// Ballos Ball (phase 4)
		case 10:
			address = 0x477ae9;
			break;
	}

	if (address != 0)
		ModLoader_WriteWord((void*)address, value);

	return 0;
}

static int lua_ModSetSpikeDamage(lua_State* L)
{
	gSpikeDamage = (int)luaL_checknumber(L, 1);

	ModLoader_WriteByte((void*)0x4162F0, gSpikeDamage);

	return 0;
}

static int lua_ModSetInitMyChar(lua_State* L)
{
	initMyChar[0] = (int)luaL_checknumber(L, 1);
	initMyChar[1] = (int)luaL_checknumber(L, 2);
	initMyChar[2] = (int)luaL_checknumber(L, 3);

	ModLoader_WriteWord((void*)0x414BD8, initMyChar[1]); //max hp
	ModLoader_WriteWord((void*)0x414BCF, initMyChar[0]); //current hp
	ModLoader_WriteLong((void*)0x414B74, initMyChar[2]); //direction

	return 0;
}

FUNCTION_TABLE ModFunctionTable[FUNCTION_TABLE_MOD_SIZE] =
{
	{"SetName", lua_ModSetName},
	{"SetAuthor", lua_ModSetAuthor},
	{"SetOpening", lua_ModSetOpening},
	{"SetStart", lua_ModSetStart},
	{"SetBossHP", lua_ModSetBossHealth},
	{"SetSpikeDamage", lua_ModSetSpikeDamage},
	{"StartStartMyChar", lua_ModSetInitMyChar},
};

BOOL PreModeInitModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Mod");
	lua_getfield(gL, -1, "Init");

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
		MessageBoxA(ghWnd, "Couldn't execute mod init function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

void RegisterPreModeModScript()
{
	if (!PreModeInitModScript())
		return;
}