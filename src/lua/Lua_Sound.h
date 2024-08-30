#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_SOUND_SIZE 7
extern FUNCTION_TABLE SoundFunctionTable[FUNCTION_TABLE_SOUND_SIZE];
#define FUNCTION_TABLE_ORG_SIZE 9
extern FUNCTION_TABLE OrgFunctionTable[FUNCTION_TABLE_ORG_SIZE];