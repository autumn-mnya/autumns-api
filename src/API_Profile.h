#pragma once

#include "cave_story.h"

#include <vector>

typedef void (*SaveProfilePreWriteElementHandler)();
typedef void (*SaveProfilePostWriteElementHandler)();
typedef void (*LoadProfilePreCloseElementHandler)();
typedef void (*LoadProfilePostCloseElementHandler)();
typedef void (*InitializeGameInitElementHandler)();

extern std::vector<SaveProfilePreWriteElementHandler> saveprofileprewriteElementHandlers;
extern std::vector<SaveProfilePostWriteElementHandler> saveprofilepostwriteElementHandlers;
extern std::vector<LoadProfilePreCloseElementHandler> loadprofileprecloseElementHandlers;
extern std::vector<LoadProfilePostCloseElementHandler> loadprofilepostcloseElementHandlers;
extern std::vector<InitializeGameInitElementHandler> intializegameElementHandlers;

extern "C" __declspec(dllexport) void RegisterSaveProfilePreWriteElement(SaveProfilePreWriteElementHandler handler);
extern "C" __declspec(dllexport) void RegisterSaveProfilePostWriteElement(SaveProfilePostWriteElementHandler handler);
void ExecuteSaveProfilePreWriteElementHandlers();
void ExecuteSaveProfilePostWriteElementHandlers();
void SaveProfileCode(void* buf, size_t eleS, size_t eleC, FILE* fp);

extern "C" __declspec(dllexport) void RegisterLoadProfilePreCloseElement(LoadProfilePreCloseElementHandler handler);
extern "C" __declspec(dllexport) void RegisterLoadProfilePostCloseElement(LoadProfilePostCloseElementHandler handler);
void ExecuteLoadProfilePreCloseElementHandlers();
void ExecuteLoadProfilePostCloseElementHandlers();
void LoadProfileCode(FILE* fp);

extern "C" __declspec(dllexport) void RegisterInitializeGameInitElement(InitializeGameInitElementHandler handler);
void ExecuteInitializeGameInitElementHandlers();
void InitializeGameCode();