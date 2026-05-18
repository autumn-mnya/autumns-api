#pragma once

#include <windows.h>
#include "cave_story.h"

extern int arms_level_entries;
extern int bullet_table_entries;

BOOL LoadLevelsTable();
void LoadLevelsTableOld();
BOOL LoadBulletTable();
void LoadBulletTableOld();
void Replacement_AddExpMyChar(int x);
BOOL ReplacementIsMaxExpMyChar(void);
void Replacement_SetBullet(int no, int x, int y, int dir);
void ActBulletCode(BULLET* bul, int code);
void Replacement_ShootBullet(void);
void ReplacementForShootBullet();
BOOL Replacement_ActBullet(void);

extern ARMS_LEVEL* autpiArmsLevelTable;
extern BULLET_TABLE* autpiBulTbl;