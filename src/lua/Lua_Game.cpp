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

#include "Lua_Game.h"

#include "Lua.h"

#include "../Main.h"
#include "../mod_loader.h"
#include "../cave_story.h"

static int lua_GameGetMode(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gCurrentGameMode);

	return 1;
}

static int lua_GameIsNew(lua_State* L)
{
	lua_pushboolean(L, !bContinue);

	return 1;
}

static int lua_GameCanAct(lua_State* L)
{
	if (g_GameFlags & 1)
		lua_pushboolean(L, TRUE);
	else
		lua_pushboolean(L, FALSE);

	return 1;
}

static int lua_GameCanControl(lua_State* L)
{
	if (g_GameFlags & 2)
		lua_pushboolean(L, TRUE);
	else
		lua_pushboolean(L, FALSE);

	return 1;
}

FUNCTION_TABLE GameFunctionTable[FUNCTION_TABLE_GAME_SIZE] =
{
	{"GetMode", lua_GameGetMode},
	{"IsNew", lua_GameIsNew},
	{"CanAct", lua_GameCanAct},
	{"CanControl", lua_GameCanControl}
};

BOOL GameInitModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "Init");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game init function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL GameActModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "Act");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game act function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL GameUpdateModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "Update");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game update function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL GameDrawModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "Draw");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game draw function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL GameDrawBelowFadeModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "DrawBelowFade");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game draw below fade function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL GameDrawAboveFadeModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "DrawAboveFade");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game draw above fade function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL GameDrawBelowTextBoxModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "DrawBelowTextBox");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game draw below textbox function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL GameDrawAboveTextBoxModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "DrawAboveTextBox");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game draw above textbox function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}

BOOL GameDrawHUDModScript(void)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Game");
	lua_getfield(gL, -1, "DrawHUD");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute game draw hud function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}