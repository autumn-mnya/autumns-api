#pragma once

#include <stddef.h>

#include "cave_story.h"

void ArmsTablePatches();

struct AsmPatch
{
    void* address;
    const unsigned char* patchBytes;
    unsigned char* originalBytes;
    size_t size;

    bool initialized;
    bool applied;
};

void ApplyAsmPatch(AsmPatch& p, bool enable);