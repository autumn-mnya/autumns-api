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

#include "Lua_Profile.h"

#include "Lua.h"

#include "../Main.h"
#include "../mod_loader.h"
#include "../cave_story.h"

BOOL IsProfileCustom(const char* name)
{
	char path[MAX_PATH];

	// Get path
	if (name != NULL)
		sprintf(path, "%s\\%s", gModulePath, name);
	else
		sprintf(path, "%s\\%s", gModulePath, gDefaultName);

	HANDLE hFile = CreateFileA(path, 0, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
	if (hFile == INVALID_HANDLE_VALUE)
		return FALSE;

	CloseHandle(hFile);
	return TRUE;
}

static int lua_ProfileSave(lua_State* L)
{
	const char* name = luaL_optstring(L, 1, NULL);
	SaveProfile(name);
	return 0;
}

static int lua_ProfileLoad(lua_State* L)
{
	const char* name = luaL_optstring(L, 1, NULL);
	LoadProfile(name);
	return 0;
}

static int lua_ProfileExists(lua_State* L)
{
	const char* name = luaL_optstring(L, 1, NULL);
	lua_pushboolean(L, IsProfileCustom(name));
	return 1;
}

FUNCTION_TABLE ProfileFunctionTable[FUNCTION_TABLE_PROFILE_SIZE] =
{
	{"Save", lua_ProfileSave},
	{"Load", lua_ProfileLoad},
	{"Exists", lua_ProfileExists},
};
