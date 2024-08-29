#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*PlayerHudElementHandler)();
typedef void (*CreditsHudElementHandler)();
typedef void (*BelowFadeElementHandler)();
typedef void (*AboveFadeElementHandler)();
typedef void (*BelowTextBoxElementHandler)();
typedef void (*AboveTextBoxElementHandler)();
typedef void (*BelowPlayerElementHandler)();
typedef void (*AbovePlayerElementHandler)();
typedef void (*EarlyActionElementHandler)();
typedef void (*ActionElementHandler)();
typedef void (*CreditsActionElementHandler)();
typedef void (*InitElementHandler)();
typedef void (*BelowPutCaretElementHandler)();
typedef void (*AbovePutCaretElementHandler)();
typedef void (*MABelowPutFPSElementHandler)();
typedef void (*MAAbovePutFPSElementHandler)();

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

void PlayerHUDCode();
void CreditsUICode();
void FadeCode();
void TextBoxCode();
void DrawPlayerCode(int fx, int fy);
void EarlyActionCode();
void ActionCode();
void CreditsActionCode();
void InitCode();
void ActionCaretCode(int fx, int fy);
void ModeActionPutFPSCode();