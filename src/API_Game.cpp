#include <Windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_Game.h"

#include "mod_loader.h"
#include "cave_story.h"

// PRE-MODE //

// Define the global list to store registered PreMode element handlers
std::vector<PreModeElementHandler> premodeElementHandlers;

// Function to register a PreMode element handler
void RegisterPreModeElement(PreModeElementHandler handler)
{
    premodeElementHandlers.push_back(handler);
}

// Function to execute all registered PreMode element handlers
void ExecutePreModeElementHandlers()
{
    for (const auto& handler : premodeElementHandlers)
    {
        handler();
    }
}

// Used for PreMode
void PreModeCode()
{
    InitTextScript2();
    ExecutePreModeElementHandlers();
}

// RELEASE //

// Define the global list to store registered PreMode element handlers
std::vector<ReleaseElementHandler> releaseElementHandlers;

// Function to register a PreMode element handler
void RegisterReleaseElement(ReleaseElementHandler handler)
{
    releaseElementHandlers.push_back(handler);
}

// Function to execute all registered PreMode element handlers
void ExecuteReleaseElementHandlers()
{
    for (const auto& handler : releaseElementHandlers)
    {
        handler();
    }
}

// Used for PreMode
void ReleaseCode()
{
    ReleaseCreditScript();
    ExecuteReleaseElementHandlers();
}