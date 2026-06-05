#include <windows.h>
#include <shlwapi.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>
#include <yaml-cpp/yaml.h>

#include "mod_loader.h"
#include "cave_story.h"
#include "ModSettings.h"

#include "API_Boss.h"
#include "API_Caret.h"
#include "API_Escape.h"
#include "API_LoadGenericData.h"
#include "API_Game.h"
#include "API_GetTrg.h"
#include "API_KeyControl.h"
#include "API_Main.h"
#include "API_ModeOpening.h"
#include "API_ModeTitle.h"
#include "API_ModeAction.h"
#include "API_MyChar.h"
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
#include "lua/Triangle.h"

#include "Debug.h"

#define autpiVer 1, 3, 0, 0

char gSavesPath[MAX_PATH];
char gDebugSavesPath[MAX_PATH];
int gCurrentGameMode = 0;
BOOL gModeSetted = FALSE;

bool EnsureDir(const char* path)
{
    if (CreateDirectoryA(path, NULL))
        return true;

    DWORD err = GetLastError();
    return (err == ERROR_ALREADY_EXISTS);
}

void EndMod()
{
    CloseModScript();
    if (autpi_debug_mode)
    {
        FreeArmsNames();
        FreeItemNames();
        FreeEquipNames();
    }
}

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

void SaveArmsTableBinary()
{
    char path[MAX_PATH];
    sprintf(path, "%s\\arms_level.tbl", exeModulePath);

    FILE* fp = fopen(path, "wb");
    if (!fp)
        return;

    fwrite(gArmsLevelTable, sizeof(ARMS_LEVEL), 14, fp);
    fclose(fp);
}

void SaveArmsTableYaml()
{
    char path[MAX_PATH];
    sprintf(path, "%s\\arms_level.yaml", exeModulePath);

    YAML::Emitter out;
    out << YAML::BeginMap;
    out << YAML::Key << "levels";
    out << YAML::Value << YAML::BeginSeq;

    for (int i = 0; i < 14; ++i)
    {
        out << YAML::Flow << YAML::BeginSeq
            << gArmsLevelTable[i].exp[0]
            << gArmsLevelTable[i].exp[1]
            << gArmsLevelTable[i].exp[2]
            << YAML::EndSeq;
    }

    out << YAML::EndSeq;
    out << YAML::EndMap;

    FILE* fp = fopen(path, "w");
    if (fp)
    {
        fputs(out.c_str(), fp);
        fclose(fp);
    }
}

void SaveBulletTableBinary()
{
    char path[MAX_PATH];
    sprintf(path, "%s\\bullet.tbl", exeModulePath);

    FILE* fp = fopen(path, "wb");
    if (!fp)
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
}

void SaveBulletTableYaml()
{
    char path[MAX_PATH];
    sprintf(path, "%s\\bullet.yaml", exeModulePath);

    YAML::Emitter out;
    out << YAML::BeginMap;
    out << YAML::Key << "bullets";
    out << YAML::Value << YAML::BeginSeq;

    for (int i = 0; i < 46; ++i)
    {
        out << YAML::BeginMap;

        out << YAML::Key << "damage" << YAML::Value << gBulTbl[i].damage;
        out << YAML::Key << "hits" << YAML::Value << gBulTbl[i].life;
        out << YAML::Key << "ticks" << YAML::Value << gBulTbl[i].life_count;
        out << YAML::Key << "bits" << YAML::Value << gBulTbl[i].bbits;
        out << YAML::Key << "enemyXL" << YAML::Value << gBulTbl[i].enemyXL;
        out << YAML::Key << "enemyYL" << YAML::Value << gBulTbl[i].enemyYL;
        out << YAML::Key << "blockXL" << YAML::Value << gBulTbl[i].blockXL;
        out << YAML::Key << "blockYL" << YAML::Value << gBulTbl[i].blockYL;

        out << YAML::Key << "view" << YAML::Value << YAML::BeginMap;
        out << YAML::Key << "front" << YAML::Value << gBulTbl[i].view.front;
        out << YAML::Key << "top" << YAML::Value << gBulTbl[i].view.top;
        out << YAML::Key << "back" << YAML::Value << gBulTbl[i].view.back;
        out << YAML::Key << "bottom" << YAML::Value << gBulTbl[i].view.bottom;
        out << YAML::EndMap;

        out << YAML::EndMap;
    }

    out << YAML::EndSeq;
    out << YAML::EndMap;

    FILE* fp = fopen(path, "w");
    if (fp)
    {
        fputs(out.c_str(), fp);
        fclose(fp);
    }
}

