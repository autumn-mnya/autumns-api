#pragma once

#include <Windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

enum {
	MODE_OPENING = 1,
	MODE_TITLE = 2,
	MODE_ACTION = 3
};

#define FUNCTION_TABLE_GAME_SIZE 6
extern FUNCTION_TABLE GameFunctionTable[FUNCTION_TABLE_GAME_SIZE];

BOOL GameInitModScript(void);
BOOL GameActModScript(void);
BOOL GameActModScript2(void);
BOOL GameUpdateModScript(void);
BOOL GameDrawModScript(void);
BOOL GameDrawBelowFadeModScript(void);
BOOL GameDrawAboveFadeModScript(void);
BOOL GameDrawBelowTextBoxModScript(void);
BOOL GameDrawAboveTextBoxModScript(void);
BOOL GameDrawHUDModScript(void);
BOOL GameDrawBelowPlayerModScript(void);
BOOL GameDrawAbovePlayerModScript(void);