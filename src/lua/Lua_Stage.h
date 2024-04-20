#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_STAGE_SIZE 10
extern FUNCTION_TABLE StageFunctionTable[FUNCTION_TABLE_STAGE_SIZE];
#define FUNCTION_TABLE_MAP_SIZE 4
extern FUNCTION_TABLE MapFunctionTable[FUNCTION_TABLE_MAP_SIZE];