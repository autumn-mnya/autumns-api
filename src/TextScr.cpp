#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "mod_loader.h"
#include "cave_story.h"

#include "lua/Lua_TextScr.h"

static int CustomTSC(MLHookCPURegisters* regs, void* ud)
{
	(void)ud;
	int w, x, y, z;

	char* where = TextScriptBuffer + gTS.p_read;
	if (where[0] != '<')
		return 0;

	char command[4] = { gTS.data[gTS.p_read + 1], gTS.data[gTS.p_read + 2], gTS.data[gTS.p_read + 3], '\0' };
	int result = TSCCommandModScript(command);

	if (result == 0)
	{
		char str_0[0x40];
		sprintf(str_0, "Couldn't execute function for code <%s", command);
		MessageBoxA(NULL, str_0, "ModScript Error", MB_OK);
		return enum_ESCRETURN_exit;
	}
	else if (result == 1)
	{
		if (strncmp(where + 1, "AUTPITTESTCOMMAND", 3) == 0) // just a test command
		{
			printf("%s", "Why are you even running this command lol\n");
			gTS.p_read += 4;
		}
		else
			return 0;
	}

	regs->eip = CSJ_tsc_done;
	return 1;
}

void InitTSC()
{
	ModLoader_AddStackableHook(CSH_tsc_start, CustomTSC, (void*)0);
}