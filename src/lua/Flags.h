#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_FLAG_SIZE 3
extern FUNCTION_TABLE FlagFunctionTable[FUNCTION_TABLE_FLAG_SIZE];
#define FUNCTION_TABLE_SKIPFLAG_SIZE 3
extern FUNCTION_TABLE SkipFlagFunctionTable[FUNCTION_TABLE_SKIPFLAG_SIZE];