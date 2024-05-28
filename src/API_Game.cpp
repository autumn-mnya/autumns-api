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
std::vector<PrePreModeElementHandler> prepremodeElementHandlers; //trust me

void RegisterPreModeElement(PreModeElementHandler handler)
{
    premodeElementHandlers.push_back(handler);
}

void RegisterPrePreModeElement(PrePreModeElementHandler handler)
{
    prepremodeElementHandlers.push_back(handler);
}

void ExecutePreModeElementHandlers()
{
    for (const auto& handler : premodeElementHandlers)
    {
        handler();
    }
}

void ExecutePrePreModeElementHandlers()
{
    for (const auto& handler : prepremodeElementHandlers)
    {
        handler();
    }
}

void PreModeCode()
{
    ExecutePrePreModeElementHandlers(); // this name sucks lol but just trust me on it for now
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