#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*PutFPSElementHandler)();

ELEMENT_HEADERS(PutFPSElementHandler, PutFPSElement)

void Replacement_PutFPS(void);