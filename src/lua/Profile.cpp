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

#include "Profile.h"

#include "Lua.h"

#include "../Main.h"
#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_Profile.h"

BOOL IsProfileCustom(const char* name)
{
	char path[MAX_PATH];

	// Get path
	if (name != NULL)
		ProfilePath(path, "%s\\%s", exeModulePath, name);
	else
		ProfilePath(path, "%s\\%s", exeModulePath, gDefaultName);

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
    char path[MAX_PATH];
	sprintf(path, "%s\\%s", exeModulePath, name);
	BOOL sc = LoadProfile(path);
	lua_pushboolean(L, sc);
	return 1;
}

static int lua_ProfileInit(lua_State* L)
{
	BOOL sc = InitializeGame(ghWnd);
	lua_pushboolean(L, sc);
	return 1;
}

static int lua_ProfileExists(lua_State* L)
{
	const char* name = luaL_optstring(L, 1, NULL);
	lua_pushboolean(L, IsProfileCustom(name));
	return 1;
}

static int lua_ProfileGetName(lua_State* L)
{
	lua_pushstring(L, GetCustomSaveName());
	return 1;
}

FUNCTION_TABLE ProfileFunctionTable[FUNCTION_TABLE_PROFILE_SIZE] =
{
	{"Save", lua_ProfileSave},
	{"Load", lua_ProfileLoad},
	{"Init", lua_ProfileInit},
	{"Exists", lua_ProfileExists},
	{"GetName", lua_ProfileGetName},
};

void RegisterSaving()
{
	if (!ProfileSavingModScript())
		return;
}

void RegisterLoading()
{
	if (!ProfileLoadingModScript())
		return;
}

void RegisterSaveAndLoad()
{
	RegisterSaveProfilePostCloseElement(RegisterSaving);
	RegisterLoadProfilePostCloseElement(RegisterLoading);
}