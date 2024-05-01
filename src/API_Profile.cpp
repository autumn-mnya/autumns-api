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
std::vector<SaveProfilePreCloseElementHandler> saveprofileprecloseElementHandlers;
std::vector<SaveProfilePostCloseElementHandler> saveprofilepostcloseElementHandlers;

void RegisterSaveProfilePreCloseElement(SaveProfilePreCloseElementHandler handler)
{
    saveprofileprecloseElementHandlers.push_back(handler);
}

void RegisterSaveProfilePostCloseElement(SaveProfilePostCloseElementHandler handler)
{
    saveprofilepostcloseElementHandlers.push_back(handler);
}

void ExecuteSaveProfilePreCloseElementHandlers()
{
    for (const auto& handler : saveprofileprecloseElementHandlers)
    {
        handler();
    }
}

void ExecuteSaveProfilePostCloseElementHandlers()
{
    for (const auto& handler : saveprofilepostcloseElementHandlers)
    {
        handler();
    }
}

// Used for SaveProfile
// 0x41D239
void SaveProfileCode(FILE* fp)
{
    ExecuteSaveProfilePreCloseElementHandlers();
    Freeware_fclose(fp);
    ExecuteSaveProfilePostCloseElementHandlers();
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