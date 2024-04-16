#include <windows.h>
#include <shlwapi.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "mod_loader.h"
#include "cave_story.h"

#include "API_Boss.h"
#include "API_Caret.h"
#include "API_LoadGenericData.h"
#include "API_Game.h"
#include "API_ModeOpening.h"
#include "API_ModeTitle.h"
#include "API_ModeAction.h"
#include "API_NpcTbl.h"
#include "API_Profile.h"
#include "API_Tile.h"
#include "API_TransferStage.h"
#include "API_Weapon.h"

char gModulePath[MAX_PATH];
char gDataPath[MAX_PATH];

void InitMod(void)
{
    // Get executable's path
    GetModuleFileNameA(NULL, gModulePath, MAX_PATH);
    PathRemoveFileSpecA(gModulePath);

    // Get path of the data folder
    strcpy(gDataPath, gModulePath);
    strcat(gDataPath, "\\data");

    // Tile Type api (unfinished, is complicated)
    // RegisterDefaultTileTypes();
    // ModLoader_WriteJump((void*)0x417E40, (void*)Replacement_HitMyCharMap);

    // Boss API
    ModLoader_WriteJump((void*)ActBossChar, (void*)Replacement_ActBossChar);

    // Caret API
    LoadCaretTable();
    ModLoader_WriteJump((void*)ActCaret, (void*)Replacement_ActCaret);
    ModLoader_WriteJump((void*)SetCaret, (void*)Replacement_SetCaret);

    // LoadGenericData API
    ModLoader_WriteCall((void*)0x4115DA, (void*)GenericDataCode);

    // Game API
    ModLoader_WriteCall((void*)0x40F67C, (void*)PreModeCode);

    // ModeOpening API
    ModLoader_WriteCall((void*)0x40F8E9, (void*)OpeningFadeCode);
    ModLoader_WriteCall((void*)0x40F91F, (void*)OpeningTextBoxCode);
    ModLoader_WriteCall((void*)0x40F809, (void*)OpeningEarlyActionCode);
    ModLoader_WriteCall((void*)0x40F840, (void*)OpeningActionCode);
    ModLoader_WriteCall((void*)0x40F74F, (void*)OpeningInitCode);

    // ModeTitle API
    ModLoader_WriteCall((void*)0x40FD85, (void*)TitleInitCode);
    ModLoader_WriteCall((void*)0x40FFDC, (void*)TitleActionCode);
    ModLoader_WriteCall((void*)0x41034C, (void*)TitleBelowCounterCode);

    // ModeAction API
    ModLoader_WriteCall((void*)0x410856, (void*)PlayerHUDCode);
    ModLoader_WriteCall((void*)0x41086A, (void*)CreditsUICode);
    ModLoader_WriteCall((void*)0x4106F5, (void*)FadeCode);
    ModLoader_WriteCall((void*)0x41086F, (void*)TextBoxCode);
    ModLoader_WriteCall((void*)0x410683, (void*)DrawPlayerCode);
    ModLoader_WriteCall((void*)0x410555, (void*)EarlyActionCode);
    ModLoader_WriteCall((void*)0x4105B5, (void*)ActionCode);
    ModLoader_WriteCall((void*)0x410600, (void*)CreditsActionCode);
    ModLoader_WriteCall((void*)0x410477, (void*)InitCode);

    // Profile API (unfinished, need a way for the user to use the FILE* fp pointer, and i dont know how ,)

    /*
    ModLoader_WriteCall((void*)0x41D22D, (void*)SaveProfileCode);
    ModLoader_WriteCall((void*)0x41D353, (void*)LoadProfileCode);
    */

    ModLoader_WriteCall((void*)0x41D576, (void*)InitializeGameCode);

    // TransferStage API
    ModLoader_WriteCall((void*)0x420EB5, (void*)TransferStageInitCode);

    // Npc Table API
    ModLoader_WriteJump((void*)0x46FA00, (void*)Replacement_ActNpChar);
    ModLoader_WriteJump((void*)0x46FAB0, (void*)Replacement_ChangeNpCharByEvent);
    ModLoader_WriteJump((void*)0x46FD10, (void*)Replacement_ChangeCheckableNpCharByEvent);

    // Weapons API
    /*
    ModLoader_WriteJump((void*)SetBullet, (void*)Replacement_SetBullet);
    ModLoader_WriteCall((void*)0x4105AB, (void*)ReplacementForActBullet);
    ModLoader_WriteCall((void*)0x4105A6, (void*)ReplacementForShootBullet); // used for ShootBullet --> should be able to create new weapons if we can just figure out a way to run code from some form of table/vector..
    */
}