#pragma once

#include <windows.h>
#include "cave_story.h"

extern int healAmount;
extern int damageAmount;

void Replacement_ModeAction_ActMyChar(BOOL b);
void Replacement_ModeAction_PutMyChar(int fx, int fy);
void Replacement_ModeAction_AnimationMyChar(BOOL b);
void Replacement_ModeAction_PutMyLife(BOOL b);
void Replacement_ModeAction_PutArmsEnergy(BOOL b);
void Replacement_ModeAction_PutMyAir(int x, int y);
void Replacement_ModeAction_PutActiveArmsList();
extern "C" __declspec(dllexport) void DamageMyChar_ModCS(int damage);
extern "C" __declspec(dllexport) void AddLifeMyChar_ModCS(int life);