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

bool debug_write_tables_binary = false;
bool debug_write_tables_yaml = false;
bool replace_player_damage_function = false;
bool use_mode_overhaul = false;
bool autpi_debug_mode = false;
bool skip_loadgenericdata = false;

void InitMod_Settings()
{
	debug_write_tables_binary = ModLoader_GetSettingBool("Write Tables on Boot (TBL)", false);
	debug_write_tables_yaml = ModLoader_GetSettingBool("Write Tables on Boot (YAML)", false);
	replace_player_damage_function = ModLoader_GetSettingBool("Replace Player Damage function", false);
	use_mode_overhaul = ModLoader_GetSettingBool("Use Mode Overhaul", false);
	autpi_debug_mode = ModLoader_GetSettingBool("Debug Mode", false);
	skip_loadgenericdata = ModLoader_GetSettingBool("Skip Asset Loading", false);
}