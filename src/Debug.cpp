#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "Debug.h"

#include "mod_loader.h"
#include "cave_story.h"
#include "Main.h"

#include "lua/Lua.h"

#include "API_Weapon.h"
#include "API_Caret.h"
#include "API_MyChar.h"
#include "API_Stage.h"

// Based off of CSE2 pause code as a base but heavily modified, very sloppy bad code caus it was made by : Autumn
// ..Also wasn't meant to be public originaly but having debug tools for modding is very useful.

enum DebugMode
{
    DEBUG_MAIN,
    DEBUG_END_MODE,
};

enum DebugOptionsMain
{
    RELOAD_LUA,
    RELOAD_TABLES,
    GOD_MODE,
    INFINITE_BOOSTER,
    SAVE_GAME,
    LOAD_GAME,
    GIVE_WEAPON,
    REMOVE_WEAPON,
    GIVE_ITEM,
    REMOVE_ITEM,
    EQUIP_ITEM,
    UNEQUIP_ITEM,
    RESTORE_LIFE,
    ADD_MAX_LIFE,
    DAMAGE_PLAYER,
    LEVEL_UP_DOWN,
    TRANSFER_STAGE,
    CHANGE_MUSIC,
    CHANGE_FLAG,
    CHANGE_SKIPFLAG,
    SPAWN_BULLET,
    SPAWN_CARET,
    SPAWN_ENTITY,
    RUN_TSC_EVENT,
    SHOW_HITBOXES,
    DEBUG_OPTIONS_END,
};

#define DEBUG_OPTIONS_PER_PAGE 25
#define DEBUG_PAGE_COUNT ((DEBUG_OPTIONS_END + DEBUG_OPTIONS_PER_PAGE - 1) / DEBUG_OPTIONS_PER_PAGE)

int gDebugMenuPage = 0;

char** gSaveFiles = NULL;
int gSaveFileCount = 0;
int gSaveFileIndex = 0; // 0 = NULL/default

int gCurrentDebugMode = 0;
int gDebugModePosition = 0;
bool godModeEnabled = false;
bool infiniteBooster = false;
int weaponChosen = 0;
int itemChosen = 0;
int equipChosen = 1;
int lifeChosen = 0;
int damageChosen = 0;
bool levelDown = false;
int mapChosen = 0;
int musicChosen = 0;
int flagChosen = 0;
int skipflagChosen = 0;
int sceneflagChosen = 0;
int bulletChosen = 0;
int bulletDir = 0;
int caretChosen = 0;
int caretDir = 0;
int entityChosen = 0;
int entityDir = 0;
int tsceventChosen = 0;
bool showHitboxes = false;

const char* modes[] = {
    "MAIN MODE",
    "FLAG MODE",
    "SCENE FLAG MODE",
};

const char* modeMainOptions[] = {
    "Reload Lua Scripts",
    "Reload Tables",
    "God Mode",
    "Infinite Booster",
    "Save Game",
    "Load Game",
    "Give weapon of type",
    "Remove weapon of type",
    "Give item of type",
    "Remove item of type",
    "Equip item of type",
    "Unequip item of type",
    "Restore Life & Ammo",
    "Add Max Life",
    "Damage Player",
    "Weapon Level",
    "Transfer to Map",
    "Change Music to",
    "Set/Unset Flag",
    "Set/Unset SkipFlag",
    "Spawn Bullet of Type",
    "Spawn Caret of Type",
    "Spawn Entity of Type",
    "Run Tsc Event",
    "Show Hitboxes",
};

int LoadStringList(const char* path, char*** outArray, int* outCount)
{
    FILE* fp = fopen(path, "r");
    if (!fp)
        return 0;

    char** array = NULL;
    int count = 0;
    int capacity = 8;

    array = (char**)malloc(sizeof(char*) * capacity);
    if (!array)
    {
        fclose(fp);
        return 0;
    }

    char line[256];

    while (fgets(line, sizeof(line), fp))
    {
        line[strcspn(line, "\r\n")] = 0;

        if (line[0] == '\0')
            continue;

        if (count >= capacity)
        {
            int newCapacity = capacity * 2;
            char** temp = (char**)realloc(array, sizeof(char*) * newCapacity);

            if (!temp)
            {
                fclose(fp);
                // cleanup partial
                for (int i = 0; i < count; i++)
                    free(array[i]);
                free(array);
                return 0;
            }

            array = temp;
            capacity = newCapacity;
        }

        char* copy = _strdup(line);
        if (!copy)
        {
            fclose(fp);
            for (int i = 0; i < count; i++)
                free(array[i]);
            free(array);
            return 0;
        }

        array[count++] = copy;
    }

    fclose(fp);

    *outArray = array;
    *outCount = count;
    return 1;
}

