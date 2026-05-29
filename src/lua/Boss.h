#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_BOSS_SIZE 8
extern FUNCTION_TABLE BossFunctionTable[FUNCTION_TABLE_BOSS_SIZE];

int BossActModScript(int char_code, int i);