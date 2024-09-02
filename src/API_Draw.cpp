#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_Draw.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(DrawFrameElementHandler, DrawFrameElement)

int Replacement_RestoreSurfaces(void)
{
    ExecuteDrawFrameElementHandlers();
    return RestoreSurfaces();
}