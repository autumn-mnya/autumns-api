#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

int lua_ArmsIndex(lua_State* L);
int lua_ArmsNextIndex(lua_State* L);

#define FUNCTION_TABLE_ARMS_SIZE 14
extern FUNCTION_TABLE ArmsFunctionTable[FUNCTION_TABLE_ARMS_SIZE];

int ShootActModScript(int chr);

int lua_ItemIndex(lua_State* L);
int lua_ItemNextIndex(lua_State* L);

#define FUNCTION_TABLE_ITEM_SIZE 4
extern FUNCTION_TABLE ItemFunctionTable[FUNCTION_TABLE_ITEM_SIZE];