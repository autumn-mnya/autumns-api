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

#include "../Main.h"
#include "../mod_loader.h"
#include "../cave_story.h"

DEFINE_ELEMENT_HANDLERS(PreGlobalModCSElementHandler, LuaPreGlobalModCSElement)
DEFINE_ELEMENT_HANDLERS(LuaMetadataElementHandler, LuaMetadataElement)
DEFINE_ELEMENT_HANDLERS(LuaFuncElementHandler, LuaFuncElement)

lua_State* GetLuaL()
{
	if (gL != nullptr)
		return gL;
	else
		return nullptr;
}

void RunLuaPreGlobalModCSCode()
{
    ExecuteLuaPreGlobalModCSElementHandlers();
}

void RunLuaMetadataCode()
{
    ExecuteLuaMetadataElementHandlers();
}

void AddAutPILuaFunctions()
{
    ExecuteLuaFuncElementHandlers();
}