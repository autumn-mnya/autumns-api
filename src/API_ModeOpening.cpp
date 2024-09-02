#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_ModeOpening.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(OpeningBelowFadeElementHandler, OpeningBelowFadeElement)
DEFINE_ELEMENT_HANDLERS(OpeningAboveFadeElementHandler, OpeningAboveFadeElement)
DEFINE_ELEMENT_HANDLERS(OpeningBelowTextBoxElementHandler, OpeningBelowTextBoxElement)
DEFINE_ELEMENT_HANDLERS(OpeningAboveTextBoxElementHandler, OpeningAboveTextBoxElement)
DEFINE_ELEMENT_HANDLERS(OpeningEarlyActionElementHandler, OpeningEarlyActionElement)
DEFINE_ELEMENT_HANDLERS(OpeningActionElementHandler, OpeningActionElement)
DEFINE_ELEMENT_HANDLERS(OpeningInitElementHandler, OpeningInitElement)
DEFINE_ELEMENT_HANDLERS(OpeningBelowPutCaretElementHandler, OpeningBelowPutCaretElement)
DEFINE_ELEMENT_HANDLERS(OpeningAbovePutCaretElementHandler, OpeningAbovePutCaretElement)
DEFINE_ELEMENT_HANDLERS(MOBelowPutFPSElementHandler, ModeOpeningBelowPutFPSElement)
DEFINE_ELEMENT_HANDLERS(MOAbovePutFPSElementHandler, ModeOpeningAbovePutFPSElement)
DEFINE_ELEMENT_HANDLERS(OpeningBelowPutBackElementHandler, OpeningBelowPutBackElement)
DEFINE_ELEMENT_HANDLERS(OpeningAbovePutBackElementHandler, OpeningAbovePutBackElement)
DEFINE_ELEMENT_HANDLERS(OpeningBelowPutStage_BackElementHandler, OpeningBelowPutStage_BackElement)
DEFINE_ELEMENT_HANDLERS(OpeningAbovePutStage_BackElementHandler, OpeningAbovePutStage_BackElement)
DEFINE_ELEMENT_HANDLERS(OpeningBelowPutStage_FrontElementHandler, OpeningBelowPutStage_FrontElement)
DEFINE_ELEMENT_HANDLERS(OpeningAbovePutStage_FrontElementHandler, OpeningAbovePutStage_FrontElement)

void OpeningPutStage_BackCode(int fx, int fy)
{
    ExecuteOpeningBelowPutStage_BackElementHandlers();
    PutStage_Back(fx, fy);
    ExecuteOpeningAbovePutStage_BackElementHandlers();
}

void OpeningPutStage_FrontCode(int fx, int fy)
{
    ExecuteOpeningBelowPutStage_FrontElementHandlers();
    PutStage_Front(fx, fy);
    ExecuteOpeningAbovePutStage_FrontElementHandlers();
}

void OpeningPutBackCode(int fx, int fy)
{
    ExecuteOpeningBelowPutBackElementHandlers();
    PutBack(fx, fy);
    ExecuteOpeningAbovePutBackElementHandlers();
}

void OpeningFadeCode()
{
    ExecuteOpeningBelowFadeElementHandlers();
    PutFade();
    ExecuteOpeningAboveFadeElementHandlers();
}

void OpeningTextBoxCode()
{
    ExecuteOpeningBelowTextBoxElementHandlers();
    PutTextScript();
    ExecuteOpeningAboveTextBoxElementHandlers();
}

void OpeningEarlyActionCode()
{
    ExecuteOpeningEarlyActionElementHandlers();
    ActNpChar();
}

void OpeningActionCode()
{
    ExecuteOpeningActionElementHandlers();
    MoveFrame3();
}

void OpeningInitCode()
{
    InitBossLife();
    ExecuteOpeningInitElementHandlers();
}

void OpeningCaretCode(int fx, int fy)
{
    ExecuteOpeningBelowPutCaretElementHandlers();
    PutCaret(fx, fy);
    ExecuteOpeningAbovePutCaretElementHandlers();
}

void ModeOpeningPutFPSCode()
{
    ExecuteModeOpeningBelowPutFPSElementHandlers();
    PutFramePerSecound();
    ExecuteModeOpeningAbovePutFPSElementHandlers();
}