#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "ModSettings.h"

#include "mod_loader.h"
#include "cave_story.h"

bool ignore_main_lua_error = true;
bool debug_write_tables = false;

void InitMod_Settings()
{
	ignore_main_lua_error = ModLoader_GetSettingBool("Ignore 'Missing main.lua' error", true);
	debug_write_tables = ModLoader_GetSettingBool("Write Tables on Boot", false);
}