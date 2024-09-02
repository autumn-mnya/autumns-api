#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

void KeyCheck(lua_State* L, int Key, int KeyTrg, int button);

#define FUNCTION_TABLE_KEY_SIZE 18
extern FUNCTION_TABLE KeyFunctionTable[FUNCTION_TABLE_KEY_SIZE];

int KeyControlModScript(unsigned int vkey, bool down);