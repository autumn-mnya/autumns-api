#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_TextScript.h"

#include "mod_loader.h"
#include "cave_story.h"

// 0x424DAE

std::vector<TextScriptSVPElementHandler> textscriptsvpElementHandlers;

void RegisterSVPElement(TextScriptSVPElementHandler handler)
{
    textscriptsvpElementHandlers.push_back(handler);
}

void ExecuteSVPElementHandlers()
{
    for (const auto& handler : textscriptsvpElementHandlers)
    {
        handler();
    }
}

void TextScriptSVPCode(const char* name)
{
    SaveProfile(name);
    ExecuteSVPElementHandlers();
}