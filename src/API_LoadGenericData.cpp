#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_LoadGenericData.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(GenericDataElementHandler, GenericDataElement)

void GenericDataCode(int a, int b, SurfaceID c, BOOL d)
{
	MakeSurface_Generic(a, b, c, d);
    ExecuteGenericDataElementHandlers();
}