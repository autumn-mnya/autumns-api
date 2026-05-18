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

#include "Star.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_StarInit(lua_State* L)
{
	InitStar();
	return 0;
}

static int lua_StarAct(lua_State* L)
{
	ActStar();
	return 0;
}

static int lua_StarPut(lua_State* L)
{
    int fx = (int)luaL_checknumber(L, 1);
    int fy = (int)luaL_checknumber(L, 2);

	PutStar(fx, fy);
	return 0;
}

FUNCTION_TABLE StarFunctionTable[FUNCTION_TABLE_STAR_SIZE] =
{
    {"Init", lua_StarInit},
    {"Act", lua_StarAct},
    {"DrawMain", lua_StarPut},
};