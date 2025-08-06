#include <Windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "Mode.h"

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include "../cave_story.h"
#include "Lua.h"
#include "Game.h"

#include "../API_Boss.h"
#include "../API_Caret.h"
#include "../API_Draw.h"
#include "../API_Game.h"
#include "../API_GetTrg.h"
#include "../API_LoadGenericData.h"
#include "../API_ModeAction.h"
#include "../API_ModeOpening.h"
#include "../API_ModeTitle.h"

int mode_fx = 0;
int mode_fy = 0;
int mode_timecounter = 0;

static int lua_Mode_CallPause(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)Call_Escape(ghWnd));
	return 1;
}

static int lua_Mode_GetFx(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)mode_fx);
	return 1;
}

static int lua_Mode_GetFy(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)mode_fy);
	return 1;
}

static int lua_Mode_LoadTimeCounter(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)LoadTimeCounter());
	return 1;
}

static int lua_Mode_GetTimeCounter(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)mode_timecounter);
	return 1;
}

static int lua_Mode_SetTimeCounter(lua_State *L)
{
	mode_timecounter = (int)luaL_checknumber(L, 1);
	return 0;
}

static int lua_Mode_GetTrg(lua_State* L)
{
	GetTrg();
	return 0;
}

static int lua_Mode_InitNpChar(lua_State* L)
{
	InitNpChar();
	return 0;
}

static int lua_Mode_InitCaret(lua_State* L)
{
	InitCaret();
	return 0;
}

static int lua_Mode_InitStar(lua_State* L)
{
	InitStar();
	return 0;
}

static int lua_Mode_InitFade(lua_State* L)
{
	InitFade();
	return 0;
}

static int lua_Mode_InitFlash(lua_State* L)
{
	InitFlash();
	return 0;
}

static int lua_Mode_InitBossLife(lua_State* L)
{
	InitBossLife();
	return 0;
}

static int lua_Mode_ExecuteOpeningInit(lua_State* L)
{
	ExecuteOpeningInitElementHandlers();
	return 0;
}

static int lua_Mode_SetFadeMask(lua_State* L)
{
	SetFadeMask();
	return 0;
}

static int lua_Mode_CutNoise(lua_State* L)
{
	CutNoise();
	return 0;
}

static int lua_Mode_ExecuteOpeningEarlyAction(lua_State* L)
{
	ExecuteOpeningEarlyActionElementHandlers();
	return 0;
}

static int lua_Mode_ActNpChar(lua_State* L)
{
	ActNpChar();
	lua_pushboolean(L, true);
	return 1;
}

static int lua_Mode_ActBossChar(lua_State* L)
{
	ActBossChar();
	return 0;
}

static int lua_Mode_ActBack(lua_State* L)
{
	ActBack();
	return 0;
}

static int lua_Mode_ResetMyCharFlag(lua_State* L)
{
	ResetMyCharFlag();
	return 0;
}

static int lua_Mode_HitMyCharMap(lua_State* L)
{
	HitMyCharMap();
	return 0;
}

static int lua_Mode_HitMyCharNpChar(lua_State* L)
{
	HitMyCharNpChar();
	return 0;
}

static int lua_Mode_HitMyCharBoss(lua_State* L)
{
	HitMyCharBoss();
	return 0;
}

static int lua_Mode_HitNpCharMap(lua_State* L)
{
	HitNpCharMap();
	return 0;
}

static int lua_Mode_HitBossMap(lua_State* L)
{
	HitBossMap();
	return 0;
}

static int lua_Mode_HitBossBullet(lua_State* L)
{
	HitBossBullet();
	return 0;
}

static int lua_Mode_ActCaret(lua_State* L)
{
	ActCaret();
	lua_pushboolean(L, true);
	return 1;
}

static int lua_Mode_ExecuteOpeningAction(lua_State* L)
{
	ExecuteOpeningActionElementHandlers();
	return 0;
}

static int lua_Mode_MoveFrame3(lua_State* L)
{
	MoveFrame3();
	return 0;
}

