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

#include "ArmsItem.h"
#include "MyChar.h"
#include "../API_MyChar.h"

#include "Lua.h"
#include "KeyControl.h"

#include "../mod_loader.h"
#include "../cave_story.h"

int player_surf = 16;

static STRUCT_TABLE PlayerTable[] =
{
	{"x", offsetof(MYCHAR, x), TYPE_PIXEL},
	{"y", offsetof(MYCHAR, y), TYPE_PIXEL},
	{"xm", offsetof(MYCHAR, xm), TYPE_PIXEL},
	{"ym", offsetof(MYCHAR, ym), TYPE_PIXEL},
	{"tgt_x", offsetof(MYCHAR, tgt_x), TYPE_PIXEL},
	{"tgt_y", offsetof(MYCHAR, tgt_y), TYPE_PIXEL},
	{"index_x", offsetof(MYCHAR, index_x), TYPE_PIXEL},
	{"index_y", offsetof(MYCHAR, index_y), TYPE_PIXEL},
	{"unit", offsetof(MYCHAR, unit), TYPE_NUMBER},
	{"ani_no", offsetof(MYCHAR, ani_no), TYPE_NUMBER},
	{"ani_wait", offsetof(MYCHAR, ani_wait), TYPE_NUMBER},
	{"boost_fuel", offsetof(MYCHAR, boost_cnt), TYPE_NUMBER},
	{"direct", offsetof(MYCHAR, direct), TYPE_NUMBER},
	{"hit_flag", offsetof(MYCHAR, flag), TYPE_NUMBER},
	{"equip", offsetof(MYCHAR, equip), TYPE_NUMBER},
	{"level", offsetof(MYCHAR, level), TYPE_NUMBER},
	{"exp_wait", offsetof(MYCHAR, exp_wait), TYPE_NUMBER},
	{"exp_count", offsetof(MYCHAR, exp_count), TYPE_NUMBER},
	{"lifeBr", offsetof(MYCHAR, lifeBr), TYPE_NUMBER},
	{"lifeBr_count", offsetof(MYCHAR, lifeBr_count), TYPE_NUMBER},
	{"air_real", offsetof(MYCHAR, air), TYPE_NUMBER},
	{"air_get", offsetof(MYCHAR, air_get), TYPE_NUMBER},
	{"x_cs", offsetof(MYCHAR, x), TYPE_NUMBER},
	{"y_cs", offsetof(MYCHAR, y), TYPE_NUMBER},
	{"xm_cs", offsetof(MYCHAR, xm), TYPE_NUMBER},
	{"ym_cs", offsetof(MYCHAR, ym), TYPE_NUMBER},
	{"tgt_x_cs", offsetof(MYCHAR, tgt_x), TYPE_NUMBER},
	{"tgt_y_cs", offsetof(MYCHAR, tgt_y), TYPE_NUMBER},
	{"index_x_cs", offsetof(MYCHAR, index_x), TYPE_NUMBER},
	{"index_y_cs", offsetof(MYCHAR, index_y), TYPE_NUMBER},
	{"boost_sw", offsetof(MYCHAR, boost_sw), TYPE_S8},
	{"star", offsetof(MYCHAR, star), TYPE_SHORT},
	{"life", offsetof(MYCHAR, life), TYPE_SHORT},
	{"max_life", offsetof(MYCHAR, max_life), TYPE_SHORT},
	{"bubble", offsetof(MYCHAR, bubble), TYPE_U8},
	{"fire_rate", offsetof(MYCHAR, rensha), TYPE_U8},
	{"shock", offsetof(MYCHAR, shock), TYPE_U8},
	{"cond", offsetof(MYCHAR, cond), TYPE_U8},
	{"up", offsetof(MYCHAR, up), TYPE_BOOL},
	{"down", offsetof(MYCHAR, down), TYPE_BOOL},
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
	else if (strcmp(x, "ammo_empty") == 0)
	{
		lua_pushnumber(L, empty_caret_timer);
		return 1;
	}
	else if (strcmp(x, "splash") == 0)
	{
		lua_pushboolean(L, gMC.sprash != 0);
		return 1;
	}
	else if (strcmp(x, "ques") == 0)
	{
		lua_pushboolean(L, gMC.ques != 0);
		return 1;
	}
	else if (strcmp(x, "surf") == 0)
	{
		lua_pushnumber(L, player_surf);
		return 1;
	}

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Player");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
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
	else if (strcmp(x, "ammo_empty") == 0)
	{
		empty_caret_timer = (int)luaL_checknumber(L, 3);
		return 0;
	}
	else if (strcmp(x, "splash") == 0)
	{
		gMC.sprash = lua_toboolean(L, 3) ? 1 : 0;
		return 0;
	}
	else if (strcmp(x, "ques") == 0)
	{
		gMC.ques = lua_toboolean(L, 3) ? 1 : 0;
		return 0;
	}
	else if (strcmp(x, "surf") == 0)
	{
		player_surf = (int)luaL_checknumber(L, 3);
		return 1;
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

	DamageMyChar_ModCS(damage);

	return 0;
}

static int lua_PlayerDamagePID(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	int damage = (int)luaL_checknumber(L, 2);

	DamageMyChar_ModCS(damage);

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

static int lua_PlayerSetArmsRect(lua_State* L)
{
	if (lua_isnumber(L, 1))
	{
		gMC.rect_arms.left = (int)luaL_checknumber(L, 1);
		gMC.rect_arms.top = (int)luaL_checknumber(L, 2);
		gMC.rect_arms.right = (int)luaL_checknumber(L, 3);
		gMC.rect_arms.bottom = (int)luaL_checknumber(L, 4);
	}
	else if (lua_isuserdata(L, 1)) {
		gMC.rect_arms = *(RECT*)luaL_checkudata(L, 1, "RectMeta");
	}
	else {
		luaL_error(L, "bad argument #1 to 'SetArmsRect' (number or RectMeta expected, got %s)", luaL_typename(L, 1));
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

static int lua_PlayerSetHitbox(lua_State* L)
{
	if (lua_isnumber(L, 1))
	{
		gMC.hit.front = (int)(luaL_checknumber(L, 1) * 0x200);
		gMC.hit.top = (int)(luaL_checknumber(L, 2) * 0x200);
		gMC.hit.back = (int)(luaL_checknumber(L, 3) * 0x200);
		gMC.hit.bottom = (int)(luaL_checknumber(L, 4) * 0x200);
	}
	else if (lua_isuserdata(L, 1)) {
		gMC.hit = *(OTHER_RECT*)luaL_checkudata(L, 1, "RangeRectMeta");
	}
	else {
		luaL_error(L, "bad argument #1 to 'SetHitbox' (number or RangeRectMeta expected, got %s)", luaL_typename(L, 1));
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

static int lua_PlayerGetArmsRect(lua_State* L)
{
	RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

	*rect = gMC.rect_arms;

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

static int lua_PlayerTouchSurface(lua_State* L)
{
	if (gMC.flag & 0xF)
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

static int lua_PlayerCheckHitFlag(lua_State* L)
{
	int flagID = (int)luaL_checknumber(L, 1);

	if (gMC.flag & flagID)
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

static int lua_PlayerGetHitDamage(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)damageAmount);
	return 1;
}

static int lua_PlayerSetCondBit(lua_State* L)
{
	int bit = (int)luaL_checknumber(L, 1);

	gMC.cond |= bit;

	return 0;
}

static int lua_PlayerUnsetCondBit(lua_State* L)
{
	int bit = (int)luaL_checknumber(L, 1);

	gMC.cond &= ~bit;

	return 0;
}

static int lua_PlayerCheckCondBit(lua_State* L)
{
	int bit = (int)luaL_checknumber(L, 1);

	if (gMC.cond & bit)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_PlayerInit(lua_State* L)
{
	InitMyChar();
	return 0;
}

static int lua_PlayerActCode(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	Replacement_ModeAction_ActMyChar(should);
	return 0;
}

static int lua_PlayerAniCode(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	Replacement_ModeAction_AnimationMyChar(should);
	return 0;
}

static int lua_PlayerResetHitFlag(lua_State* L)
{
	ResetMyCharFlag();
	return 0;
}

static int lua_PlayerTileHitCode(lua_State* L)
{
	HitMyCharMap();
	return 0;
}

static int lua_PlayerNpcHitCode(lua_State* L)
{
	HitMyCharNpChar();
	return 0;
}

static int lua_PlayerBossHitCode(lua_State* L)
{
	HitMyCharBoss();
	return 0;
}

static int lua_PlayerPutLife(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	PutMyLife(should);
	return 0;
}

static int lua_PlayerPutExp(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	PutArmsEnergy(should);
	return 0;
}

static int lua_PlayerPutAir(lua_State* L)
{
    int x = (int)luaL_checknumber(L, 1);
    int y = (int)luaL_checknumber(L, 2);

	PutMyAir(x, y);
	return 0;
}

static int lua_PlayerPutArmsList(lua_State* L)
{
	PutActiveArmsList();
	return 0;
}

static int lua_PlayerPutMain(lua_State* L)
{
    int fx = (int)luaL_checknumber(L, 1);
    int fy = (int)luaL_checknumber(L, 2);

	Replacement_ModeAction_PutMyChar(fx, fy);
	return 0;
}

// tgt_mc keys (aka just the player key presses in freeware)
static int lua_NpcTgtKeyJump(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);

	KeyCheck(L, gKey, gKeyTrg, gKeyJump, 1);

	return 1;
}

static int lua_NpcTgtKeyShot(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);

	KeyCheck(L, gKey, gKeyTrg, gKeyShot, 1);

	return 1;
}

static int lua_NpcTgtKeyArms(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyArms, 1);

	return 1;
}

static int lua_NpcTgtKeyArmsRev(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyArmsRev, 1);

	return 1;
}

static int lua_NpcTgtKeyItem(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyItem, 1);

	return 1;
}

static int lua_NpcTgtKeyMap(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyMap, 1);

	return 1;
}

static int lua_NpcTgtKeyOk(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyOk, 1);

	return 1;
}

static int lua_NpcTgtKeyCancel(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyCancel, 1);

	return 1;
}