void FreeStringList(char*** array, int* count)
{
    if (!*array)
        return;

    for (int i = 0; i < *count; i++)
        free((*array)[i]);

    free(*array);
    *array = NULL;
    *count = 0;
}

int LoadSaveFiles(const char* folder)
{
    FreeStringList(&gSaveFiles, &gSaveFileCount);

    int capacity = 8;
    gSaveFiles = (char**)malloc(sizeof(char*) * capacity);
    if (!gSaveFiles)
        return 0;

    char searchPath[MAX_PATH];
    snprintf(searchPath, sizeof(searchPath), "%s\\*.dat", folder);

    WIN32_FIND_DATAA fd;
    HANDLE hFind = FindFirstFileA(searchPath, &fd);

    if (hFind == INVALID_HANDLE_VALUE)
        return 1; // If no save files, still return 1 caus we have one save already (the Profile.dat!!)

    do
    {
        if (!(fd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))
        {
            if (gSaveFileCount >= capacity)
            {
                capacity *= 2;
                char** temp = (char**)realloc(gSaveFiles, sizeof(char*) * capacity);
                if (!temp)
                    break;
                gSaveFiles = temp;
            }

            char fullPath[MAX_PATH];
            snprintf(fullPath, sizeof(fullPath), "%s\\%s", folder, fd.cFileName);

            gSaveFiles[gSaveFileCount++] = _strdup(fullPath);
        }

    } while (FindNextFileA(hFind, &fd));

    FindClose(hFind);

    return 1;
}

char** gEquipNames = NULL;
int gEquipCount = 0;

char** gArmsNames = NULL;
int gArmsCount = 0;

char** gItemNames = NULL;
int gItemCount = 0;

int LoadEquipNames(void)
{
    char path[MAX_PATH];
    snprintf(path, sizeof(path), "%s\\mods\\autpi\\debug_equip.txt", exeModulePath);

    FreeStringList(&gEquipNames, &gEquipCount);
    return LoadStringList(path, &gEquipNames, &gEquipCount);
}

int LoadArmsNames(void)
{
    char path[MAX_PATH];
    snprintf(path, sizeof(path), "%s\\mods\\autpi\\debug_arms.txt", exeModulePath);

    FreeStringList(&gArmsNames, &gArmsCount);
    return LoadStringList(path, &gArmsNames, &gArmsCount);
}

int LoadItemNames(void)
{
    char path[MAX_PATH];
    snprintf(path, sizeof(path), "%s\\mods\\autpi\\debug_items.txt", exeModulePath);

    FreeStringList(&gItemNames, &gItemCount);
    return LoadStringList(path, &gItemNames, &gItemCount);
}

void FreeEquipNames(void)
{
    FreeStringList(&gEquipNames, &gEquipCount);
}

void FreeArmsNames(void)
{
    FreeStringList(&gArmsNames, &gArmsCount);
}

void FreeItemNames(void)
{
    FreeStringList(&gItemNames, &gItemCount);
}

int GetEquipIndex(int equip)
{
    if (equip <= 0)
        return -1;

    for (int i = 0; i < gEquipCount; i++)
    {
        if (equip == (1 << i))
            return i;
    }

    return -1;
}

void ReloadStageTable()
{
    //UnloadStageTable();

    if (!LoadStageTable("stage.tbl"))
    {
        char errormsg[256];
		sprintf(errormsg, "Couldn't reload stage table");
		MessageBoxA(ghWnd, errormsg, "Error", MB_OK);
		return;
    }
}

void ReloadArmsTable()
{
    LoadLevelsTable();
}

void ReloadBulletTable()
{
    LoadBulletTable();
}

void ReloadCaretTable()
{
    LoadCaretTable();
}

void ReloadNPCTable()
{
    ReleaseNpcTable();

	char path[MAX_PATH];
	sprintf(path, "%s\\npc.tbl", exeDataPath);

	if (!LoadNpcTable(path))
	{
        char errormsg[256];
		sprintf(errormsg, "Couldn't reload npc table");
		MessageBoxA(ghWnd, errormsg, "Error", MB_OK);
		return;
    }
}

