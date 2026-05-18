#pragma once

#include "cave_story.h"

#define MAX_BOSS_TABLE_SIZE 5000

void ActBossCode(int code_char);
void Replacement_ActBossChar();
extern "C" __declspec(dllexport) void AutPI_AddBoss(BOSSFUNCTION func, char* author, char* name);