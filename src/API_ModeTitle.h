#pragma once

#include "cave_story.h"

#include <vector>

// Define the function signature for Init element handlers
typedef void (*TitleInitElementHandler)();

// Declare the global list to store registered Init element handlers
extern std::vector<TitleInitElementHandler> Title_initElementHandlers;

// Define the function signature for Action element handlers
typedef void (*TitleActionElementHandler)();

// Declare the global list to store registered Action element handlers
extern std::vector<TitleActionElementHandler> Title_actionElementHandlers;

// Define the function signature for Action element handlers
typedef void (*TitleBelowCounterElementHandler)();

// Declare the global list to store registered Action element handlers
extern std::vector<TitleBelowCounterElementHandler> Title_belowcounterElementHandlers;

extern "C" __declspec(dllexport) void RegisterTitleInitElement(TitleInitElementHandler handler); // Function for registering a Init Element
void ExecuteTitleInitElementHandlers();
void TitleInitCode();

extern "C" __declspec(dllexport) void RegisterTitleActionElement(TitleActionElementHandler handler); // Function for registering a Action Element
void ExecuteTitleActionElementHandlers();
void TitleActionCode();

extern "C" __declspec(dllexport) void RegisterTitleBelowCounterElement(TitleBelowCounterElementHandler handler); // Function for registering a Action Element
void ExecuteTitleBelowCounterElementHandlers();
void TitleBelowCounterCode(int x, int y);