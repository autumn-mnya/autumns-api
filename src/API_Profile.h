#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*SaveProfilePreCloseElementHandler)();
typedef void (*SaveProfilePostCloseElementHandler)();
typedef void (*LoadProfilePreCloseElementHandler)();
typedef void (*LoadProfilePostCloseElementHandler)();
typedef void (*LoadProfileInitElementHandler)();
typedef void (*InitializeGameInitElementHandler)();

ELEMENT_HEADERS(SaveProfilePreCloseElementHandler, SaveProfilePreCloseElement)
ELEMENT_HEADERS(SaveProfilePostCloseElementHandler, SaveProfilePostCloseElement)
ELEMENT_HEADERS(LoadProfilePreCloseElementHandler, LoadProfilePreCloseElement)
ELEMENT_HEADERS(LoadProfilePostCloseElementHandler, LoadProfilePostCloseElement)
ELEMENT_HEADERS(LoadProfileInitElementHandler, LoadProfileInitElement)
ELEMENT_HEADERS(InitializeGameInitElementHandler, InitializeGameInitElement)

void SaveProfileCode(FILE* fp);
void LoadProfileCode(FILE* fp);
void LoadProfileInitCode();
void InitializeGameCode();