void ReloadTables()
{
    ReloadStageTable();
    ReloadArmsTable();
    ReloadBulletTable();
    ReloadCaretTable();
    ReloadNPCTable();
}

// Runs every frame
void ActDebug()
{
    // unused as of now
}

#define DEBUG_TEXT_COLOR(value) ((gDebugModePosition == value) ? 0xFFFF00 : 0xFFFFFF)

// Hitbox code was borrowed from Rain's CSE2 ds ports debug mode as well.
// It won't work exactly the same, but its probably helpful?
static void PutSquare(RECT src, unsigned long col)
{
	RECT dst;
	for (int i = 0; i < 4; i++)
	{
		dst = src;
		switch (i)
		{
			case 0:
				dst.right = dst.left ;
				break;
			case 1:
				dst.bottom = dst.top ;
				break;
			case 2:
				dst.top = dst.bottom ;
				break;
			case 3:
				dst.left = dst.right ;
				break;
		}
		CortBox(&dst, col);
	}
}

static int Sub2Px(int coord)
{
	return (coord / 0x200);
}

void PutHitboxes(int fx, int fy)
{
    if (!showHitboxes)
        return;

	static const long green_color = GetCortBoxColor(RGB(0x00, 0xFF, 0x00));
	static const long red_color = GetCortBoxColor(RGB(0xFF, 0x00, 0x00));
	static const long yellow_color = GetCortBoxColor(RGB(0xFF, 0xFF, 0x00));
	static const long cyan_color = GetCortBoxColor(RGB(0x00, 0xFF, 0xFF));
	static const long white_color = GetCortBoxColor(RGB(0xFF, 0xFF, 0xFF));
	RECT rect;
	int side, back, front, temp;
	long color;

	//Player collision box
		rect.left = Sub2Px(gMC.x) - Sub2Px(gMC.hit.back) - Sub2Px(fx);
		rect.top = Sub2Px(gMC.y) - Sub2Px(gMC.hit.top) - Sub2Px(fy);
		rect.right = Sub2Px(gMC.x) + Sub2Px(gMC.hit.back) - Sub2Px(fx);
		rect.bottom = Sub2Px(gMC.y) + Sub2Px(gMC.hit.bottom) - Sub2Px(fy);
		CortBox(&rect, yellow_color);

    //Player hitbox
		rect.left = Sub2Px(gMC.x) - Sub2Px(gMC.hit.back) - Sub2Px(fx) + Sub2Px(3 * 0x200);
		rect.top = Sub2Px(gMC.y) - Sub2Px(gMC.hit.top) - Sub2Px(fy) + Sub2Px(6 * 0x200);
		rect.right = Sub2Px(gMC.x) + Sub2Px(gMC.hit.back) - Sub2Px(fx) - Sub2Px(3 * 0x200);
		rect.bottom = Sub2Px(gMC.y) + Sub2Px(gMC.hit.bottom) - Sub2Px(fy) - Sub2Px(6 * 0x200);
		CortBox(&rect, cyan_color);

		for (int n = 0; n < NPC_MAX; ++n)
		{
			if (gNPC[n].cond & 0x80)
			{
				if (gNPC[n].damage)
				{
					color = red_color;
				}
				else if (gNPC[n].bits & (NPC_EVENT_WHEN_TOUCHED | NPC_INTERACTABLE))
				{
					color = green_color;
				}
				else
				{
					color = white_color;
				}

				back = gNPC[n].hit.back;
				front = gNPC[n].hit.front;

				if (gNPC[n].bits & (NPC_SOLID_SOFT | NPC_SOLID_HARD))
				{
					front = gNPC[n].hit.back;
				}

				if (gNPC[n].direct == 0)
				{
					temp = front;
					front = back;
					back = temp;
				}

				rect.left = Sub2Px(gNPC[n].x) - Sub2Px(back) - Sub2Px(fx);
				rect.top = Sub2Px(gNPC[n].y) - Sub2Px(gNPC[n].hit.top) - Sub2Px(fy);
				rect.right = Sub2Px(gNPC[n].x) + Sub2Px(front) - Sub2Px(fx);
				rect.bottom = Sub2Px(gNPC[n].y) + Sub2Px(gNPC[n].hit.bottom) - Sub2Px(fy);

				CortBox(&rect, color);
			}
		}

		for (int n = 0; n < BOSS_MAX; ++n)
		{
			if (gBoss[n].cond & 0x80)
			{
				if (gBoss[n].damage)
				{
					color = red_color;
				}
				else
				{
					color = white_color;
				}

				back = gBoss[n].hit.back;
				front = gBoss[n].hit.front;

				if (gBoss[n].bits & (NPC_SOLID_SOFT | NPC_SOLID_HARD))
				{
					front = gBoss[n].hit.back;
				}

				if (gBoss[n].direct == 0)
				{
					temp = front;
					front = back;
					back = temp;
				}
				rect.left = Sub2Px(gBoss[n].x) - Sub2Px(back) - Sub2Px(fx);
				rect.top = Sub2Px(gBoss[n].y) - Sub2Px(gBoss[n].hit.top) - Sub2Px(fy);
				rect.right = Sub2Px(gBoss[n].x) + Sub2Px(front) - Sub2Px(fx);
				rect.bottom = Sub2Px(gBoss[n].y) + Sub2Px(gBoss[n].hit.bottom) - Sub2Px(fy);

				CortBox(&rect, color);
			}
		}

		for (int n = 0; n < BULLET_MAX; ++n)
		{
			if (gBul[n].cond & 0x80)
			{
				rect.left = Sub2Px(gBul[n].x) - Sub2Px(gBul[n].enemyXL) - Sub2Px(fx);
				rect.top = Sub2Px(gBul[n].y) - Sub2Px(gBul[n].enemyYL) - Sub2Px(fy);
				rect.right = Sub2Px(gBul[n].x) + Sub2Px(gBul[n].enemyXL) - Sub2Px(fx);
				rect.bottom = Sub2Px(gBul[n].y) + Sub2Px(gBul[n].enemyYL) - Sub2Px(fy);

				CortBox(&rect, red_color);

				rect.left = Sub2Px(gBul[n].x) - Sub2Px(gBul[n].blockXL) - Sub2Px(fx);
				rect.top = Sub2Px(gBul[n].y) - Sub2Px(gBul[n].blockYL) - Sub2Px(fy);
				rect.right = Sub2Px(gBul[n].x) + Sub2Px(gBul[n].blockXL) - Sub2Px(fx);
				rect.bottom = Sub2Px(gBul[n].y) + Sub2Px(gBul[n].blockYL) - Sub2Px(fy);

				CortBox(&rect, cyan_color);
			}
		}
}