void SaveCaretTableBinary()
{
    char path[MAX_PATH];
    sprintf(path, "%s\\caret.tbl", exeModulePath);

    FILE* fp = fopen(path, "wb");
    if (!fp)
        return;

    fwrite(gCaretTable, sizeof(CARET_TABLE), 18, fp);
    fclose(fp);
}

void SaveCaretTableYaml()
{
    char path[MAX_PATH];
    sprintf(path, "%s\\caret.yaml", exeModulePath);

    YAML::Emitter out;
    out << YAML::BeginMap;
    out << YAML::Key << "carets";
    out << YAML::Value << YAML::BeginSeq;

    for (int i = 0; i < 18; ++i)
    {
        out << YAML::Flow << YAML::BeginSeq
            << gCaretTable[i].view_left
            << gCaretTable[i].view_top
            << YAML::EndSeq;
    }

    out << YAML::EndSeq;
    out << YAML::EndMap;

    FILE* fp = fopen(path, "w");
    if (fp)
    {
        fputs(out.c_str(), fp);
        fclose(fp);
    }
}

void SetPathAutPI()
{
	strcpy(gSavesPath, exeModulePath);
	strcat(gSavesPath, "\\savedata");

    EnsureDir(gSavesPath);

    if (autpi_debug_mode)
    {
        strcpy(gDebugSavesPath, gSavesPath);
        strcat(gDebugSavesPath, "\\debug_saves");
        
        EnsureDir(gDebugSavesPath);
    }
}

