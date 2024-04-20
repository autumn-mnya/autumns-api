#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_GetTrg.h"

#include "mod_loader.h"
#include "cave_story.h"

std::vector<GetTrgElementHandler> gettrgElementHandlers;

// Function to register a GetTrg element handler
void RegisterGetTrgElement(GetTrgElementHandler handler)
{
    gettrgElementHandlers.push_back(handler);
}

void ExecuteGetTrgElementHandlers()
{
    for (const auto& handler : gettrgElementHandlers)
    {
        handler();
    }
}

void Replacement_GetTrg(void)
{
    static int key_old;
    gKeyTrg = gKey ^ key_old;
    gKeyTrg = gKey & gKeyTrg;
    key_old = gKey;

    ExecuteGetTrgElementHandlers();
}