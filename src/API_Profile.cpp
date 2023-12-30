#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_Profile.h"

#include "mod_loader.h"
#include "cave_story.h"

// SAVE PROFILE //

// Define the global list to store registered Pre/Post SaveProfile element handlers
std::vector<SaveProfilePreWriteElementHandler> saveprofileprewriteElementHandlers;
std::vector<SaveProfilePostWriteElementHandler> saveprofilepostwriteElementHandlers;

// Function to register a PreWrite HUD element handler
void RegisterSaveProfilePreWriteElement(SaveProfilePreWriteElementHandler handler)
{
    saveprofileprewriteElementHandlers.push_back(handler);
}

// Function to register a PostWrite HUD element handler
void RegisterSaveProfilePostWriteElement(SaveProfilePostWriteElementHandler handler)
{
    saveprofilepostwriteElementHandlers.push_back(handler);
}

// Function to execute all registered PreWrite element handlers
void ExecuteSaveProfilePreWriteElementHandlers()
{
    for (const auto& handler : saveprofileprewriteElementHandlers)
    {
        handler();
    }
}

// Function to execute all registered PostWrite element handlers
void ExecuteSaveProfilePostWriteElementHandlers()
{
    for (const auto& handler : saveprofilepostwriteElementHandlers)
    {
        handler();
    }
}

// Used for SaveProfile
void SaveProfileCode(void* buf, size_t eleS, size_t eleC, FILE* fp)
{
    ExecuteSaveProfilePreWriteElementHandlers();
    Freeware_fwrite(buf, eleS, eleC, fp);
    ExecuteSaveProfilePostWriteElementHandlers();
}

// LOAD PROFILE //

std::vector<LoadProfilePreCloseElementHandler> loadprofileprecloseElementHandlers;
std::vector<LoadProfilePostCloseElementHandler> loadprofilepostcloseElementHandlers;

void RegisterLoadProfilePreCloseElement(LoadProfilePreCloseElementHandler handler)
{
    loadprofileprecloseElementHandlers.push_back(handler);
}

void RegisterLoadProfilePostCloseElement(LoadProfilePostCloseElementHandler handler)
{
    loadprofilepostcloseElementHandlers.push_back(handler);
}

void ExecuteLoadProfilePreCloseElementHandlers()
{
    for (const auto& handler : loadprofileprecloseElementHandlers)
    {
        handler();
    }
}

void ExecuteLoadProfilePostCloseElementHandlers()
{
    for (const auto& handler : loadprofilepostcloseElementHandlers)
    {
        handler();
    }
}

void LoadProfileCode(FILE* fp)
{
    ExecuteLoadProfilePreCloseElementHandlers();
    Freeware_fclose(fp);
    ExecuteLoadProfilePostCloseElementHandlers();
}

// INITIALIZEGAME //

std::vector<InitializeGameInitElementHandler> intializegameElementHandlers;

void RegisterInitializeGameInitElement(InitializeGameInitElementHandler handler)
{
    intializegameElementHandlers.push_back(handler);
}

void ExecuteInitializeGameInitElementHandlers()
{
    for (const auto& handler : intializegameElementHandlers)
    {
        handler();
    }
}

void InitializeGameCode()
{
    ClearArmsData();
    ExecuteInitializeGameInitElementHandlers();
}