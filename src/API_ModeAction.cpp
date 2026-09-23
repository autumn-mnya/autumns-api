#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_ModeAction.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

#include "lua/Lua.h"

// PLAYER UI //

DEFINE_ELEMENT_HANDLERS(PlayerHudElementHandler, PlayerHudElement)
DEFINE_ELEMENT_HANDLERS(CreditsHudElementHandler, CreditsHudElement)
DEFINE_ELEMENT_HANDLERS(BelowFadeElementHandler, BelowFadeElement)
DEFINE_ELEMENT_HANDLERS(AboveFadeElementHandler, AboveFadeElement)
DEFINE_ELEMENT_HANDLERS(BelowTextBoxElementHandler, BelowTextBoxElement)
DEFINE_ELEMENT_HANDLERS(AboveTextBoxElementHandler, AboveTextBoxElement)
DEFINE_ELEMENT_HANDLERS(BelowPlayerElementHandler, BelowPlayerElement)
DEFINE_ELEMENT_HANDLERS(AbovePlayerElementHandler, AbovePlayerElement)
DEFINE_ELEMENT_HANDLERS(EarlyActionElementHandler, EarlyActionElement)
DEFINE_ELEMENT_HANDLERS(ActionElementHandler, ActionElement)
DEFINE_ELEMENT_HANDLERS(CreditsActionElementHandler, CreditsActionElement)
DEFINE_ELEMENT_HANDLERS(InitElementHandler, InitElement)
DEFINE_ELEMENT_HANDLERS(BelowPutCaretElementHandler, BelowPutCaretElement)
DEFINE_ELEMENT_HANDLERS(AbovePutCaretElementHandler, AbovePutCaretElement)
DEFINE_ELEMENT_HANDLERS(MABelowPutFPSElementHandler, ModeActionBelowPutFPSElement)
DEFINE_ELEMENT_HANDLERS(MAAbovePutFPSElementHandler, ModeActionAbovePutFPSElement)
DEFINE_ELEMENT_HANDLERS(BelowPutBackElementHandler, BelowPutBackElement)
DEFINE_ELEMENT_HANDLERS(AbovePutBackElementHandler, AbovePutBackElement)
DEFINE_ELEMENT_HANDLERS(BelowPutStage_BackElementHandler, BelowPutStage_BackElement)
DEFINE_ELEMENT_HANDLERS(AbovePutStage_BackElementHandler, AbovePutStage_BackElement)
DEFINE_ELEMENT_HANDLERS(BelowPutStage_FrontElementHandler, BelowPutStage_FrontElement)
DEFINE_ELEMENT_HANDLERS(AbovePutStage_FrontElementHandler, AbovePutStage_FrontElement)

void PutStage_BackCode(int fx, int fy)
{
    ExecuteBelowPutStage_BackElementHandlers();
    PutStage_Back(fx, fy);
    ExecuteAbovePutStage_BackElementHandlers();
}

void PutStage_FrontCode(int fx, int fy)
{
    ExecuteBelowPutStage_FrontElementHandlers();
    PutStage_Front(fx, fy);
    ExecuteAbovePutStage_FrontElementHandlers();
}

void PutBackCode(int fx, int fy)
{
    ExecuteBelowPutBackElementHandlers();
    PutBack(fx, fy);
    ExecuteAbovePutBackElementHandlers();
}

void FadeCode()
{
    ExecuteBelowFadeElementHandlers();
    PutFade();
    ExecuteAboveFadeElementHandlers();
}

void TextBoxCode()
{
    // Run player HUD code here
    if (g_GameFlags & 2)
        ExecutePlayerHudElementHandlers();

    // Run credits drawing code here
    if (g_GameFlags & 8)
        ExecuteCreditsHudElementHandlers();

    ExecuteBelowTextBoxElementHandlers();
    PutTextScript();
    ExecuteAboveTextBoxElementHandlers();
}

void DrawPlayerCode(int fx, int fy)
{
    ExecuteBelowPlayerElementHandlers();
    if (!MyCharPutModScript())
        PutMyChar(fx, fy);
    ExecuteAbovePlayerElementHandlers();
}

void EarlyActionCode()
{
    ExecuteEarlyActionElementHandlers();
    ActStar();
}

void ActionCode()
{
    ExecuteActionElementHandlers();
    MoveFrame3();
}

void CreditsActionCode()
{
    ActionStripper();
    ExecuteCreditsActionElementHandlers();
}

void InitCode()
{
    InitBossLife();
    ExecuteInitElementHandlers();
}

void ActionCaretCode(int fx, int fy)
{
    ExecuteBelowPutCaretElementHandlers();
    PutCaret(fx, fy);
    ExecuteAbovePutCaretElementHandlers();
}

void ModeActionPutFPSCode()
{
    ExecuteModeActionBelowPutFPSElementHandlers();
    PutFramePerSecound();
    ExecuteModeActionAbovePutFPSElementHandlers();
}

// 0x410725 -- Address where this function gets called normally, we replace it with our own.
int Replacement_ModeAction_CampLoop()
{
    int ret = ItemInventoryModScript();

    if (ret == -1)
        return CampLoop();

    return ret;
}

// 0x410785
int Replacement_ModeAction_MiniMapLoop()
{
    int ret = MiniMapModScript();

    if (ret == -1)
        return MiniMapLoop();

    return ret;
}