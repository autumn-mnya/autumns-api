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

#include "Flash.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

static int lua_FlashInit(lua_State* L)
{
	InitFlash();
	return 0;
}

static int lua_FlashAct(lua_State* L)
{
    int flx = (int)luaL_checknumber(L, 1);
    int fly = (int)luaL_checknumber(L, 2);
	ActFlash(flx, fly);
	return 0;
}

static int lua_FlashPut(lua_State* L)
{
    PutFlash();
    return 0;
}

static int lua_FlashSpawn(lua_State* L)
{
    int type = FLASH_MODE_FLASH;
    bool explosion = false;

	if (!lua_isnoneornil(L, 1))
	{
		luaL_checktype(L, 1, LUA_TBOOLEAN);
		explosion = (bool)lua_toboolean(L, 1);
	}

    int x = (int)luaL_optnumber(L, 2, 0);
    int y = (int)luaL_optnumber(L, 3, 0);
    
	

    if (explosion)
        type = FLASH_MODE_EXPLOSION;

    SetFlash(x*0x200, y*0x200, type);
    return 0;
}

static int lua_FlashReset(lua_State* L)
{
    ResetFlash();
    return 0;
}

FUNCTION_TABLE FlashFunctionTable[FUNCTION_TABLE_FLASH_SIZE] =
{
    {"Init", lua_FlashInit},
    {"ActMain", lua_FlashAct},
    {"DrawMain", lua_FlashPut},
    {"Spawn", lua_FlashSpawn},
    {"Reset", lua_FlashReset},
};