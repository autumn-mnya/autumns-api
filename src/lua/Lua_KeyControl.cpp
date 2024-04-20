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

static void KeyCheck(lua_State* L, int button)
{
	BOOL hold = FALSE;

	if (!lua_isnoneornil(L, 1))
	{
		luaL_checktype(L, 1, LUA_TBOOLEAN);
		hold = (BOOL)lua_toboolean(L, 1);
	}

	if (hold)
	{
		if (gKey & button)
		{
			lua_pushboolean(L, 1);
			return;
		}

	}
	else
	{
		if (gKeyTrg & button)
		{
			lua_pushboolean(L, 1);
			return;
		}
	}

	lua_pushboolean(L, 0);
}

static int lua_KeyJump(lua_State* L)
{
	KeyCheck(L, gKeyJump);

	return 1;
}

static int lua_KeyShot(lua_State* L)
{
	KeyCheck(L, gKeyShot);

	return 1;
}

static int lua_KeyArms(lua_State* L)
{
	KeyCheck(L, gKeyArms);

	return 1;
}

static int lua_KeyArmsRev(lua_State* L)
{
	KeyCheck(L, gKeyArmsRev);

	return 1;
}

static int lua_KeyItem(lua_State* L)
{
	KeyCheck(L, gKeyItem);

	return 1;
}

static int lua_KeyMap(lua_State* L)
{
	KeyCheck(L, gKeyMap);

	return 1;
}

static int lua_KeyOk(lua_State* L)
{
	KeyCheck(L, gKeyOk);

	return 1;
}

static int lua_KeyCancel(lua_State* L)
{
	KeyCheck(L, gKeyCancel);

	return 1;
}

static int lua_KeyLeft(lua_State* L)
{
	KeyCheck(L, gKeyLeft);

	return 1;
}

static int lua_KeyUp(lua_State* L)
{
	KeyCheck(L, gKeyUp);

	return 1;
}

static int lua_KeyRight(lua_State* L)
{
	KeyCheck(L, gKeyRight);

	return 1;
}

static int lua_KeyDown(lua_State* L)
{
	KeyCheck(L, gKeyDown);

	return 1;
}

static int lua_KeyShift(lua_State* L)
{
	KeyCheck(L, 0x200);

	return 1;
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
	{"Shift", lua_KeyShift}
};