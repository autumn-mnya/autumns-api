#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

int lua_ArmsIndex(lua_State* L);
int lua_ArmsNextIndex(lua_State* L);

#define FUNCTION_TABLE_ARMS_SIZE 23
extern FUNCTION_TABLE ArmsFunctionTable[FUNCTION_TABLE_ARMS_SIZE];

int lua_ArmsGetCurrent(lua_State* L);
int lua_ArmsGetByID(lua_State* L);
int lua_ArmsGetByInvPos(lua_State* L);
int lua_ArmsGetCurrentInvPos(lua_State* L);
int lua_ArmsSetCurrentInvPos(lua_State* L);
int lua_ArmsUseAmmo(lua_State* L);
int lua_ArmsAddAmmo(lua_State* L);
int lua_ArmsSwitchNext(lua_State* L);
int lua_ArmsSwitchPrev(lua_State* L);
int lua_ArmsSwitchFirst(lua_State* L);
int lua_ArmsAddExp(lua_State* L);
int lua_ArmsRemoveExp(lua_State* L);
int lua_ArmsCountArmsBullet(lua_State* L);
int lua_ArmsZeroExp(lua_State* L);
int lua_ArmsCurrentMax(lua_State* L);
int lua_ArmsGetExpX(lua_State* L);
int lua_ArmsSetExpX(lua_State* L);

int ShootActModScript(int chr);

int lua_ItemIndex(lua_State* L);
int lua_ItemNextIndex(lua_State* L);

#define FUNCTION_TABLE_ITEM_SIZE 8
extern FUNCTION_TABLE ItemFunctionTable[FUNCTION_TABLE_ITEM_SIZE];