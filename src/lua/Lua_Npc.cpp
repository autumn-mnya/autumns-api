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

#include "Lua_Npc.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

#include "../API_Npc.h"

static BOOL fcuking = TRUE;

static STRUCT_TABLE NpcTable[] =
{
	{"x", offsetof(NPCHAR, x), TYPE_PIXEL},
	{"y", offsetof(NPCHAR, y), TYPE_PIXEL},
	{"xm", offsetof(NPCHAR, xm), TYPE_NUMBER},
	{"ym", offsetof(NPCHAR, ym), TYPE_NUMBER},
	{"xm2", offsetof(NPCHAR, xm2), TYPE_NUMBER},
	{"ym2", offsetof(NPCHAR, ym2), TYPE_NUMBER},
	{"tgt_x", offsetof(NPCHAR, tgt_x), TYPE_PIXEL},
	{"tgt_y", offsetof(NPCHAR, tgt_y), TYPE_PIXEL},
	{"tgt_1", offsetof(NPCHAR, tgt_x), TYPE_NUMBER},
	{"tgt_2", offsetof(NPCHAR, tgt_y), TYPE_NUMBER},
	{"id", offsetof(NPCHAR, code_char), TYPE_NUMBER},
	{"flag", offsetof(NPCHAR, code_flag), TYPE_NUMBER},
	{"event", offsetof(NPCHAR, code_event), TYPE_NUMBER},
	{"surf", offsetof(NPCHAR, surf), TYPE_SURFACE},
	{"hit_voice", offsetof(NPCHAR, hit_voice), TYPE_NUMBER},
	{"destroy_voice", offsetof(NPCHAR, destroy_voice), TYPE_NUMBER},
	{"life", offsetof(NPCHAR, life), TYPE_NUMBER},
	{"exp", offsetof(NPCHAR, exp), TYPE_NUMBER},
	{"smoke_size", offsetof(NPCHAR, size), TYPE_NUMBER},
	{"direct", offsetof(NPCHAR, direct), TYPE_NUMBER},
	{"ani_wait", offsetof(NPCHAR, ani_wait), TYPE_NUMBER},
	{"ani_no", offsetof(NPCHAR, ani_no), TYPE_NUMBER},
	{"count1", offsetof(NPCHAR, count1), TYPE_NUMBER},
	{"count2", offsetof(NPCHAR, count2), TYPE_NUMBER},
	{"act_no", offsetof(NPCHAR, act_no), TYPE_NUMBER},
	{"act_wait", offsetof(NPCHAR, act_wait), TYPE_NUMBER},
	{"damage", offsetof(NPCHAR, damage), TYPE_NUMBER},
	{"pNpc", offsetof(NPCHAR, pNpc), TYPE_NPC},
	// don't use
	{"cond", offsetof(NPCHAR, cond), TYPE_NUMBER},
	{"hit_flag", offsetof(NPCHAR, flag), TYPE_NUMBER},
	{"shock", offsetof(NPCHAR, shock), TYPE_NUMBER},
	{"bits", offsetof(NPCHAR, bits), TYPE_NUMBER}
};

