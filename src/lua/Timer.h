#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_TIMER_SIZE 5
extern FUNCTION_TABLE TimerFunctionTable[FUNCTION_TABLE_TIMER_SIZE];