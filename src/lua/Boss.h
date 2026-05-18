#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

int lua_BossIndex(lua_State* L);
int lua_BossNextIndex(lua_State* L);
int lua_BossGetByIndex(lua_State* L);

#define FUNCTION_TABLE_BOSS_SIZE 6
extern FUNCTION_TABLE BossFunctionTable[FUNCTION_TABLE_BOSS_SIZE];

int BossActModScript(int char_code, int i);