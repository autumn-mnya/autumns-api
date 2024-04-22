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

#include "Lua_Bullet.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_Weapon.h"

static STRUCT_TABLE BulletTable[] =
{
	{"x", offsetof(BULLET, x), TYPE_PIXEL},
	{"y", offsetof(BULLET, y), TYPE_PIXEL},
	{"xm", offsetof(BULLET, xm), TYPE_PIXEL},
	{"ym", offsetof(BULLET, ym), TYPE_PIXEL},
	{"tgt_x", offsetof(BULLET, tgt_x), TYPE_PIXEL},
	{"tgt_y", offsetof(BULLET, tgt_y), TYPE_PIXEL},
	{"id", offsetof(BULLET, code_bullet), TYPE_NUMBER},
	{"life", offsetof(BULLET, life), TYPE_NUMBER},
	{"life_count", offsetof(BULLET, life_count), TYPE_NUMBER},
	{"direct", offsetof(BULLET, direct), TYPE_NUMBER},
	{"ani_wait", offsetof(BULLET, ani_wait), TYPE_NUMBER},
	{"ani_no", offsetof(BULLET, ani_no), TYPE_NUMBER},
	{"count1", offsetof(BULLET, count1), TYPE_NUMBER},
	{"count2", offsetof(BULLET, count2), TYPE_NUMBER},
	{"act_no", offsetof(BULLET, act_no), TYPE_NUMBER},
	{"act_wait", offsetof(BULLET, act_wait), TYPE_NUMBER},
	{"damage", offsetof(BULLET, damage), TYPE_NUMBER},
	{"enemyhit_x", offsetof(BULLET, enemyXL), TYPE_PIXEL},
	{"enemyhit_y", offsetof(BULLET, enemyYL), TYPE_PIXEL},
	{"blockhit_x", offsetof(BULLET, blockXL), TYPE_PIXEL},
	{"blockhit_y", offsetof(BULLET, blockYL), TYPE_PIXEL},
	// don't use
	{"cond", offsetof(BULLET, cond), TYPE_NUMBER},
	{"hit_flag", offsetof(BULLET, flag), TYPE_NUMBER},
	{"bits", offsetof(BULLET, bbits), TYPE_NUMBER}
};

