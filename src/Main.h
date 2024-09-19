#pragma once

#include <Windows.h>

#include "cave_story.h"

extern int gCurrentGameMode;
extern BOOL gModeSetted;

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

// Alternate version for taking argument


// Define the macros to automate handler creation
#define DEFINE_ELEMENT_HANDLERS_ARG_1(Type, Name, Arg0Type) \
    std::vector<Type> Name##Handlers; \
    \
    void Register##Name(Type handler) \
    { \
        Name##Handlers.push_back(handler); \
    } \
    \
    void Execute##Name##Handlers(Arg0Type arg0) \
    { \
        for (const auto& handler : Name##Handlers) \
        { \
            handler(arg0); \
        } \
    }

#define ELEMENT_HEADERS_ARG_1(Type, Name, Arg0Type) \
    extern "C" __declspec(dllexport) void Register##Name(Type handler); \
    void Execute##Name##Handlers(Arg0Type arg0);
