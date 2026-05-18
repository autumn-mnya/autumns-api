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

#include "Ending.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_CreditsStart(lua_State* L)
{
    g_GameFlags |= 8;
    StartCreditScript();
    return 0;
}

static int lua_CreditsActMain(lua_State* L)
{
	ActionCredit();
	return 0;
}

static int lua_CreditsActIllust(lua_State* L)
{
	ActionIllust();
	return 0;
}

static int lua_CreditsActStrip(lua_State* L)
{
	ActionStripper();
	return 0;
}

static int lua_CreditsPutIllust(lua_State* L)
{
	PutIllust();
	return 0;
}

static int lua_CreditsPutStrip(lua_State* L)
{
	PutStripper();
	return 0;
}

FUNCTION_TABLE CreditsFunctionTable[FUNCTION_TABLE_CREDITS_SIZE] =
{
    {"Start", lua_CreditsStart},
    {"ActMain", lua_CreditsActMain},
	{"ActImg", lua_CreditsActIllust},
    {"ActCast", lua_CreditsActStrip},
    {"DrawImg", lua_CreditsPutIllust},
    {"DrawCast", lua_CreditsPutStrip},
};