#pragma once

#include "cave_story.h"

#include <vector>

// Define the function signature for BelowFade element handlers
typedef void (*OpeningBelowFadeElementHandler)();

// Declare the global list to store registered BelowFade element handlers
extern std::vector<OpeningBelowFadeElementHandler> Opening_belowfadeElementHandlers;

// Define the function signature for AboveFade element handlers
typedef void (*OpeningAboveFadeElementHandler)();

// Declare the global list to store registered AboveFade element handlers
extern std::vector<OpeningAboveFadeElementHandler> Opening_abovefadeElementHandlers;

// Define the function signature for BelowTextBox element handlers
typedef void (*OpeningBelowTextBoxElementHandler)();

// Declare the global list to store registered BelowTextBox element handlers
extern std::vector<OpeningBelowTextBoxElementHandler> Opening_belowtextboxElementHandlers;

// Define the function signature for AboveTextBox element handlers
typedef void (*OpeningAboveTextBoxElementHandler)();

// Declare the global list to store registered AboveTextBox element handlers
extern std::vector<OpeningAboveTextBoxElementHandler> Opening_abovetextBoxElementHandlers;

// Define the function signature for Early Action element handlers
typedef void (*OpeningEarlyActionElementHandler)();

// Declare the global list to store registered Early Action element handlers
extern std::vector<OpeningEarlyActionElementHandler> Opening_earlyactionElementHandlers;

// Define the function signature for Action element handlers
typedef void (*OpeningActionElementHandler)();

// Declare the global list to store registered Action element handlers
extern std::vector<OpeningActionElementHandler> Opening_actionElementHandlers;

// Define the function signature for Init element handlers
typedef void (*OpeningInitElementHandler)();

// Declare the global list to store registered Init element handlers
extern std::vector<OpeningInitElementHandler> Opening_initElementHandlers;

extern "C" __declspec(dllexport) void RegisterOpeningBelowFadeElement(OpeningBelowFadeElementHandler handler); // Function for registering a BelowFade element
void ExecuteOpeningBelowFadeElementHandlers();
extern "C" __declspec(dllexport) void RegisterOpeningAboveFadeElement(OpeningAboveFadeElementHandler handler); // Function for registering a AboveFade element
void ExecuteOpeningAboveFadeElementHandlers();
void OpeningFadeCode();

extern "C" __declspec(dllexport) void RegisterOpeningBelowTextBoxElement(OpeningBelowTextBoxElementHandler handler); // Function for registering a BelowTextBox element
void ExecuteOpeningBelowTextBoxElementHandlers();
extern "C" __declspec(dllexport) void RegisterOpeningAboveTextBoxElement(OpeningAboveTextBoxElementHandler handler); // Function for registering a AboveTextBox element
void ExecuteOpeningAboveTextBoxElementHandlers();
void OpeningTextBoxCode();

extern "C" __declspec(dllexport) void RegisterOpeningEarlyActionElement(OpeningEarlyActionElementHandler handler); // Function for registering a Early Action Element
void ExecuteOpeningEarlyActionElementHandlers();
void OpeningEarlyActionCode();

extern "C" __declspec(dllexport) void RegisterOpeningActionElement(OpeningActionElementHandler handler); // Function for registering a Action Element
void ExecuteOpeningActionElementHandlers();
void OpeningActionCode();

extern "C" __declspec(dllexport) void RegisterOpeningInitElement(OpeningInitElementHandler handler); // Function for registering a Init Element
void ExecuteOpeningInitElementHandlers();
void OpeningInitCode();