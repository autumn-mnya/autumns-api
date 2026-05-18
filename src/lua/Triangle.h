#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

unsigned char Replacement_GetArktan(int x, int y);

#define FUNCTION_TABLE_TRIANGLE_SIZE 5
extern FUNCTION_TABLE TriangleFunctionTable[FUNCTION_TABLE_TRIANGLE_SIZE];