static const char* GetDebugOptionName(int i)
{
    return modeMainOptions[i];
}

void DebugModeMain()
{
    int start = gDebugMenuPage * DEBUG_OPTIONS_PER_PAGE;
    int end = start + DEBUG_OPTIONS_PER_PAGE;

    if (end > DEBUG_OPTIONS_END)
        end = DEBUG_OPTIONS_END;

    for (int i = start; i < end; i++)
    {
        char buffer[128];

        switch (i)
        {
            case GOD_MODE:
                sprintf(buffer, "%s: (%s)", modeMainOptions[i], godModeEnabled ? "ENABLED" : "DISABLED");
                break;

            case INFINITE_BOOSTER:
                sprintf(buffer, "%s: (%s)", modeMainOptions[i], infiniteBooster ? "ENABLED" : "DISABLED");
                break;

            case LOAD_GAME:
                if (gSaveFileIndex == 0)
                    sprintf(buffer, "%s: Profile.dat (Default)", modeMainOptions[i]);
                else
                {
                    const char* path = gSaveFiles[gSaveFileIndex - 1];
                    const char* name = strrchr(path, '\\');
                    name = name ? name + 1 : path;
                    sprintf(buffer, "%s: %s", modeMainOptions[i], name);
                }
                break;

            case GIVE_WEAPON:
            case REMOVE_WEAPON:
                sprintf(buffer, "%s: %s (%d)", modeMainOptions[i],
                    (weaponChosen >= 0 && weaponChosen < gArmsCount) ? gArmsNames[weaponChosen] : "Unknown",
                    weaponChosen);
                break;

            case GIVE_ITEM:
            case REMOVE_ITEM:
                sprintf(buffer, "%s: %s (%d)", modeMainOptions[i],
                    (itemChosen >= 0 && itemChosen < gItemCount) ? gItemNames[itemChosen] : "Unknown",
                    itemChosen);
                break;

            case EQUIP_ITEM:
            case UNEQUIP_ITEM:
            {
                int index = GetEquipIndex(equipChosen);
                const char* name = (index >= 0 && index < gEquipCount) ? gEquipNames[index] : "Unknown";

                sprintf(buffer, "%s: %s (%d)", modeMainOptions[i], name, equipChosen);
                break;
            }

            case ADD_MAX_LIFE:
                sprintf(buffer, "%s: %d", modeMainOptions[i], lifeChosen);
                break;

            case DAMAGE_PLAYER:
                sprintf(buffer, "%s: %d", modeMainOptions[i], damageChosen);
                break;

            case LEVEL_UP_DOWN:
                sprintf(buffer, "%s %s [Arms %d, Level %d]", modeMainOptions[i], levelDown ? "Down" : "Up", gArmsData[gSelectedArms].code, gArmsData[gSelectedArms].level);
                break;

            case TRANSFER_STAGE:
                sprintf(buffer, "%s: %d", modeMainOptions[i], mapChosen);
                break;

            case CHANGE_MUSIC:
                sprintf(buffer, "%s: %d", modeMainOptions[i], musicChosen);
                break;

            case CHANGE_FLAG:
                sprintf(buffer, "%s: %d (%s)", modeMainOptions[i], flagChosen,
                    GetNPCFlag(flagChosen) ? "True" : "False");
                break;

            case CHANGE_SKIPFLAG:
                sprintf(buffer, "%s: %d (%s)", modeMainOptions[i], skipflagChosen,
                    GetSkipFlag(skipflagChosen) ? "True" : "False");
                break;

            case SPAWN_BULLET:
                sprintf(buffer, "%s: %d (Dir %d)", modeMainOptions[i], bulletChosen, bulletDir);
                break;

            case SPAWN_CARET:
                sprintf(buffer, "%s: %d (Dir %d)", modeMainOptions[i], caretChosen, caretDir);
                break;

            case SPAWN_ENTITY:
                sprintf(buffer, "%s: %d (Dir %d)", modeMainOptions[i], entityChosen, entityDir);
                break;

            case RUN_TSC_EVENT:
                sprintf(buffer, "%s: %d", modeMainOptions[i], tsceventChosen);
                break;

            case SHOW_HITBOXES:
                sprintf(buffer, "%s: %s", modeMainOptions[i], showHitboxes ? "True" : "False");
                break;

            default:
                sprintf(buffer, "%s", modeMainOptions[i]);
                break;
        }

        int y = 32 + ((i - start) * 8);

        PutText(16, y, buffer, DEBUG_TEXT_COLOR(i));
    }
}

