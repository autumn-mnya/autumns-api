#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_VALUEVIEW_SIZE 7
extern FUNCTION_TABLE ValueViewFunctionTable[FUNCTION_TABLE_VALUEVIEW_SIZE];