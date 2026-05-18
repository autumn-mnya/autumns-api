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

#include "Triangle.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

unsigned char Replacement_GetArktan(int x, int y)
{
    short k;
    unsigned char a;

    x *= -1;
    y *= -1;

    if (x == 0 && y == 0)
        return 0;

    a = 0;

    if (x > 0)
    {
        if (y > 0)
        {
            if (x > y)
            {
                if (x == 0) return 0;
                k = (y * 0x2000) / x;
                while (k > gTan[a]) ++a;
            }
            else
            {
                if (y == 0) return 0;
                k = (x * 0x2000) / y;
                while (k > gTan[a]) ++a;
                a = 0x40 - a;
            }
        }
        else
        {
            if (x > -y)
            {
                if (x == 0) return 0;
                k = (-y * 0x2000) / x;
                while (k > gTan[a]) ++a;
                a = 0x100 - a;
            }
            else
            {
                if (y == 0) return 0;
                k = (x * 0x2000) / -y;
                while (k > gTan[a]) ++a;
                a = 0x100 - 0x40 + a;
            }
        }
    }
    else
    {
        if (y > 0)
        {
            if (-x > y)
            {
                if (x == 0) return 0;
                k = (y * 0x2000) / -x;
                while (k > gTan[a]) ++a;
                a = 0x80 - a;
            }
            else
            {
                if (y == 0) return 0;
                k = (-x * 0x2000) / y;
                while (k > gTan[a]) ++a;
                a = 0x40 + a;
            }
        }
        else
        {
            if (-x > -y)
            {
                if (x == 0) return 0;
                k = (-y * 0x2000) / -x;
                while (k > gTan[a]) ++a;
                a = 0x80 + a;
            }
            else
            {
                if (y == 0) return 0;
                k = (-x * 0x2000) / -y;
                while (k > gTan[a]) ++a;
                a = 0x100 - 0x40 - a;
            }
        }
    }

    return a;
}

static int lua_TriangleGetSin(lua_State* L)
{
	int val = (int)luaL_checknumber(L, 1);
    lua_pushnumber(L, (lua_Number)GetSin(val) / 512.0);
	return 1;
}

static int lua_TriangleGetCos(lua_State* L)
{
	int val = (int)luaL_checknumber(L, 1);
    lua_pushnumber(L, (lua_Number)GetCos(val) / 512.0);
	return 1;
}

static int lua_TriangleGetSin2(lua_State* L)
{
	int val = (int)luaL_checknumber(L, 1);
    lua_pushnumber(L, (lua_Number)GetSin(val));
	return 1;
}

static int lua_TriangleGetCos2(lua_State* L)
{
	int val = (int)luaL_checknumber(L, 1);
    lua_pushnumber(L, (lua_Number)GetCos(val));
	return 1;
}

static int lua_TriangleGetArktan(lua_State* L)
{
	int x = (int)luaL_checknumber(L, 1);
	int y = (int)luaL_checknumber(L, 2);

	int val = GetArktan(x*512, y*512);
	lua_pushnumber(L, (lua_Number)val);
	return 1;
}

FUNCTION_TABLE TriangleFunctionTable[FUNCTION_TABLE_TRIANGLE_SIZE] =
{
    {"GetSin", lua_TriangleGetSin},
    {"GetCos", lua_TriangleGetCos},
    {"GetSin2", lua_TriangleGetSin2},
    {"GetCos2", lua_TriangleGetCos2},
    {"GetArktan", lua_TriangleGetArktan},
};
