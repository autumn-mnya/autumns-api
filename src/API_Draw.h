#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*DrawFrameElementHandler)();

ELEMENT_HEADERS(DrawFrameElementHandler, DrawFrameElement)

int Replacement_RestoreSurfaces(void);