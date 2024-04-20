#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_KEY_SIZE 13
extern FUNCTION_TABLE KeyFunctionTable[FUNCTION_TABLE_KEY_SIZE];