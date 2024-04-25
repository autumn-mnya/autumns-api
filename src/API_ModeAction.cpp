#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_ModeAction.h"

#include "mod_loader.h"
#include "cave_story.h"

// PLAYER UI //

// Define the global list to store registered Player HUD element handlers
std::vector<PlayerHudElementHandler> playerhudElementHandlers;

// Function to register a Player HUD element handler
void RegisterPlayerHudElement(PlayerHudElementHandler handler)
{
    playerhudElementHandlers.push_back(handler);
}

// Function to execute all registered Player HUD element handlers
void ExecutePlayerHudElementHandlers()
{
    for (const auto& handler : playerhudElementHandlers)
    {
        handler();
    }
}

// Used for Player UI
void PlayerHUDCode()
{
    PutActiveArmsList();
    ExecutePlayerHudElementHandlers();
}

// CREDITS UI //

// Define the global list to store registered Credits HUD element handlers
std::vector<CreditsHudElementHandler> creditshudElementHandlers;

// Function to register a Credits HUD element handler
void RegisterCreditsHudElement(CreditsHudElementHandler handler)
{
    creditshudElementHandlers.push_back(handler);
}

// Function to execute all registered Credits HUD element handlers
void ExecuteCreditsHudElementHandlers()
{
    for (const auto& handler : creditshudElementHandlers)
    {
        handler();
    }
}

// Used for Credits UI
void CreditsUICode()
{
    PutStripper();
    ExecuteCreditsHudElementHandlers();
}

// FADE //

// Define the global list to store registered Below/Above Fade element handlers
std::vector<BelowFadeElementHandler> belowfadeElementHandlers;
std::vector<AboveFadeElementHandler> abovefadeElementHandlers;

// Function to register a BelowFade HUD element handler
void RegisterBelowFadeElement(BelowFadeElementHandler handler)
{
    belowfadeElementHandlers.push_back(handler);
}

// Function to register a AboveFade HUD element handler
void RegisterAboveFadeElement(AboveFadeElementHandler handler)
{
    abovefadeElementHandlers.push_back(handler);
}

// Function to execute all registered BelowFade element handlers
void ExecuteBelowFadeElementHandlers()
{
    for (const auto& handler : belowfadeElementHandlers)
    {
        handler();
    }
}

// Function to execute all registered AboveFade element handlers
void ExecuteAboveFadeElementHandlers()
{
    for (const auto& handler : abovefadeElementHandlers)
    {
        handler();
    }
}

// Used for Fade UI
void FadeCode()
{
    ExecuteBelowFadeElementHandlers();
    PutFade();
    ExecuteAboveFadeElementHandlers();
}

// TEXTBOX //

// Define the global list to store registered Below/Above TextBox element handlers
std::vector<BelowTextBoxElementHandler> belowtextBoxElementHandlers;
std::vector<AboveTextBoxElementHandler> abovetextBoxElementHandlers;

// Function to register a BelowTextBox HUD element handler
void RegisterBelowTextBoxElement(BelowTextBoxElementHandler handler)
{
    belowtextBoxElementHandlers.push_back(handler);
}

// Function to register a AboveTextBox HUD element handler
void RegisterAboveTextBoxElement(AboveTextBoxElementHandler handler)
{
    abovetextBoxElementHandlers.push_back(handler);
}

// Function to execute all registered BelowTextBox element handlers
void ExecuteBelowTextBoxElementHandlers()
{
    for (const auto& handler : belowtextBoxElementHandlers)
    {
        handler();
    }
}

// Function to execute all registered AboveTextBox element handlers
void ExecuteAboveTextBoxElementHandlers()
{
    for (const auto& handler : abovetextBoxElementHandlers)
    {
        handler();
    }
}

// Used for TextBox UI
void TextBoxCode()
{
    ExecuteBelowTextBoxElementHandlers();
    PutTextScript();
    ExecuteAboveTextBoxElementHandlers();
}

// PLAYER DRAWING //

// Define the global list to store registered Below/Above Player element handlers
std::vector<BelowPlayerElementHandler> belowplayerElementHandlers;
std::vector<AbovePlayerElementHandler> aboveplayerElementHandlers;

// Function to register a BelowPlayer HUD element handler
void RegisterBelowPlayerElement(BelowPlayerElementHandler handler)
{
    belowplayerElementHandlers.push_back(handler);
}

