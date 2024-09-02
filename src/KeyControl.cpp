#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "mod_loader.h"
#include "cave_story.h"

#include "lua/Lua_KeyControl.h"

static int KeyDownFunction(MLHookCPURegisters* regs, void* ud) {
    unsigned int lp = *(unsigned int*)(regs->ebp + 0x10);

    KeyControlModScript(lp, true);

    return 0;
}

static int KeyUpFunction(MLHookCPURegisters* regs, void* ud) {
    unsigned int lp = *(unsigned int*)(regs->ebp + 0x10);

    KeyControlModScript(lp, false);

    return 0;
}

void InitKeyControl() {
    // Lets see if this works
    ModLoader_AddStackableHook((void*)0x413016, 6, KeyUpFunction, (void*)0);
    ModLoader_AddStackableHook((void*)0x412E5C, 6, KeyDownFunction, (void*)0);
}