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

#include "Lua_MyChar.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

static STRUCT_TABLE PlayerTable[] =
{
	{"x", offsetof(MYCHAR, x), TYPE_PIXEL},
	{"y", offsetof(MYCHAR, y), TYPE_PIXEL},
	{"xm", offsetof(MYCHAR, xm), TYPE_NUMBER},
	{"ym", offsetof(MYCHAR, ym), TYPE_NUMBER},
	{"ani_no", offsetof(MYCHAR, ani_no), TYPE_NUMBER},
	{"ani_wait", offsetof(MYCHAR, ani_wait), TYPE_NUMBER},
	{"boost_fuel", offsetof(MYCHAR, boost_cnt), TYPE_NUMBER},
	{"direct", offsetof(MYCHAR, direct), TYPE_NUMBER},
	// don't use
	{"cond", offsetof(MYCHAR, cond), TYPE_NUMBER},
	{"hit_flag", offsetof(MYCHAR, flag), TYPE_NUMBER},
	{"equip", offsetof(MYCHAR, equip), TYPE_NUMBER},
};

int lua_PlayerIndex(lua_State* L)
{
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, PlayerTable, &gMC, sizeof(PlayerTable) / sizeof(STRUCT_TABLE)))
		return 1;

	if (strcmp(x, "air") == 0)
	{
		lua_pushnumber(L, gMC.air / 10);
		return 1;
	}
	else if (strcmp(x, "fire_rate") == 0)
	{
		lua_pushnumber(L, gMC.rensha);
		return 1;
	}
	else if (strcmp(x, "ammo_empty") == 0)
	{
		lua_pushnumber(L, empty_caret_timer);
		return 1;
	}
	else if (strcmp(x, "unit") == 0)
	{
		lua_pushnumber(L, gMC.unit);
		return 1;
	}
	else if (strcmp(x, "boost_sw") == 0)
	{
		lua_pushnumber(L, gMC.boost_sw);
		return 1;
	}
	else if (strcmp(x, "ques") == 0)
	{
		lua_pushnumber(L, gMC.ques);
		return 1;
	}
	else if (strcmp(x, "up") == 0)
	{
		lua_pushnumber(L, gMC.up);
		return 1;
	}
	else if (strcmp(x, "down") == 0)
	{
		lua_pushnumber(L, gMC.down);
		return 1;
	}
	else if (strcmp(x, "splash") == 0)
	{
		lua_pushnumber(L, gMC.sprash);
		return 1;
	}
	else if (strcmp(x, "tgt_x") == 0)
	{
		lua_pushnumber(L, gMC.tgt_x);
		return 1;
	}
	else if (strcmp(x, "tgt_y") == 0)
	{
		lua_pushnumber(L, gMC.tgt_y);
		return 1;
	}
	else if (strcmp(x, "index_x") == 0)
	{
		lua_pushnumber(L, gMC.index_x);
		return 1;
	}
	else if (strcmp(x, "index_y") == 0)
	{
		lua_pushnumber(L, gMC.index_y);
		return 1;
	}

	return 0;
}

int lua_PlayerNextIndex(lua_State* L)
{
	const char* x = luaL_checkstring(L, 2);

	if (Write2StructBasic(L, x, PlayerTable, &gMC, sizeof(PlayerTable) / sizeof(STRUCT_TABLE)))
		return 0;

	if (strcmp(x, "air") == 0)
	{
		gMC.air = (int)luaL_checknumber(L, 3) * 10;
		return 0;
	}
	else if (strcmp(x, "fire_rate") == 0)
	{
		gMC.rensha = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "ammo_empty") == 0)
	{
		empty_caret_timer = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "unit") == 0)
	{
		gMC.unit = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "boost_sw") == 0)
	{
		gMC.boost_sw = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "ques") == 0)
	{
		gMC.ques = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "up") == 0)
	{
		gMC.up = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "down") == 0)
	{
		gMC.down = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "splash") == 0)
	{
		gMC.sprash = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "tgt_x") == 0)
	{
		gMC.tgt_x = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "tgt_y") == 0)
	{
		gMC.tgt_y = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "index_x") == 0)
	{
		gMC.index_x = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "index_y") == 0)
	{
		gMC.index_y = (int)luaL_checknumber(L, 3);
		return 0;
	}

	lua_rawset(L, -3);

	return 0;
}

