#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_FLASH_SIZE 5
extern FUNCTION_TABLE FlashFunctionTable[FUNCTION_TABLE_FLASH_SIZE];