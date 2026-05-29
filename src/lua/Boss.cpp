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

#include "Boss.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_GetBossByBufferIndex(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	bool ignore_alive = lua_toboolean(L, 2);

	if ((gBoss[id].cond & 0x80) || ignore_alive)
	{
		NPCHAR** boss = (NPCHAR**)lua_newuserdata(L, sizeof(NPCHAR*));
		*boss = &gBoss[id];

		luaL_getmetatable(L, "NpcMeta");
		lua_setmetatable(L, -2);

		return 1;
	}

	return 0;
}

static int lua_BossCopy(lua_State* L)
{
    NPCHAR** source = (NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
    NPCHAR** target = (NPCHAR**)luaL_checkudata(L, 2, "NpcMeta");
    **target = **source;
    return 0;
}

static int lua_BossInitLife(lua_State* L)
{
	InitBossLife();
	return 0;
}

static int lua_BossPutLife(lua_State* L)
{
    PutBossLife();
    return 0;
}

static int lua_BossInit(lua_State* L)
{
    int id = (int)luaL_checknumber(L, 1);
    InitBossChar(id);
    return 0;
}

static int lua_BossAct(lua_State* L)
{
    ActBossChar();
    return 0;
}

static int lua_BossTileHitCode(lua_State* L)
{
	HitBossMap();
	return 0;
}

static int lua_BossPut(lua_State* L)
{
    int fx = (int)luaL_checknumber(L, 1);
    int fy = (int)luaL_checknumber(L, 2);

	PutBossChar(fx, fy);
	return 0;
}

FUNCTION_TABLE BossFunctionTable[FUNCTION_TABLE_BOSS_SIZE] =
{
	{"GetByBufferIndex", lua_GetBossByBufferIndex},
	{"Copy", lua_BossCopy},
    {"InitLife", lua_BossInitLife},
    {"DrawLife", lua_BossPutLife},
    {"Set", lua_BossInit},
    {"ActMain", lua_BossAct},
    {"TileHitCode", lua_BossTileHitCode},
    {"DrawMain", lua_BossPut},
};

int BossActModScript(int char_code, int i)
{
	if (!gL)
		return 1;
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Boss");
	lua_getfield(gL, -1, "Act");
	lua_geti(gL, -1, char_code);

	if (lua_isnil(gL, -1))
	{
		char trolololo[0x10];
		sprintf(trolololo, "Act%d", char_code);
		lua_getfield(gL, -3, trolololo);

		if (lua_isnil(gL, -1))
		{
			lua_settop(gL, 0); // Clear stack
			return 1;
		}
	}

	NPCHAR** boss = (NPCHAR**)lua_newuserdata(gL, sizeof(NPCHAR*));
	*boss = &gBoss[0];

	luaL_getmetatable(gL, "NpcMeta");
	lua_setmetatable(gL, -2);

	if (lua_pcall(gL, 1, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, error, "Boss Act ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return 2;
}