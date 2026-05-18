#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_CREDITS_SIZE 6
extern FUNCTION_TABLE CreditsFunctionTable[FUNCTION_TABLE_CREDITS_SIZE];