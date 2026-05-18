#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "ASM_Patches.h"

#include "mod_loader.h"
#include "cave_story.h"
#include "Main.h"

#include "API_Weapon.h"

void ArmsTablePatches()
{
	WriteProcessMemory(GetCurrentProcess(), (void*)(0x41975A + 3), &autpiArmsLevelTable, 4, NULL);
	WriteProcessMemory(GetCurrentProcess(), (void*)(0x419774 + 3), &autpiArmsLevelTable, 4, NULL);

	WriteProcessMemory(GetCurrentProcess(), (void*)(0x4197DD + 3), &autpiArmsLevelTable, 4, NULL);

	WriteProcessMemory(GetCurrentProcess(), (void*)(0x419A7F + 3), &autpiArmsLevelTable, 4, NULL);

	WriteProcessMemory(GetCurrentProcess(), (void*)(0x419F9F + 3), &autpiArmsLevelTable, 4, NULL);
	WriteProcessMemory(GetCurrentProcess(), (void*)(0x419FE7 + 3), &autpiArmsLevelTable, 4, NULL);

	const void* tableAddressPlus8 = &autpiArmsLevelTable[0].exp[2];
	WriteProcessMemory(GetCurrentProcess(), (void*)(0x4198FB + 2), &tableAddressPlus8, 4, NULL);
}

// Helper function, can be reused for other on/off asm patches that would re-apply original game bytes
void ApplyAsmPatch(AsmPatch& p, bool enable)
{
    if (!p.initialized)
    {
        for (size_t i = 0; i < p.size; ++i)
        {
            p.originalBytes[i] = ModLoader_GetByte((void*)((uintptr_t)p.address + i));
        }
        p.initialized = true;
    }

    if (enable)
    {
        if (p.applied)
            return;

        for (size_t i = 0; i < p.size; ++i)
        {
            ModLoader_WriteByte((void*)((uintptr_t)p.address + i), p.patchBytes[i]);
        }

        p.applied = true;
    }
    else
    {
        if (!p.applied)
            return;

        for (size_t i = 0; i < p.size; ++i)
        {
            ModLoader_WriteByte((void*)((uintptr_t)p.address + i), p.originalBytes[i]);
        }

        p.applied = false;
    }
}