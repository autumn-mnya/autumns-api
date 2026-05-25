#include <windows.h>
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

#include "KeyControl.h"
#include "../API_KeyControl.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

void KeyCheck(lua_State* L, int Key, int KeyTrg, int button, int option)
{
	BOOL hold = FALSE;

	if (!lua_isnoneornil(L, option))
	{
		luaL_checktype(L, option, LUA_TBOOLEAN);
		hold = (BOOL)lua_toboolean(L, option);
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
	KeyCheck(L, gKey, gKeyTrg, gKeyJump, 1);

	return 1;
}

static int lua_KeyShot(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyShot, 1);

	return 1;
}

static int lua_KeyArms(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyArms, 1);

	return 1;
}

static int lua_KeyArmsRev(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyArmsRev, 1);

	return 1;
}

static int lua_KeyItem(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyItem, 1);

	return 1;
}

static int lua_KeyMap(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyMap, 1);

	return 1;
}

static int lua_KeyOk(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyOk, 1);

	return 1;
}

static int lua_KeyCancel(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyCancel, 1);

	return 1;
}

static int lua_KeyLeft(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyLeft, 1);

	return 1;
}

static int lua_KeyUp(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyUp, 1);

	return 1;
}

static int lua_KeyRight(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyRight, 1);

	return 1;
}

static int lua_KeyDown(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, gKeyDown, 1);

	return 1;
}

static int lua_KeyShift(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, KEY_SHIFT, 1);

	return 1;
}

static int lua_KeyPause(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, KEY_ESCAPE, 1);

	return 1;
}

static int lua_KeyF1(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, KEY_F1, 1);

	return 1;
}

static int lua_KeyF2(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, KEY_F2, 1);

	return 1;
}

static int lua_KeyPlus(lua_State* L)
{
	KeyCheck(L, gKey, gKeyTrg, KEY_PLUS, 1);

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

static int lua_SetKey(lua_State* L)
{
	gKey = (int)luaL_checkinteger(L, 1);

	return 0;
}

static int lua_SetKeyTrg(lua_State* L)
{
	gKeyTrg = (int)luaL_checkinteger(L, 1);

	return 0;
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

static int lua_KeyJumpID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyJump, 2);
	return 1;
}

static int lua_KeyShotID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyShot, 2);
	return 1;
}

static int lua_KeyArmsID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyArms, 2);
	return 1;
}

static int lua_KeyArmsRevID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyArmsRev, 2);
	return 1;
}

static int lua_KeyItemID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyItem, 2);
	return 1;
}

static int lua_KeyMapID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyMap, 2);
	return 1;
}

static int lua_KeyOkID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyOk, 2);
	return 1;
}

static int lua_KeyCancelID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyCancel, 2);
	return 1;
}

static int lua_KeyLeftID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyLeft, 2);
	return 1;
}

static int lua_KeyUpID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyUp, 2);
	return 1;
}

static int lua_KeyRightID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyRight, 2);
	return 1;
}

static int lua_KeyDownID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, gKeyDown, 2);
	return 1;
}

static int lua_KeyShiftID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, KEY_SHIFT, 2);
	return 1;
}

static int lua_KeyPauseID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, KEY_ESCAPE, 2);
	return 1;
}

static int lua_KeyF1ID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, KEY_F1, 2);
	return 1;
}

static int lua_KeyF2ID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, KEY_F2, 2);
	return 1;
}

static int lua_KeyPlusID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	KeyCheck(L, gKey, gKeyTrg, KEY_PLUS, 2);
	return 1;
}

static int lua_GetKeyID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	lua_pushnumber(L, gKey);
	return 1;
}

static int lua_GetKeyTrgID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	lua_pushnumber(L, gKeyTrg);
	return 1;
}

static int lua_SetKeyID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	gKey = (int)luaL_checkinteger(L, 2);
	return 0;
}

static int lua_SetKeyTrgID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	gKeyTrg = (int)luaL_checkinteger(L, 2);
	return 0;
}

static int lua_ClearKeyID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
	gKey = 0;
	return 0;
}

static int lua_ClearKeyTrgID(lua_State* L)
{
	int id = (int)luaL_checkinteger(L, 1);
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
	{"Pause", lua_KeyPause},
	{"F1", lua_KeyF1},
	{"F2", lua_KeyF2},
	{"Plus", lua_KeyPlus},
	{"GetKey", lua_GetKey},
	{"GetKeyTrg", lua_GetKeyTrg},
	{"SetKey", lua_SetKey},
	{"SetKeyTrg", lua_SetKeyTrg},
	{"ClearKey", lua_ClearKey},
	{"ClearKeyTrg", lua_ClearKeyTrg},
	{"GetTrg", lua_GetTrg},
	{"JumpID", lua_KeyJumpID},
	{"ShootID", lua_KeyShotID},
	{"ArmsID", lua_KeyArmsID},
	{"ArmsRevID", lua_KeyArmsRevID},
	{"ItemID", lua_KeyItemID},
	{"MapID", lua_KeyMapID},
	{"OkID", lua_KeyOkID},
	{"CancelID", lua_KeyCancelID},
	{"LeftID", lua_KeyLeftID},
	{"UpID", lua_KeyUpID},
	{"RightID", lua_KeyRightID},
	{"DownID", lua_KeyDownID},
	{"ShiftID", lua_KeyShiftID},
	{"PauseID", lua_KeyPauseID},
	{"F1ID", lua_KeyF1ID},
	{"F2ID", lua_KeyF2ID},
	{"PlusID", lua_KeyPlusID},
	{"GetKeyID", lua_GetKeyID},
	{"GetKeyTrgID", lua_GetKeyTrgID},
	{"SetKeyID", lua_SetKeyID},
	{"SetKeyTrgID", lua_SetKeyTrgID},
	{"ClearKeyID", lua_ClearKeyID},
	{"ClearKeyTrgID", lua_ClearKeyTrgID},
};

int KeyControlModScript(unsigned int vkey, bool down, bool repeat) {
	if (!gL)
		return TRUE;
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

	lua_pushlstring(gL, (char*)&chr, ct);

	if (down) {
		lua_pushboolean(gL, repeat);
	}

	if (lua_pcall(gL, down ? 3 : 2, 0, 0) != LUA_OK)
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
