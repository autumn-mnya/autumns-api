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
	BOOL sc = LoadProfile(name);
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

static int dummyclosefunction(lua_State* L) {
	luaL_Stream* p = (luaL_Stream*)luaL_checkudata(gL, 1, LUA_FILEHANDLE);
	// No, we don't want to really close this file because we already do it ourselves
	p->f = NULL;
	p->closef = NULL;
	errno = 0;
	return luaL_fileresult(L, true, NULL);
}

BOOL ProfileSavingModScript(FILE* fp)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Profile");
	lua_getfield(gL, -1, "DuringSave");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	// Should already be pushed
	luaL_Stream* lfp = (luaL_Stream*)lua_newuserdatauv(gL, sizeof(luaL_Stream), 0);
	luaL_setmetatable(gL, LUA_FILEHANDLE);
	lfp->f = fp;
	lfp->closef = &dummyclosefunction; // Don't do it man

	if (lua_pcall(gL, 1, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute during save function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL ProfileLoadingModScript(FILE* fp)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Profile");
	lua_getfield(gL, -1, "DuringLoad");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	// Should already be pushed
	luaL_Stream* lfp = (luaL_Stream*)lua_newuserdatauv(gL, sizeof(luaL_Stream), 0);
	luaL_setmetatable(gL, LUA_FILEHANDLE);
	lfp->f = fp;
	lfp->closef = &dummyclosefunction; // Don't do it man

	if (lua_pcall(gL, 1, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute during load function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

void RegisterSaving(FILE* fp)
{
	if (!ProfileSavingModScript(fp))
		return;
}

void RegisterLoading(FILE* fp)
{
	if (!ProfileLoadingModScript(fp))
		return;
}

void RegisterSaveAndLoad()
{
	// Those were originally using post-close version.
	// Not sure why
	RegisterSaveProfilePreCloseElement(RegisterSaving);
	RegisterLoadProfilePreCloseElement(RegisterLoading);
}