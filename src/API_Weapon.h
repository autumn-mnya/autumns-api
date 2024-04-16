#pragma once

#include "cave_story.h"

#define MAX_BULLET_TABLE 3000
extern BULLET_TABLE gBulTblExtra[MAX_BULLET_TABLE];

void Replacement_SetBullet(int no, int x, int y, int dir);
void addNewEntryToBulTblExtra(signed char damage, signed char life, int life_count, int bbits, int enemyXL, int enemyYL, int blockXL, int blockYL, OTHER_RECT view);
void ReplacementForShootBullet();
void ReplacementForActBullet();