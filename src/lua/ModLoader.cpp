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

#include "ModLoader.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

unsigned char ModLoader_GetByte(void* address)
{
	if (!address)
		return 0;
	return *reinterpret_cast<unsigned char*>(address);
}

unsigned short ModLoader_GetWord(void* address)
{
	if (!address)
		return 0;
	return *reinterpret_cast<unsigned short*>(address);
}

unsigned long ModLoader_GetLong(void* address)
{
	if (!address)
		return 0;
	return *reinterpret_cast<unsigned long*>(address);
}

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

static int lua_ModLoaderGetByte(lua_State* L)
{
	int address = (int)luaL_checknumber(L, 1);
	lua_pushnumber(L, (lua_Number)ModLoader_GetByte((void*)address));
	return 1;
}

static int lua_ModLoaderGetWord(lua_State* L)
{
	int address = (int)luaL_checknumber(L, 1);
	lua_pushnumber(L, (lua_Number)ModLoader_GetWord((void*)address));
	return 1;
}

static int lua_ModLoaderGetLong(lua_State* L)
{
	int address = (int)luaL_checknumber(L, 1);
	lua_pushnumber(L, (lua_Number)ModLoader_GetLong((void*)address));
	return 1;
}

FUNCTION_TABLE ModLoaderFunctionTable[FUNCTION_TABLE_MOD_LOADER_SIZE] =
{
	{"WriteByte", lua_ModLoaderWriteByte},
	{"WriteWord", lua_ModLoaderWriteWord},
	{"WriteLong", lua_ModLoaderWriteLong},
	{"WriteWordBE", lua_ModLoaderWriteWordBigEndian},
	{"WriteLongBE", lua_ModLoaderWriteLongBigEndian},
	{"GetByte", lua_ModLoaderGetByte},
	{"GetWord", lua_ModLoaderGetWord},
	{"GetLong", lua_ModLoaderGetLong},
};