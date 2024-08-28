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

bool debug_write_tables = false;

void InitMod_Settings()
{
	debug_write_tables = ModLoader_GetSettingBool("Write Tables on Boot", false);
}