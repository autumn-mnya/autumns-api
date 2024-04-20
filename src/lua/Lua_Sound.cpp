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

#include "Lua_Sound.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

static int lua_SoundPlay(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);
	BOOL loop = FALSE;
	if (!lua_isnoneornil(L, 2))
	{
		luaL_checktype(L, 2, LUA_TBOOLEAN);
		loop = (BOOL)lua_toboolean(L, 2);
	}

	if (loop)
		PlaySoundObject(no, SOUND_MODE_PLAY_LOOP);
	else
		PlaySoundObject(no, SOUND_MODE_PLAY);

	return 0;
}

static int lua_SoundStop(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	PlaySoundObject(no, SOUND_MODE_STOP);

	return 0;
}

static int lua_SoundChangeFrequency(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);
	int rate = (int)luaL_checknumber(L, 2);

	ChangeSoundFrequency(no, rate);

	return 0;
}

static int lua_SoundChangeVolume(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);
	int volume = (int)luaL_checknumber(L, 2);

	ChangeSoundVolume(no, volume);

	return 0;
}

static int lua_SoundChangePan(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);
	int pan = (int)luaL_checknumber(L, 2);

	ChangeSoundPan(no, pan);

	return 0;
}

FUNCTION_TABLE SoundFunctionTable[FUNCTION_TABLE_SOUND_SIZE] =
{
	{"Play", lua_SoundPlay},
	{"Stop", lua_SoundStop},
	{"ChangeFrequency", lua_SoundChangeFrequency},
	{"ChangeVolume", lua_SoundChangeVolume},
	{"ChangePan", lua_SoundChangePan}
};

static int lua_OrganyaPlay(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	ChangeMusic((MusicID)no);

	return 0;
}

static int lua_OrganyaGetCurrent(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gMusicNo);

	return 1;
}

static int lua_OrganyaGetOld(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gOldNo);

	return 1;
}

static int lua_OrganyaGetPosition(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)GetOrganyaPosition());

	return 1;
}

static int lua_OrganyaGetOldPosition(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gOldPos);

	return 1;
}

static int lua_OrganyaSetPosition(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	SetOrganyaPosition(no);

	return 0;
}

static int lua_OrganyaSetVolume(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	ChangeOrganyaVolume(no);

	return 0;
}

FUNCTION_TABLE OrgFunctionTable[FUNCTION_TABLE_ORG_SIZE] =
{
	{"Play", lua_OrganyaPlay},
	{"GetCurrent", lua_OrganyaGetCurrent},
	{"GetOld", lua_OrganyaGetOld},
	{"GetPosition", lua_OrganyaGetPosition},
	{"GetOldPosition", lua_OrganyaGetOldPosition},
	{"SetPosition", lua_OrganyaSetPosition},
	{"SetVolume", lua_OrganyaSetVolume}
};