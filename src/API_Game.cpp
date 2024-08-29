#include <Windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_Game.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(PreModeElementHandler, PreModeElement)
DEFINE_ELEMENT_HANDLERS(PrePreModeElementHandler, PrePreModeElement)
DEFINE_ELEMENT_HANDLERS(ReleaseElementHandler, ReleaseElement)

void PreModeCode()
{
    ExecutePrePreModeElementHandlers(); // this name sucks lol but just trust me on it for now
    InitTextScript2();
    ExecutePreModeElementHandlers();
}

// Used for PreMode
void ReleaseCode()
{
    ReleaseCreditScript();
    ExecuteReleaseElementHandlers();
}