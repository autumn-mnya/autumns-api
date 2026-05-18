#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_FADE_SIZE 8
extern FUNCTION_TABLE FadeFunctionTable[FUNCTION_TABLE_FADE_SIZE];