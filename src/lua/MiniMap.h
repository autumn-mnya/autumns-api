#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_MINIMAP_SIZE 4
extern FUNCTION_TABLE MiniMapFunctionTable[FUNCTION_TABLE_MINIMAP_SIZE];