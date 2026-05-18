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

#include "Timer.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_TimerGet(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)time_count);

	return 1;
}

static int lua_TimerSet(lua_State* L)
{
	int x = (int)luaL_checknumber(L, 1);
	time_count = x;

	return 0;
}

static int lua_TimerSave(lua_State* L)
{
    SaveTimeCounter();
    return 0;
}

static int lua_TimerLoad(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)LoadTimeCounter());
	return 1;
}

static int lua_TimerPut(lua_State *L)
{
	int x = (int)luaL_checknumber(L, 1);
	int y = (int)luaL_checknumber(L, 2);
	PutTimeCounter(x, y);
	return 0;
}

FUNCTION_TABLE TimerFunctionTable[FUNCTION_TABLE_TIMER_SIZE] =
{
    {"Get", lua_TimerGet},
    {"Set", lua_TimerSet},
    {"Save", lua_TimerSave},
    {"Load", lua_TimerLoad},
    {"Put", lua_TimerPut},
};