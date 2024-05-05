#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_ModeTitle.h"

#include "mod_loader.h"
#include "cave_story.h"

// INIT CODE //

// Define the global list to store registered Init element handlers
std::vector<TitleInitElementHandler> Title_initElementHandlers;

// Function to register a Init element handler
void RegisterTitleInitElement(TitleInitElementHandler handler)
{
    Title_initElementHandlers.push_back(handler);
}

// Function to execute all registered Init element handlers
void ExecuteTitleInitElementHandlers()
{
    for (const auto& handler : Title_initElementHandlers)
    {
        handler();
    }
}

// Used for Init Code
void TitleInitCode()
{
    InitBossLife();
    ExecuteTitleInitElementHandlers();
}

// ACTION CODE //

// Define the global list to store registered Action element handlers
std::vector<TitleActionElementHandler> Title_actionElementHandlers;

// Function to register a Action element handler
void RegisterTitleActionElement(TitleActionElementHandler handler)
{
    Title_actionElementHandlers.push_back(handler);
}

// Function to execute all registered Action element handlers
void ExecuteTitleActionElementHandlers()
{
    for (const auto& handler : Title_actionElementHandlers)
    {
        handler();
    }
}

// Used for Action Code
void TitleActionCode()
{
    ExecuteTitleActionElementHandlers();
    MoveFrame3();
}

// BELOW COUNTER CODE //

// Define the global list to store registered Below Counter element handlers
std::vector<TitleBelowCounterElementHandler> Title_belowcounterElementHandlers;

// Function to register a Below Counter element handler
void RegisterTitleBelowCounterElement(TitleBelowCounterElementHandler handler)
{
    Title_belowcounterElementHandlers.push_back(handler);
}

// Function to execute all registered Below Counter element handlers
void ExecuteTitleBelowCounterElementHandlers()
{
    for (const auto& handler : Title_belowcounterElementHandlers)
    {
        handler();
    }
}

// Used for Below Counter Code
void TitleBelowCounterCode(int x, int y)
{
    PutCaret(x, y);
    ExecuteTitleBelowCounterElementHandlers();
}

// ModeTitle PutFPS //

std::vector<MTBelowPutFPSElementHandler> MTbelowputfpsElementHandlers;
std::vector<MTAbovePutFPSElementHandler> MTaboveputfpsElementHandlers;

void RegisterModeTitleBelowPutFPSElement(MTBelowPutFPSElementHandler handler)
{
    MTbelowputfpsElementHandlers.push_back(handler);
}

void RegisterModeTitleAbovePutFPSElement(MTAbovePutFPSElementHandler handler)
{
    MTaboveputfpsElementHandlers.push_back(handler);
}

void ExecuteModeTitleBelowPutFPSElementHandlers()
{
    for (const auto& handler : MTbelowputfpsElementHandlers)
    {
        handler();
    }
}

void ExecuteModeTitleAbovePutFPSElementHandlers()
{
    for (const auto& handler : MTaboveputfpsElementHandlers)
    {
        handler();
    }
}

void ModeTitlePutFPSCode()
{
    ExecuteModeTitleBelowPutFPSElementHandlers();
    PutFramePerSecound();
    ExecuteModeTitleAbovePutFPSElementHandlers();
}