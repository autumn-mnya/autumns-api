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

void OpeningPutBackCode(int fx, int fy);
void OpeningFadeCode();
void OpeningTextBoxCode();
void OpeningEarlyActionCode();
void OpeningActionCode();
void OpeningInitCode();
void OpeningCaretCode(int fx, int fy);
void ModeOpeningPutFPSCode();