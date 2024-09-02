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

#include "Lua_KeyControl.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

void KeyCheck(lua_State* L, int Key, int KeyTrg, int button)
{
	BOOL hold = FALSE;

	if (!lua_isnoneornil(L, 1))
	{
		luaL_checktype(L, 1, LUA_TBOOLEAN);
		hold = (BOOL)lua_toboolean(L, 1);
	}

	if (hold)
	{
		if (Key & button)
		{
			lua_pushboolean(L, 1);
			return;
		}

	}
	else
	{
		if (KeyTrg & button)
		{
			lua_pushboolean(L, 1);
			return;
		}
	}

	lua_pushboolean(L, 0);
}

static int lua_KeyJump(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyJump);

	return 1;
}

static int lua_KeyShot(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyShot);

	return 1;
}

static int lua_KeyArms(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyArms);

	return 1;
}

static int lua_KeyArmsRev(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyArmsRev);

	return 1;
}

static int lua_KeyItem(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyItem);

	return 1;
}

static int lua_KeyMap(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyMap);

	return 1;
}

static int lua_KeyOk(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyOk);

	return 1;
}

static int lua_KeyCancel(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyCancel);

	return 1;
}

static int lua_KeyLeft(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyLeft);

	return 1;
}

static int lua_KeyUp(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyUp);

	return 1;
}

static int lua_KeyRight(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyRight);

	return 1;
}

static int lua_KeyDown(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyDown);

	return 1;
}

static int lua_KeyShift(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, 0x200);

	return 1;
}

static int lua_GetKey(lua_State* L)
{
	lua_pushnumber(L, gKey);

	return 1;
}

static int lua_GetKeyTrg(lua_State* L)
{
	lua_pushnumber(L, gKeyTrg);

	return 1;
}

static int lua_ClearKey(lua_State* L)
{
	gKey = 0;

	return 0;
}

static int lua_ClearKeyTrg(lua_State* L)
{
	gKeyTrg = 0;

	return 0;
}

static int lua_GetTrg(lua_State* L)
{
	GetTrg();
	return 0;
}

FUNCTION_TABLE KeyFunctionTable[FUNCTION_TABLE_KEY_SIZE] =
{
	{"Jump", lua_KeyJump},
	{"Shoot", lua_KeyShot},
	{"Arms", lua_KeyArms},
	{"ArmsRev", lua_KeyArmsRev},
	{"Item", lua_KeyItem},
	{"Map", lua_KeyMap},
	{"Ok", lua_KeyOk},
	{"Cancel", lua_KeyCancel},
	{"Left", lua_KeyLeft},
	{"Up", lua_KeyUp},
	{"Right", lua_KeyRight},
	{"Down", lua_KeyDown},
	{"Shift", lua_KeyShift},
	{"GetKey", lua_GetKey},
	{"GetKeyTrg", lua_GetKeyTrg},
	{"ClearKey", lua_ClearKey},
	{"ClearKeyTrg", lua_ClearKeyTrg},
	{"GetTrg", lua_GetTrg},
};

int KeyControlModScript(unsigned int vkey, bool down) {
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Key");
	lua_getfield(gL, -1, down ? "KeyDown" : "KeyUp");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return TRUE;
	}

	lua_pushinteger(gL, vkey);

	static BYTE wks[256];
	GetKeyboardState(wks);
	WORD chr = 0;
	int ct = ToAscii(vkey, MapVirtualKeyA(vkey, MAPVK_VK_TO_VSC), wks, &chr, 0);

	lua_pushlstring(gL, (char *)&chr, ct);

	if (lua_pcall(gL, 2, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, down ? "Couldn't execute key down function" : "Couldn't execute key up function", "ModScript Error", MB_OK);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return TRUE;
}
