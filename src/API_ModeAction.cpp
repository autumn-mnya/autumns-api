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

void PutBackCode(int fx, int fy)
{
    ExecuteBelowPutBackElementHandlers();
    PutBack(fx, fy);
    ExecuteAbovePutBackElementHandlers();
}

void PlayerHUDCode()
{
    PutActiveArmsList();
    ExecutePlayerHudElementHandlers();
}

void CreditsUICode()
{
    PutStripper();
    ExecuteCreditsHudElementHandlers();
}

void FadeCode()
{
    ExecuteBelowFadeElementHandlers();
    PutFade();
    ExecuteAboveFadeElementHandlers();
}

void TextBoxCode()
{
    ExecuteBelowTextBoxElementHandlers();
    PutTextScript();
    ExecuteAboveTextBoxElementHandlers();
}

void DrawPlayerCode(int fx, int fy)
{
    ExecuteBelowPlayerElementHandlers();
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