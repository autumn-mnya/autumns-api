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
bool replace_player_damage_function = true;
bool replace_player_hud_functions = true;
bool replace_inventory_function = true;
bool replace_map_functions = true;
bool replace_escape_menu_functions = true;
bool enable_old_mouse_code = false;
bool use_mode_overhaul = false;
bool autpi_debug_mode = false;
bool skip_loadgenericdata = false;
bool disable_vanilla_npc_code = false;
bool disable_vanilla_boss_code = false;
bool disable_vanilla_caret_code = false;
bool disable_vanilla_bullet_code = false;
bool disable_vanilla_shoot_code = false;

void InitMod_Settings()
{
	debug_write_tables_binary = ModLoader_GetSettingBool("Write Tables on Boot (TBL)", false);
	debug_write_tables_yaml = ModLoader_GetSettingBool("Write Tables on Boot (YAML)", false);
	replace_player_damage_function = ModLoader_GetSettingBool("Replace Player Damage function", true);
	replace_player_hud_functions = ModLoader_GetSettingBool("Replace Player Hud functions", true);
	replace_inventory_function = ModLoader_GetSettingBool("Replace Inventory Menu function", true);
	replace_map_functions = ModLoader_GetSettingBool("Replace Map System Menu function", true);
	replace_escape_menu_functions = ModLoader_GetSettingBool("Replace Escape Menu function", true);
	enable_old_mouse_code = ModLoader_GetSettingBool("Enable Old ModCS Mouse Code", false);
	use_mode_overhaul = ModLoader_GetSettingBool("Use Mode Overhaul", false);
	autpi_debug_mode = ModLoader_GetSettingBool("Debug Mode", false);
	skip_loadgenericdata = ModLoader_GetSettingBool("Skip Asset Loading", false);
	disable_vanilla_npc_code = ModLoader_GetSettingBool("Disable Vanilla Npc Code", false);
	disable_vanilla_boss_code = ModLoader_GetSettingBool("Disable Vanilla Map Boss Code", false);
	disable_vanilla_caret_code = ModLoader_GetSettingBool("Disable Vanilla Caret Code", false);
	disable_vanilla_bullet_code = ModLoader_GetSettingBool("Disable Vanilla Bullet Code", false);
	disable_vanilla_shoot_code = ModLoader_GetSettingBool("Disable Vanilla Shoot Code", false);
}