void DoDebugActionLR(int mode, int pos, int dir)
{
    PlaySoundObject(1, SOUND_MODE_PLAY);
    switch (mode)
    {
        case DEBUG_MAIN:
            switch (pos)
            {
                case LOAD_GAME:
                {
                    int max = gSaveFileCount;

                    gSaveFileIndex += dir;

                    if (gSaveFileIndex < 0)
                        gSaveFileIndex = max;
                    if (gSaveFileIndex > max)
                        gSaveFileIndex = 0;

                    break;
                }

                case GIVE_WEAPON:
                case REMOVE_WEAPON:
                    weaponChosen += dir;
                    break;
                case GIVE_ITEM:
                case REMOVE_ITEM:
                    itemChosen += dir;
                    break;
                case EQUIP_ITEM:
                case UNEQUIP_ITEM: {
                    if (equipChosen == 0)
                        equipChosen = 1;
                    else {
                        if (dir > 0) {
                            equipChosen <<= 1;
                            if (equipChosen == 0) // Wrapped past 2^31
                                equipChosen = 1;
                        } else if (dir < 0) {
                            equipChosen >>= 1;
                            if (equipChosen == 0) // Wrapped below 2^0
                                equipChosen = 0x80000000; // 2^31
                        }
                    }
                    break;
                }
                case ADD_MAX_LIFE:
                    lifeChosen += dir;
                    break;
                case DAMAGE_PLAYER:
                    damageChosen += dir;
                    break;
                case LEVEL_UP_DOWN:
                    if (abs(dir) == 10)
                    {
                        if (dir == -10)
                            RotationArmsRev();
                        else
                            RotationArms();
                    }
                    else
                    {
                        if (levelDown)
                            levelDown = false;
                        else
                            levelDown = true;
                    }
                    break;
                case TRANSFER_STAGE:
                    mapChosen += dir;
                    break;
                case CHANGE_MUSIC:
                    musicChosen += dir;
                    break;
                case CHANGE_FLAG:
                    flagChosen += dir;
                    break;
                case CHANGE_SKIPFLAG:
                    skipflagChosen += dir;
                    break;
                case SPAWN_BULLET:
                    bulletChosen += dir;
                    break;
                case SPAWN_CARET:
                    caretChosen += dir;
                    break;
                case SPAWN_ENTITY:
                    entityChosen += dir;
                    break;
                case RUN_TSC_EVENT:
                    tsceventChosen += dir;
                    break;
            }
            break;
    }
}

