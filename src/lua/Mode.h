#pragma once

extern "C"
{
#include <lua.h>
}

#include "Lua.h"


#define FUNCTION_TABLE_MODE_SIZE 130
extern FUNCTION_TABLE ModeFunctionTable[FUNCTION_TABLE_MODE_SIZE];

int ModeModScript(int char_code);