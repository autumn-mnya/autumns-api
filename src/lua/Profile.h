#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_PROFILE_SIZE 5
extern FUNCTION_TABLE ProfileFunctionTable[FUNCTION_TABLE_PROFILE_SIZE];

void RegisterSaveAndLoad();