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

#include "MiniMap.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_MiniMapLoop(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)Replacement_ModeAction_MiniMapLoop());
	return 1;
}

static int lua_MiniMapSet(lua_State* L)
{
    int a = (int)luaL_checknumber(L, 1);
	SetMapping(a);
	return 0;
}

static int lua_MiniMapActive(lua_State* L)
{
	if (IsMapping())
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_MiniMapStart(lua_State* L)
{
	StartMapping();
	return 0;
}

FUNCTION_TABLE MiniMapFunctionTable[FUNCTION_TABLE_MINIMAP_SIZE] =
{
    {"ActLoop", lua_MiniMapLoop},
    {"Set", lua_MiniMapSet},
    {"Get", lua_MiniMapActive},
    {"Reset", lua_MiniMapStart},
};