static int lua_PlayerIsHit(lua_State* L)
{
	if (gMC.shock)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerIsLookingUp(lua_State* L)
{
	if (gMC.up)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerIsLookingDown(lua_State* L)
{
	if (gMC.down)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerGetLife(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gMC.life);

	return 1;
}

static int lua_PlayerAddLife(lua_State* L)
{
	int life = (int)luaL_checknumber(L, 1);

	AddLifeMyChar(life);

	return 0;
}

static int lua_PlayerGetMaxLife(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gMC.max_life);

	return 1;
}

static int lua_PlayerAddMaxLife(lua_State* L)
{
	int life = (int)luaL_checknumber(L, 1);

	AddMaxLifeMyChar(life);

	return 0;
}

static int lua_PlayerDamage(lua_State* L)
{
	int damage = (int)luaL_checknumber(L, 1);

	DamageMyChar(damage);

	return 0;
}

static int lua_PlayerSetRect(lua_State* L)
{
	if (lua_isnumber(L, 1))
	{
		gMC.rect.left = (int)luaL_checknumber(L, 1);
		gMC.rect.top = (int)luaL_checknumber(L, 2);
		gMC.rect.right = (int)luaL_checknumber(L, 3);
		gMC.rect.bottom = (int)luaL_checknumber(L, 4);
	}
	else if (lua_isuserdata(L, 1)) {
		gMC.rect = *(RECT*)luaL_checkudata(L, 1, "RectMeta");
	}
	else {
		luaL_error(L, "bad argument #1 to 'SetRect' (number or RectMeta expected, got %s)", luaL_typename(L, 1));
		return 0;
	}

	return 0;
}

static int lua_PlayerOffsetRect(lua_State* L)
{
	gMC.rect.left += (int)luaL_checknumber(L, 1);
	gMC.rect.top += (int)luaL_checknumber(L, 2);
	gMC.rect.right += (int)luaL_optnumber(L, 3, (int)lua_tonumber(L, 1));
	gMC.rect.bottom += (int)luaL_optnumber(L, 4, (int)lua_tonumber(L, 2));

	return 0;
}

static int lua_PlayerSetViewbox(lua_State* L)
{
	if (lua_isnumber(L, 1))
	{
		gMC.view.front = (int)(luaL_checknumber(L, 1) * 0x200);
		gMC.view.top = (int)(luaL_checknumber(L, 2) * 0x200);
		gMC.view.back = (int)(luaL_checknumber(L, 3) * 0x200);
		gMC.view.bottom = (int)(luaL_checknumber(L, 4) * 0x200);
	}
	else if (lua_isuserdata(L, 1)) {
		gMC.view = *(OTHER_RECT*)luaL_checkudata(L, 1, "RangeRectMeta");
	}
	else {
		luaL_error(L, "bad argument #1 to 'SetViewbox' (number or RangeRectMeta expected, got %s)", luaL_typename(L, 1));
		return 0;
	}

	return 0;
}

static int lua_PlayerGetRect(lua_State* L)
{
	RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

	*rect = gMC.rect;

	luaL_getmetatable(L, "RectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_PlayerGetHitbox(lua_State* L)
{
	OTHER_RECT* hit = (OTHER_RECT*)lua_newuserdata(L, sizeof(OTHER_RECT));

	*hit = gMC.hit;

	luaL_getmetatable(L, "RangeRectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_PlayerGetViewbox(lua_State* L)
{
	OTHER_RECT* view = (OTHER_RECT*)lua_newuserdata(L, sizeof(OTHER_RECT));

	*view = gMC.view;

	luaL_getmetatable(L, "RangeRectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_PlayerSetArmsYOffset(lua_State* L)
{
	int offset = (int)luaL_checknumber(L, 1);
	ModLoader_WriteLong((void*)0x415302, -offset);
	ModLoader_WriteLong((void*)0x415330, offset);
	return 0;
}

static int lua_PlayerEquip(lua_State* L)
{
	int bit = (int)luaL_checknumber(L, 1);

	EquipItem(bit, TRUE);

	return 0;
}

static int lua_PlayerUnequip(lua_State* L)
{
	int bit = (int)luaL_checknumber(L, 1);

	EquipItem(bit, FALSE);

	return 0;
}

static int lua_PlayerHasEquipped(lua_State* L)
{
	int bit = (int)luaL_checknumber(L, 1);

	if (gMC.equip & bit)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerTouchLeftWall(lua_State* L)
{
	if (gMC.flag & 1)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerTouchRightWall(lua_State* L)
{
	if (gMC.flag & 4)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerTouchCeiling(lua_State* L)
{
	if (gMC.flag & 2)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerTouchFloor(lua_State* L)
{
	if (gMC.flag & 8)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerTouchSlopeRight(lua_State* L)
{
	if (gMC.flag & 16)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerTouchSlopeLeft(lua_State* L)
{
	if (gMC.flag & 32)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerTouchTile(lua_State* L)
{
	if (gMC.flag & 0xFF)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerTouchWater(lua_State* L)
{
	if (gMC.flag & 0x100)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerAirProcess(lua_State* L)
{
	AirProcess();
	return 0;
}

FUNCTION_TABLE PlayerFunctionTable[FUNCTION_TABLE_PLAYER_SIZE] =
{
	{"IsHit", lua_PlayerIsHit},
	{"IsLookingUp", lua_PlayerIsLookingUp},
	{"IsLookingDown", lua_PlayerIsLookingDown},
	{"GetLife", lua_PlayerGetLife},
	{"AddLife", lua_PlayerAddLife},
	{"GetMaxLife", lua_PlayerGetMaxLife},
	{"AddMaxLife", lua_PlayerAddMaxLife},
	{"Damage", lua_PlayerDamage},
	{"SetRect", lua_PlayerSetRect},
	{"OffsetRect", lua_PlayerOffsetRect},
	{"SetViewbox", lua_PlayerSetViewbox},
	{"GetRect", lua_PlayerGetRect},
	{"GetHitbox", lua_PlayerGetHitbox},
	{"GetViewbox", lua_PlayerGetViewbox},
	{"SetArmsYOffset", lua_PlayerSetArmsYOffset},
	{"Equip", lua_PlayerEquip},
	{"Unequip", lua_PlayerUnequip},
	{"HasEquipped", lua_PlayerHasEquipped},
	{"TouchLeftWall", lua_PlayerTouchLeftWall},
	{"TouchRightWall", lua_PlayerTouchRightWall},
	{"TouchCeiling", lua_PlayerTouchCeiling},
	{"TouchFloor", lua_PlayerTouchFloor},
	{"TouchSlopeRight", lua_PlayerTouchSlopeRight},
	{"TouchSlopeLeft", lua_PlayerTouchSlopeLeft},
	{"TouchTile", lua_PlayerTouchTile},
	{"TouchWater", lua_PlayerTouchWater},
	{"ProcessAir", lua_PlayerAirProcess},
};