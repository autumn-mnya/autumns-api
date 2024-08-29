#pragma once

#include <Windows.h>

#include "cave_story.h"

extern int gCurrentGameMode;

extern char gModulePath[MAX_PATH];
extern char gDataPath[MAX_PATH];

// Define the macros to automate handler creation
#define DEFINE_ELEMENT_HANDLERS(Type, Name) \
    std::vector<Type> Name##Handlers; \
    \
    void Register##Name(Type handler) \
    { \
        Name##Handlers.push_back(handler); \
    } \
    \
    void Execute##Name##Handlers() \
    { \
        for (const auto& handler : Name##Handlers) \
        { \
            handler(); \
        } \
    }

#define ELEMENT_HEADERS(Type, Name) \
    extern "C" __declspec(dllexport) void Register##Name(Type handler); \
    void Execute##Name##Handlers();