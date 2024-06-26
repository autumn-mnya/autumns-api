#pragma once

#include "cave_story.h"

#include <vector>

// Define the function signature for PreMode element handlers
typedef void (*PreModeElementHandler)();

// Declare the global list to store registered PreMode element handlers
extern std::vector<PreModeElementHandler> premodeElementHandlers;

typedef void (*PrePreModeElementHandler)();

extern std::vector<PrePreModeElementHandler> prepremodeElementHandlers;

// Define the function signature for Release element handlers
typedef void (*ReleaseElementHandler)();

// Declare the global list to store registered Release element handlers
extern std::vector<ReleaseElementHandler> releaseElementHandlers;

extern "C" __declspec(dllexport) void RegisterPreModeElement(PreModeElementHandler handler); // Function for registering a PreMode element
void ExecutePreModeElementHandlers();
extern "C" __declspec(dllexport) void RegisterPrePreModeElement(PrePreModeElementHandler handler); // Function for registering a PreMode element
void ExecutePrePreModeElementHandlers();
void PreModeCode();

extern "C" __declspec(dllexport) void RegisterReleaseElement(ReleaseElementHandler handler); // Function for registering a PreMode element
void ExecuteReleaseElementHandlers();
void ReleaseCode();