#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

extern int gReadValue;

#define FUNCTION_TABLE_TSC_SIZE 5
extern FUNCTION_TABLE TscFunctionTable[FUNCTION_TABLE_TSC_SIZE];

int TSCCommandModScript(char command[4]);