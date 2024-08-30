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

WAVEFORMATEX format = { WAVE_FORMAT_PCM, 1, 22050, 22050, 1, 8, 0 };

static int lua_SoundCreate(lua_State* L)
{
	DSBUFFERDESC dsbd;

	int num = (int)luaL_checknumber(L, 1);

	luaL_checktype(L, 2, LUA_TTABLE);
	int len = lua_rawlen(L, 2);

	if (num < 0 || num >= SE_MAX) {
		luaL_error(L, "Invalid sound ID %d", num);
		return 0;
	}

	if (lpSECONDARYBUFFER[num] != NULL) {
		luaL_error(L, "Sound with ID %d already exists", num);
		return 0;
	}
	
	unsigned char* buffer = (unsigned char*)malloc(len);

	for (int i = 0; i < len; i++) {
		if (lua_rawgeti(L, 2, (lua_Integer)i + 1) != LUA_TNUMBER) {
			free(buffer);
			luaL_error(L, "Sample %d was not a number", i);
			return 0;
		}

		buffer[i] = lua_tonumber(L, -1);

		lua_pop(L, 1);
	}

	memset(&dsbd, 0, sizeof(dsbd));
	dsbd.dwSize = sizeof(dsbd);
	dsbd.dwFlags = DSBCAPS_STATIC | DSBCAPS_GLOBALFOCUS | DSBCAPS_CTRLPAN | DSBCAPS_CTRLVOLUME | DSBCAPS_CTRLFREQUENCY;
	dsbd.dwBufferBytes = len;
	dsbd.lpwfxFormat = (LPWAVEFORMATEX)&format;

	if (lpDS->CreateSoundBuffer(&dsbd, &lpSECONDARYBUFFER[num], NULL) != DS_OK) {
		luaL_error(L, "Failed to create sound with ID %d", num);
		return 0;
	}

	LPVOID lpbuf1, lpbuf2;
	DWORD dwbuf1, dwbuf2;

	lpSECONDARYBUFFER[num]->Lock(0, len, &lpbuf1, &dwbuf1, &lpbuf2, &dwbuf2, 0);

	memcpy(lpbuf1, buffer, dwbuf1);

	if (dwbuf2 != 0)
		memcpy(lpbuf2, buffer, dwbuf2);

	lpSECONDARYBUFFER[num]->Unlock(lpbuf1, dwbuf1, lpbuf2, dwbuf2);
	
	free(buffer);

	return 0;
}

static int lua_SoundDestroy(lua_State* L)
{
	int num = (int)luaL_checknumber(L, 1);

	if (num < 0 || num >= SE_MAX) {
		luaL_error(L, "Invalid sound ID %d", num);
		return 0;
	}

	if (lpSECONDARYBUFFER[num] == NULL) {
		luaL_error(L, "Sound with ID %d does not exist", num);
		return 0;
	}

	lpSECONDARYBUFFER[num]->Release();
	lpSECONDARYBUFFER[num] = NULL;

	return 0;
}

FUNCTION_TABLE SoundFunctionTable[FUNCTION_TABLE_SOUND_SIZE] =
{
	{"Play", lua_SoundPlay},
	{"Stop", lua_SoundStop},
	{"ChangeFrequency", lua_SoundChangeFrequency},
	{"ChangeVolume", lua_SoundChangeVolume},
	{"ChangePan", lua_SoundChangePan},
	{"Create", lua_SoundCreate},
	{"Destroy", lua_SoundDestroy}
};

static int lua_OrganyaPlay(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	ChangeMusic((MusicID)no);

	return 0;
}

static int lua_OrganyaRecall(lua_State* L)
{
	ReCallMusic();

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

static int lua_OrganyaFadeOut(lua_State* L)
{
	SetOrganyaFadeout();

	return 0;
}

FUNCTION_TABLE OrgFunctionTable[FUNCTION_TABLE_ORG_SIZE] =
{
	{"Play", lua_OrganyaPlay},
	{"Recall", lua_OrganyaRecall},
	{"GetCurrent", lua_OrganyaGetCurrent},
	{"GetOld", lua_OrganyaGetOld},
	{"GetPosition", lua_OrganyaGetPosition},
	{"GetOldPosition", lua_OrganyaGetOldPosition},
	{"SetPosition", lua_OrganyaSetPosition},
	{"SetVolume", lua_OrganyaSetVolume},
	{"FadeOut", lua_OrganyaFadeOut}
};