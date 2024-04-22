#pragma once

#include <Windows.h>
#include <vector>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

typedef void (*PreGlobalModCSElementHandler)();
extern std::vector<PreGlobalModCSElementHandler> preglobalmodcsElementHandlers;
typedef void (*LuaMetadataElementHandler)();
extern std::vector<LuaMetadataElementHandler> luametadataElementHandlers;
typedef void (*LuaFuncElementHandler)();
extern std::vector<LuaFuncElementHandler> luafuncElementHandlers;

extern "C" __declspec(dllexport) lua_State * GetLuaL();
extern "C" __declspec(dllexport) void RegisterLuaPreGlobalModCSElement(PreGlobalModCSElementHandler handler);
void ExecuteLuaPreGlobalModCSElementHandlers();
void RunLuaPreGlobalModCSCode();
extern "C" __declspec(dllexport) void RegisterLuaMetadataElement(LuaMetadataElementHandler handler);
void ExecuteLuaMetadataElementHandlers();
void RunLuaMetadataCode();
extern "C" __declspec(dllexport) void RegisterLuaFuncElement(LuaFuncElementHandler handler);
void ExecuteLuaFuncElementHandlers();
void AddAutPILuaFunctions();