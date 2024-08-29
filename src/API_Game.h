#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*PreModeElementHandler)();
typedef void (*PrePreModeElementHandler)();
typedef void (*ReleaseElementHandler)();

ELEMENT_HEADERS(PreModeElementHandler, PreModeElement)
ELEMENT_HEADERS(PrePreModeElementHandler, PrePreModeElement)
ELEMENT_HEADERS(ReleaseElementHandler, ReleaseElement)

void PreModeCode();
void ReleaseCode();