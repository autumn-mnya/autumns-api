#pragma once

#include "cave_story.h"

#include <vector>

// Define the function signature for Init element handlers
typedef void (*GenericDataElementHandler)();

// Declare the global list to store registered Init element handlers
extern std::vector<GenericDataElementHandler> genericdataElementHandlers;

extern "C" __declspec(dllexport) void RegisterGenericDataElement(GenericDataElementHandler handler); // Function for registering a Init Element
void ExecuteGenericDataElementHandlers();
void GenericDataCode(int a, int b, SurfaceID c, BOOL d);