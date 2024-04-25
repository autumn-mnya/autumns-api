#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_ModeOpening.h"

#include "mod_loader.h"
#include "cave_story.h"

// FADE //

// Define the global list to store registered Below/Above Fade element handlers
std::vector<OpeningBelowFadeElementHandler> Opening_belowfadeElementHandlers;
std::vector<OpeningAboveFadeElementHandler> Opening_abovefadeElementHandlers;

// Function to register a BelowFade HUD element handler
void RegisterOpeningBelowFadeElement(OpeningBelowFadeElementHandler handler)
{
    Opening_belowfadeElementHandlers.push_back(handler);
}

// Function to register a AboveFade HUD element handler
void RegisterOpeningAboveFadeElement(OpeningAboveFadeElementHandler handler)
{
    Opening_abovefadeElementHandlers.push_back(handler);
}

// Function to execute all registered BelowFade element handlers
void ExecuteOpeningBelowFadeElementHandlers()
{
    for (const auto& handler : Opening_belowfadeElementHandlers)
    {
        handler();
    }
}

// Function to execute all registered AboveFade element handlers
void ExecuteOpeningAboveFadeElementHandlers()
{
    for (const auto& handler : Opening_abovefadeElementHandlers)
    {
        handler();
    }
}

// Used for Fade UI
void OpeningFadeCode()
{
    ExecuteOpeningBelowFadeElementHandlers();
    PutFade();
    ExecuteOpeningAboveFadeElementHandlers();
}

// TEXTBOX //

// Define the global list to store registered Below/Above TextBox element handlers
std::vector<OpeningBelowTextBoxElementHandler> Opening_belowtextBoxElementHandlers;
std::vector<OpeningAboveTextBoxElementHandler> Opening_abovetextBoxElementHandlers;

// Function to register a BelowTextBox HUD element handler
void RegisterOpeningBelowTextBoxElement(OpeningBelowTextBoxElementHandler handler)
{
    Opening_belowtextBoxElementHandlers.push_back(handler);
}

// Function to register a AboveTextBox HUD element handler
void RegisterOpeningAboveTextBoxElement(OpeningAboveTextBoxElementHandler handler)
{
    Opening_abovetextBoxElementHandlers.push_back(handler);
}

// Function to execute all registered BelowTextBox element handlers
void ExecuteOpeningBelowTextBoxElementHandlers()
{
    for (const auto& handler : Opening_belowtextBoxElementHandlers)
    {
        handler();
    }
}

// Function to execute all registered AboveTextBox element handlers
void ExecuteOpeningAboveTextBoxElementHandlers()
{
    for (const auto& handler : Opening_abovetextBoxElementHandlers)
    {
        handler();
    }
}

// Used for TextBox UI
void OpeningTextBoxCode()
{
    ExecuteOpeningBelowTextBoxElementHandlers();
    PutTextScript();
    ExecuteOpeningAboveTextBoxElementHandlers();
}

// EARLY ACTION CODE //

// Define the global list to store registered Early Action element handlers
std::vector<OpeningEarlyActionElementHandler> Opening_earlyactionElementHandlers;

// Function to register a Early Action element handler
void RegisterOpeningEarlyActionElement(OpeningEarlyActionElementHandler handler)
{
    Opening_earlyactionElementHandlers.push_back(handler);
}

// Function to execute all registered Early Action element handlers
void ExecuteOpeningEarlyActionElementHandlers()
{
    for (const auto& handler : Opening_earlyactionElementHandlers)
    {
        handler();
    }
}

// Used for Early Action Code
void OpeningEarlyActionCode()
{
    ExecuteOpeningEarlyActionElementHandlers();
    ActNpChar();
}

// ACTION CODE //

// Define the global list to store registered Action element handlers
std::vector<OpeningActionElementHandler> Opening_actionElementHandlers;

// Function to register a Action element handler
void RegisterOpeningActionElement(OpeningActionElementHandler handler)
{
    Opening_actionElementHandlers.push_back(handler);
}

// Function to execute all registered Action element handlers
void ExecuteOpeningActionElementHandlers()
{
    for (const auto& handler : Opening_actionElementHandlers)
    {
        handler();
    }
}

// Used for Action Code
void OpeningActionCode()
{
    ExecuteOpeningActionElementHandlers();
    MoveFrame3();
}

// INIT CODE //

// Define the global list to store registered Init element handlers
std::vector<OpeningInitElementHandler> Opening_initElementHandlers;

// Function to register a Init element handler
void RegisterOpeningInitElement(OpeningInitElementHandler handler)
{
    Opening_initElementHandlers.push_back(handler);
}

// Function to execute all registered Init element handlers
void ExecuteOpeningInitElementHandlers()
{
    for (const auto& handler : Opening_initElementHandlers)
    {
        handler();
    }
}

// Used for Init Code
void OpeningInitCode()
{
    InitBossLife();
    ExecuteOpeningInitElementHandlers();
}

// PutCaret //

std::vector<OpeningBelowPutCaretElementHandler> Opening_belowputcaretElementHandlers;
std::vector<OpeningAbovePutCaretElementHandler> Opening_aboveputcaretElementHandlers;

void RegisterOpeningBelowPutCaretElement(OpeningBelowPutCaretElementHandler handler)
{
    Opening_belowputcaretElementHandlers.push_back(handler);
}

void RegisterOpeningAbovePutCaretElement(OpeningAbovePutCaretElementHandler handler)
{
    Opening_aboveputcaretElementHandlers.push_back(handler);
}

void ExecuteOpeningBelowPutCaretElementHandlers()
{
    for (const auto& handler : Opening_belowputcaretElementHandlers)
    {
        handler();
    }
}

void ExecuteOpeningAbovePutCaretElementHandlers()
{
    for (const auto& handler : Opening_aboveputcaretElementHandlers)
    {
        handler();
    }
}

void OpeningCaretCode(int fx, int fy)
{
    ExecuteOpeningBelowPutCaretElementHandlers();
    PutCaret(fx, fy);
    ExecuteOpeningAbovePutCaretElementHandlers();
}