#pragma once

#include <windows.h>
#include <vector>

#include "cave_story.h"
#include "Main.h"

extern bool godModeEnabled;
extern bool infiniteBooster;

int LoadEquipNames(void);
int LoadArmsNames(void);
int LoadItemNames(void);
void FreeEquipNames(void);
void FreeArmsNames(void);
void FreeItemNames(void);
void ActDebug();
void PutHitboxes(int fx, int fy);
int Call_DebugMenu(void);
void ActMyCharDebugMovement();