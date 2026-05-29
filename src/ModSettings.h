#pragma once

#include "cave_story.h"

extern bool debug_write_tables_binary;
extern bool debug_write_tables_yaml;
extern bool replace_player_damage_function;
extern bool replace_player_hud_functions;
extern bool replace_inventory_function;
extern bool replace_map_functions;
extern bool replace_escape_menu_functions;
extern bool enable_old_mouse_code;
extern bool use_mode_overhaul;
extern bool autpi_debug_mode;
extern bool skip_loadgenericdata;
extern bool disable_vanilla_npc_code;
extern bool disable_vanilla_boss_code;
extern bool disable_vanilla_caret_code;
extern bool disable_vanilla_bullet_code;
extern bool disable_vanilla_shoot_code;

void InitMod_Settings();