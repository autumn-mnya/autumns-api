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
#include "ModSettings.h"

#include "API_Boss.h"
#include "API_Caret.h"
#include "API_LoadGenericData.h"
#include "API_Game.h"
#include "API_GetTrg.h"
#include "API_KeyControl.h"
#include "API_ModeOpening.h"
#include "API_ModeTitle.h"
#include "API_ModeAction.h"
#include "API_Npc.h"
#include "API_Profile.h"
#include "API_PutFPS.h"
#include "API_Stage.h"
#include "API_TextScript.h"
#include "API_Weapon.h"
#include "API_Draw.h"
#include "ASM_Patches.h"

#include "lua/Lua.h"
#include "lua/Mod.h"
#include "lua/ModLoader.h"
#include "lua/Mode.h"
#include "lua/Profile.h"
#include "lua/Stage.h"

int gCurrentGameMode = 0;
BOOL gModeSetted = FALSE;

void SetModeOpening()
{
    gCurrentGameMode = 1;
}

void SetModeTitle()
{
    gCurrentGameMode = 2;
}

void SetModeAction()
{
    gCurrentGameMode = 3;
}

// Write Arms Table debug function
void SaveArmsTable()
{
    FILE* fp;
    char path[MAX_PATH];

    // Construct the file path
    sprintf(path, "%s\\%s", exeModulePath, "arms_level.tbl");

    // Open the file for writing
    fp = fopen(path, "wb");
    if (fp == NULL) {
        // Handle the error...
        return;
    }

    // Read the data to the file
    fwrite(gArmsLevelTable, sizeof(ARMS_LEVEL), 14, fp);

    // Close the file
    fclose(fp);
}

// Write Bullet Table debug function
void SaveBulletTable()
{
    FILE* fp;
    char path[MAX_PATH];
    size_t size;

    sprintf(path, "%s\\bullet.tbl", exeModulePath);

    fp = fopen(path, "wb");
    if (fp == NULL)
        return;

    for (int i = 0; i < 46; ++i)
    {
        fwrite(&gBulTbl[i].damage, 1, 1, fp);
        fwrite(&gBulTbl[i].life, 1, 1, fp);
        fwrite(&gBulTbl[i].life_count, 4, 1, fp);
        fwrite(&gBulTbl[i].bbits, 4, 1, fp);
        fwrite(&gBulTbl[i].enemyXL, 4, 1, fp);
        fwrite(&gBulTbl[i].enemyYL, 4, 1, fp);
        fwrite(&gBulTbl[i].blockXL, 4, 1, fp);
        fwrite(&gBulTbl[i].blockYL, 4, 1, fp);
        fwrite(&gBulTbl[i].view, 16, 1, fp);
    }

    fclose(fp);
    return;
}

// Write Caret Table debug function
void SaveCaretTable()
{
    FILE* fp;
    char path[MAX_PATH];

    // Construct the file path
    sprintf(path, "%s\\%s", exeModulePath, "caret.tbl");

    // Open the file for writing
    fp = fopen(path, "wb");
    if (fp == NULL) {
        // Handle the error...
        return;
    }

    // Read the data to the file
    fwrite(gCaretTable, sizeof(CARET_TABLE), 18, fp);

    // Close the file
    fclose(fp);
}

void LoadModTables()
{
    LoadLevelsTable();
    ArmsTablePatches();
    LoadBulletTable();
    LoadCaretTable();
}

static int ModeSwitchFunction(MLHookCPURegisters* regs, void* ud) {
    if (gModeSetted) {
        gModeSetted = FALSE;
        regs->eax = gCurrentGameMode; // Setting the return value
        regs->eip += 14; // At each of the places I put this hook the JMP to the return is 14 bytes ahead
        return 1;
    }
    return 0;
}

int Replacement_ModeCall(HWND hWNd)
{
    return 0;
}

int gGameMode = 1;

void Replacement_Game_PlaySound7(int sound, int mode)
{
    gGameMode = ModLoader_GetByte((void*)0x40F693);

    while (gGameMode)
    {
        int result = ModeModScript(gGameMode);

        if (result >= 0)
        {
            gGameMode = result;
        }
        else if (result == -2)
        {
            if (gGameMode == 1)
                gGameMode = ModeOpening(ghWnd);
            else if (gGameMode == 2)
                gGameMode = ModeTitle(ghWnd);
            else if (gGameMode == 3)
                gGameMode = ModeAction(ghWnd);
            else
                gGameMode = 0;
        }
        else
        {
            gGameMode = 0;
        }
    }

    PlaySoundObject(sound, mode);
}

void WriteDebugTables()
{
    SaveArmsTable();
    SaveBulletTable();
    SaveCaretTable();
}

