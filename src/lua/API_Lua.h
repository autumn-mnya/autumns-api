#pragma once

#include <Windows.h>
#include <vector>
#include "../cave_story.h"
#include "../Main.h"

extern "C"
{
#include <lua.h>
}

typedef void (*PreGlobalModCSElementHandler)();
typedef void (*LuaMetadataElementHandler)();
typedef void (*LuaFuncElementHandler)();

ELEMENT_HEADERS(PreGlobalModCSElementHandler, LuaPreGlobalModCSElement)
ELEMENT_HEADERS(LuaMetadataElementHandler, LuaMetadataElement)
ELEMENT_HEADERS(LuaFuncElementHandler, LuaFuncElement)

extern "C" __declspec(dllexport) lua_State * GetLuaL();
void RunLuaPreGlobalModCSCode();
void RunLuaMetadataCode();
void AddAutPILuaFunctions();