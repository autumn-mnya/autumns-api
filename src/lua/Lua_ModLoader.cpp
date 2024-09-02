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

#include "Lua_ModLoader.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

static int lua_ModLoaderWriteByte(lua_State* L)
{
	int address = (int)luaL_checknumber(L, 1);
	int value = (int)luaL_checknumber(L, 2);

	ModLoader_WriteByte((void*)address, value);

	return 0;
}

static int lua_ModLoaderWriteWord(lua_State* L)
{
	int address = (int)luaL_checknumber(L, 1);
	int value = (int)luaL_checknumber(L, 2);

	ModLoader_WriteWord((void*)address, value);

	return 0;
}

static int lua_ModLoaderWriteLong(lua_State* L)
{
	int address = (int)luaL_checknumber(L, 1);
	int value = (int)luaL_checknumber(L, 2);

	ModLoader_WriteLong((void*)address, value);

	return 0;
}

static int lua_ModLoaderWriteWordBigEndian(lua_State* L)
{
	int address = (int)luaL_checknumber(L, 1);
	int value = (int)luaL_checknumber(L, 2);

	ModLoader_WriteWordBE((void*)address, value);

	return 0;
}

static int lua_ModLoaderWriteLongBigEndian(lua_State* L)
{
	int address = (int)luaL_checknumber(L, 1);
	int value = (int)luaL_checknumber(L, 2);

	ModLoader_WriteLongBE((void*)address, value);

	return 0;
}

FUNCTION_TABLE ModLoaderFunctionTable[FUNCTION_TABLE_MOD_LOADER_SIZE] =
{
	{"WriteByte", lua_ModLoaderWriteByte},
	{"WriteWord", lua_ModLoaderWriteWord},
	{"WriteLong", lua_ModLoaderWriteLong},
	{"WriteWordBE", lua_ModLoaderWriteWordBigEndian},
	{"WriteLongBE", lua_ModLoaderWriteLongBigEndian},
};