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
extern "C" __declspec(dllexport) BOOL ReloadModScript();


#define DEFINE_MODSCRIPT_CALL(func_name, lua_field_name, lua_func_name, error_msg) \
static inline BOOL func_name(void)                                               \
{                                                                  \
	lua_getglobal(gL, "ModCS");                                    \
	lua_getfield(gL, -1, lua_field_name);                                  \
	lua_getfield(gL, -1, lua_func_name);                           \
	                                                               \
	if (lua_isnil(gL, -1))                                         \
	{                                                              \
		lua_settop(gL, 0);                                         \
		return TRUE;                                               \
	}                                                              \
	                                                               \
	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)                          \
	{                                                              \
		const char* error = lua_tostring(gL, -1);                  \
		ErrorLog(error, 0);                                        \
		printf("ERROR: %s\n", error);                              \
		MessageBoxA(ghWnd, error_msg, "ModScript Error", MB_OK);   \
		return FALSE;                                              \
	}                                                              \
	                                                               \
	lua_settop(gL, 0);                                             \
	return TRUE;                                                   \
}

DEFINE_MODSCRIPT_CALL(GameInitModScript, "Game", "Init", "Couldn't execute game init function")
DEFINE_MODSCRIPT_CALL(GameActModScript, "Game", "Act", "Couldn't execute game act function")
DEFINE_MODSCRIPT_CALL(GameActModScript2, "Game", "Act2", "Couldn't execute game act2 function")
DEFINE_MODSCRIPT_CALL(GameUpdateModScript, "Game", "Update", "Couldn't execute game update function")
DEFINE_MODSCRIPT_CALL(GameDrawModScript, "Game", "Draw", "Couldn't execute game draw function")
DEFINE_MODSCRIPT_CALL(GameDrawBelowPutStage_BackModScript, "Game", "DrawBelowStageBack", "Couldn't execute game draw below stageback function")
DEFINE_MODSCRIPT_CALL(GameDrawAbovePutStage_BackModScript, "Game", "DrawAboveStageBack", "Couldn't execute game draw above stageback function")
DEFINE_MODSCRIPT_CALL(GameDrawBelowPutStage_FrontModScript, "Game", "DrawBelowStageFront", "Couldn't execute game draw below stagefront function")
DEFINE_MODSCRIPT_CALL(GameDrawAbovePutStage_FrontModScript, "Game", "DrawAboveStageFront", "Couldn't execute game draw above stagefront function")
DEFINE_MODSCRIPT_CALL(GameDrawBelowFadeModScript, "Game", "DrawBelowFade", "Couldn't execute game draw below fade function")
DEFINE_MODSCRIPT_CALL(GameDrawAboveFadeModScript, "Game", "DrawAboveFade", "Couldn't execute game draw above fade function")
DEFINE_MODSCRIPT_CALL(GameDrawBelowTextBoxModScript, "Game", "DrawBelowTextBox", "Couldn't execute game draw below textbox function")
DEFINE_MODSCRIPT_CALL(GameDrawAboveTextBoxModScript, "Game", "DrawAboveTextBox", "Couldn't execute game draw above textbox function")
DEFINE_MODSCRIPT_CALL(GameDrawHUDModScript, "Game", "DrawHUD", "Couldn't execute game draw hud function")
DEFINE_MODSCRIPT_CALL(GameDrawBelowPlayerModScript, "Game", "DrawBelowPlayer", "Couldn't execute game draw below player function")
DEFINE_MODSCRIPT_CALL(GameDrawAbovePlayerModScript, "Game", "DrawAbovePlayer", "Couldn't execute game draw above player function")
DEFINE_MODSCRIPT_CALL(ProfileSavingModScript, "Profile", "DuringSave", "Couldn't execute during save function")
DEFINE_MODSCRIPT_CALL(ProfileLoadingModScript, "Profile", "DuringLoad", "Couldn't execute during load function")
DEFINE_MODSCRIPT_CALL(StageOnTransferModScript, "Stage", "OnTransfer", "Couldn't execute stage transfer function")

// Only include the macro in one place (header or .cpp)
#define PROPER_MODSCRIPT_CALL(func_name, func_run) \
static inline void func_name(void)                 \
{                                                  \
	if (!(func_run)())                             \
		return;                                     \
}

// Use the macro to define all wrapper functions
PROPER_MODSCRIPT_CALL(InitMod_Lua, InitModScript)
PROPER_MODSCRIPT_CALL(Lua_GameInit, GameInitModScript)
PROPER_MODSCRIPT_CALL(Lua_GameAct, GameActModScript)
PROPER_MODSCRIPT_CALL(Lua_GameAct2, GameActModScript2)
PROPER_MODSCRIPT_CALL(Lua_GameDraw, GameDrawModScript)
PROPER_MODSCRIPT_CALL(Lua_GameUpdate, GameUpdateModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawBelowPutStage_Back, GameDrawBelowPutStage_BackModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawAbovePutStage_Back, GameDrawAbovePutStage_BackModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawBelowPutStage_Front, GameDrawBelowPutStage_FrontModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawAbovePutStage_Front, GameDrawAbovePutStage_FrontModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawBelowFade, GameDrawBelowFadeModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawAboveFade, GameDrawAboveFadeModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawBelowTextBox, GameDrawBelowTextBoxModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawAboveTextBox, GameDrawAboveTextBoxModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawHUD, GameDrawHUDModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawBelowPlayer, GameDrawBelowPlayerModScript)
PROPER_MODSCRIPT_CALL(Lua_GameDrawAbovePlayer, GameDrawAbovePlayerModScript)

void Lua_GameActTrg();
void Lua_FrameInit();