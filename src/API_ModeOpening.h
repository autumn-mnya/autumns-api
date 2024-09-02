#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*OpeningBelowFadeElementHandler)();
typedef void (*OpeningAboveFadeElementHandler)();
typedef void (*OpeningBelowTextBoxElementHandler)();
typedef void (*OpeningAboveTextBoxElementHandler)();
typedef void (*OpeningEarlyActionElementHandler)();
typedef void (*OpeningActionElementHandler)();
typedef void (*OpeningInitElementHandler)();
typedef void (*OpeningBelowPutCaretElementHandler)();
typedef void (*OpeningAbovePutCaretElementHandler)();
typedef void (*OpeningBelowPutBackElementHandler)();
typedef void (*OpeningAbovePutBackElementHandler)();
typedef void (*OpeningBelowPutStage_BackElementHandler)();
typedef void (*OpeningAbovePutStage_BackElementHandler)();
typedef void (*OpeningBelowPutStage_FrontElementHandler)();
typedef void (*OpeningAbovePutStage_FrontElementHandler)();
typedef void (*MOBelowPutFPSElementHandler)();
typedef void (*MOAbovePutFPSElementHandler)();

ELEMENT_HEADERS(OpeningBelowFadeElementHandler, OpeningBelowFadeElement)
ELEMENT_HEADERS(OpeningAboveFadeElementHandler, OpeningAboveFadeElement)
ELEMENT_HEADERS(OpeningBelowTextBoxElementHandler, OpeningBelowTextBoxElement)
ELEMENT_HEADERS(OpeningAboveTextBoxElementHandler, OpeningAboveTextBoxElement)
ELEMENT_HEADERS(OpeningEarlyActionElementHandler, OpeningEarlyActionElement)
ELEMENT_HEADERS(OpeningActionElementHandler, OpeningActionElement)
ELEMENT_HEADERS(OpeningInitElementHandler, OpeningInitElement)
ELEMENT_HEADERS(OpeningBelowPutCaretElementHandler, OpeningBelowPutCaretElement)
ELEMENT_HEADERS(OpeningAbovePutCaretElementHandler, OpeningAbovePutCaretElement)
ELEMENT_HEADERS(MOBelowPutFPSElementHandler, ModeOpeningBelowPutFPSElement)
ELEMENT_HEADERS(MOAbovePutFPSElementHandler, ModeOpeningAbovePutFPSElement)
ELEMENT_HEADERS(OpeningBelowPutBackElementHandler, OpeningBelowPutBackElement)
ELEMENT_HEADERS(OpeningAbovePutBackElementHandler, OpeningAbovePutBackElement)
ELEMENT_HEADERS(OpeningBelowPutStage_BackElementHandler, OpeningBelowPutStage_BackElement)
ELEMENT_HEADERS(OpeningAbovePutStage_BackElementHandler, OpeningAbovePutStage_BackElement)
ELEMENT_HEADERS(OpeningBelowPutStage_FrontElementHandler, OpeningBelowPutStage_FrontElement)
ELEMENT_HEADERS(OpeningAbovePutStage_FrontElementHandler, OpeningAbovePutStage_FrontElement)

void OpeningPutStage_BackCode(int fx, int fy);
void OpeningPutStage_FrontCode(int fx, int fy);
void OpeningPutBackCode(int fx, int fy);
void OpeningFadeCode();
void OpeningTextBoxCode();
void OpeningEarlyActionCode();
void OpeningActionCode();
void OpeningInitCode();
void OpeningCaretCode(int fx, int fy);
void ModeOpeningPutFPSCode();