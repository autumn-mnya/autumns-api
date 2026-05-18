#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_SELSTAGE_SIZE 3
extern FUNCTION_TABLE SelStageFunctionTable[FUNCTION_TABLE_SELSTAGE_SIZE];