int lua_BulletIndex(lua_State* L)
{
	BULLET** bul = (BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, BulletTable, *bul, sizeof(BulletTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Bullet");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_BulletNextIndex(lua_State* L)
{
	BULLET** bul = (BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, BulletTable, *bul, sizeof(BulletTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_GetBulletByBufferIndex(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);

	if (gBul[id].cond & 0x80)
	{
		BULLET** bul = (BULLET**)lua_newuserdata(L, sizeof(BULLET*));
		*bul = &gBul[id];

		luaL_getmetatable(L, "BulletMeta");
		lua_setmetatable(L, -2);

		return 1;
	}

	return 0;
}

static int lua_BulletSetRect(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (lua_isnumber(L, 2))
	{
		bul->rect.left = (int)luaL_checknumber(L, 2);
		bul->rect.top = (int)luaL_checknumber(L, 3);
		bul->rect.right = (int)luaL_checknumber(L, 4);
		bul->rect.bottom = (int)luaL_checknumber(L, 5);
	}
	else if (lua_isuserdata(L, 2)) {
		bul->rect = *(RECT*)luaL_checkudata(L, 2, "RectMeta");
	}
	else {
		luaL_error(L, "bad argument #2 to 'SetRect' (number or RectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	return 0;
}

static int lua_BulletOffsetRect(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	bul->rect.left += (int)luaL_checknumber(L, 2);
	bul->rect.top += (int)luaL_checknumber(L, 3);
	bul->rect.right += (int)luaL_optnumber(L, 4, (int)lua_tonumber(L, 2));
	bul->rect.bottom += (int)luaL_optnumber(L, 5, (int)lua_tonumber(L, 3));

	return 0;
}

static int lua_BulletSetViewbox(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (lua_isnumber(L, 2))
	{
		bul->view.front = (int)(luaL_checknumber(L, 2) * 0x200);
		bul->view.top = (int)(luaL_checknumber(L, 3) * 0x200);
		bul->view.back = (int)(luaL_checknumber(L, 4) * 0x200);
		bul->view.bottom = (int)(luaL_checknumber(L, 5) * 0x200);
	}
	else if (lua_isuserdata(L, 2)) {
		bul->view = *(OTHER_RECT*)luaL_checkudata(L, 2, "RangeRectMeta");
	}
	else {
		luaL_error(L, "bad argument #2 to 'SetViewbox' (number or RangeRectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	return 0;
}

static int lua_BulletGetRect(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

	*rect = bul->rect;

	luaL_getmetatable(L, "RectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_BulletGetViewbox(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	OTHER_RECT* view = (OTHER_RECT*)lua_newuserdata(L, sizeof(OTHER_RECT));

	*view = bul->view;

	luaL_getmetatable(L, "RangeRectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_BulletDelete(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	bul->cond = 0;

	return 0;
}

static int lua_CountBulletByID(lua_State* D)
{
	lua_pushnumber(D, CountBulletNum((int)luaL_checknumber(D, 1)));

	return 1;
}

static int lua_BulletSetBit(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	int bit = (int)luaL_checknumber(L, 2);

	bul->bbits |= 1 << bit;

	return 0;
}

static int lua_BulletUnsetBit(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	int bit = (int)luaL_checknumber(L, 2);

	bul->bbits &= ~(1 << bit);

	return 0;
}

static int lua_BulletCheckBit(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	int bit = (int)luaL_checknumber(L, 2);

	if (bul->bbits & (1 << bit))
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchLeftWall(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 1)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchRightWall(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 4)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchCeiling(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 2)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchFloor(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 8)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchBottomSlopeRight(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 0x10)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchBottomSlopeLeft(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 0x20)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchTopSlopeRight(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 0x40)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchTopSlopeLeft(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 0x80)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletTouchTile(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	if (bul->flag & 0x2FF)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_BulletMove(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");

	bul->x += bul->xm;
	bul->y += bul->ym;

	return 0;
}

static int lua_SpawnBullet(lua_State* L)
{
	int code = (int)luaL_checknumber(L, 1);
	int x = (int)(luaL_checknumber(L, 2) * 0x200);
	int y = (int)(luaL_checknumber(L, 3) * 0x200);
	int dir = (int)luaL_optnumber(L, 4, 0);

	int i = 0;

	while (i < BULLET_MAX && gBul[i].cond & 0x80)
		++i;

	if (i >= BULLET_MAX)
		return 0;

	BULLET** bul = (BULLET**)lua_newuserdata(L, sizeof(BULLET*));
	*bul = &gBul[i];

	luaL_getmetatable(L, "BulletMeta");
	lua_setmetatable(L, -2);

	SetBullet(code, x, y, dir);

	return 1;
}

static int lua_ActCodeBullet(lua_State* L)
{
	BULLET* bul = *(BULLET**)luaL_checkudata(L, 1, "BulletMeta");
	int code_char = (int)luaL_optnumber(L, 2, bul->code_bullet);

	ActBulletCode(bul, code_char);

	return 0;
}

FUNCTION_TABLE BulletFunctionTable[FUNCTION_TABLE_BULLET_SIZE] =
{
	{"GetByBufferIndex", lua_GetBulletByBufferIndex},
	{"SetRect", lua_BulletSetRect},
	{"OffsetRect", lua_BulletOffsetRect},
	{"SetViewbox", lua_BulletSetViewbox},
	{"GetRect", lua_BulletGetRect},
	{"GetViewbox", lua_BulletGetViewbox},
	{"Delete", lua_BulletDelete},
	{"CountByID", lua_CountBulletByID},
	{"SetBit", lua_BulletSetBit},
	{"UnsetBit", lua_BulletUnsetBit},
	{"CheckBit", lua_BulletCheckBit},
	{"TouchLeftWall", lua_BulletTouchLeftWall},
	{"TouchRightWall", lua_BulletTouchRightWall},
	{"TouchCeiling", lua_BulletTouchCeiling},
	{"TouchFloor", lua_BulletTouchFloor},
	{"TouchBottomSlopeLeft", lua_BulletTouchBottomSlopeLeft},
	{"TouchBottomSlopeRight", lua_BulletTouchBottomSlopeRight},
	{"TouchTopSlopeLeft", lua_BulletTouchTopSlopeLeft},
	{"TouchTopSlopeRight", lua_BulletTouchTopSlopeRight},
	{"TouchTile", lua_BulletTouchTile},
	{"Move", lua_BulletMove},
	{"Spawn", lua_SpawnBullet},
	{"ActCode", lua_ActCodeBullet}
};

int BulletActModScript(int code, int i)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Bullet");
	lua_getfield(gL, -1, "Act");
	lua_geti(gL, -1, code);

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return 1;
	}

	BULLET** bul = (BULLET**)lua_newuserdata(gL, sizeof(BULLET*));
	*bul = &gBul[i];

	luaL_getmetatable(gL, "BulletMeta");
	lua_setmetatable(gL, -2);

	if (lua_pcall(gL, 1, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		return FALSE;
	}

	lua_settop(gL, 0); // Clear stack

	return 2;
}