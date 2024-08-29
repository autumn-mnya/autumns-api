#pragma once

#include <vector>

#include "Main.h"

typedef void (*TextScriptSVPElementHandler)();

ELEMENT_HEADERS(TextScriptSVPElementHandler, SVPElement)

void TextScriptSVPCode(const char* name);