static int lua_NpcTgtKeyLeft(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyLeft, 1);

	return 1;
}

static int lua_NpcTgtKeyUp(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyUp, 1);

	return 1;
}

static int lua_NpcTgtKeyRight(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyRight, 1);

	return 1;
}

static int lua_NpcTgtKeyDown(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, gKeyDown, 1);

	return 1;
}

static int lua_NpcTgtKeyShift(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, KEY_SHIFT, 1);

	return 1;
}

static int lua_NpcTgtKeyPause(lua_State* L)
{
	(void)luaL_checkudata(L, 1, "PlayerMeta");

	lua_settop(L, 0);
	
	KeyCheck(L, gKey, gKeyTrg, KEY_ESCAPE, 1);

	return 1;
}

static int lua_MultiplayerIsPlaying(lua_State* L)
{
    MYCHAR* mc = *(MYCHAR**)luaL_checkudata(L, 1, "PlayerMeta");
	lua_pushboolean(L, 1);
	return 1;
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
	{"DamageMyID", lua_PlayerDamagePID},
	{"SetRect", lua_PlayerSetRect},
	{"SetArmsRect", lua_PlayerSetArmsRect},
	{"OffsetRect", lua_PlayerOffsetRect},
	{"SetViewbox", lua_PlayerSetViewbox},
	{"SetHitbox", lua_PlayerSetHitbox},
	{"GetRect", lua_PlayerGetRect},
	{"GetArmsRect", lua_PlayerGetArmsRect},
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
	{"TouchSurface", lua_PlayerTouchSurface},
	{"TouchSlopeRight", lua_PlayerTouchSlopeRight},
	{"TouchSlopeLeft", lua_PlayerTouchSlopeLeft},
	{"TouchTile", lua_PlayerTouchTile},
	{"TouchWater", lua_PlayerTouchWater},
	{"HitFlag", lua_PlayerCheckHitFlag},
	{"SetCond", lua_PlayerSetCondBit},
	{"UnsetCond", lua_PlayerUnsetCondBit},
	{"CheckCond", lua_PlayerCheckCondBit},
	{"ProcessAir", lua_PlayerAirProcess},
	{"GetHitDamage", lua_PlayerGetHitDamage},
	{"Init", lua_PlayerInit},
	{"ActMain", lua_PlayerActCode},
	{"AniMain", lua_PlayerAniCode},
	{"ResetTileFlag", lua_PlayerResetHitFlag},
	{"TileHitCode", lua_PlayerTileHitCode},
	{"NpcHitCode", lua_PlayerNpcHitCode},
	{"BossHitCode", lua_PlayerBossHitCode},
	{"DrawLife", lua_PlayerPutLife},
	{"DrawExp", lua_PlayerPutExp},
	{"DrawAir", lua_PlayerPutAir},
	{"DrawArms", lua_PlayerPutArmsList},
	{"DrawMain", lua_PlayerPutMain},
	// npc.tgt_mc key presses
	{"KeyJump", lua_NpcTgtKeyJump},
	{"KeyShoot", lua_NpcTgtKeyShot},
	{"KeyArms", lua_NpcTgtKeyArms},
	{"KeyArmsRev", lua_NpcTgtKeyArmsRev},
	{"KeyItem", lua_NpcTgtKeyItem},
	{"KeyMap", lua_NpcTgtKeyMap},
	{"KeyOk", lua_NpcTgtKeyOk},
	{"KeyCancel", lua_NpcTgtKeyCancel},
	{"KeyLeft", lua_NpcTgtKeyLeft},
	{"KeyUp", lua_NpcTgtKeyUp},
	{"KeyRight", lua_NpcTgtKeyRight},
	{"KeyDown", lua_NpcTgtKeyDown},
	{"KeyShift", lua_NpcTgtKeyShift},
	{"KeyPause", lua_NpcTgtKeyPause},
	{"IsPlaying", lua_MultiplayerIsPlaying}, // cse2le compat
	// Arms inventory stuff (so you don't have to change many function arguments.. I know this is getting unhinged.)
	{"ArmsGetCurrent", lua_ArmsGetCurrent},
	{"ArmsGetByID", lua_ArmsGetByID},
	{"ArmsGetByInvPos", lua_ArmsGetByInvPos},
	{"ArmsGetCurrentInvPos", lua_ArmsGetCurrentInvPos},
	{"ArmsSetCurrentInvPos", lua_ArmsSetCurrentInvPos},
	{"ArmsUseAmmo", lua_ArmsUseAmmo},
	{"ArmsAddAmmo", lua_ArmsAddAmmo},
	{"ArmsSwitchNext", lua_ArmsSwitchNext},
	{"ArmsSwitchPrev", lua_ArmsSwitchPrev},
	{"ArmsSwitchFirst", lua_ArmsSwitchFirst},
	{"ArmsAddExp", lua_ArmsAddExp},
	{"ArmsRemoveExp", lua_ArmsRemoveExp},
	{"ArmsCountBullet", lua_ArmsCountArmsBullet},
	{"ArmsResetCurrentExp", lua_ArmsZeroExp},
	{"ArmsIsCurrentMaxExp", lua_ArmsCurrentMax},
	{"ArmsGetExpX", lua_ArmsGetExpX},
	{"ArmsSetExpX", lua_ArmsSetExpX},
};


// used in CSE2LE / fan lua recreations to allow multiplayer
static int lua_PlayerGetActiveCount(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)1);
	return 1;
}

static int lua_GetMaxPlayerCount(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)1);
	return 1;
}

static int lua_GetPlayerByID(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);

	// Commented out in freeware dll lol
	// This exists solely to make CSE2LE porting easier..

	/*
	if (id < 1 || id > MAX_PLAYERS)
	{
		lua_pushnil(L);
		return 1;
	}
	*/

	MYCHAR** mc = (MYCHAR**)lua_newuserdata(L, sizeof(MYCHAR*));
	*mc = &gMC;

	luaL_getmetatable(L, "PlayerMeta");
	lua_setmetatable(L, -2);

	return 1;
}

FUNCTION_TABLE MultiplayerFunctionTable[FUNCTION_TABLE_MULTIPLAYER_SIZE] =
{
	{"GetPlayerCount", lua_PlayerGetActiveCount},
	{"GetMaxPlayerCount", lua_GetMaxPlayerCount},
    {"GetByID", lua_GetPlayerByID},
};