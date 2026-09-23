#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

ELEMENT_HEADERS(PreModeElementHandler, PreModeElement)
ELEMENT_HEADERS(PrePreModeElementHandler, PrePreModeElement)
ELEMENT_HEADERS(ReleaseElementHandler, ReleaseElement)

void PreModeCode();
void ReleaseCode();