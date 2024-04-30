#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

int lua_NpcIndex(lua_State* L);
int lua_NpcNextIndex(lua_State* L);

#define FUNCTION_TABLE_NPC_SIZE 31
extern FUNCTION_TABLE NpcFunctionTable[FUNCTION_TABLE_NPC_SIZE];

int NpcActModScript(int char_code, int i);