#include <Windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include "API_Lua.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

lua_State* GetLuaL()
{
	if (gL != nullptr)
		return gL;
	else
		return nullptr;
}

// Pre Global ModCS

std::vector<PreGlobalModCSElementHandler> preglobalmodcsElementHandlers;

void RegisterLuaPreGlobalModCSElement(PreGlobalModCSElementHandler handler)
{
    preglobalmodcsElementHandlers.push_back(handler);
}

void ExecuteLuaPreGlobalModCSElementHandlers()
{
    for (const auto& handler : preglobalmodcsElementHandlers)
    {
        handler();
    }
}

void RunLuaPreGlobalModCSCode()
{
    ExecuteLuaPreGlobalModCSElementHandlers();
}

// Metadata

std::vector<LuaMetadataElementHandler> luametadataElementHandlers;
std::vector<LuaFuncElementHandler> luafuncElementHandlers;

void RegisterLuaMetadataElement(LuaMetadataElementHandler handler)
{
    luametadataElementHandlers.push_back(handler);
}

void ExecuteLuaMetadataElementHandlers()
{
    for (const auto& handler : luametadataElementHandlers)
    {
        handler();
    }
}

void RunLuaMetadataCode()
{
    ExecuteLuaMetadataElementHandlers();
}

// Lua Func

void RegisterLuaFuncElement(LuaFuncElementHandler handler)
{
    luafuncElementHandlers.push_back(handler);
}

void ExecuteLuaFuncElementHandlers()
{
    for (const auto& handler : luafuncElementHandlers)
    {
        handler();
    }
}

void AddAutPILuaFunctions()
{
    ExecuteLuaFuncElementHandlers();
}