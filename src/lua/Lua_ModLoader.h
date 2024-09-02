#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_MOD_LOADER_SIZE 5
extern FUNCTION_TABLE ModLoaderFunctionTable[FUNCTION_TABLE_MOD_LOADER_SIZE];