void InitMod(void)
{
    InitMod_Settings();

    if (use_mode_overhaul == false)
    {
        ModLoader_AddStackableHook((void*)0x40F930, 8, ModeSwitchFunction, (void*)0); // intro
        ModLoader_AddStackableHook((void*)0x410375, 8, ModeSwitchFunction, (void*)0); // title
        ModLoader_AddStackableHook((void*)0x410880, 8, ModeSwitchFunction, (void*)0); // game
    }
    else
    {
        ModLoader_WriteCall((void*)0x40F6A7, Replacement_ModeCall);
        ModLoader_WriteCall((void*)0x40F6BC, Replacement_ModeCall);
        ModLoader_WriteCall((void*)0x40F6D1, Replacement_ModeCall);
        ModLoader_WriteCall((void*)0x40F6E2, Replacement_Game_PlaySound7);
    }

    // Boss API
    ModLoader_WriteJump((void*)ActBossChar, (void*)Replacement_ActBossChar);

    // Caret API
    ModLoader_WriteJump((void*)ActCaret, (void*)Replacement_ActCaret);
    ModLoader_WriteJump((void*)SetCaret, (void*)Replacement_SetCaret);

    // LoadGenericData API
    ModLoader_WriteCall((void*)0x4115DA, (void*)GenericDataCode);

    // Game API
    ModLoader_WriteCall((void*)0x40F67C, (void*)PreModeCode);

    // GetTrg API
    ModLoader_WriteJump((void*)0x4122E0, (void*)Replacement_GetTrg);

    // ModeOpening API
    ModLoader_WriteCall((void*)0x40F8E9, (void*)OpeningFadeCode);
    ModLoader_WriteCall((void*)0x40F91F, (void*)OpeningTextBoxCode);
    ModLoader_WriteCall((void*)0x40F809, (void*)OpeningEarlyActionCode);
    ModLoader_WriteCall((void*)0x40F840, (void*)OpeningActionCode);
    ModLoader_WriteCall((void*)0x40F74F, (void*)OpeningInitCode);
    ModLoader_WriteCall((void*)0x40F8E1, (void*)OpeningCaretCode);
    ModLoader_WriteCall((void*)0x40F924, (void*)ModeOpeningPutFPSCode);
    ModLoader_WriteCall((void*)0x40F871, (void*)OpeningPutBackCode);
    ModLoader_WriteCall((void*)0x40F881, (void*)OpeningPutStage_BackCode);
    ModLoader_WriteCall((void*)0x40F8D1, (void*)OpeningPutStage_FrontCode);

    // ModeTitle API
    ModLoader_WriteCall((void*)0x40FD85, (void*)TitleInitCode);
    ModLoader_WriteCall((void*)0x40FFDC, (void*)TitleActionCode);
    ModLoader_WriteCall((void*)0x41034C, (void*)TitleBelowCounterCode);
    ModLoader_WriteCall((void*)0x410369, (void*)ModeTitlePutFPSCode);

    // ModeAction API
    ModLoader_WriteCall((void*)0x4106F5, (void*)FadeCode);
    ModLoader_WriteCall((void*)0x41086F, (void*)TextBoxCode);
    ModLoader_WriteCall((void*)0x410683, (void*)DrawPlayerCode);
    ModLoader_WriteCall((void*)0x410555, (void*)EarlyActionCode);
    ModLoader_WriteCall((void*)0x4105B5, (void*)ActionCode);
    ModLoader_WriteCall((void*)0x410600, (void*)CreditsActionCode);
    ModLoader_WriteCall((void*)0x410477, (void*)InitCode);
    ModLoader_WriteCall((void*)0x4106D8, (void*)ActionCaretCode);
    ModLoader_WriteCall((void*)0x410874, (void*)ModeActionPutFPSCode);
    ModLoader_WriteCall((void*)0x410633, (void*)PutBackCode);
    ModLoader_WriteCall((void*)0x410643, (void*)PutStage_BackCode);
    ModLoader_WriteCall((void*)0x4106C3, (void*)PutStage_FrontCode);

    // Profile API
    // ModLoader_WriteCall((void*)0x41CFE8, (void*)ProfilePath); //IsProfile
    ModLoader_WriteCall((void*)0x41D095, (void*)ProfilePath); //Save
    ModLoader_WriteCall((void*)0x41D2A9, (void*)ProfilePath); //Load
    ModLoader_WriteCall((void*)0x41D073, (void*)ProfilePath); //Save (Custom)
    ModLoader_WriteCall((void*)0x41D287, (void*)ProfilePathLoadCustom); //Load (Custom)
    ModLoader_WriteCall((void*)0x41D239, (void*)SaveProfileCode);
    ModLoader_WriteCall((void*)0x41D353, (void*)LoadProfileCode);
    ModLoader_WriteCall((void*)0x41D508, (void*)LoadProfileInitCode);
    ModLoader_WriteCall((void*)0x41D576, (void*)InitializeGameCode);

    // PutFPS API
    ModLoader_WriteJump((void*)0x412370, (void*)Replacement_PutFPS);

    // TransferStage API
    ModLoader_WriteCall((void*)0x420EB5, (void*)TransferStageInitCode);

    // Npc Table API
    ModLoader_WriteJump((void*)0x46FA00, (void*)Replacement_ActNpChar);
    ModLoader_WriteJump((void*)0x46FAB0, (void*)Replacement_ChangeNpCharByEvent);
    ModLoader_WriteJump((void*)0x46FD10, (void*)Replacement_ChangeCheckableNpCharByEvent);

    // TextScript API
    ModLoader_WriteCall((void*)0x424DAE, (void*)TextScriptSVPCode);

    /*
    ModLoader_WriteJump((void*)0x4196F0, (void*)AddExpMyChar);
    ModLoader_WriteJump((void*)0x4198C0, (void*)IsMaxExpMyChar);
    */
    ModLoader_WriteJump((void*)0x403F80, (void*)Replacement_SetBullet);
    ModLoader_WriteJump((void*)0x408FC0, (void*)Replacement_ActBullet);
    ModLoader_WriteJump((void*)0x41FE70, (void*)Replacement_ShootBullet);
    // ModLoader_WriteCall((void*)0x4105A6, (void*)ReplacementForShootBullet);

    ModLoader_WriteCall((void*)0x40B42D, (void*)Replacement_RestoreSurfaces);

    GetDefaultOpening(); // get default opening from exe before doing stuff
    GetDefaultStart(); // get default start from exe before doing stuff
    ModLoader_WriteCall((void*)0x40F766, (void*)TransferToOpeningStage);
    ModLoader_WriteCall((void*)0x41D59A, (void*)TransferToStartingStage);

    InitTSC();
    InitKeyControl();

    RegisterPreModeElement(LoadModTables);
    RegisterPreModeElement(InitMod_Lua);
    RegisterPreModeElement(RegisterPreModeModScript);

    if (use_mode_overhaul == false)
    {
        RegisterOpeningInitElement(SetModeOpening);
        RegisterTitleInitElement(SetModeTitle);
        RegisterInitElement(SetModeAction);
    }
   
    RegisterOpeningInitElement(Lua_GameInit);
    RegisterOpeningEarlyActionElement(Lua_GameAct);
    RegisterOpeningActionElement(Lua_GameUpdate);
    RegisterModeOpeningAbovePutFPSElement(Lua_GameDraw);

    RegisterOpeningBelowPutStage_BackElement(Lua_GameDrawBelowPutStage_Back);
    RegisterOpeningAbovePutStage_BackElement(Lua_GameDrawAbovePutStage_Back);
    RegisterOpeningBelowPutStage_FrontElement(Lua_GameDrawBelowPutStage_Front);
    RegisterOpeningAbovePutStage_FrontElement(Lua_GameDrawAbovePutStage_Front);
    RegisterOpeningBelowFadeElement(Lua_GameDrawBelowFade);
    RegisterOpeningAboveFadeElement(Lua_GameDrawAboveFade);
    RegisterOpeningBelowTextBoxElement(Lua_GameDrawBelowTextBox);
    RegisterOpeningAboveTextBoxElement(Lua_GameDrawAboveTextBox);

    RegisterTitleInitElement(Lua_GameInit);
    RegisterTitleActionElement(Lua_GameAct);
    RegisterTitleActionElement(Lua_GameUpdate);
    RegisterModeTitleAbovePutFPSElement(Lua_GameDraw);

    RegisterInitElement(Lua_GameInit);
    ModLoader_WriteCall((void*)0x4104D0, (void*)Lua_GameActTrg);
    RegisterEarlyActionElement(Lua_GameAct2); // Act2 runs like old ModCS, and is useful for many scenarios
    RegisterActionElement(Lua_GameUpdate);
    RegisterModeActionAbovePutFPSElement(Lua_GameDraw);

    RegisterBelowPutStage_BackElement(Lua_GameDrawBelowPutStage_Back);
    RegisterAbovePutStage_BackElement(Lua_GameDrawAbovePutStage_Back);
    RegisterBelowPutStage_FrontElement(Lua_GameDrawBelowPutStage_Front);
    RegisterAbovePutStage_FrontElement(Lua_GameDrawAbovePutStage_Front);
    RegisterBelowPlayerElement(Lua_GameDrawBelowPlayer);
    RegisterAbovePlayerElement(Lua_GameDrawAbovePlayer);
    RegisterBelowFadeElement(Lua_GameDrawBelowFade);
    RegisterAboveFadeElement(Lua_GameDrawAboveFade);
    RegisterBelowTextBoxElement(Lua_GameDrawBelowTextBox);
    RegisterAboveTextBoxElement(Lua_GameDrawAboveTextBox);
    RegisterPlayerHudElement(Lua_GameDrawHUD);

    RegisterSaveAndLoad();
    RegisterOnTransferStage();

    // If a modder needs the tables from their exe, they can enable that.
    if (debug_write_tables)
        RegisterPreModeElement(WriteDebugTables);

    RegisterGetTrgElement(AutPI_GetTrg_ForInput);

    RegisterDrawFrameElement(Lua_FrameInit);
}