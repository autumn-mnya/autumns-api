#pragma once

#include "cave_story.h"

#include <vector>

typedef void (*PutFPSElementHandler)();
extern std::vector<PutFPSElementHandler> putfpsElementHandlers;

extern "C" __declspec(dllexport) void RegisterPutFPSElement(PutFPSElementHandler handler); // Function for registering a GetTrg element
void ExecutePutFPSElementHandlers();
void Replacement_PutFPS(void);