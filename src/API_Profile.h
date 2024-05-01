#pragma once

#include "cave_story.h"

#include <vector>

typedef void (*SaveProfilePreCloseElementHandler)();
typedef void (*SaveProfilePostCloseElementHandler)();
typedef void (*LoadProfilePreCloseElementHandler)();
typedef void (*LoadProfilePostCloseElementHandler)();
typedef void (*InitializeGameInitElementHandler)();

extern std::vector<SaveProfilePreCloseElementHandler> saveprofileprecloseElementHandlers;
extern std::vector<SaveProfilePostCloseElementHandler> saveprofilepostcloseElementHandlers;
extern std::vector<LoadProfilePreCloseElementHandler> loadprofileprecloseElementHandlers;
extern std::vector<LoadProfilePostCloseElementHandler> loadprofilepostcloseElementHandlers;
extern std::vector<InitializeGameInitElementHandler> intializegameElementHandlers;

extern "C" __declspec(dllexport) void RegisterSaveProfilePreCloseElement(SaveProfilePreCloseElementHandler handler);
extern "C" __declspec(dllexport) void RegisterSaveProfilePostCloseElement(SaveProfilePostCloseElementHandler handler);
void ExecuteSaveProfilePreCloseElementHandlers();
void ExecuteSaveProfilePostCloseElementHandlers();
void SaveProfileCode(FILE* fp);

extern "C" __declspec(dllexport) void RegisterLoadProfilePreCloseElement(LoadProfilePreCloseElementHandler handler);
extern "C" __declspec(dllexport) void RegisterLoadProfilePostCloseElement(LoadProfilePostCloseElementHandler handler);
void ExecuteLoadProfilePreCloseElementHandlers();
void ExecuteLoadProfilePostCloseElementHandlers();
void LoadProfileCode(FILE* fp);

extern "C" __declspec(dllexport) void RegisterInitializeGameInitElement(InitializeGameInitElementHandler handler);
void ExecuteInitializeGameInitElementHandlers();
void InitializeGameCode();