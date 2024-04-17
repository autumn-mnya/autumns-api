#pragma once

#include <vector>

typedef void (*TextScriptSVPElementHandler)();
extern std::vector<TextScriptSVPElementHandler> textscriptsvpElementHandlers;

void Replacement_TextScript_SaveProfile_Call(const char* name);
extern "C" __declspec(dllexport) void RegisterSVPElement(TextScriptSVPElementHandler handler);
void ExecuteSVPElementHandlers();
void TextScriptSVPCode(const char* name);