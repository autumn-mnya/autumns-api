#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_ModeTitle.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(TitleInitElementHandler, TitleInitElement)
DEFINE_ELEMENT_HANDLERS(TitleActionElementHandler, TitleActionElement)
DEFINE_ELEMENT_HANDLERS(TitleBelowCounterElementHandler, TitleBelowCounterElement)
DEFINE_ELEMENT_HANDLERS(MTBelowPutFPSElementHandler, ModeTitleBelowPutFPSElement)
DEFINE_ELEMENT_HANDLERS(MTAbovePutFPSElementHandler, ModeTitleAbovePutFPSElement)

void TitleInitCode()
{
    InitBossLife();
    ExecuteTitleInitElementHandlers();
}

void TitleActionCode()
{
    ExecuteTitleActionElementHandlers();
    ActCaret();
}

void TitleBelowCounterCode(int x, int y)
{
    PutCaret(x, y);
    ExecuteTitleBelowCounterElementHandlers();
}

void ModeTitlePutFPSCode()
{
    ExecuteModeTitleBelowPutFPSElementHandlers();
    PutFramePerSecound();
    ExecuteModeTitleAbovePutFPSElementHandlers();
}