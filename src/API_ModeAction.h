#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

ELEMENT_HEADERS(PlayerHudElementHandler, PlayerHudElement)
ELEMENT_HEADERS(CreditsHudElementHandler, CreditsHudElement)
ELEMENT_HEADERS(BelowFadeElementHandler, BelowFadeElement)
ELEMENT_HEADERS(AboveFadeElementHandler, AboveFadeElement)
ELEMENT_HEADERS(BelowTextBoxElementHandler, BelowTextBoxElement)
ELEMENT_HEADERS(AboveTextBoxElementHandler, AboveTextBoxElement)
ELEMENT_HEADERS(BelowPlayerElementHandler, BelowPlayerElement)
ELEMENT_HEADERS(AbovePlayerElementHandler, AbovePlayerElement)
ELEMENT_HEADERS(EarlyActionElementHandler, EarlyActionElement)
ELEMENT_HEADERS(ActionElementHandler, ActionElement)
ELEMENT_HEADERS(CreditsActionElementHandler, CreditsActionElement)
ELEMENT_HEADERS(InitElementHandler, InitElement)
ELEMENT_HEADERS(BelowPutCaretElementHandler, BelowPutCaretElement)
ELEMENT_HEADERS(AbovePutCaretElementHandler, AbovePutCaretElement)
ELEMENT_HEADERS(MABelowPutFPSElementHandler, ModeActionBelowPutFPSElement)
ELEMENT_HEADERS(MAAbovePutFPSElementHandler, ModeActionAbovePutFPSElement)
ELEMENT_HEADERS(BelowPutBackElementHandler, BelowPutBackElement)
ELEMENT_HEADERS(AbovePutBackElementHandler, AbovePutBackElement)
ELEMENT_HEADERS(BelowPutStage_BackElementHandler, BelowPutStage_BackElement)
ELEMENT_HEADERS(AbovePutStage_BackElementHandler, AbovePutStage_BackElement)
ELEMENT_HEADERS(BelowPutStage_FrontElementHandler, BelowPutStage_FrontElement)
ELEMENT_HEADERS(AbovePutStage_FrontElementHandler, AbovePutStage_FrontElement)

void PutStage_BackCode(int fx, int fy);
void PutStage_FrontCode(int fx, int fy);
void PutBackCode(int fx, int fy);
void FadeCode();
void TextBoxCode();
void DrawPlayerCode(int fx, int fy);
void EarlyActionCode();
void ActionCode();
void CreditsActionCode();
void InitCode();
void ActionCaretCode(int fx, int fy);
void ModeActionPutFPSCode();