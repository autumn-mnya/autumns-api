#pragma once

#include "cave_story.h"

#include <vector>

// Define the function signature for Player HUD element handlers
typedef void (*PlayerHudElementHandler)();

// Declare the global list to store registered Player HUD element handlers
extern std::vector<PlayerHudElementHandler> playerhudElementHandlers;

// Define the function signature for Credits HUD element handlers
typedef void (*CreditsHudElementHandler)();

// Declare the global list to store registered Credits HUD element handlers
extern std::vector<CreditsHudElementHandler> creditshudElementHandlers;

// Define the function signature for BelowFade element handlers
typedef void (*BelowFadeElementHandler)();

// Declare the global list to store registered BelowFade element handlers
extern std::vector<BelowFadeElementHandler> belowfadeElementHandlers;

// Define the function signature for AboveFade element handlers
typedef void (*AboveFadeElementHandler)();

// Declare the global list to store registered AboveFade element handlers
extern std::vector<AboveFadeElementHandler> abovefadeElementHandlers;

// Define the function signature for BelowTextBox element handlers
typedef void (*BelowTextBoxElementHandler)();

// Declare the global list to store registered BelowTextBox element handlers
extern std::vector<BelowTextBoxElementHandler> belowtextboxElementHandlers;

// Define the function signature for AboveTextBox element handlers
typedef void (*AboveTextBoxElementHandler)();

// Declare the global list to store registered AboveTextBox element handlers
extern std::vector<AboveTextBoxElementHandler> abovetextboxElementHandlers;

// Define the function signature for BelowPlayer element handlers
typedef void (*BelowPlayerElementHandler)();

// Declare the global list to store registered BelowPlayer element handlers
extern std::vector<BelowPlayerElementHandler> belowplayerElementHandlers;

// Define the function signature for AbovePlayer element handlers
typedef void (*AbovePlayerElementHandler)();

// Declare the global list to store registered AbovePlayer element handlers
extern std::vector<AbovePlayerElementHandler> aboveplayerElementHandlers;

// Define the function signature for Early Action element handlers
typedef void (*EarlyActionElementHandler)();

// Declare the global list to store registered Early Action element handlers
extern std::vector<EarlyActionElementHandler> earlyactionElementHandlers;

// Define the function signature for Action element handlers
typedef void (*ActionElementHandler)();

// Declare the global list to store registered Action element handlers
extern std::vector<ActionElementHandler> actionElementHandlers;

// Define the function signature for Credits Action element handlers
typedef void (*CreditsActionElementHandler)();

// Declare the global list to store registered Credits Action element handlers
extern std::vector<CreditsActionElementHandler> creditsactionElementHandlers;

// Define the function signature for Init element handlers
typedef void (*InitElementHandler)();

// Declare the global list to store registered Init element handlers
extern std::vector<InitElementHandler> initElementHandlers;

extern "C" __declspec(dllexport) void RegisterPlayerHudElement(PlayerHudElementHandler handler); // Function for registering a hud element for the Players UI
void ExecutePlayerHudElementHandlers();
void PlayerHUDCode();

extern "C" __declspec(dllexport) void RegisterCreditsHudElement(CreditsHudElementHandler handler); // Function for registering a hud element for the Credits UI
void ExecuteCreditsHudElementHandlers();
void CreditsUICode();

extern "C" __declspec(dllexport) void RegisterBelowFadeElement(BelowFadeElementHandler handler); // Function for registering a BelowFade element
void ExecuteBelowFadeElementHandlers();
extern "C" __declspec(dllexport) void RegisterAboveFadeElement(AboveFadeElementHandler handler); // Function for registering a AboveFade element
void ExecuteAboveFadeElementHandlers();
void FadeCode();

extern "C" __declspec(dllexport) void RegisterBelowTextBoxElement(BelowTextBoxElementHandler handler); // Function for registering a BelowTextBox element
void ExecuteBelowTextBoxElementHandlers();
extern "C" __declspec(dllexport) void RegisterAboveTextBoxElement(AboveTextBoxElementHandler handler); // Function for registering a AboveTextBox element
void ExecuteAboveTextBoxElementHandlers();
void TextBoxCode();

extern "C" __declspec(dllexport) void RegisterBelowPlayerElement(BelowPlayerElementHandler handler); // Function for registering a BelowPlayer element
void ExecuteBelowPlayerElementHandlers();
extern "C" __declspec(dllexport) void RegisterAbovePlayerElement(AboveTextBoxElementHandler handler); // Function for registering a AbovePlayer element
void ExecuteAbovePlayerElementHandlers();
void DrawPlayerCode(int fx, int fy);

extern "C" __declspec(dllexport) void RegisterEarlyActionElement(EarlyActionElementHandler handler); // Function for registering a Early Action Element
void ExecuteEarlyActionElementHandlers();
void EarlyActionCode();

extern "C" __declspec(dllexport) void RegisterActionElement(ActionElementHandler handler); // Function for registering a Action Element
void ExecuteActionElementHandlers();
void ActionCode();

extern "C" __declspec(dllexport) void RegisterCreditsActionElement(CreditsActionElementHandler handler); // Function for registering a Credits Action Element
void ExecuteCreditsActionElementHandlers();
void CreditsActionCode();

extern "C" __declspec(dllexport) void RegisterInitElement(InitElementHandler handler); // Function for registering a Init Element
void ExecuteInitElementHandlers();
void InitCode();