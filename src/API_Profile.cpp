#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_Profile.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(SaveProfilePreCloseElementHandler, SaveProfilePreCloseElement)
DEFINE_ELEMENT_HANDLERS(SaveProfilePostCloseElementHandler, SaveProfilePostCloseElement)
DEFINE_ELEMENT_HANDLERS(LoadProfilePreCloseElementHandler, LoadProfilePreCloseElement)
DEFINE_ELEMENT_HANDLERS(LoadProfilePostCloseElementHandler, LoadProfilePostCloseElement)
DEFINE_ELEMENT_HANDLERS(LoadProfileInitElementHandler, LoadProfileInitElement)
DEFINE_ELEMENT_HANDLERS(InitializeGameInitElementHandler, InitializeGameInitElement)

char gCustomSaveName[260];

void ProfilePath(char* p, const char* fm, const char* mp, const char* nm)
{
    sprintf(p, fm, mp, nm);
    strcpy(gCustomSaveName, nm);
}

void SaveProfileCode(FILE* fp)
{
    ExecuteSaveProfilePreCloseElementHandlers();
    Freeware_fclose(fp);
    ExecuteSaveProfilePostCloseElementHandlers();
}

void LoadProfileCode(FILE* fp)
{
    ExecuteLoadProfilePreCloseElementHandlers();
    Freeware_fclose(fp);
    ExecuteLoadProfilePostCloseElementHandlers();
}

void LoadProfileInitCode()
{
    ExecuteLoadProfileInitElementHandlers();
    ClearFade();
}

void InitializeGameCode()
{
    ClearArmsData();
    ExecuteInitializeGameInitElementHandlers();
}

char* GetCustomSaveName()
{
    return gCustomSaveName;
}