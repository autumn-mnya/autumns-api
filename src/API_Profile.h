#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

ELEMENT_HEADERS(SaveProfilePreCloseElementHandler, SaveProfilePreCloseElement)
ELEMENT_HEADERS(SaveProfilePostCloseElementHandler, SaveProfilePostCloseElement)
ELEMENT_HEADERS(LoadProfilePreCloseElementHandler, LoadProfilePreCloseElement)
ELEMENT_HEADERS(LoadProfilePostCloseElementHandler, LoadProfilePostCloseElement)
ELEMENT_HEADERS(LoadProfileInitElementHandler, LoadProfileInitElement)
ELEMENT_HEADERS(InitializeGameInitElementHandler, InitializeGameInitElement)

void ProfilePath(char* p, const char* fm, const char* mp, const char* nm);
void ProfilePathLoadCustom(char* p, const char* fm, const char* nm);
void SaveProfileCode(FILE* fp);
void LoadProfileCode(FILE* fp);
void LoadProfileInitCode();
void InitializeGameCode();
extern "C" __declspec(dllexport) char* GetCustomSaveName();