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

#include "Lua_Draw.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

static STRUCT_TABLE RectTable[] =
{
	{"left", offsetof(RECT, left), TYPE_NUMBER},
	{"top", offsetof(RECT, top), TYPE_NUMBER},
	{"right", offsetof(RECT, right), TYPE_NUMBER},
	{"bottom", offsetof(RECT, bottom), TYPE_NUMBER},
};

int lua_RectIndex(lua_State* L)
{
	RECT* rect = (RECT*)luaL_checkudata(L, 1, "RectMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, RectTable, rect, sizeof(RectTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Rect");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_RectNextIndex(lua_State* L)
{
	RECT* rect = (RECT*)luaL_checkudata(L, 1, "RectMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, RectTable, rect, sizeof(RectTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_CreateRect(lua_State* L)
{
	int left = (int)luaL_optnumber(L, 1, 0);
	int top = (int)luaL_optnumber(L, 2, 0);
	int right = (int)luaL_optnumber(L, 3, 0);
	int bottom = (int)luaL_optnumber(L, 4, 0);

	RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

	rect->left = left;
	rect->top = top;
	rect->right = right;
	rect->bottom = bottom;

	luaL_getmetatable(L, "RectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_SetRect(lua_State* L)
{
	RECT* rect = (RECT*)luaL_checkudata(L, 1, "RectMeta");

	rect->left = (int)luaL_checknumber(L, 2);
	rect->top = (int)luaL_checknumber(L, 3);
	rect->right = (int)luaL_checknumber(L, 4);
	rect->bottom = (int)luaL_checknumber(L, 5);

	return 0;

}

static int lua_PutRect(lua_State* L)
{
	RECT* rect = (RECT*)luaL_checkudata(L, 1, "RectMeta");
	int x = (int)luaL_checknumber(L, 2);
	int y = (int)luaL_checknumber(L, 3);
	int surface = (int)luaL_checknumber(L, 4);

	if (lua_isnoneornil(L, 5))
	{
		PutBitmap3(&grcFull, x, y, rect, (SurfaceID)surface);
	}
	else if (lua_isboolean(L, 5))
	{
		BOOL alpha = (BOOL)lua_toboolean(L, 5);

		if (alpha)
			PutBitmap3(&grcFull, x, y, rect, (SurfaceID)surface);
		else
			PutBitmap4(&grcFull, x, y, rect, (SurfaceID)surface);
	}
	else if (lua_isnumber(L, 5))
	{
		int target = (int)lua_tonumber(L, 5);
		Surface2Surface(x, y, rect, (SurfaceID)target, (SurfaceID)surface);
	}
	else {
		luaL_error(L, "bad argument #5 to 'Put' (number or boolean expected, got %s)", luaL_typename(L, 5));
	}

	return 0;
}

static int lua_PutRectEx(lua_State* L)
{
	RECT* rect = (RECT*)luaL_checkudata(L, 1, "RectMeta");
	RECT* view = (RECT*)luaL_checkudata(L, 2, "RectMeta");
	int x = (int)luaL_checknumber(L, 3);
	int y = (int)luaL_checknumber(L, 4);
	int surface = (int)luaL_checknumber(L, 5);
	BOOL alpha = TRUE;

	if (!lua_isnoneornil(L, 6))
	{
		luaL_checktype(L, 6, LUA_TBOOLEAN);
		alpha = (BOOL)lua_toboolean(L, 6);
	}

	if (alpha)
		PutBitmap3(view, x, y, rect, (SurfaceID)surface);
	else
		PutBitmap4(view, x, y, rect, (SurfaceID)surface);

	return 0;
}

static int lua_PutRectToSurface(lua_State* L)
{
	lua_PutRect(L);
	SerenaAlert(L, "ModCS.Rect.Put2Surface has been merged with ModCS.Rect.Put since ModCS 0.2.0.0. It is suggested to use ModCS.Rect.Put");

	return 0;
}

FUNCTION_TABLE RectFunctionTable[FUNCTION_TABLE_RECT_SIZE] =
{
	{"Create", lua_CreateRect},
	{"Set", lua_SetRect},
	{"Put", lua_PutRect},
	{"PutEx", lua_PutRectEx},
	{"Put2Surface", lua_PutRectToSurface}
};

/* Color */

static STRUCT_TABLE ColorTable[] =
{
	{"red", offsetof(COLOR, r), TYPE_NUMBER},
	{"green", offsetof(COLOR, g), TYPE_NUMBER},
	{"blue", offsetof(COLOR, b), TYPE_NUMBER}
};

int lua_ColorIndex(lua_State* L)
{
	COLOR* color = (COLOR*)luaL_checkudata(L, 1, "ColorMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, ColorTable, color, sizeof(ColorTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Color");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_ColorNextIndex(lua_State* L)
{
	COLOR* color = (COLOR*)luaL_checkudata(L, 1, "ColorMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, ColorTable, color, sizeof(ColorTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_CreateColor(lua_State* L)
{
	// Did this because it was generally easier for me to keep track of the stack like this
	int red = (int)luaL_optnumber(L, 1, 0);
	int green = (int)luaL_optnumber(L, 2, 0);
	int blue = (int)luaL_optnumber(L, 3, 0);

	COLOR* color = (COLOR*)lua_newuserdata(L, sizeof(COLOR));

	color->r = red;
	color->g = green;
	color->b = blue;

	luaL_getmetatable(L, "ColorMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_SetColor(lua_State* L)
{
	COLOR* color = (COLOR*)luaL_checkudata(L, 1, "ColorMeta");

	color->r = (int)luaL_checknumber(L, 2);
	color->g = (int)luaL_checknumber(L, 3);
	color->b = (int)luaL_checknumber(L, 4);

	return 0;
}

static int lua_ColorBox(lua_State* L)
{
	RECT pos;
	COLOR* color;
	int surface;

	color = (COLOR*)luaL_checkudata(L, 1, "ColorMeta");

	if (lua_isnumber(L, 2))
	{
		pos.left = (int)luaL_checknumber(L, 2);
		pos.top = (int)luaL_checknumber(L, 3);
		pos.right = pos.left + (int)luaL_checknumber(L, 4);
		pos.bottom = pos.top + (int)luaL_checknumber(L, 5);
		surface = (int)luaL_optnumber(L, 6, -1);
	}
	else if (lua_isuserdata(L, 2)) {
		pos = *(RECT*)luaL_checkudata(L, 2, "RectMeta");
		surface = (int)luaL_optnumber(L, 3, -1);
	}
	else {
		luaL_error(L, "bad argument #2 to 'Box' (number or RectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	unsigned long cortboxcolor = GetCortBoxColor(RGB(color->r, color->g, color->b));

	if (surface == -1)
		CortBox(&pos, cortboxcolor);
	else
		CortBox2(&pos, cortboxcolor, (SurfaceID)surface);

	return 0;
}

FUNCTION_TABLE ColorFunctionTable[FUNCTION_TABLE_COLOR_SIZE] =
{
	{"Create", lua_CreateColor},
	{"Set", lua_SetColor},
	{"Box", lua_ColorBox}
};

/* Surface */
int lua_SurfaceIndex(lua_State* L)
{
	const char* x = luaL_checkstring(L, 2);

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Surface");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

static int lua_CreateSurface(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);

	lua_pushnumber(L, id);

	if (lua_isnumber(L, 2))
	{
		int w = (int)luaL_checknumber(L, 2);
		int h = (int)luaL_checknumber(L, 3);

		luaL_getmetatable(L, "SurfaceMeta");
		lua_setmetatable(L, -2);

		if (!MakeSurface_Generic(w, h, (SurfaceID)id, FALSE))
			luaL_error(L, "Error in making generic surface with ID %d", id);
		return 1;
	}
	else if (lua_isstring(L, 2)) {
		const char* path = luaL_checkstring(L, 2);
		if (!MakeSurface_File(path, (SurfaceID)id))
			luaL_error(L, "Error in making surface from file %s with ID %d", path, id);
		return 1;
	}

	luaL_error(L, "bad argument #2 to 'Create' (number or string expected, got %s)", luaL_typename(L, 2));
	return 0;
}

static int lua_LoadBitmap2Surface(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	const char* path = luaL_checkstring(L, 2);

	if (!ReloadBitmap_File(path, (SurfaceID)id))
		luaL_error(L, "Error in loading file %s to surface", path);

	return 0;
}

static int lua_Screenshot2Surface(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	RECT rect;

	if (lua_isnumber(L, 2))
	{
		rect.left = (int)luaL_checknumber(L, 2);
		rect.top = (int)luaL_checknumber(L, 3);
		rect.right = rect.left + (int)luaL_checknumber(L, 4);
		rect.bottom = rect.top + (int)luaL_checknumber(L, 5);
	}
	else if (lua_isuserdata(L, 2)) {
		rect = *(RECT*)luaL_checkudata(L, 2, "RectMeta");
	}
	else if (lua_isnoneornil(L, 2)) {
		rect = grcGame;
	}
	else {
		luaL_error(L, "bad argument #2 to 'Screenshot' (number or RectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	BackupSurface((SurfaceID)id, &rect);

	return 0;
}

FUNCTION_TABLE SurfaceFunctionTable[FUNCTION_TABLE_SURFACE_SIZE] =
{
	{"Create", lua_CreateSurface},
	{"LoadBitmap", lua_LoadBitmap2Surface},
	{"Screenshot", lua_Screenshot2Surface}
};

/* Text */
int lua_PutText(lua_State* L)
{
	const char* message = luaL_checkstring(L, 1);
	int x = (int)luaL_checknumber(L, 2);
	int y = (int)luaL_checknumber(L, 3);
	COLOR color;
	int surface;

	if (!lua_isnoneornil(L, 4))
	{
		color = *(COLOR*)luaL_checkudata(L, 4, "ColorMeta");
	}
	else
	{
		color.r = 0xFF;
		color.g = 0xFF;
		color.b = 0xFE;
	}

	surface = (int)luaL_optnumber(L, 5, -1);

	if (surface == -1)
		PutText(x, y, message, RGB(color.r, color.g, color.b));
	else
		PutText2(x, y, message, RGB(color.r, color.g, color.b), (SurfaceID)surface);

	return 0;
}

/* Misc. */
int lua_GetFullRect(lua_State* L)
{
	RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

	*rect = grcFull;

	luaL_getmetatable(L, "RectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

int lua_GetGameRect(lua_State* L)
{
	RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

	*rect = grcGame;

	luaL_getmetatable(L, "RectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static STRUCT_TABLE OtherRectTable[] =
{
	{"front", offsetof(OTHER_RECT, front), TYPE_PIXEL},
	{"top", offsetof(OTHER_RECT, top), TYPE_PIXEL},
	{"back", offsetof(OTHER_RECT, back), TYPE_PIXEL},
	{"bottom", offsetof(OTHER_RECT, bottom), TYPE_PIXEL},
};

int lua_OtherRectIndex(lua_State* L)
{
	OTHER_RECT* rect = (OTHER_RECT*)luaL_checkudata(L, 1, "RangeRectMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, OtherRectTable, rect, sizeof(OtherRectTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "RangeRect");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_OtherRectNextIndex(lua_State* L)
{
	OTHER_RECT* rect = (OTHER_RECT*)luaL_checkudata(L, 1, "RangeRectMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, OtherRectTable, rect, sizeof(OtherRectTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_CreateOtherRect(lua_State* L)
{
	// Did this because it was generally easier for me to keep track of the stack like this
	int front = (int)(luaL_optnumber(L, 1, 0) * 0x200);;
	int top = (int)(luaL_optnumber(L, 2, 0) * 0x200);;
	int back = (int)(luaL_optnumber(L, 3, 0) * 0x200);;
	int bottom = (int)(luaL_optnumber(L, 4, 0) * 0x200);;

	OTHER_RECT* rect = (OTHER_RECT*)lua_newuserdata(L, sizeof(OTHER_RECT));

	rect->front = front;
	rect->top = top;
	rect->back = back;
	rect->bottom = bottom;

	luaL_getmetatable(L, "RangeRectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_SetOtherRect(lua_State* L)
{
	OTHER_RECT* rect = (OTHER_RECT*)luaL_checkudata(L, 1, "RangeRectMeta");

	rect->front = (int)(luaL_checknumber(L, 2) * 0x200);
	rect->top = (int)(luaL_checknumber(L, 3) * 0x200);
	rect->back = (int)(luaL_checknumber(L, 4) * 0x200);
	rect->bottom = (int)(luaL_checknumber(L, 5) * 0x200);

	return 0;
}

FUNCTION_TABLE OtherRectFunctionTable[FUNCTION_TABLE_OTHER_RECT_SIZE] =
{
	{"Create", lua_CreateOtherRect},
	{"Set", lua_SetOtherRect}
};