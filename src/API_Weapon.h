#pragma once

#include "cave_story.h"

void LoadLevelsTable();
void LoadBulletTable();
void Replacement_AddExpMyChar(int x);
BOOL ReplacementIsMaxExpMyChar(void);
void Replacement_SetBullet(int no, int x, int y, int dir);
void ActBulletCode(BULLET* bul, int code);
void Replacement_ShootBullet(void);
void ReplacementForShootBullet();
BOOL Replacement_ActBullet(void);

extern ARMS_LEVEL* autpiArmsLevelTable;
extern BULLET_TABLE* autpiBulTbl;