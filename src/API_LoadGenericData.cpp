#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_LoadGenericData.h"

#include "mod_loader.h"
#include "cave_story.h"

// Define the global list to store registered GenericData element handlers
std::vector<GenericDataElementHandler> genericdataElementHandlers;

// Function to register a GenericData element handler
void RegisterGenericDataElement(GenericDataElementHandler handler)
{
    genericdataElementHandlers.push_back(handler);
}

// Function to execute all registered GenericData element handlers
void ExecuteGenericDataElementHandlers()
{
    for (const auto& handler : genericdataElementHandlers)
    {
        handler();
    }
}

void GenericDataCode(int a, int b, SurfaceID c, BOOL d)
{
	MakeSurface_Generic(a, b, c, d);
    printf("%d,%d,%d,%d\n", a, b, c, d);
    ExecuteGenericDataElementHandlers();
}