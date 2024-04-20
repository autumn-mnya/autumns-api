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

#include "Lua_ArmsItem.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

void RemoveExpMyChar(int x)
{
	gArmsData[gSelectedArms].exp -= x;

	while (gArmsData[gSelectedArms].exp < 0)
	{
		if (gArmsData[gSelectedArms].level > 1)
		{
			--gArmsData[gSelectedArms].level;

			int lv = gArmsData[gSelectedArms].level - 1;
			int arms_code = gArmsData[gSelectedArms].code;

			gArmsData[gSelectedArms].exp = gArmsLevelTable[arms_code].exp[lv] + gArmsData[gSelectedArms].exp;

			if (gMC.life > 0 && gArmsData[gSelectedArms].code != 13)
				PlaySoundObject(37, SOUND_MODE_PLAY);
			SetCaret(gMC.x, gMC.y, 10, 2);
		}
		else
		{
			gArmsData[gSelectedArms].exp = 0;
		}
	}
}

static STRUCT_TABLE ArmsTable[] =
{
	{"id", offsetof(ARMS, code), TYPE_NUMBER},
	{"level", offsetof(ARMS, level), TYPE_NUMBER},
	{"exp", offsetof(ARMS, exp), TYPE_NUMBER},
	{"ammo", offsetof(ARMS, num), TYPE_NUMBER},
	{"max_ammo", offsetof(ARMS, max_num), TYPE_NUMBER},
};

int lua_ArmsIndex(lua_State* L)
{
	ARMS** arms = (ARMS**)luaL_checkudata(L, 1, "ArmsMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, ArmsTable, *arms, sizeof(ArmsTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Arms");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_ArmsNextIndex(lua_State* L)
{
	ARMS** arms = (ARMS**)luaL_checkudata(L, 1, "ArmsMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, ArmsTable, *arms, sizeof(ArmsTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_ArmsAdd(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	int ammo = (int)luaL_optnumber(L, 2, 0);
	AddArmsData(id, ammo);
	return 0;
}

static int lua_ArmsRemove(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	SubArmsData(id);
	return 0;
}

static int lua_ArmsGetCurrent(lua_State* L)
{
	ARMS** arms = (ARMS**)lua_newuserdata(L, sizeof(ARMS*));
	*arms = &gArmsData[gSelectedArms];

	luaL_getmetatable(L, "ArmsMeta");
	lua_setmetatable(L, -2);
	return 1;
}

static int lua_ArmsGetByID(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);

	for (int i = 0; i < ARMS_MAX; ++i)
	{
		if (gArmsData[i].code == id)
		{
			ARMS** arms = (ARMS**)lua_newuserdata(L, sizeof(ARMS*));
			*arms = &gArmsData[i];

			luaL_getmetatable(L, "ArmsMeta");
			lua_setmetatable(L, -2);
			return 1;
		}
	}

	return 0;
}

static int lua_ArmsGetByInvPos(lua_State* L)
{
	int pos = (int)luaL_checknumber(L, 1);
	if (pos > ARMS_MAX)
		SerenaAlert(L, "Out of bounds Arms inventory access");

	ARMS** arms = (ARMS**)lua_newuserdata(L, sizeof(ARMS*));
	*arms = &gArmsData[pos - 1];

	luaL_getmetatable(L, "ArmsMeta");
	lua_setmetatable(L, -2);
	return 1;
}

static int lua_ArmsGetCurrentInvPos(lua_State* L)
{
	lua_pushnumber(L, gSelectedArms + 1);
	return 1;
}

static int lua_ArmsUseAmmo(lua_State* L)
{
	int num = (int)luaL_optnumber(L, 1, 1);

	lua_pushboolean(L, UseArmsEnergy(num));
	return 1;
}

static int lua_ArmsAddAmmo(lua_State* L)
{
	int num = (int)luaL_checknumber(L, 1);
	ChargeArmsEnergy(num);
	return 0;
}

static int lua_ArmsSwitchNext(lua_State* L)
{
	RotationArms();
	return 0;
}

static int lua_ArmsSwitchPrev(lua_State* L)
{
	RotationArmsRev();
	return 0;
}

static int lua_ArmsSwitchFirst(lua_State* L)
{
	ChangeToFirstArms();
	return 0;
}

static int lua_ArmsAddExp(lua_State* L)
{
	int x = (int)luaL_checknumber(L, 1);
	AddExpMyChar(x);

	return 0;
}

static int lua_ArmsRemoveExp(lua_State* L)
{
	int x = (int)luaL_checknumber(L, 1);
	RemoveExpMyChar(x);

	return 0;
}

static int lua_ArmsGetLevels(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	lua_newtable(L);

	for (int i = 0; i < 3; ++i)
	{
		lua_pushnumber(L, gArmsLevelTable[id].exp[i]);
		lua_seti(L, -2, i + 1);
	}

	return 1;
}

FUNCTION_TABLE ArmsFunctionTable[FUNCTION_TABLE_ARMS_SIZE] =
{
	{"Add", lua_ArmsAdd},
	{"Remove", lua_ArmsRemove},
	{"GetCurrent", lua_ArmsGetCurrent},
	{"GetByID", lua_ArmsGetByID},
	{"GetByInvPos", lua_ArmsGetByInvPos},
	{"GetCurrentInvPos", lua_ArmsGetCurrentInvPos},
	{"UseAmmo", lua_ArmsUseAmmo},
	{"AddAmmo", lua_ArmsAddAmmo},
	{"SwitchNext", lua_ArmsSwitchNext},
	{"SwitchPrev", lua_ArmsSwitchPrev},
	{"SwitchFirst", lua_ArmsSwitchFirst},
	{"AddExp", lua_ArmsAddExp},
	{"RemoveExp", lua_ArmsRemoveExp},
	{"GetLevels", lua_ArmsGetLevels}
};

int ShootActModScript(int chr)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Arms");
	lua_getfield(gL, -1, "Shoot");
	lua_geti(gL, -1, chr);

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return 1;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		return 0;
	}

	lua_settop(gL, 0); // Clear stack

	return 2;
}

