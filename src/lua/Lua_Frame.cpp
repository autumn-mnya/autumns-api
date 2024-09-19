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

#include "Lua_Frame.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

static int lua_CameraSetTarget(lua_State* L)
{
	const char* x;

	lua_getmetatable(L, 1);

	if (lua_isnoneornil(L, -1) || !(lua_isuserdata(L, 1)))
	{
		luaL_error(L, "bad argument #1 to 'SetTarget' (game object expected, got %s)", luaL_typename(L, 1));
		return 0;
	}

	lua_getfield(L, -1, "__name");
	x = luaL_checkstring(L, -1);

	if (strcmp(x, "PlayerMeta") == 0)
	{
		gFrame.tgt_x = &gMC.tgt_x;
		gFrame.tgt_y = &gMC.tgt_y;
	}
	else if (strcmp(x, "NpcMeta") == 0)
	{
		NPCHAR* npc = *(NPCHAR**)lua_touserdata(L, 1);
		gFrame.tgt_x = &npc->x;
		gFrame.tgt_y = &npc->y;
	}
	else if (strcmp(x, "CaretMeta") == 0)
	{
		CARET* crt = *(CARET**)lua_touserdata(L, 1);
		gFrame.tgt_x = &crt->x;
		gFrame.tgt_y = &crt->y;
	}
	else {
		luaL_error(L, "bad argument #1 to 'SetTarget' (game object expected, got %s)", luaL_typename(L, 1));
		return 0;
	}

	return 0;
}

static int lua_CameraSetDelay(lua_State* L)
{
	int wait = (int)luaL_checknumber(L, 1);
	gFrame.wait = wait;
	return 0;
}

static int lua_CameraReset(lua_State* L)
{
	SetFrameMyChar();
	return 0;
}

static int lua_CameraGetXPos(lua_State* L)
{
	lua_pushnumber(L, gFrame.x / 0x200);
	return 1;
}

static int lua_CameraGetYPos(lua_State* L)
{
	lua_pushnumber(L, gFrame.y / 0x200);
	return 1;
}

static int lua_CameraSetQuake(lua_State* L)
{
	int wait = (int)luaL_checknumber(L, 1);
	gFrame.quake = wait;
	return 0;
}

static int lua_CameraSetAltQuake(lua_State* L)
{
	int wait = (int)luaL_checknumber(L, 1);
	gFrame.quake2 = wait;
	return 0;
}

static int lua_CameraSetXPos(lua_State* L)
{
	gFrame.x = (int)(luaL_checknumber(L, 1) * 0x200);
	return 0;
}

static int lua_CameraSetYPos(lua_State* L)
{
	gFrame.y = (int)(luaL_checknumber(L, 1) * 0x200);
	return 0;
}

FUNCTION_TABLE CameraFunctionTable[FUNCTION_TABLE_CAMERA_SIZE] =
{
	{"SetTarget", lua_CameraSetTarget},
	{"SetDelay", lua_CameraSetDelay},
	{"Reset", lua_CameraReset},
	{"GetXPos", lua_CameraGetXPos},
	{"GetYPos", lua_CameraGetYPos},
	{"SetXPos", lua_CameraSetXPos},
	{"SetYPos", lua_CameraSetYPos},
	{"SetQuake", lua_CameraSetQuake},
	{"SetAltQuake", lua_CameraSetAltQuake}
};