static int lua_Mode_ProcFade(lua_State* L)
{
	ProcFade();
	return 0;
}

static int lua_Mode_GetFramePosition(lua_State* L)
{
	GetFramePosition(&mode_fx, &mode_fy);
	return 0;
}

static int lua_Mode_ExecuteOpeningBelowPutBack(lua_State* L)
{
	ExecuteOpeningBelowPutBackElementHandlers();
	return 0;
}

static int lua_Mode_PutBack(lua_State* L)
{
	PutBack(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteOpeningAbovePutBack(lua_State* L)
{
	ExecuteOpeningAbovePutBackElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteOpeningBelowPutStage_Back(lua_State* L)
{
	ExecuteOpeningBelowPutStage_BackElementHandlers();
	return 0;
}

static int lua_Mode_PutStage_Back(lua_State* L)
{
	PutStage_Back(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteOpeningAbovePutStage_Back(lua_State* L)
{
	ExecuteOpeningAbovePutStage_BackElementHandlers();
	return 0;
}

static int lua_Mode_PutBossChar(lua_State* L)
{
	PutBossChar(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_PutNpChar(lua_State* L)
{
	PutNpChar(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_PutMapDataVector(lua_State* L)
{
	PutMapDataVector(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteOpeningBelowPutStage_Front(lua_State* L)
{
	ExecuteOpeningBelowPutStage_FrontElementHandlers();
	return 0;
}

static int lua_Mode_PutStage_Front(lua_State* L)
{
	PutStage_Front(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteOpeningAbovePutStage_Front(lua_State* L)
{
	ExecuteOpeningAbovePutStage_FrontElementHandlers();
	return 0;
}

static int lua_Mode_PutFront(lua_State* L)
{
	PutFront(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteOpeningBelowPutCaret(lua_State* L)
{
	ExecuteOpeningBelowPutCaretElementHandlers();
	return 0;
}

static int lua_Mode_PutCaret(lua_State* L)
{
	PutCaret(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteOpeningAbovePutCaret(lua_State* L)
{
	ExecuteOpeningAbovePutCaretElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteOpeningBelowFade(lua_State* L)
{
	ExecuteOpeningBelowFadeElementHandlers();
	return 0;
}

static int lua_Mode_PutFade(lua_State* L)
{
	PutFade();
	return 0;
}

static int lua_Mode_ExecuteOpeningAboveFade(lua_State* L)
{
	ExecuteOpeningAboveFadeElementHandlers();
	return 0;
}

static int lua_Mode_TextScriptProc(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)TextScriptProc());
	return 1;
}

static int lua_Mode_PutMapName(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	PutMapName(should);
	return 0;
}

static int lua_Mode_ExecuteOpeningBelowTextBox(lua_State* L)
{
	ExecuteOpeningBelowTextBoxElementHandlers();
	return 0;
}

static int lua_Mode_PutTextScript(lua_State* L)
{
	PutTextScript();
	return 0;
}

static int lua_Mode_ExecuteOpeningAboveTextBox(lua_State* L)
{
	ExecuteOpeningAboveTextBoxElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteOpeningBelowPutFPS(lua_State* L)
{
	ExecuteModeOpeningBelowPutFPSElementHandlers();
	return 0;
}

static int lua_Mode_PutFPS(lua_State* L)
{
	PutFramePerSecound();
	return 0;
}

static int lua_Mode_ExecuteOpeningAbovePutFPS(lua_State* L)
{
	ExecuteModeOpeningAbovePutFPSElementHandlers();
	return 0;
}

static int lua_Mode_FlipSystemTask(lua_State* L)
{
	if (Flip_SystemTask(ghWnd))
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}


static int lua_Mode_GetgCounter(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)gCounter);
	return 1;
}

static int lua_Mode_SetgCounter(lua_State* L)
{
	gCounter = (int)luaL_checknumber(L, 1);
	return 0;
}

static int lua_Mode_IncrementgCounter(lua_State* L)
{
	++gCounter;
	return 0;
}

static int lua_Mode_Backend_GetTicks(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)GetTickCount());
	return 1;
}

static int lua_Mode_ExecuteTitleInit(lua_State* L)
{
	ExecuteTitleInitElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteTitleAction(lua_State* L)
{
	ExecuteTitleActionElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteTitleBelowCounter(lua_State* L)
{
	ExecuteTitleBelowCounterElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteTitleBelowPutFPS(lua_State* L)
{
	ExecuteModeTitleBelowPutFPSElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteTitleAbovePutFPS(lua_State* L)
{
	ExecuteModeTitleAbovePutFPSElementHandlers();
	return 0;
}

static int lua_Mode_PutTimeCounter(lua_State *L)
{
	int x = (int)luaL_checknumber(L, 1);
	int y = (int)luaL_checknumber(L, 2);
	PutTimeCounter(x, y);
	return 0;
}

static int lua_Mode_InitMyChar(lua_State* L)
{
	InitMyChar();
	return 0;
}

static int lua_Mode_InitBullet(lua_State* L)
{
	InitBullet();
	return 0;
}

static int lua_Mode_ClearArmsData(lua_State* L)
{
	ClearArmsData();
	return 0;
}

static int lua_Mode_ClearItemData(lua_State* L)
{
	ClearItemData();
	return 0;
}

static int lua_Mode_ClearPermitStage(lua_State* L)
{
	ClearPermitStage();
	return 0;
}

static int lua_Mode_StartMapping(lua_State* L)
{
	StartMapping();
	return 0;
}

static int lua_Mode_InitFlags(lua_State* L)
{
	InitFlags();
	return 0;
}

static int lua_Mode_ExecuteGameplayInit(lua_State* L)
{
	ExecuteInitElementHandlers();
	return 0;
}

static int lua_Mode_ActMyChar(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	ActMyChar(should);
	return 0;
}

static int lua_Mode_ExecuteGameplayEarlyAction(lua_State* L)
{
	ExecuteEarlyActionElementHandlers();
	return 0;
}

static int lua_Mode_ActStar(lua_State* L)
{
	ActStar();
	return 0;
}

static int lua_Mode_ActValueView(lua_State* L)
{
	ActValueView();
	return 0;
}

static int lua_Mode_HitBulletMap(lua_State* L)
{
	HitBulletMap();
	return 0;
}

static int lua_Mode_HitNpCharBullet(lua_State* L)
{
	HitNpCharBullet();
	return 0;
}

static int lua_Mode_ShootBullet(lua_State* L)
{
	ShootBullet();
	lua_pushboolean(L, true);
	return 1;
}

static int lua_Mode_ActBullet(lua_State* L)
{
	ActBullet();
	lua_pushboolean(L, true);
	return 1;
}

static int lua_Mode_ExecuteGameplayAction(lua_State* L)
{
	ExecuteActionElementHandlers();
	return 0;
}

static int lua_Mode_ActFlash(lua_State* L)
{
	ActFlash(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_AnimationMyChar(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	AnimationMyChar(should);
	return 0;
}

static int lua_Mode_ActionCredit(lua_State* L)
{
	ActionCredit();
	return 0;
}

static int lua_Mode_ActionIllust(lua_State* L)
{
	ActionIllust();
	return 0;
}

static int lua_Mode_ActionStripper(lua_State* L)
{
	ActionStripper();
	return 0;
}

static int lua_Mode_ExecuteCreditsAction(lua_State* L)
{
	ExecuteCreditsActionElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayBelowPutBack(lua_State* L)
{
	ExecuteBelowPutBackElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayAbovePutBack(lua_State* L)
{
	ExecuteAbovePutBackElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayBelowPutStage_Back(lua_State* L)
{
	ExecuteBelowPutStage_BackElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayAbovePutStage_Back(lua_State* L)
{
	ExecuteAbovePutStage_BackElementHandlers();
	return 0;
}

static int lua_Mode_PutBullet(lua_State* L)
{
	PutBullet(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteGameplayBelowPlayer(lua_State* L)
{
	ExecuteBelowPlayerElementHandlers();
	return 0;
}

static int lua_Mode_PutMyChar(lua_State* L)
{
	PutMyChar(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteGameplayAbovePlayer(lua_State* L)
{
	ExecuteAbovePlayerElementHandlers();
	return 0;
}

static int lua_Mode_PutStar(lua_State* L)
{
	PutStar(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_ExecuteGameplayBelowPutStage_Front(lua_State* L)
{
	ExecuteBelowPutStage_FrontElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayAbovePutStage_Front(lua_State* L)
{
	ExecuteAbovePutStage_FrontElementHandlers();
	return 0;
}

static int lua_Mode_PutFlash(lua_State* L)
{
	PutFlash();
	return 0;
}

static int lua_Mode_ExecuteGameplayBelowPutCaret(lua_State* L)
{
	ExecuteBelowPutCaretElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayAbovePutCaret(lua_State* L)
{
	ExecuteAbovePutCaretElementHandlers();
	return 0;
}

static int lua_Mode_PutValueView(lua_State* L)
{
	PutValueView(mode_fx, mode_fy);
	return 0;
}

static int lua_Mode_PutBossLife(lua_State* L)
{
	PutBossLife();
	return 0;
}

static int lua_Mode_ExecuteGameplayBelowFade(lua_State* L)
{
	ExecuteBelowFadeElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayAboveFade(lua_State* L)
{
	ExecuteAboveFadeElementHandlers();
	return 0;
}

static int lua_Mode_CampLoop(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)CampLoop());
	return 1;
}

static int lua_Mode_MiniMapLoop(lua_State *L)
{
	lua_pushnumber(L, (lua_Number)MiniMapLoop());
	return 1;
}

static int lua_Mode_PutMylife(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	PutMyLife(should);
	return 0;
}

static int lua_Mode_PutArmsEnergy(lua_State* L)
{
	int should = 0;
	bool check = lua_toboolean(L, 1);

	if (check)
		should = 1;

	PutArmsEnergy(should);
	return 0;
}

static int lua_Mode_PutActiveArmsList(lua_State* L)
{
	PutActiveArmsList();
	return 0;
}

static int lua_Mode_PutIllust(lua_State* L)
{
	PutIllust();
	return 0;
}

static int lua_Mode_PutStripper(lua_State* L)
{
	PutStripper();
	return 0;
}

static int lua_Mode_PutMyAir(lua_State* L)
{
	int x = (int)luaL_optnumber(L, 1, (WINDOW_WIDTH / 2) - 40);
	int y = (int)luaL_optnumber(L, 2, (WINDOW_HEIGHT / 2) - 16);
	PutMyAir(x, y);
	return 0;
}

static int lua_Mode_ExecuteGameplayPlayerHud(lua_State* L)
{
	ExecutePlayerHudElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayCreditsHud(lua_State* L)
{
	ExecuteCreditsHudElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayBelowTextBox(lua_State* L)
{
	ExecuteBelowTextBoxElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayAboveTextBox(lua_State* L)
{
	ExecuteAboveTextBoxElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayBelowPutFPS(lua_State* L)
{
	ExecuteModeActionBelowPutFPSElementHandlers();
	return 0;
}

static int lua_Mode_ExecuteGameplayAbovePutFPS(lua_State* L)
{
	ExecuteModeActionAbovePutFPSElementHandlers();
	return 0;
}

static int lua_Mode_ResetGameRect(lua_State* L)
{
	grcGame.left = 0;
	return 0;
}

static int lua_Mode_GameInitLua(lua_State* L)
{
	lua_pushboolean(L, GameInitModScript());
	return 1;
}

static int lua_Mode_GameActLua(lua_State* L)
{
	lua_pushboolean(L, GameActModScript());
	return 1;
}

static int lua_Mode_GameUpdateLua(lua_State* L)
{
	lua_pushboolean(L, GameUpdateModScript());
	return 1;
}

static int lua_Mode_GameDrawLua(lua_State* L)
{
	lua_pushboolean(L, GameDrawModScript());
	return 1;
}


FUNCTION_TABLE ModeFunctionTable[FUNCTION_TABLE_MODE_SIZE] =
{
	{"CallPause", lua_Mode_CallPause},
	{"GetTrg", lua_Mode_GetTrg},

	{"GetFx", lua_Mode_GetFx},
	{"GetFy", lua_Mode_GetFy},
	{"LoadTimeCounter", lua_Mode_LoadTimeCounter},
	{"GetTimeCounter", lua_Mode_GetTimeCounter},
	{"SetTimeCounter", lua_Mode_SetTimeCounter},
	{"InitNpChar", lua_Mode_InitNpChar},
	{"InitCaret", lua_Mode_InitCaret},
	{"InitStar", lua_Mode_InitStar},
	{"InitFade", lua_Mode_InitFade},
	{"InitFlash", lua_Mode_InitFlash},
	{"InitBossLife", lua_Mode_InitBossLife},

	{"ExecuteOpeningInit", lua_Mode_ExecuteOpeningInit},
	{"SetFadeMask", lua_Mode_SetFadeMask},
	{"CutNoise", lua_Mode_CutNoise},
	{"ExecuteOpeningEarlyAction", lua_Mode_ExecuteOpeningEarlyAction},
	{"ActNpChar", lua_Mode_ActNpChar},
	{"ActBossChar", lua_Mode_ActBossChar},
	{"ActBack", lua_Mode_ActBack},
	{"ResetMyCharFlag", lua_Mode_ResetMyCharFlag},
	{"HitMyCharMap", lua_Mode_HitMyCharMap},
	{"HitMyCharNpChar", lua_Mode_HitMyCharNpChar},

	{"HitMyCharBoss", lua_Mode_HitMyCharBoss},
	{"HitNpCharMap", lua_Mode_HitNpCharMap},
	{"HitBossMap", lua_Mode_HitBossMap},
	{"HitBossBullet", lua_Mode_HitBossBullet},
	{"ActCaret", lua_Mode_ActCaret},
	{"ExecuteOpeningAction", lua_Mode_ExecuteOpeningAction},
	{"MoveFrame3", lua_Mode_MoveFrame3},
	{"ProcFade", lua_Mode_ProcFade},
	{"GetFramePosition", lua_Mode_GetFramePosition},
	{"ExecuteOpeningBelowPutBack", lua_Mode_ExecuteOpeningBelowPutBack},

	{"PutBack", lua_Mode_PutBack},
	{"ExecuteOpeningAbovePutBack", lua_Mode_ExecuteOpeningAbovePutBack},
	{"ExecuteOpeningBelowPutStage_Back", lua_Mode_ExecuteOpeningBelowPutStage_Back},
	{"PutStage_Back", lua_Mode_PutStage_Back},
	{"ExecuteOpeningAbovePutStage_Back", lua_Mode_ExecuteOpeningAbovePutStage_Back},
	{"PutBossChar", lua_Mode_PutBossChar},
	{"PutNpChar", lua_Mode_PutNpChar},
	{"PutMapDataVector", lua_Mode_PutMapDataVector},
	{"ExecuteOpeningBelowPutStage_Front", lua_Mode_ExecuteOpeningBelowPutStage_Front},
	{"PutStage_Front", lua_Mode_PutStage_Front},

	{"ExecuteOpeningAbovePutStage_Front", lua_Mode_ExecuteOpeningAbovePutStage_Front},
	{"PutFront", lua_Mode_PutFront},
	{"ExecuteOpeningBelowPutCaret", lua_Mode_ExecuteOpeningBelowPutCaret},
	{"PutCaret", lua_Mode_PutCaret},
	{"ExecuteOpeningAbovePutCaret", lua_Mode_ExecuteOpeningAbovePutCaret},
	{"ExecuteOpeningBelowFade", lua_Mode_ExecuteOpeningBelowFade},
	{"PutFade", lua_Mode_PutFade},
	{"ExecuteOpeningAboveFade", lua_Mode_ExecuteOpeningAboveFade},
	{"TextScriptProc", lua_Mode_TextScriptProc},

	{"PutMapName", lua_Mode_PutMapName},
	{"ExecuteOpeningBelowTextBox", lua_Mode_ExecuteOpeningBelowTextBox},
	{"PutTextScript", lua_Mode_PutTextScript},
	{"ExecuteOpeningAboveTextBox", lua_Mode_ExecuteOpeningAboveTextBox},
	{"ExecuteOpeningBelowPutFPS", lua_Mode_ExecuteOpeningBelowPutFPS},
	{"PutFPS", lua_Mode_PutFPS},
	{"ExecuteOpeningAbovePutFPS", lua_Mode_ExecuteOpeningAbovePutFPS},
	{"FlipSystemTask", lua_Mode_FlipSystemTask},
	{"GetgCounter", lua_Mode_GetgCounter},
	{"SetgCounter", lua_Mode_SetgCounter},
	{"IncrementgCounter", lua_Mode_IncrementgCounter},
	{"Backend_GetTicks", lua_Mode_Backend_GetTicks},

	{"ExecuteTitleInit", lua_Mode_ExecuteTitleInit},
	{"ExecuteTitleAction", lua_Mode_ExecuteTitleAction},
	{"ExecuteTitleBelowCounter", lua_Mode_ExecuteTitleBelowCounter},
	{"ExecuteTitleBelowPutFPS", lua_Mode_ExecuteTitleBelowPutFPS},
	{"ExecuteTitleAbovePutFPS", lua_Mode_ExecuteTitleAbovePutFPS},
	{"PutTimeCounter", lua_Mode_PutTimeCounter},
	{"InitMyChar", lua_Mode_InitMyChar},
	{"InitBullet", lua_Mode_InitBullet},
	{"ClearArmsData", lua_Mode_ClearArmsData},
	{"ClearItemData", lua_Mode_ClearItemData},
	{"ClearPermitStage", lua_Mode_ClearPermitStage},
	{"StartMapping", lua_Mode_StartMapping},

	{"InitFlags", lua_Mode_InitFlags},
	{"ExecuteGameplayInit", lua_Mode_ExecuteGameplayInit},
	{"ActMyChar", lua_Mode_ActMyChar},
	{"ExecuteGameplayEarlyAction", lua_Mode_ExecuteGameplayEarlyAction},
	{"ActStar", lua_Mode_ActStar},
	{"ActValueView", lua_Mode_ActValueView},
	{"HitBulletMap", lua_Mode_HitBulletMap},
	{"HitNpCharBullet", lua_Mode_HitNpCharBullet},
	{"ShootBullet", lua_Mode_ShootBullet},
	{"ActBullet", lua_Mode_ActBullet},

	{"ExecuteGameplayAction", lua_Mode_ExecuteGameplayAction},
	{"ActFlash", lua_Mode_ActFlash},
	{"AnimationMyChar", lua_Mode_AnimationMyChar},
	{"ActionCredit", lua_Mode_ActionCredit},
	{"ActionIllust", lua_Mode_ActionIllust},
	{"ActionStripper", lua_Mode_ActionStripper},
	{"ExecuteCreditsAction", lua_Mode_ExecuteCreditsAction},
	{"ExecuteGameplayBelowPutBack", lua_Mode_ExecuteGameplayBelowPutBack},
	{"ExecuteGameplayAbovePutBack", lua_Mode_ExecuteGameplayAbovePutBack},
	{"ExecuteGameplayBelowPutStage_Back", lua_Mode_ExecuteGameplayBelowPutStage_Back},

	{"ExecuteGameplayAbovePutStage_Back", lua_Mode_ExecuteGameplayAbovePutStage_Back},
	{"PutBullet", lua_Mode_PutBullet},
	{"ExecuteGameplayBelowPlayer", lua_Mode_ExecuteGameplayBelowPlayer},
	{"PutMyChar", lua_Mode_PutMyChar},
	{"ExecuteGameplayAbovePlayer", lua_Mode_ExecuteGameplayAbovePlayer},
	{"PutStar", lua_Mode_PutStar},
	{"ExecuteGameplayBelowPutStage_Front", lua_Mode_ExecuteGameplayBelowPutStage_Front},
	{"ExecuteGameplayAbovePutStage_Front", lua_Mode_ExecuteGameplayAbovePutStage_Front},
	{"PutFlash", lua_Mode_PutFlash},
	{"ExecuteGameplayBelowPutCaret", lua_Mode_ExecuteGameplayBelowPutCaret},

	{"ExecuteGameplayAbovePutCaret", lua_Mode_ExecuteGameplayAbovePutCaret},
	{"PutValueView", lua_Mode_PutValueView},
	{"PutBossLife", lua_Mode_PutBossLife},
	{"ExecuteGameplayBelowFade", lua_Mode_ExecuteGameplayBelowFade},
	{"ExecuteGameplayAboveFade", lua_Mode_ExecuteGameplayAboveFade},
	{"CampLoop", lua_Mode_CampLoop},
	{"MiniMapLoop", lua_Mode_MiniMapLoop},
	{"PutMyLife", lua_Mode_PutMylife},
	{"PutArmsEnergy", lua_Mode_PutArmsEnergy},

	{"PutActiveArmsList", lua_Mode_PutActiveArmsList},
	{"PutIllust", lua_Mode_PutIllust},
	{"PutStripper", lua_Mode_PutStripper},
	{"PutMyAir", lua_Mode_PutMyAir},
	{"ExecuteGameplayPlayerHud", lua_Mode_ExecuteGameplayPlayerHud},
	{"ExecuteGameplayCreditsHud", lua_Mode_ExecuteGameplayCreditsHud},
	{"ExecuteGameplayBelowTextBox", lua_Mode_ExecuteGameplayBelowTextBox},
	{"ExecuteGameplayAboveTextBox", lua_Mode_ExecuteGameplayAboveTextBox},
	{"ExecuteGameplayBelowPutFPS", lua_Mode_ExecuteGameplayBelowPutFPS},
	{"ExecuteGameplayAbovePutFPS", lua_Mode_ExecuteGameplayAbovePutFPS},

	{"ResetGameRect", lua_Mode_ResetGameRect},

	// Lua functions to run lua code.. inside of your lua modes . its getting weird!
	{"GameInitLua", lua_Mode_GameInitLua},
	{"GameActLua", lua_Mode_GameActLua},
	{"GameUpdateLua", lua_Mode_GameUpdateLua},
	{"GameDrawLua", lua_Mode_GameDrawLua},
};

int ModeModScript(int mode_id)
{
    lua_settop(gL, 0);
    lua_getglobal(gL, "ModCS");
    if (!lua_istable(gL, -1)) return -2;

    lua_getfield(gL, -1, "Mode");
    if (!lua_istable(gL, -1)) return -2;

    lua_rawgeti(gL, -1, mode_id);
    if (lua_isnil(gL, -1))
    {
        lua_pop(gL, 1);
        // Optional legacy: try "ActX"
        char key[16];
        snprintf(key, sizeof(key), "Act%d", mode_id);
        lua_getfield(gL, -2, key);
        if (lua_isnil(gL, -1))
        {
            lua_settop(gL, 0);
            return -2; // No Lua override
        }
    }

    if (lua_pcall(gL, 0, 1, 0) != LUA_OK)
    {
        const char* err = lua_tostring(gL, -1);
        ErrorLog(err, 0);
        printf("ERROR: %s\n", err);
        lua_settop(gL, 0);
        return -1;
    }

    int ret = lua_isinteger(gL, -1) ? (int)lua_tointeger(gL, -1) : -1;
    lua_settop(gL, 0);
    return ret;
}
