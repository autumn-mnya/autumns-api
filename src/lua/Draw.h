#pragma once


#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

struct COLOR
{
	int r;
	int g;
	int b;
};

int lua_RectIndex(lua_State* L);
int lua_RectNextIndex(lua_State* L);

#define FUNCTION_TABLE_RECT_SIZE 5
extern FUNCTION_TABLE RectFunctionTable[FUNCTION_TABLE_RECT_SIZE];

int lua_ColorIndex(lua_State* L);
int lua_ColorNextIndex(lua_State* L);

#define FUNCTION_TABLE_COLOR_SIZE 3
extern FUNCTION_TABLE ColorFunctionTable[FUNCTION_TABLE_COLOR_SIZE];

int lua_SurfaceIndex(lua_State* L);

#define FUNCTION_TABLE_SURFACE_SIZE 4
extern FUNCTION_TABLE SurfaceFunctionTable[FUNCTION_TABLE_SURFACE_SIZE];

int lua_PutText(lua_State* L);
int lua_GetFullRect(lua_State* L);
int lua_GetGameRect(lua_State* L);

int lua_OtherRectIndex(lua_State* L);
int lua_OtherRectNextIndex(lua_State* L);

#define FUNCTION_TABLE_OTHER_RECT_SIZE 2
extern FUNCTION_TABLE OtherRectFunctionTable[FUNCTION_TABLE_OTHER_RECT_SIZE];