#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*GenericDataElementHandler)();

ELEMENT_HEADERS(GenericDataElementHandler, GenericDataElement)

void GenericDataCode(int a, int b, SurfaceID c, BOOL d);