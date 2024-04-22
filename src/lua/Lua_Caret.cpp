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

#include "Lua_Caret.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_Caret.h"

static BOOL fcuking = TRUE;

static STRUCT_TABLE CaretTable[] =
{
	{"x", offsetof(CARET, x), TYPE_PIXEL},
	{"y", offsetof(CARET, y), TYPE_PIXEL},
	{"xm", offsetof(CARET, xm), TYPE_NUMBER},
	{"ym", offsetof(CARET, ym), TYPE_NUMBER},
	{"id", offsetof(CARET, code), TYPE_NUMBER},
	{"direct", offsetof(CARET, direct), TYPE_NUMBER},
	{"ani_wait", offsetof(CARET, ani_wait), TYPE_NUMBER},
	{"ani_no", offsetof(CARET, ani_no), TYPE_NUMBER},
	{"act_no", offsetof(CARET, act_no), TYPE_NUMBER},
	{"act_wait", offsetof(CARET, act_wait), TYPE_NUMBER},
	{"view_x", offsetof(CARET, view_left), TYPE_PIXEL},
	{"view_y", offsetof(CARET, view_top), TYPE_PIXEL},
	// don't use
	{"cond", offsetof(CARET, cond), TYPE_NUMBER}
};

int lua_CaretIndex(lua_State* L)
{
	CARET** crt = (CARET**)luaL_checkudata(L, 1, "CaretMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, CaretTable, *crt, sizeof(CaretTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Caret");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_CaretNextIndex(lua_State* L)
{
	CARET** crt = (CARET**)luaL_checkudata(L, 1, "CaretMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, CaretTable, *crt, sizeof(CaretTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_GetCaretByBufferIndex(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);

	if (gCrt[id].cond & 0x80)
	{
		CARET** crt = (CARET**)lua_newuserdata(L, sizeof(CARET*));
		*crt = &gCrt[id];

		luaL_getmetatable(L, "CaretMeta");
		lua_setmetatable(L, -2);

		return 1;
	}

	return 0;
}

static int lua_CaretSetRect(lua_State* L)
{
	CARET* crt = *(CARET**)luaL_checkudata(L, 1, "CaretMeta");

	if (lua_isnumber(L, 2))
	{
		crt->rect.left = (int)luaL_checknumber(L, 2);
		crt->rect.top = (int)luaL_checknumber(L, 3);
		crt->rect.right = (int)luaL_checknumber(L, 4);
		crt->rect.bottom = (int)luaL_checknumber(L, 5);
	}
	else if (lua_isuserdata(L, 2)) {
		crt->rect = *(RECT*)luaL_checkudata(L, 2, "RectMeta");
	}
	else {
		luaL_error(L, "bad argument #2 to 'SetRect' (number or RectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	return 0;
}

static int lua_CaretOffsetRect(lua_State* L)
{
	CARET* crt = *(CARET**)luaL_checkudata(L, 1, "CaretMeta");

	crt->rect.left += (int)luaL_checknumber(L, 2);
	crt->rect.top += (int)luaL_checknumber(L, 3);
	crt->rect.right += (int)luaL_optnumber(L, 4, (int)lua_tonumber(L, 2));
	crt->rect.bottom += (int)luaL_optnumber(L, 5, (int)lua_tonumber(L, 3));

	return 0;
}

static int lua_CaretGetRect(lua_State* L)
{
	CARET* crt = *(CARET**)luaL_checkudata(L, 1, "CaretMeta");
	RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

	*rect = crt->rect;

	luaL_getmetatable(L, "RectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_CaretDelete(lua_State* L)
{
	CARET* crt = *(CARET**)luaL_checkudata(L, 1, "CaretMeta");

	crt->cond = 0;

	return 0;
}

static int lua_CaretMove(lua_State* L)
{
	CARET* crt = *(CARET**)luaL_checkudata(L, 1, "CaretMeta");

	crt->x += crt->xm;
	crt->y += crt->ym;

	return 0;
}

static int lua_SpawnCaret(lua_State* L)
{
	int code = (int)luaL_checknumber(L, 1);
	int x = (int)(luaL_checknumber(L, 2) * 0x200);
	int y = (int)(luaL_checknumber(L, 3) * 0x200);
	int dir = (int)luaL_optnumber(L, 4, 0);

	int c;
	for (c = 0; c < CARET_MAX; ++c)
		if (gCrt[c].cond == 0)
			break;

	if (c == CARET_MAX)
		return 0;

	CARET** crt = (CARET**)lua_newuserdata(L, sizeof(CARET*));
	*crt = &gCrt[c];

	luaL_getmetatable(L, "CaretMeta");
	lua_setmetatable(L, -2);

	SetCaret(x, y, code, dir);

	return 1;
}

static int lua_ActCodeCaret(lua_State* L)
{
	CARET* crt = *(CARET**)luaL_checkudata(L, 1, "CaretMeta");
	int code = (int)luaL_optnumber(L, 2, crt->code);

	ActCaretCode(crt, code);

	return 0;
}

FUNCTION_TABLE CaretFunctionTable[FUNCTION_TABLE_CARET_SIZE] =
{
	{"GetByBufferIndex", lua_GetCaretByBufferIndex},
	{"SetRect", lua_CaretSetRect},
	{"OffsetRect", lua_CaretOffsetRect},
	{"GetRect", lua_CaretGetRect},
	{"Delete", lua_CaretDelete},
	{"Move", lua_CaretMove},
	{"Spawn", lua_SpawnCaret},
	{"ActCode", lua_ActCodeCaret}
};

int CaretActModScript(int code, int i)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Caret");
	lua_getfield(gL, -1, "Act");
	lua_geti(gL, -1, code);

	if (lua_isnil(gL, -1))
	{
		char trolololo[0x10];
		sprintf(trolololo, "Act%d", code);
		lua_getfield(gL, -3, trolololo);

		if (lua_isnil(gL, -1))
		{
			lua_settop(gL, 0); // Clear stack
			return 1;
		}

		if (fcuking)
		{
			printf("WARNING: Defining Caret Act functions using ModCS.Caret.ActX (where X is the Caret Type ID) has been deprecated. It's recommended to define Caret Act functions in the ModCS.Caret.Act array instead.\n");
			fcuking = FALSE;
		}
	}

	CARET** crt = (CARET**)lua_newuserdata(gL, sizeof(CARET*));
	*crt = &gCrt[i];

	luaL_getmetatable(gL, "CaretMeta");
	lua_setmetatable(gL, -2);

	if (lua_pcall(gL, 1, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return 2;
}