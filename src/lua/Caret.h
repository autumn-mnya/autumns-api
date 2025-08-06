#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

int lua_CaretIndex(lua_State* L);
int lua_CaretNextIndex(lua_State* L);

#define FUNCTION_TABLE_CARET_SIZE 8
extern FUNCTION_TABLE CaretFunctionTable[FUNCTION_TABLE_CARET_SIZE];

int CaretActModScript(int code, int i);