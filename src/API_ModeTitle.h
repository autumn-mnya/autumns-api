#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*TitleInitElementHandler)();
typedef void (*TitleActionElementHandler)();
typedef void (*TitleBelowCounterElementHandler)();
typedef void (*MTBelowPutFPSElementHandler)();
typedef void (*MTAbovePutFPSElementHandler)();

ELEMENT_HEADERS(TitleInitElementHandler, TitleInitElement)
ELEMENT_HEADERS(TitleActionElementHandler, TitleActionElement)
ELEMENT_HEADERS(TitleBelowCounterElementHandler, TitleBelowCounterElement)
ELEMENT_HEADERS(MTBelowPutFPSElementHandler, ModeTitleBelowPutFPSElement)
ELEMENT_HEADERS(MTAbovePutFPSElementHandler, ModeTitleAbovePutFPSElement)

void TitleInitCode();
void TitleActionCode();
void TitleBelowCounterCode(int x, int y);
void ModeTitlePutFPSCode();