#pragma once

#include "cave_story.h"

#include <vector>

// Define the function signature for GetTrg element handlers
typedef void (*GetTrgElementHandler)();

// Declare the global list to store registered GetTrg element handlers
extern std::vector<GetTrgElementHandler> gettrgElementHandlers;

extern "C" __declspec(dllexport) void RegisterGetTrgElement(GetTrgElementHandler handler); // Function for registering a GetTrg element
void ExecuteGetTrgElementHandlers();
void Replacement_GetTrg(void);