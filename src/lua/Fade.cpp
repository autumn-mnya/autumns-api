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

#include "Fade.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_FadeInit(lua_State* L)
{
	InitFade();
	return 0;
}

static int lua_FadeSetMask(lua_State* L)
{
	SetFadeMask();
	return 0;
}

static int lua_FadeClear(lua_State* L)
{
	ClearFade();
	return 0;
}

static int lua_FadeProc(lua_State* L)
{
	ProcFade();
	return 0;
}

static int lua_FadePut(lua_State* L)
{
	PutFade();
	return 0;
}

static int lua_FadeOut(lua_State* L)
{
    int dir = (int)luaL_checknumber(L, 1);
	StartFadeOut(dir);
	return 0;
}

static int lua_FadeIn(lua_State* L)
{
    int dir = (int)luaL_checknumber(L, 1);
	StartFadeIn(dir);
	return 0;
}

static int lua_FadeActive(lua_State* L)
{
	if (GetFadeActive())
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

FUNCTION_TABLE FadeFunctionTable[FUNCTION_TABLE_FADE_SIZE] =
{
    {"Init", lua_FadeInit},
    {"SetMask", lua_FadeSetMask},
    {"Clear", lua_FadeClear},
    {"ActMain", lua_FadeProc},
    {"DrawMain", lua_FadePut},
    {"Out", lua_FadeOut},
    {"In", lua_FadeIn},
    {"IsActive", lua_FadeActive},
};