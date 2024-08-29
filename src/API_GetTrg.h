#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*GetTrgElementHandler)();

ELEMENT_HEADERS(GetTrgElementHandler, GetTrgElement)

void Replacement_GetTrg(void);