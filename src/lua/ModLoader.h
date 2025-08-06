#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

extern "C" __declspec(dllexport) unsigned char ModLoader_GetByte(void* address);
extern "C" __declspec(dllexport) unsigned short ModLoader_GetWord(void* address);
extern "C" __declspec(dllexport) unsigned long ModLoader_GetLong(void* address);

#define FUNCTION_TABLE_MOD_LOADER_SIZE 8
extern FUNCTION_TABLE ModLoaderFunctionTable[FUNCTION_TABLE_MOD_LOADER_SIZE];