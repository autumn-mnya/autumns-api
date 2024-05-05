#pragma once


#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

extern char gModName[256];
extern char gModAuthor[256];

#define FUNCTION_TABLE_MOD_SIZE 4
extern FUNCTION_TABLE ModFunctionTable[FUNCTION_TABLE_MOD_SIZE];

BOOL PreModeInitModScript(void);
void RegisterPreModeModScript();