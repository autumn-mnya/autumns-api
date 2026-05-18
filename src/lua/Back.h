#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

int lua_BackIndex(lua_State* L);
int lua_BackNextIndex(lua_State* L);

#define FUNCTION_TABLE_BACK_SIZE 4
extern FUNCTION_TABLE BackFunctionTable[FUNCTION_TABLE_BACK_SIZE];