#pragma once

#include <vector>

typedef void (*TextScriptSVPElementHandler)();
extern std::vector<TextScriptSVPElementHandler> textscriptsvpElementHandlers;

extern "C" __declspec(dllexport) void RegisterSVPElement(TextScriptSVPElementHandler handler);
void ExecuteSVPElementHandlers();
void TextScriptSVPCode(const char* name);