// Function to register a AbovePlayer HUD element handler
void RegisterAbovePlayerElement(AbovePlayerElementHandler handler)
{
    aboveplayerElementHandlers.push_back(handler);
}

// Function to execute all registered BelowPlayer element handlers
void ExecuteBelowPlayerElementHandlers()
{
    for (const auto& handler : belowplayerElementHandlers)
    {
        handler();
    }
}

// Function to execute all registered AbovePlayer element handlers
void ExecuteAbovePlayerElementHandlers()
{
    for (const auto& handler : aboveplayerElementHandlers)
    {
        handler();
    }
}

// Used for Player
void DrawPlayerCode(int fx, int fy)
{
    ExecuteBelowPlayerElementHandlers();
    PutMyChar(fx, fy);
    ExecuteAbovePlayerElementHandlers();
}

// EARLY ACTION CODE //

// Define the global list to store registered Early Action element handlers
std::vector<EarlyActionElementHandler> earlyactionElementHandlers;

// Function to register a Early Action element handler
void RegisterEarlyActionElement(EarlyActionElementHandler handler)
{
    earlyactionElementHandlers.push_back(handler);
}

// Function to execute all registered Early Action element handlers
void ExecuteEarlyActionElementHandlers()
{
    for (const auto& handler : earlyactionElementHandlers)
    {
        handler();
    }
}

// Used for Early Action Code
void EarlyActionCode()
{
    ExecuteEarlyActionElementHandlers();
    ActStar();
}

// ACTION CODE //

// Define the global list to store registered Action element handlers
std::vector<ActionElementHandler> actionElementHandlers;

// Function to register a Action element handler
void RegisterActionElement(ActionElementHandler handler)
{
    actionElementHandlers.push_back(handler);
}

// Function to execute all registered Action element handlers
void ExecuteActionElementHandlers()
{
    for (const auto& handler : actionElementHandlers)
    {
        handler();
    }
}

// Used for Action Code
void ActionCode()
{
    ExecuteActionElementHandlers();
    MoveFrame3();
}

// CREDITS ACTION CODE //

// Define the global list to store registered Credits Action element handlers
std::vector<CreditsActionElementHandler> creditsactionElementHandlers;

// Function to register a Credits Action element handler
void RegisterCreditsActionElement(CreditsActionElementHandler handler)
{
    creditsactionElementHandlers.push_back(handler);
}

// Function to execute all registered Credits Action element handlers
void ExecuteCreditsActionElementHandlers()
{
    for (const auto& handler : creditsactionElementHandlers)
    {
        handler();
    }
}

// Used for Credits Action Code
void CreditsActionCode()
{
    ActionStripper();
    ExecuteCreditsActionElementHandlers();
}

// INIT CODE //

// Define the global list to store registered Init element handlers
std::vector<InitElementHandler> initElementHandlers;

// Function to register a Init element handler
void RegisterInitElement(InitElementHandler handler)
{
    initElementHandlers.push_back(handler);
}

// Function to execute all registered Init element handlers
void ExecuteInitElementHandlers()
{
    for (const auto& handler : initElementHandlers)
    {
        handler();
    }
}

// Used for Init Code
void InitCode()
{
    InitBossLife();
    ExecuteInitElementHandlers();
}

// PutCaret //

std::vector<BelowPutCaretElementHandler> belowputcaretElementHandlers;
std::vector<AbovePutCaretElementHandler> aboveputcaretElementHandlers;

void RegisterBelowPutCaretElement(BelowPutCaretElementHandler handler)
{
    belowputcaretElementHandlers.push_back(handler);
}

void RegisterAbovePutCaretElement(AbovePutCaretElementHandler handler)
{
    aboveputcaretElementHandlers.push_back(handler);
}

void ExecuteBelowPutCaretElementHandlers()
{
    for (const auto& handler : belowputcaretElementHandlers)
    {
        handler();
    }
}

void ExecuteAbovePutCaretElementHandlers()
{
    for (const auto& handler : aboveputcaretElementHandlers)
    {
        handler();
    }
}

void ActionCaretCode(int fx, int fy)
{
    ExecuteBelowPutCaretElementHandlers();
    PutCaret(fx, fy);
    ExecuteAbovePutCaretElementHandlers();
}