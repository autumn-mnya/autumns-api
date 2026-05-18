#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "API_MyChar.h"
#include "lua/Lua.h"

#include "mod_loader.h"
#include "cave_story.h"

int damageAmount = 0;

// 0x410541 - TRUE
// 0x41054D - FALSE
void Replacement_ModeAction_ActMyChar(BOOL b)
{
    if (!MyCharActModScript())
        ActMyChar(b);
}

// 0x410683
void Replacement_ModeAction_PutMyChar(int fx, int fy)
{
    if (!MyCharPutModScript())
        PutMyChar(fx, fy);
}

// 0x4105D7 - TRUE
// 0x4105E3 - FALSE
void Replacement_ModeAction_AnimationMyChar(BOOL b)
{
    if (!MyCharAniModScript())
        AnimationMyChar(b);
}

// 0x410838
void Replacement_ModeAction_PutMyLife(BOOL b)
{
    if (!MyCharHudLifeModScript())
        PutMyLife(b);
}

// 0x410842
void Replacement_ModeAction_PutArmsEnergy(BOOL b)
{
    if (!MyCharHudExpModScript())
        PutArmsEnergy(b);
}

// 0x41084E
void Replacement_ModeAction_PutMyAir(int x, int y)
{
    if (!MyCharHudAirModScript())
        PutMyAir(x, y);
}

// 0x410856
void Replacement_ModeAction_PutActiveArmsList()
{
    if (!MyCharHudArmsModScript())
        PutActiveArmsList();
}

void DamageMyChar_ModCS(int damage)
{
	damageAmount = damage;

    if (MyCharHitModScript())
        return;

	DamageMyChar(damage);
}