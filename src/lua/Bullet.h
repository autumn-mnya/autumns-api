#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

int lua_BulletIndex(lua_State* L);
int lua_BulletNextIndex(lua_State* L);

#define FUNCTION_TABLE_BULLET_SIZE 23
extern FUNCTION_TABLE BulletFunctionTable[FUNCTION_TABLE_BULLET_SIZE];

int BulletActModScript(int code, int i);