void DoDebugActionReset(int mode, int pos)
{
    PlaySoundObject(1, SOUND_MODE_PLAY);
    switch (mode)
    {
        case DEBUG_MAIN:
            switch (pos)
            {
                case GIVE_WEAPON:
                case REMOVE_WEAPON:
                    weaponChosen = 0;
                    break;
                case GIVE_ITEM:
                case REMOVE_ITEM:
                    itemChosen = 0;
                    break;
                case EQUIP_ITEM:
                case UNEQUIP_ITEM:
                    equipChosen = 1;
                    break;
                case ADD_MAX_LIFE:
                    lifeChosen = 0;
                    break;
                case DAMAGE_PLAYER:
                    damageChosen = 0;
                    break;
                case TRANSFER_STAGE:
                    mapChosen = 0;
                    break;
                case CHANGE_MUSIC:
                    musicChosen = 0;
                    break;
                case CHANGE_FLAG:
                    flagChosen = 0;
                    break;
                case CHANGE_SKIPFLAG:
                    skipflagChosen = 0;
                    break;
                case SPAWN_BULLET:
                    bulletChosen = 0;
                    break;
                case SPAWN_CARET:
                    caretChosen = 0;
                    break;
                case SPAWN_ENTITY:
                    entityChosen = 0;
                    break;
                case RUN_TSC_EVENT:
                    tsceventChosen = 0;
                    break;
            }
            break;
    }
}

void DoDebugActionOK(int mode, int pos)
{
    PlaySoundObject(1, SOUND_MODE_PLAY);
    switch (mode)
    {
        case DEBUG_MAIN:
            switch (pos)
            {
                case RELOAD_LUA:
                    ReloadModScript();
                    break;

                case RELOAD_TABLES:
                    ReloadTables();
                    break;

                case GOD_MODE:
                    if (godModeEnabled)
                        godModeEnabled = false;
                    else
                        godModeEnabled = true;
                    break;

                case INFINITE_BOOSTER:
                    if (infiniteBooster)
                        infiniteBooster = false;
                    else
                        infiniteBooster = true;
                    break;

                case SAVE_GAME:
                    SaveProfile(NULL);
                    break;

                case LOAD_GAME:
                {
                    if (gSaveFileIndex == 0)
                    {
                        LoadProfile(NULL);
                    }
                    else
                    {
                        LoadProfile(gSaveFiles[gSaveFileIndex - 1]);
                    }
                    SetFrameTargetMyChar(16);
                    SetFrameMyChar();
                    break;
                }

                case GIVE_WEAPON:
                    AddArmsData(weaponChosen, 0);
                    break;

                case REMOVE_WEAPON:
                    SubArmsData(weaponChosen);
                    break;

                case GIVE_ITEM:
                    AddItemData(itemChosen);
                    break;

                case REMOVE_ITEM:
                    SubItemData(itemChosen);
                    break;

                case EQUIP_ITEM:
                    EquipItem(equipChosen, TRUE);
                    break;

                case UNEQUIP_ITEM:
                    EquipItem(equipChosen, FALSE);
                    break;

                case RESTORE_LIFE:
                    AddLifeMyChar(1000);
                    FullArmsEnergy();
                    break;

                case ADD_MAX_LIFE:
                    AddMaxLifeMyChar(lifeChosen);
                    break;

                case DAMAGE_PLAYER:
                    DamageMyChar_ModCS(damageChosen);
                    break;

                case LEVEL_UP_DOWN:
                    if (levelDown)
                    {
                        if (gArmsData[gSelectedArms].level > 1)
                        {
                            --gArmsData[gSelectedArms].level;

                            int lv = gArmsData[gSelectedArms].level - 1;
                            int arms_code = gArmsData[gSelectedArms].code;

                            gArmsData[gSelectedArms].exp = autpiArmsLevelTable[arms_code].exp[lv];

                            if (gMC.life > 0 && gArmsData[gSelectedArms].code != 13)
                                SetCaret(gMC.x, gMC.y, CARET_LEVEL_UP, DIR_RIGHT);
                        }
                        else
                            gArmsData[gSelectedArms].exp = 0;
                    }
                    else
                    {
                        if (gArmsData[gSelectedArms].level != 3)
                        {
                            ++gArmsData[gSelectedArms].level;
                            gArmsData[gSelectedArms].exp = 0;

                            if (gArmsData[gSelectedArms].code != 13)
                            {
                                PlaySoundObject(27, SOUND_MODE_PLAY);
                                SetCaret(gMC.x, gMC.y, CARET_LEVEL_UP, DIR_LEFT);
                            }
                        }
                        else
                            gArmsData[gSelectedArms].exp = autpiArmsLevelTable[gArmsData[gSelectedArms].code].exp[gArmsData[gSelectedArms].level-1];
                    }
                    break;

                case TRANSFER_STAGE:
                    if (!TransferStage(mapChosen, 0, 0, 0))
                        PlaySoundObject(158, SOUND_MODE_PLAY);
                    break;

                case CHANGE_MUSIC:
                    ChangeMusic((MusicID)musicChosen);
                    break;

                case CHANGE_FLAG:
                    if (GetNPCFlag(flagChosen))
                        CutNPCFlag(flagChosen);
                    else
                        SetNPCFlag(flagChosen);
                    break;

                case CHANGE_SKIPFLAG:
                    if (GetSkipFlag(skipflagChosen))
                        CutSkipFlag(skipflagChosen);
                    else
                        SetSkipFlag(skipflagChosen);
                    break;
            
                case SPAWN_BULLET:
                    SetBullet(bulletChosen, gMC.x, gMC.y - (0x32 * 0x200), bulletDir);
                    break;

                case SPAWN_CARET:
                    SetCaret(gMC.x, gMC.y - (0x32 * 0x200), caretChosen, caretDir);
                    break;

                case SPAWN_ENTITY:
                    SetNpChar(entityChosen, gMC.x, gMC.y - (0x32 * 0x200), 0, 0, entityDir, NULL, 0x100);
                    break;

                case RUN_TSC_EVENT:
                    StartTextScript(tsceventChosen);
                    break;

                case SHOW_HITBOXES:
                    if (showHitboxes)
                        showHitboxes = false;
                    else
                        showHitboxes = true;
                    break;
            }
        break;
    }
}

