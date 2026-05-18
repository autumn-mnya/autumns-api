#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_STAGE_SIZE 15
extern FUNCTION_TABLE StageFunctionTable[FUNCTION_TABLE_STAGE_SIZE];
#define FUNCTION_TABLE_MAP_SIZE 6
extern FUNCTION_TABLE MapFunctionTable[FUNCTION_TABLE_MAP_SIZE];

void RegisterOnTransferStage();