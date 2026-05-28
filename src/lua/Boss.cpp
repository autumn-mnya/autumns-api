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

// Boss table and Boss acting is unfinished for now, its too complicated for my eepy brain.. Sorry im stupid!
// Maybe eventually!!

static STRUCT_TABLE BossTable[] =
{
	{"x", offsetof(NPCHAR, x), TYPE_PIXEL},
	{"y", offsetof(NPCHAR, y), TYPE_PIXEL},
	{"xm", offsetof(NPCHAR, xm), TYPE_PIXEL},
	{"ym", offsetof(NPCHAR, ym), TYPE_PIXEL},
	{"xm2", offsetof(NPCHAR, xm2), TYPE_PIXEL},
	{"ym2", offsetof(NPCHAR, ym2), TYPE_PIXEL},
	{"tgt_x", offsetof(NPCHAR, tgt_x), TYPE_PIXEL},
	{"tgt_y", offsetof(NPCHAR, tgt_y), TYPE_PIXEL},
	{"tgt_1", offsetof(NPCHAR, tgt_x), TYPE_NUMBER},
	{"tgt_2", offsetof(NPCHAR, tgt_y), TYPE_NUMBER},
	{"id", offsetof(NPCHAR, code_char), TYPE_NUMBER},
	{"flag", offsetof(NPCHAR, code_flag), TYPE_NUMBER},
	{"event", offsetof(NPCHAR, code_event), TYPE_NUMBER},
	{"surf", offsetof(NPCHAR, surf), TYPE_SURFACE},
	{"hit_voice", offsetof(NPCHAR, hit_voice), TYPE_NUMBER},
	{"destroy_voice", offsetof(NPCHAR, destroy_voice), TYPE_NUMBER},
	{"life", offsetof(NPCHAR, life), TYPE_NUMBER},
	{"exp", offsetof(NPCHAR, exp), TYPE_NUMBER},
	{"smoke_size", offsetof(NPCHAR, size), TYPE_NUMBER},
	{"direct", offsetof(NPCHAR, direct), TYPE_NUMBER},
	{"ani_wait", offsetof(NPCHAR, ani_wait), TYPE_NUMBER},
	{"ani_no", offsetof(NPCHAR, ani_no), TYPE_NUMBER},
	{"count1", offsetof(NPCHAR, count1), TYPE_NUMBER},
	{"count2", offsetof(NPCHAR, count2), TYPE_NUMBER},
	{"act_no", offsetof(NPCHAR, act_no), TYPE_NUMBER},
	{"act_wait", offsetof(NPCHAR, act_wait), TYPE_NUMBER},
	{"damage", offsetof(NPCHAR, damage), TYPE_NUMBER},
	{"pNpc", offsetof(NPCHAR, pNpc), TYPE_NPC},
	{"cond", offsetof(NPCHAR, cond), TYPE_NUMBER},
	{"hit_flag", offsetof(NPCHAR, flag), TYPE_NUMBER},
	{"shock", offsetof(NPCHAR, shock), TYPE_NUMBER},
	{"bits", offsetof(NPCHAR, bits), TYPE_NUMBER}
};

int lua_BossIndex(lua_State* L)
{
	NPCHAR** boss = (NPCHAR**)luaL_checkudata(L, 1, "BossMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, BossTable, *boss, sizeof(BossTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Boss");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_BossNextIndex(lua_State* L)
{
	NPCHAR** boss = (NPCHAR**)luaL_checkudata(L, 1, "BossMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, BossTable, *boss, sizeof(BossTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_GetBossByBufferIndex(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	bool ignore_alive = lua_toboolean(L, 2);

	if ((gBoss[id].cond & 0x80) || ignore_alive)
	{
		NPCHAR** boss = (NPCHAR**)lua_newuserdata(L, sizeof(NPCHAR*));
		*boss = &gBoss[id];

		luaL_getmetatable(L, "BossMeta");
		lua_setmetatable(L, -2);

		return 1;
	}

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
    {"InitLife", lua_BossInitLife},
    {"DrawLife", lua_BossPutLife},
    {"Set", lua_BossInit},
    {"ActMain", lua_BossAct},
    {"TileHitCode", lua_BossTileHitCode},
    {"DrawMain", lua_BossPut},
};

// unused for now, but exists
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
	*boss = &gBoss[i];

	luaL_getmetatable(gL, "BossMeta");
	lua_setmetatable(gL, -2);

	if (lua_pcall(gL, 1, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return 2;
}