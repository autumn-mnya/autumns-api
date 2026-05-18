#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_CONFIG_SIZE 3
extern FUNCTION_TABLE ConfigFunctionTable[FUNCTION_TABLE_CONFIG_SIZE];

int lua_ConfigIndex(lua_State* L);
int lua_ConfigNextIndex(lua_State* L);

BOOL SaveConfigData(ConfigData* conf);