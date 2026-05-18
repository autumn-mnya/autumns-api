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

#include "Config.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_ModeOpening.h"
#include "../API_ModeAction.h"

BOOL SaveConfigData(ConfigData* conf)
{
	// Get path
	char path[MAX_PATH];
	sprintf(path, "%s\\%s", exeModulePath, gConfigFileName);

	// Open file
	FILE* fp = fopen(path, "wb");
	if (fp == NULL)
		return FALSE;

	// Write data
	fwrite(conf, sizeof(ConfigData), 1, fp);

	// Close file
	fclose(fp);

	return TRUE;
}

static STRUCT_TABLE ConfigTable[] =
{
	{"move_mode", offsetof(ConfigData, move_button_mode), TYPE_NUMBER},
	{"attack_mode", offsetof(ConfigData, attack_button_mode), TYPE_NUMBER},
	{"ok_mode", offsetof(ConfigData, ok_button_mode), TYPE_NUMBER},
	{"window_size", offsetof(ConfigData, display_mode), TYPE_NUMBER},
    {"gamepad_enabled", offsetof(ConfigData, bJoystick), TYPE_BOOL},
};

int lua_ConfigIndex(lua_State* L)
{
	ConfigData* conf = (ConfigData*)luaL_checkudata(L, 1, "ConfigMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, ConfigTable, conf, sizeof(ConfigTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Config");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_ConfigNextIndex(lua_State* L)
{
	ConfigData* conf = (ConfigData*)luaL_checkudata(L, 1, "ConfigMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, ConfigTable, conf, sizeof(ConfigTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_CreateConfig(lua_State* L)
{
	ConfigData* conf = (ConfigData*)lua_newuserdata(L, sizeof(ConfigData));

	luaL_getmetatable(L, "ConfigMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_GetConfig(lua_State* L)
{
	ConfigData confLoad;
	if (!LoadConfigData(&confLoad))
		DefaultConfigData(&confLoad);

	ConfigData* conf = (ConfigData*)lua_newuserdata(L, sizeof(ConfigData));

	*conf = confLoad;

	luaL_getmetatable(L, "ConfigMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_ConfigSave(lua_State* L)
{
    ConfigData* conf = (ConfigData*)luaL_checkudata(L, 1, "ConfigMeta");
	SaveConfigData(conf);
	return 0;
}

FUNCTION_TABLE ConfigFunctionTable[FUNCTION_TABLE_CONFIG_SIZE] =
{
    {"Create", lua_CreateConfig},
    {"Get", lua_GetConfig},
    {"Save", lua_ConfigSave},
};