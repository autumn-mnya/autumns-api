#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

typedef enum LuaDataType
{
	TYPE_NUMBER = 1,
	TYPE_STRING = 2,
	TYPE_OTHER_RECT = 3,
	TYPE_RECT = 4,
	TYPE_COLOR = 5,
	TYPE_SURFACE = 6,
	TYPE_NPC = 7,
	TYPE_PIXEL = 8
} LuaDataType;

typedef struct STRUCT_TABLE
{
	const char* name;
	size_t offset;
	LuaDataType type;
} STRUCT_TABLE;

typedef struct FUNCTION_TABLE
{
	const char* name;
	lua_CFunction f;
} FUNCTION_TABLE;

typedef struct METATABLE_TABLE
{
	const char* name;
	lua_CFunction index;
	lua_CFunction newindex;
} METATABLE_TABLE;

extern lua_State* gL;

void PrintStack(lua_State* L);
void SerenaAlert(lua_State* L, const char* warning);

extern "C" __declspec(dllexport) BOOL ReadStructBasic(lua_State* L, const char* name, STRUCT_TABLE* table, void* data, int length);
extern "C" __declspec(dllexport) BOOL Write2StructBasic(lua_State* L, const char* name, STRUCT_TABLE* table, void* data, int length);
extern "C" __declspec(dllexport) void PushFunctionTable(lua_State* L, const char* name, const FUNCTION_TABLE* table, int length, BOOL pop);
extern "C" __declspec(dllexport) void PushFunctionTableModName(lua_State* L, const char* modname, const char* name, const FUNCTION_TABLE* table, int length, BOOL pop);
extern "C" __declspec(dllexport) void PushSimpleMetatables(lua_State* L, const METATABLE_TABLE* table, int length);

extern long mouseKey;
extern long mouseKeyTrg;

void AutPI_GetTrg_ForInput();

BOOL InitModScript(void);
void CloseModScript(void);

void InitMod_Lua();

void Lua_GameInit();
void Lua_GameAct();
void Lua_GameActTrg();
void Lua_GameUpdate();
void Lua_GameDraw();
void Lua_GameDrawBelowFade();
void Lua_GameDrawAboveFade();
void Lua_GameDrawBelowTextBox();
void Lua_GameDrawAboveTextBox();
void Lua_GameDrawHUD();
void Lua_GameDrawBelowPlayer();
void Lua_GameDrawAbovePlayer();