int lua_NpcIndex(lua_State* L)
{
	NPCHAR** npc = (NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	const char* x = luaL_checkstring(L, 2);

	if (ReadStructBasic(L, x, NpcTable, *npc, sizeof(NpcTable) / sizeof(STRUCT_TABLE)))
		return 1;

	lua_getglobal(L, "ModCS");
	lua_getfield(L, -1, "Npc");
	lua_pushstring(L, x);
	lua_rawget(L, -2);

	return 1;
}

int lua_NpcNextIndex(lua_State* L)
{
	NPCHAR** npc = (NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	const char* x = luaL_checkstring(L, 2);

	Write2StructBasic(L, x, NpcTable, *npc, sizeof(NpcTable) / sizeof(STRUCT_TABLE));

	return 0;
}

static int lua_GetNpcByEvent(lua_State* L)
{
	int code_event = (int)luaL_checknumber(L, 1);

	for (int i = 0; i < NPC_MAX; ++i)
	{
		if ((gNPC[i].cond & 0x80) && gNPC[i].code_event == code_event)
		{
			NPCHAR** npc = (NPCHAR**)lua_newuserdata(L, sizeof(NPCHAR*));
			*npc = &gNPC[i];

			luaL_getmetatable(L, "NpcMeta");
			lua_setmetatable(L, -2);

			return 1;
		}
	}

	return 0;
}

static int lua_GetNpcByBufferIndex(lua_State* L)
{
	int id = (int)luaL_checknumber(L, 1);

	if (gNPC[id].cond & 0x80)
	{
		NPCHAR** npc = (NPCHAR**)lua_newuserdata(L, sizeof(NPCHAR*));
		*npc = &gNPC[id];

		luaL_getmetatable(L, "NpcMeta");
		lua_setmetatable(L, -2);

		return 1;
	}

	return 0;
}

static int lua_NpcSetRect(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (lua_isnumber(L, 2))
	{
		npc->rect.left = (int)luaL_checknumber(L, 2);
		npc->rect.top = (int)luaL_checknumber(L, 3);
		npc->rect.right = (int)luaL_checknumber(L, 4);
		npc->rect.bottom = (int)luaL_checknumber(L, 5);
	}
	else if (lua_isuserdata(L, 2)) {
		npc->rect = *(RECT*)luaL_checkudata(L, 2, "RectMeta");
	}
	else {
		luaL_error(L, "bad argument #2 to 'SetRect' (number or RectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	return 0;
}

static int lua_NpcOffsetRect(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	npc->rect.left += (int)luaL_checknumber(L, 2);
	npc->rect.top += (int)luaL_checknumber(L, 3);
	npc->rect.right += (int)luaL_optnumber(L, 4, (int)lua_tonumber(L, 2));
	npc->rect.bottom += (int)luaL_optnumber(L, 5, (int)lua_tonumber(L, 3));

	return 0;
}

static int lua_NpcSetHitbox(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (lua_isnumber(L, 2))
	{
		npc->hit.front = (int)(luaL_checknumber(L, 2) * 0x200);
		npc->hit.top = (int)(luaL_checknumber(L, 3) * 0x200);
		npc->hit.back = (int)(luaL_checknumber(L, 4) * 0x200);
		npc->hit.bottom = (int)(luaL_checknumber(L, 5) * 0x200);
	}
	else if (lua_isuserdata(L, 2)) {
		npc->hit = *(OTHER_RECT*)luaL_checkudata(L, 2, "RangeRectMeta");
	}
	else {
		luaL_error(L, "bad argument #2 to 'SetHitbox' (number or RangeRectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	return 0;
}

static int lua_NpcSetViewbox(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (lua_isnumber(L, 2))
	{
		npc->view.front = (int)(luaL_checknumber(L, 2) * 0x200);
		npc->view.top = (int)(luaL_checknumber(L, 3) * 0x200);
		npc->view.back = (int)(luaL_checknumber(L, 4) * 0x200);
		npc->view.bottom = (int)(luaL_checknumber(L, 5) * 0x200);
	}
	else if (lua_isuserdata(L, 2)) {
		npc->view = *(OTHER_RECT*)luaL_checkudata(L, 2, "RangeRectMeta");
	}
	else {
		luaL_error(L, "bad argument #2 to 'SetViewbox' (number or RangeRectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	return 0;
}

static int lua_NpcGetRect(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

	*rect = npc->rect;

	luaL_getmetatable(L, "RectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_NpcGetHitbox(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	OTHER_RECT* hit = (OTHER_RECT*)lua_newuserdata(L, sizeof(OTHER_RECT));

	*hit = npc->hit;

	luaL_getmetatable(L, "RangeRectMeta");
	lua_setmetatable(L, -2);

	return 1;
}

static int lua_NpcGetViewbox(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	OTHER_RECT* view = (OTHER_RECT*)lua_newuserdata(L, sizeof(OTHER_RECT));

	*view = npc->view;

	luaL_getmetatable(L, "RangeRectMeta")
		; lua_setmetatable(L, -2);

	return 1;
}

static int lua_NpcIsHit(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->shock)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcDelete(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	npc->cond = 0;

	return 0;
}

static int lua_NpcKill(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	LoseNpChar(npc, TRUE);

	return 0;
}

static int lua_NpcKillOnNextFrame(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	npc->cond |= 8;

	return 0;
}

static int lua_NpcSetBit(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	int bit = (int)luaL_checknumber(L, 2);

	npc->bits |= 1 << bit;

	return 0;
}

static int lua_NpcUnsetBit(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	int bit = (int)luaL_checknumber(L, 2);

	npc->bits &= ~(1 << bit);

	return 0;
}

static int lua_NpcCheckBit(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	int bit = (int)luaL_checknumber(L, 2);

	if (npc->bits & (1 << bit))
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcTouchLeftWall(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->flag & 1)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcTouchRightWall(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->flag & 4)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcTouchCeiling(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->flag & 2)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcTouchFloor(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->flag & 8)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcTouchSlopeRight(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->flag & 16)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcTouchSlopeLeft(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->flag & 32)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcTouchTile(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->flag & 0xFF)
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_NpcTouchPlayer(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	if (npc->direct == 0)
	{
		if (gMC.x + (2 * 0x200) > npc->x - npc->hit.front
			&& gMC.x - (2 * 0x200) < npc->x + npc->hit.back
			&& gMC.y + (2 * 0x200) > npc->y - npc->hit.top
			&& gMC.y - (2 * 0x200) < npc->y + npc->hit.bottom)
		{
			lua_pushboolean(L, 1);
			return 1;
		}
	}
	else
	{
		if (gMC.x + (2 * 0x200) > npc->x - npc->hit.back
			&& gMC.x - (2 * 0x200) < npc->x + npc->hit.front
			&& gMC.y + (2 * 0x200) > npc->y - npc->hit.top
			&& gMC.y - (2 * 0x200) < npc->y + npc->hit.bottom)
		{
			lua_pushboolean(L, 1);
			return 1;
		}
	}

	lua_pushboolean(L, 0);
	return 1;
}

static int lua_NpcMove(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	npc->x += npc->xm;
	npc->y += npc->ym;

	return 0;
}

static int lua_NpcMove2(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");

	npc->x += npc->xm2;
	npc->y += npc->ym2;

	return 0;
}

static int lua_NpcTriggerBox(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	OTHER_RECT range;

	if (lua_isnumber(L, 2))
	{
		range.front = (int)(luaL_checknumber(L, 2) * 0x200);
		range.top = (int)(luaL_checknumber(L, 3) * 0x200);
		range.back = (int)(luaL_checknumber(L, 4) * 0x200);
		range.bottom = (int)(luaL_checknumber(L, 5) * 0x200);
	}
	else if (lua_isuserdata(L, 2)) {
		range = *(OTHER_RECT*)luaL_checkudata(L, 2, "RangeRectMeta");
	}
	else {
		luaL_error(L, "bad argument #2 to 'TriggerBox' (number or RangeRectMeta expected, got %s)", luaL_typename(L, 2));
		return 0;
	}

	if (
		npc->x - range.front < gMC.x &&
		npc->y - range.top < gMC.y &&
		npc->x + range.back > gMC.x &&
		npc->y + range.bottom > gMC.y
		)
	{
		lua_pushboolean(L, 1);
		return 1;
	}
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_ChangeNpc(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	int code_char = (int)luaL_checknumber(L, 2);

	ChangeNpChar(npc, code_char);

	return 0;
}

static int lua_SpawnNpc(lua_State* L)
{
	int code_char = (int)luaL_checknumber(L, 1);
	int x = (int)(luaL_checknumber(L, 2) * 0x200);
	int y = (int)(luaL_checknumber(L, 3) * 0x200);
	unsigned int start_index = (int)luaL_optnumber(L, 4, 0x100);

	int n = start_index;

	while (n < NPC_MAX && gNPC[n].cond)
		++n;

	if (n == NPC_MAX)
		return 0;

	NPCHAR** npc = (NPCHAR**)lua_newuserdata(L, sizeof(NPCHAR*));
	*npc = &gNPC[n];

	luaL_getmetatable(L, "NpcMeta");
	lua_setmetatable(L, -2);

	SetNpChar(code_char, x, y, 0, 0, 0, NULL, start_index);

	return 1;
}

static int lua_ActCodeNpc(lua_State* L)
{
	NPCHAR* npc = *(NPCHAR**)luaL_checkudata(L, 1, "NpcMeta");
	int code_char = (int)luaL_optnumber(L, 2, npc->code_char);

	ActNpcCode(npc, code_char);

	return 0;
}

FUNCTION_TABLE NpcFunctionTable[FUNCTION_TABLE_NPC_SIZE] =
{
	{"GetByEvent", lua_GetNpcByEvent},
	{"GetByBufferIndex", lua_GetNpcByBufferIndex},
	{"SetRect", lua_NpcSetRect},
	{"OffsetRect", lua_NpcOffsetRect},
	{"SetHitbox", lua_NpcSetHitbox},
	{"SetViewbox", lua_NpcSetViewbox},
	{"GetRect", lua_NpcGetRect},
	{"GetHitbox", lua_NpcGetHitbox},
	{"GetViewbox", lua_NpcGetViewbox},
	{"IsHit", lua_NpcIsHit},
	{"Delete", lua_NpcDelete},
	{"Kill", lua_NpcKill},
	{"KillOnNextFrame", lua_NpcKillOnNextFrame},
	{"SetBit", lua_NpcSetBit},
	{"UnsetBit", lua_NpcUnsetBit},
	{"CheckBit", lua_NpcCheckBit},
	{"TouchLeftWall", lua_NpcTouchLeftWall},
	{"TouchRightWall", lua_NpcTouchRightWall},
	{"TouchCeiling", lua_NpcTouchCeiling},
	{"TouchFloor", lua_NpcTouchFloor},
	{"TouchSlopeRight", lua_NpcTouchSlopeRight},
	{"TouchSlopeLeft", lua_NpcTouchSlopeLeft},
	{"TouchTile", lua_NpcTouchTile},
	{"TouchPlayer", lua_NpcTouchPlayer},
	{"Move", lua_NpcMove},
	{"Move2", lua_NpcMove2},
	{"TriggerBox", lua_NpcTriggerBox},
	{"Change", lua_ChangeNpc},
	{"Spawn", lua_SpawnNpc},
	{"ActCode", lua_ActCodeNpc},
};

int NpcActModScript(int char_code, int i)
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Npc");
	lua_getfield(gL, -1, "Act");
	lua_geti(gL, -1, char_code);

	if (lua_isnil(gL, -1))
	{
		char trolololo[0x10];
		sprintf(trolololo, "Act%d", char_code);
		lua_getfield(gL, -3, trolololo);

		if (lua_isnil(gL, -1))
		{
			lua_settop(gL, 0); // Clear stack
			return 1;
		}

		if (fcuking)
		{
			printf("WARNING: Defining NPC Act functions using ModCS.Npc.ActX (where X is the NPC Type ID) has been deprecated. It's recommended to define NPC Act functions in the ModCS.Npc.Act array instead.\n");
			fcuking = FALSE;
		}
	}

	NPCHAR** npc = (NPCHAR**)lua_newuserdata(gL, sizeof(NPCHAR*));
	*npc = &gNPC[i];

	luaL_getmetatable(gL, "NpcMeta");
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