void LoadModTables()
{
    LoadLevelsTable();
    ArmsTablePatches();
    LoadBulletTable();
    LoadCaretTable();

    if (autpi_debug_mode)
    {
        LoadArmsNames();
        LoadItemNames();
        LoadEquipNames();
    }
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

void WriteDebugTablesBinary()
{
    SaveArmsTableBinary();
    SaveBulletTableBinary();
    SaveCaretTableBinary();
}

void WriteDebugTablesYaml()
{
    SaveArmsTableYaml();
    SaveBulletTableYaml();
    SaveCaretTableYaml();
}

// Early action?
void ActDebugMode()
{
    if (godModeEnabled)
    {
        gMC.air = 1000;
        gMC.shock = 128;
        FullArmsEnergy();
    }

    if (infiniteBooster)
    {
        if (gMC.boost_cnt == 1)
            gMC.boost_cnt += 10;
    }

	// Main debug menu ui
    if (gKey & KEY_SHIFT)
    {
        if (gKeyTrg & KEY_F2)
        {
            //BackupSurface(SURFACE_ID_SCREEN_GRAB, &grcGame);
            switch (Call_DebugMenu())
            {
                case enum_ESCRETURN_exit:
                {
                    gCurrentGameMode = 0;
	                gModeSetted = TRUE;
                }
            }
        }
    }
}

// Below Fade
void DrawDebugMode()
{
    PutHitboxes(gFrame.x, gFrame.y);
}

BOOL ReplacementLoadGenericData()
{
    int pt_size = 0;

    // Run MakePixToneObject for each sound effect ID, since we still want that to be loaded automatically probably.
	pt_size += MakePixToneObject(&gPtpTable[0], 2, 32);
	pt_size += MakePixToneObject(&gPtpTable[2], 2, 33);
	pt_size += MakePixToneObject(&gPtpTable[4], 2, 34);
	pt_size += MakePixToneObject(&gPtpTable[6], 1, 15);
	pt_size += MakePixToneObject(&gPtpTable[7], 1, 24);
	pt_size += MakePixToneObject(&gPtpTable[8], 1, 23);
	pt_size += MakePixToneObject(&gPtpTable[9], 2, 50);
	pt_size += MakePixToneObject(&gPtpTable[11], 2, 51);
	pt_size += MakePixToneObject(&gPtpTable[33], 1, 1);
	pt_size += MakePixToneObject(&gPtpTable[38], 1, 2);
	pt_size += MakePixToneObject(&gPtpTable[56], 1, 29);
	pt_size += MakePixToneObject(&gPtpTable[61], 1, 43);
	pt_size += MakePixToneObject(&gPtpTable[62], 3, 44);
	pt_size += MakePixToneObject(&gPtpTable[65], 1, 45);
	pt_size += MakePixToneObject(&gPtpTable[66], 1, 46);
	pt_size += MakePixToneObject(&gPtpTable[68], 1, 47);
	pt_size += MakePixToneObject(&gPtpTable[49], 3, 35);
	pt_size += MakePixToneObject(&gPtpTable[52], 3, 39);
	pt_size += MakePixToneObject(&gPtpTable[13], 2, 52);
	pt_size += MakePixToneObject(&gPtpTable[28], 2, 53);
	pt_size += MakePixToneObject(&gPtpTable[15], 2, 70);
	pt_size += MakePixToneObject(&gPtpTable[17], 2, 71);
	pt_size += MakePixToneObject(&gPtpTable[19], 2, 72);
	pt_size += MakePixToneObject(&gPtpTable[30], 1, 5);
	pt_size += MakePixToneObject(&gPtpTable[32], 1, 11);
	pt_size += MakePixToneObject(&gPtpTable[35], 1, 4);
	pt_size += MakePixToneObject(&gPtpTable[46], 2, 25);
	pt_size += MakePixToneObject(&gPtpTable[48], 1, 27);
	pt_size += MakePixToneObject(&gPtpTable[54], 2, 28);
	pt_size += MakePixToneObject(&gPtpTable[39], 1, 14);
	pt_size += MakePixToneObject(&gPtpTable[23], 2, 16);
	pt_size += MakePixToneObject(&gPtpTable[25], 3, 17);
	pt_size += MakePixToneObject(&gPtpTable[34], 1, 18);
	pt_size += MakePixToneObject(&gPtpTable[36], 2, 20);
	pt_size += MakePixToneObject(&gPtpTable[31], 1, 22);
	pt_size += MakePixToneObject(&gPtpTable[41], 2, 26);
	pt_size += MakePixToneObject(&gPtpTable[43], 1, 21);
	pt_size += MakePixToneObject(&gPtpTable[44], 2, 12);
	pt_size += MakePixToneObject(&gPtpTable[57], 2, 38);
	pt_size += MakePixToneObject(&gPtpTable[59], 1, 31);
	pt_size += MakePixToneObject(&gPtpTable[60], 1, 42);
	pt_size += MakePixToneObject(&gPtpTable[69], 1, 48);
	pt_size += MakePixToneObject(&gPtpTable[70], 2, 49);
	pt_size += MakePixToneObject(&gPtpTable[72], 1, 100);
	pt_size += MakePixToneObject(&gPtpTable[73], 3, 101);
	pt_size += MakePixToneObject(&gPtpTable[76], 2, 54);
	pt_size += MakePixToneObject(&gPtpTable[78], 2, 102);
	pt_size += MakePixToneObject(&gPtpTable[80], 2, 103);
	pt_size += MakePixToneObject(&gPtpTable[81], 1, 104);
	pt_size += MakePixToneObject(&gPtpTable[82], 1, 105);
	pt_size += MakePixToneObject(&gPtpTable[83], 2, 106);
	pt_size += MakePixToneObject(&gPtpTable[85], 1, 107);
	pt_size += MakePixToneObject(&gPtpTable[86], 1, 30);
	pt_size += MakePixToneObject(&gPtpTable[87], 1, 108);
	pt_size += MakePixToneObject(&gPtpTable[88], 1, 109);
	pt_size += MakePixToneObject(&gPtpTable[89], 1, 110);
	pt_size += MakePixToneObject(&gPtpTable[90], 1, 111);
	pt_size += MakePixToneObject(&gPtpTable[91], 1, 112);
	pt_size += MakePixToneObject(&gPtpTable[92], 1, 113);
	pt_size += MakePixToneObject(&gPtpTable[93], 2, 114);
	pt_size += MakePixToneObject(&gPtpTable[95], 2, 150);
	pt_size += MakePixToneObject(&gPtpTable[97], 2, 151);
	pt_size += MakePixToneObject(&gPtpTable[99], 1, 152);
	pt_size += MakePixToneObject(&gPtpTable[100], 1, 153);
	pt_size += MakePixToneObject(&gPtpTable[101], 2, 154);
	pt_size += MakePixToneObject(&gPtpTable[111], 2, 155);
	pt_size += MakePixToneObject(&gPtpTable[103], 2, 56);
	pt_size += MakePixToneObject(&gPtpTable[105], 2, 40);
	pt_size += MakePixToneObject(&gPtpTable[105], 2, 41);
	pt_size += MakePixToneObject(&gPtpTable[107], 2, 37);
	pt_size += MakePixToneObject(&gPtpTable[109], 2, 57);
	pt_size += MakePixToneObject(&gPtpTable[113], 3, 115);
	pt_size += MakePixToneObject(&gPtpTable[116], 1, 104);
	pt_size += MakePixToneObject(&gPtpTable[117], 3, 116);
	pt_size += MakePixToneObject(&gPtpTable[120], 2, 58);
	pt_size += MakePixToneObject(&gPtpTable[122], 2, 55);
	pt_size += MakePixToneObject(&gPtpTable[124], 2, 117);
	pt_size += MakePixToneObject(&gPtpTable[126], 1, 59);
	pt_size += MakePixToneObject(&gPtpTable[127], 1, 60);
	pt_size += MakePixToneObject(&gPtpTable[128], 1, 61);
	pt_size += MakePixToneObject(&gPtpTable[129], 2, 62);
	pt_size += MakePixToneObject(&gPtpTable[131], 2, 63);
	pt_size += MakePixToneObject(&gPtpTable[133], 2, 64);
	pt_size += MakePixToneObject(&gPtpTable[135], 1, 65);
	pt_size += MakePixToneObject(&gPtpTable[136], 1, 3);
	pt_size += MakePixToneObject(&gPtpTable[137], 1, 6);
	pt_size += MakePixToneObject(&gPtpTable[138], 1, 7);

    return TRUE;
}

// 0x411266 - Save
// 0x41100D - Load
void WindowRectPath(char* p, const char* fm, const char* mp, const char* nm)
{
    sprintf(p, fm, gSavesPath, nm);
}

void InitMod(void)
{
    InitMod_Settings();
    printf("%s. %d.%d.%d.%d\n", "AUTPI Version", autpiVer);

    // Main API
    ModLoader_WriteCall((void*)0x4124BE, (void*)SetPathCode);
    RegisterSetPathElement(SetPathAutPI);

    if (use_mode_overhaul == false)
    {
        ModLoader_AddStackableHook((void*)0x40F930, 8, ModeSwitchFunction, (void*)0); // intro
        ModLoader_AddStackableHook((void*)0x410375, 8, ModeSwitchFunction, (void*)0); // title
        ModLoader_AddStackableHook((void*)0x410880, 8, ModeSwitchFunction, (void*)0); // game
    }
    else
    {
        ModLoader_WriteCall((void*)0x40F6A7, reinterpret_cast<const void*>(Replacement_ModeCall)); // so gcc doesnt whine abt it
        ModLoader_WriteCall((void*)0x40F6BC, reinterpret_cast<const void*>(Replacement_ModeCall));
        ModLoader_WriteCall((void*)0x40F6D1, reinterpret_cast<const void*>(Replacement_ModeCall));
        ModLoader_WriteCall((void*)0x40F6E2, reinterpret_cast<const void*>(Replacement_Game_PlaySound7));
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
    ModLoader_WriteCall((void*)0x40F6F9, (void*)ReleaseCode);

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
    ModLoader_WriteCall((void*)0x40F8C1, (void*)OpeningPutStage_FrontCode);

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
    ModLoader_WriteCall((void*)0x4106B3, (void*)PutStage_FrontCode);

    // Profile API
    ModLoader_WriteCall((void*)0x41CFE8, (void*)ProfilePath); //IsProfile
    ModLoader_WriteCall((void*)0x41D095, (void*)ProfilePath); //Save
    ModLoader_WriteCall((void*)0x41D2A9, (void*)ProfilePath); //Load
    ModLoader_WriteCall((void*)0x41D073, (void*)ProfilePath); //Save (Custom)
    ModLoader_WriteCall((void*)0x41D287, (void*)ProfilePathLoadCustom); //Load (Custom)
    ModLoader_WriteCall((void*)0x41D239, (void*)SaveProfileCode);
    ModLoader_WriteCall((void*)0x41D353, (void*)LoadProfileCode);
    ModLoader_WriteCall((void*)0x41D508, (void*)LoadProfileInitCode);
    ModLoader_WriteCall((void*)0x41D576, (void*)InitializeGameCode);

    // Window Rect path goes to savedata folder instead
    ModLoader_WriteCall((void*)0x411266, (void*)WindowRectPath);
    ModLoader_WriteCall((void*)0x41100D, (void*)WindowRectPath);

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

    ModLoader_WriteCall((void*)0x40B42D, (void*)Replacement_RestoreSurfaces);

    GetDefaultOpening(); // get default opening from exe before doing stuff
    GetDefaultStart(); // get default start from exe before doing stuff
    ModLoader_WriteCall((void*)0x40F766, (void*)TransferToOpeningStage);
    ModLoader_WriteCall((void*)0x41D59A, (void*)TransferToStartingStage);

    // GetArktan patch for safety
    ModLoader_WriteJump((void*)0x4258E0, (void*)Replacement_GetArktan);

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
    if (debug_write_tables_binary)
        RegisterPreModeElement(WriteDebugTablesBinary);

    if (debug_write_tables_yaml)
        RegisterPreModeElement(WriteDebugTablesYaml);

    if (enable_old_mouse_code)
        RegisterGetTrgElement(AutPI_GetTrg_ForInput);

    RegisterDrawFrameElement(Lua_FrameInit);

    ModLoader_WriteCall((void*)0x410541, (void*)Replacement_ModeAction_ActMyChar);
    ModLoader_WriteCall((void*)0x41054D, (void*)Replacement_ModeAction_ActMyChar);
    //ModLoader_WriteCall((void*)0x410683, (void*)Replacement_ModeAction_PutMyChar);
    ModLoader_WriteCall((void*)0x4105D7, (void*)Replacement_ModeAction_AnimationMyChar);
    ModLoader_WriteCall((void*)0x4105E3, (void*)Replacement_ModeAction_AnimationMyChar);

    // DamageMyChar Calls
    if (replace_player_damage_function)
    {
        ModLoader_WriteCall((void*)0x4162F1, (void*)DamageMyChar_ModCS);
        ModLoader_WriteCall((void*)0x4192DF, (void*)DamageMyChar_ModCS);
        ModLoader_WriteCall((void*)0x419311, (void*)DamageMyChar_ModCS);
        ModLoader_WriteCall((void*)0x419343, (void*)DamageMyChar_ModCS);
        ModLoader_WriteCall((void*)0x419375, (void*)DamageMyChar_ModCS);
        ModLoader_WriteCall((void*)0x4193B2, (void*)DamageMyChar_ModCS);
        ModLoader_WriteCall((void*)0x4195DF, (void*)DamageMyChar_ModCS);
        ModLoader_WriteCall((void*)0x419611, (void*)DamageMyChar_ModCS);
        ModLoader_WriteCall((void*)0x41964E, (void*)DamageMyChar_ModCS);
    }

    // AddLifeMyChar Calls
    if (replace_player_heal_function)
    {
        ModLoader_WriteCall((void*)0x419216, (void*)AddLifeMyChar_ModCS);
        ModLoader_WriteCall((void*)0x4226BD, (void*)AddLifeMyChar_ModCS);
    }
    
    if (replace_player_hud_functions)
    {
        ModLoader_WriteCall((void*)0x410838, (void*)Replacement_ModeAction_PutMyLife);
        ModLoader_WriteCall((void*)0x410842, (void*)Replacement_ModeAction_PutArmsEnergy);
        ModLoader_WriteCall((void*)0x41084E, (void*)Replacement_ModeAction_PutMyAir);
        ModLoader_WriteCall((void*)0x410856, (void*)Replacement_ModeAction_PutActiveArmsList);
    }

    if (replace_inventory_function)
        ModLoader_WriteCall((void*)0x410725, (void*)Replacement_ModeAction_CampLoop);

    // Call_Escape() function calls
    if (replace_escape_menu_functions)
    {
        ModLoader_WriteCall((void*)0x401DF2, (void*)Replacement_Call_Escape_ModCS);
        ModLoader_WriteCall((void*)0x40DC2A, (void*)Replacement_Call_Escape_ModCS);
        ModLoader_WriteCall((void*)0x40F7CD, (void*)Replacement_Call_Escape_ModCS);
        ModLoader_WriteCall((void*)0x40FF6A, (void*)Replacement_Call_Escape_ModCS);
        ModLoader_WriteCall((void*)0x4104E8, (void*)Replacement_Call_Escape_ModCS);
        ModLoader_WriteCall((void*)0x4146D8, (void*)Replacement_Call_Escape_ModCS);
        ModLoader_WriteCall((void*)0x41488B, (void*)Replacement_Call_Escape_ModCS);
        ModLoader_WriteCall((void*)0x4149F0, (void*)Replacement_Call_Escape_ModCS);
        ModLoader_WriteCall((void*)0x41DAA0, (void*)Replacement_Call_Escape_ModCS);
    }

    // MiniMapLoop() function calls
    if (replace_map_functions)
    {
        ModLoader_WriteCall((void*)0x410785, (void*)Replacement_ModeAction_MiniMapLoop);
        ModLoader_WriteCall((void*)0x42444C, (void*)Replacement_ModeAction_MiniMapLoop);
    }

    if (autpi_debug_mode == true)
    {
        RegisterEarlyActionElement(ActDebugMode);
        RegisterBelowFadeElement(DrawDebugMode);
    }

    if (skip_loadgenericdata)
    {
        ModLoader_WriteCall((void*)0x40F601, (void*)ReplacementLoadGenericData);
    }

    //RegisterReleaseElement(EndMod);
}