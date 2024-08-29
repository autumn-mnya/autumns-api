#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_TextScript.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(TextScriptSVPElementHandler, SVPElement)

// Replace the SaveProfile() call that gets ran when doing <SVP with this
void TextScriptSVPCode(const char* name)
{
    SaveProfile(name);
    ExecuteSVPElementHandlers();
}