void DoDebugActionItem(int mode, int pos)
{
    PlaySoundObject(1, SOUND_MODE_PLAY);
    switch (mode)
    {
        case DEBUG_MAIN:
            switch (pos)
            {
                case SPAWN_BULLET: // increment direction up to 4 and then wrap around
                    if (bulletDir < 4)
                        ++bulletDir;
                    else
                        bulletDir = 0;
                    break;

                case SPAWN_CARET: // increment direction up to 4 and then wrap around
                    if (caretDir < 4)
                        ++caretDir;
                    else
                        caretDir = 0;
                    break;
                
                case SPAWN_ENTITY: // increment direction up to 4 and then wrap around
                    if (entityDir < 4)
                        ++entityDir;
                    else
                        entityDir = 0;

                    break;
            }
        break;
    }
}

// The debug menu itself
void DebugMenu()
{
    RECT rcArrow = {0 + 12, 240, 12 + 12, 250};
    PutText(0, 0, "AUTPI DEBUG", 0xFFFFFF);
    char pageText[32];
    sprintf(pageText, "Page %d/%d", gDebugMenuPage + 1, DEBUG_PAGE_COUNT);
    PutText(0, 8, pageText, 0xFFFFFF);

    PutText(WINDOW_WIDTH - 150, 0, "CONTROLS:", 0xFFFFFF);
    PutText(WINDOW_WIDTH - 150, 8, "Left/Right in/decrease by 1", 0xFFFFFF);
    PutText(WINDOW_WIDTH - 150, 16, "A/S in/decrease by 10", 0xFFFFFF);
    PutText(WINDOW_WIDTH - 150, 24, "Shift + A/S in/decrease by 100", 0xFFFFFF);

    PutBitmap3(&grcGame, 0, 32 + ((gDebugModePosition) * 8), &rcArrow, SURFACE_ID_TEXT_BOX);

    switch (gCurrentDebugMode)
    {
        case DEBUG_MAIN:
            DebugModeMain();
            break;
    }

    if (gKeyTrg & gKeyOk)
        DoDebugActionOK(gCurrentDebugMode, gDebugModePosition);

    if (gKeyTrg & gKeyCancel)
        DoDebugActionReset(gCurrentDebugMode, gDebugModePosition);

    if (gKeyTrg & gKeyItem)
        DoDebugActionItem(gCurrentDebugMode, gDebugModePosition);

    if (gKeyTrg & gKeyLeft)
        DoDebugActionLR(gCurrentDebugMode, gDebugModePosition, -1);

    if (gKeyTrg & gKeyRight)
        DoDebugActionLR(gCurrentDebugMode, gDebugModePosition, 1);

    if (gKeyTrg & gKeyArmsRev)
    {
        if (gKey & KEY_SHIFT)
            DoDebugActionLR(gCurrentDebugMode, gDebugModePosition, -100);
        else
            DoDebugActionLR(gCurrentDebugMode, gDebugModePosition, -10);
    }

    if (gKeyTrg & gKeyArms)
    {
        if (gKey & KEY_SHIFT)
            DoDebugActionLR(gCurrentDebugMode, gDebugModePosition, 100);
        else
            DoDebugActionLR(gCurrentDebugMode, gDebugModePosition, 10);
    }
}

