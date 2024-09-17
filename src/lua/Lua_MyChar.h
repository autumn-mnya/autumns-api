#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

int lua_PlayerIndex(lua_State* L);
int lua_PlayerNextIndex(lua_State* L);

#define FUNCTION_TABLE_PLAYER_SIZE 27
extern FUNCTION_TABLE PlayerFunctionTable[FUNCTION_TABLE_PLAYER_SIZE];
