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

#define FUNCTION_TABLE_MOD_SIZE 7
extern FUNCTION_TABLE ModFunctionTable[FUNCTION_TABLE_MOD_SIZE];

void GetDefaultOpening();
void GetDefaultStart();
BOOL TransferToOpeningStage(int default_no, int default_event, int default_x, int default_y);
BOOL TransferToStartingStage(int default_no, int default_event, int default_x, int default_y);
BOOL PreModeInitModScript(void);
void RegisterPreModeModScript();