int EnterDebugMenu()
{
    LoadSaveFiles(gDebugSavesPath);
    gSaveFileIndex = 0;
    int return_value = 0;
    RECT rcView = {0, 0, WINDOW_WIDTH, WINDOW_HEIGHT};

    for (;;)
	{
        GetTrg();

        if (gKey & KEY_ESCAPE)
        {
            return_value = 1;
            break;
        }

        /*
        if (gKeyTrg & gKeyArms)
        {
            if (gCurrentDebugMode == (DEBUG_END_MODE - 1))
                gCurrentDebugMode = 0;
            else
                ++gCurrentDebugMode;
        }

        if (gKeyTrg & gKeyArmsRev)
        {
            if (gCurrentDebugMode == 0)
                gCurrentDebugMode = (DEBUG_END_MODE - 1);
            else
                --gCurrentDebugMode;
        }
        */

        // Move it up and down
        if (gKeyTrg & gKeyDown)
        {
            PlaySoundObject(1, SOUND_MODE_PLAY);

            int maxOnPage = DEBUG_OPTIONS_PER_PAGE;
            int maxIndex = DEBUG_OPTIONS_END - 1;

            int start = gDebugMenuPage * DEBUG_OPTIONS_PER_PAGE;
            int end = start + maxOnPage;

            if (gDebugModePosition + 1 < end && gDebugModePosition + 1 < DEBUG_OPTIONS_END)
                gDebugModePosition++;
            else
            {
                if (gDebugMenuPage < DEBUG_PAGE_COUNT - 1)
                {
                    gDebugMenuPage++;
                    gDebugModePosition = gDebugMenuPage * DEBUG_OPTIONS_PER_PAGE;
                }
                else
                {
                    gDebugMenuPage = 0;
                    gDebugModePosition = 0;
                }
            }
        }

        if (gKeyTrg & gKeyUp)
        {
            PlaySoundObject(1, SOUND_MODE_PLAY);

            if (gDebugModePosition > gDebugMenuPage * DEBUG_OPTIONS_PER_PAGE)
                gDebugModePosition--;
            else
            {
                if (gDebugMenuPage > 0)
                {
                    gDebugMenuPage--;
                    gDebugModePosition = (gDebugMenuPage + 1) * DEBUG_OPTIONS_PER_PAGE - 1;

                    if (gDebugModePosition >= DEBUG_OPTIONS_END)
                        gDebugModePosition = DEBUG_OPTIONS_END - 1;
                }
                else
                {
                    gDebugMenuPage = DEBUG_PAGE_COUNT - 1;
                    gDebugModePosition = DEBUG_OPTIONS_END - 1;
                }
            }
        }

    	// Draw screen
		//PutBitmap3(&rcView, 0, 0, &rcView, SURFACE_ID_SCREEN_GRAB);
        CortBox(&rcView, 0x000010);
        // PutBitmap3(&rcView, 0, 0, &rcView, SURFACE_ID_FG_OVERLAY); // Only in CSE2LE

        DebugMenu();

        if (!Flip_SystemTask(ghWnd))
		{
			// Quit if window is closed
			return_value = 3;
			break;
		}
    }

    return return_value;
}

int Call_DebugMenu(void)
{
    int return_value = EnterDebugMenu();

	switch (return_value)
	{
		default:
			return_value = enum_ESCRETURN_continue;
			break;

		case 3:
			return_value = enum_ESCRETURN_exit;
			break;
	}

    gKeyTrg = gKey = 0;

    return return_value;
}