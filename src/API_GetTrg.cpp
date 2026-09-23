#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_GetTrg.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(GetTrgElementHandler, GetTrgElement)

void Replacement_GetTrg(void)
{
    static int key_old;
    gKeyTrg = gKey ^ key_old;
    gKeyTrg = gKey & gKeyTrg;
    key_old = gKey;

    ExecuteGetTrgElementHandlers();
}