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

#include "ValueView.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_ClearValueView(lua_State* L)
{
	ClearValueView();
	return 0;
}

static int lua_SetValueViewPlayer(lua_State* L)
{
	int value = (int)luaL_checknumber(L, 1);
	SetValueView(&gMC.x, &gMC.y, value);

	return 0;
}

static int lua_SetValueViewNpc(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	int value = (int)luaL_checknumber(L, 2);

	SetValueView(&npc->x, &npc->y, value);
	return 0;
}

static int lua_SetValueViewCaret(lua_State* L)
{
	CARET* crt = *(CARET**)luaL_checkudata(L, 1, "CaretMeta");
	int value = (int)luaL_checknumber(L, 2);

	SetValueView(&crt->x, &crt->y, value);
	return 0;
}

static int lua_SetValueViewBullet(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	int value = (int)luaL_checknumber(L, 2);

	SetValueView(&bul->x, &bul->y, value);
	return 0;
}

static int lua_ValueViewAct(lua_State* L)
{
	ActValueView();
	return 0;
}

static int lua_ValueViewPut(lua_State* L)
{
    int fx = (int)luaL_checknumber(L, 1);
    int fy = (int)luaL_checknumber(L, 2);

	PutValueView(fx, fy);
	return 0;
}

FUNCTION_TABLE ValueViewFunctionTable[FUNCTION_TABLE_VALUEVIEW_SIZE] =
{
    {"Clear", lua_ClearValueView},
    {"SetPlayer", lua_SetValueViewPlayer},
	{"SetNpc", lua_SetValueViewNpc},
	{"SetCaret", lua_SetValueViewCaret},
	{"SetBullet", lua_SetValueViewBullet},
	{"ActMain", lua_ValueViewAct},
	{"DrawMain", lua_ValueViewPut},
};