static STRUCT_TABLE ItemTable[] =
{
	{"id", offsetof(ITEM, code), TYPE_NUMBER}
};

int lua_ItemIndex(lua_State* L)
{
	ITEM** item = (ITEM**)luaL_checkudata(L, 1, "ItemMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, ItemTable, *item, sizeof(ItemTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Item");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_ItemNextIndex(lua_State* L)
{
	ITEM** item = (ITEM**)luaL_checkudata(L, 1, "ItemMeta");
	const char* x = luaL_checkstring(L, 2);

	if (Write2StructBasic(L, x, ItemTable, *item, sizeof(ItemTable) / sizeof(STRUCT_TABLE)))
		return 0;

	return 0;
}

static int lua_ItemAdd(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	AddItemData(id);
	return 1;
}

static int lua_ItemRemove(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);
	SubItemData(id);
	return 0;
}

static int lua_ItemGetByID(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);

	for (int i = 0; i < ITEM_MAX; ++i)
	{
		if (gItemData[i].code == id)
		{
			ITEM** item = (ITEM**)lua_newuserdata(L, sizeof(ITEM*));
			*item = &gItemData[i];

			luaL_getmetatable(L, "ItemMeta");
			lua_setmetatable(L, -2);
			return 1;
		}
	}

	return 0;
}

static int lua_ItemGetByInvPos(lua_State* L)
{
	int pos = (int)luaL_checknumber(L, 1);
	if (pos > ITEM_MAX)
		SerenaAlert(L, "Out of bounds Item inventory access");

	ITEM** item = (ITEM**)lua_newuserdata(L, sizeof(ITEM*));
	*item = &gItemData[pos - 1];

	luaL_getmetatable(L, "ItemMeta");
	lua_setmetatable(L, -2);
	return 1;
}

FUNCTION_TABLE ItemFunctionTable[FUNCTION_TABLE_ITEM_SIZE] =
{
	{"Add", lua_ItemAdd},
	{"Remove", lua_ItemRemove},
	{"GetByID", lua_ItemGetByID},
	{"GetByInvPos", lua_ItemGetByInvPos}
};