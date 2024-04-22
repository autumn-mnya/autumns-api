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

	WriteProcessMemory(GetCurrentProcess(), (void*)(0x4198FB + 2), (char*)(&autpiArmsLevelTable) + 8, 4, NULL);
}