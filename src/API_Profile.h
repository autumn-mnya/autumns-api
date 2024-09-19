#pragma once

#include "cave_story.h"

#include <vector>

#include "Main.h"

typedef void (*SaveProfilePreCloseElementHandler)(FILE*);
typedef void (*SaveProfilePostCloseElementHandler)();
typedef void (*LoadProfilePreCloseElementHandler)(FILE*);
typedef void (*LoadProfilePostCloseElementHandler)();
typedef void (*LoadProfileInitElementHandler)();
typedef void (*InitializeGameInitElementHandler)();

ELEMENT_HEADERS_ARG_1(SaveProfilePreCloseElementHandler, SaveProfilePreCloseElement, FILE*)
ELEMENT_HEADERS(SaveProfilePostCloseElementHandler, SaveProfilePostCloseElement)
ELEMENT_HEADERS_ARG_1(LoadProfilePreCloseElementHandler, LoadProfilePreCloseElement, FILE*)
ELEMENT_HEADERS(LoadProfilePostCloseElementHandler, LoadProfilePostCloseElement)
ELEMENT_HEADERS(LoadProfileInitElementHandler, LoadProfileInitElement)
ELEMENT_HEADERS(InitializeGameInitElementHandler, InitializeGameInitElement)

void SaveProfileCode(FILE* fp);
void LoadProfileCode(FILE* fp);
void LoadProfileInitCode();
void InitializeGameCode();