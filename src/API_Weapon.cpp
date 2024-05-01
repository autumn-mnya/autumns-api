#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "API_Weapon.h"

#include "mod_loader.h"
#include "cave_story.h"
#include "Main.h"

#include "lua/Lua_ArmsItem.h"
#include "lua/Lua_Bullet.h"

ARMS_LEVEL* autpiArmsLevelTable;
BULLET_TABLE* autpiBulTbl;

void SetDefaultArmsTable()
{
	int i = 0;

	autpiArmsLevelTable = (ARMS_LEVEL*)malloc(15 * sizeof(ARMS_LEVEL));

	for (i = 0; i < 15; ++i)
	{
		autpiArmsLevelTable[i].exp[0] = gArmsLevelTable[i].exp[0];
		autpiArmsLevelTable[i].exp[1] = gArmsLevelTable[i].exp[1];
		autpiArmsLevelTable[i].exp[2] = gArmsLevelTable[i].exp[2];
	}
}

void SetDefaultBulletTable()
{
	int i = 0;

	autpiBulTbl = (BULLET_TABLE*)malloc(47 * sizeof(BULLET_TABLE));

	for (i = 0; i < 47; ++i)
	{
		autpiBulTbl[i].damage = gBulTbl[i].damage;
		autpiBulTbl[i].life = gBulTbl[i].life;
		autpiBulTbl[i].life_count = gBulTbl[i].life_count;
		autpiBulTbl[i].bbits = gBulTbl[i].bbits;
		autpiBulTbl[i].enemyXL = gBulTbl[i].enemyXL;
		autpiBulTbl[i].enemyYL = gBulTbl[i].enemyYL;
		autpiBulTbl[i].blockXL = gBulTbl[i].blockXL;
		autpiBulTbl[i].blockYL = gBulTbl[i].blockYL;
		autpiBulTbl[i].view.front = gBulTbl[i].view.front;
		autpiBulTbl[i].view.top = gBulTbl[i].view.top;
		autpiBulTbl[i].view.back = gBulTbl[i].view.back;
		autpiBulTbl[i].view.bottom = gBulTbl[i].view.bottom;
	}
}

void LoadLevelsTable()
{
	FILE* fp;
	char path[MAX_PATH];
	size_t size;
	int entries;

	sprintf(path, "%s\\%s", gDataPath, "arms_level.tbl");

	size = GetFileSizeLong(path);
	if (size == INVALID_FILE_SIZE)
	{
		printf("%s%s", "arms_level.tbl", " had invalid size.\nUsing default arms_level table inside executable instead!\n");
		SetDefaultArmsTable();
		return;
	}

	entries = (int)(size / 12);

	fp = fopen(path, "rb");
	if (fp == NULL)
	{
		printf("%s%s", "arms_level.tbl", " was not found.\nUsing default arms_level table inside executable instead!\n");
		SetDefaultArmsTable();
		return;
	}

	autpiArmsLevelTable = (ARMS_LEVEL*)malloc(entries * sizeof(ARMS_LEVEL));

	if (autpiArmsLevelTable == NULL)
	{
		fclose(fp);
		free(autpiArmsLevelTable);
		printf("%s%s", "arms_level.tbl", " was null.\nUsing default arms_level table inside executable instead!\n");
		SetDefaultArmsTable();
		return;
	}

	for (int i = 0; i < entries; ++i)
		fread(&autpiArmsLevelTable[i].exp, 12, 1, fp);

	fclose(fp);
	return;
}

void LoadBulletTable()
{
	FILE* fp;
	char path[MAX_PATH];
	size_t size;
	unsigned int entries;

	sprintf(path, "%s\\bullet.tbl", gDataPath);

	size = GetFileSizeLong(path);
	if (size == INVALID_FILE_SIZE)
	{
		printf("%s%s", "bullet.tbl", " had invalid size.\nUsing default bullet table inside executable instead!\n");
		SetDefaultBulletTable();
		return;
	}

	entries = (int)(size / 42);

	fp = fopen(path, "rb");
	if (fp == NULL)
	{
		printf("%s%s", "bullet.tbl", " was not found.\nUsing default bullet table inside executable instead!\n");
		SetDefaultBulletTable();
		return;
	}

	autpiBulTbl = (BULLET_TABLE*)malloc(entries * sizeof(BULLET_TABLE));

	if (autpiBulTbl == NULL)
	{
		fclose(fp);
		free(autpiBulTbl);
		printf("%s%s", "bullet.tbl", " was null.\nUsing default bullet table inside executable instead!\n");
		SetDefaultBulletTable();
		return;
	}

	for (int i = 0; i < entries; ++i)
	{
		fread(&autpiBulTbl[i].damage, 1, 1, fp);
		fread(&autpiBulTbl[i].life, 1, 1, fp);
		fread(&autpiBulTbl[i].life_count, 4, 1, fp);
		fread(&autpiBulTbl[i].bbits, 4, 1, fp);
		fread(&autpiBulTbl[i].enemyXL, 4, 1, fp);
		fread(&autpiBulTbl[i].enemyYL, 4, 1, fp);
		fread(&autpiBulTbl[i].blockXL, 4, 1, fp);
		fread(&autpiBulTbl[i].blockYL, 4, 1, fp);
		fread(&autpiBulTbl[i].view, 16, 1, fp);
	}

	fclose(fp);
	return;
}

void Replacement_AddExpMyChar(int x)
{
	int lv = gArmsData[gSelectedArms].level - 1;
	int arms_code = gArmsData[gSelectedArms].code;

	gArmsData[gSelectedArms].exp += x;

	if (lv == 2)
	{
		if (gArmsData[gSelectedArms].exp >= autpiArmsLevelTable[arms_code].exp[lv])
		{
			gArmsData[gSelectedArms].exp = autpiArmsLevelTable[arms_code].exp[lv];

			if (gMC.equip & EQUIP_WHIMSICAL_STAR)
			{
				if (gMC.star < 3)
					++gMC.star;
			}
		}
	}
	else
	{
		for (; lv < 2; ++lv)
		{
			if (gArmsData[gSelectedArms].exp >= autpiArmsLevelTable[arms_code].exp[lv])
			{
				++gArmsData[gSelectedArms].level;
				gArmsData[gSelectedArms].exp = 0;

				if (gArmsData[gSelectedArms].code != 13)
				{
					PlaySoundObject(27, SOUND_MODE_PLAY);
					SetCaret(gMC.x, gMC.y, CARET_LEVEL_UP, DIR_LEFT);
				}
			}
		}
	}

	if (gArmsData[gSelectedArms].code != 13)
	{
		gMC.exp_count += x;
		gMC.exp_wait = 30;
	}
	else
	{
		gMC.exp_wait = 10;
	}
}

BOOL ReplacementIsMaxExpMyChar(void)
{
	int arms_code;

	if (gArmsData[gSelectedArms].level == 3)
	{
		arms_code = gArmsData[gSelectedArms].code;

		if (gArmsData[gSelectedArms].exp >= autpiArmsLevelTable[arms_code].exp[2])
			return TRUE;
	}

	return FALSE;
}

void Replacement_SetBullet(int no, int x, int y, int dir)
{
	int i = 0;
	while (i < BULLET_MAX && gBul[i].cond & 0x80)
		++i;

	if (i >= BULLET_MAX)
		return;

	memset(&gBul[i], 0, sizeof(BULLET));
	gBul[i].code_bullet = no;
	gBul[i].cond = 0x80;
	gBul[i].direct = dir;
	gBul[i].damage = autpiBulTbl[no].damage;
	gBul[i].life = autpiBulTbl[no].life;
	gBul[i].life_count = autpiBulTbl[no].life_count;
	gBul[i].bbits = autpiBulTbl[no].bbits;
	gBul[i].enemyXL = autpiBulTbl[no].enemyXL * 0x200;
	gBul[i].enemyYL = autpiBulTbl[no].enemyYL * 0x200;
	gBul[i].blockXL = autpiBulTbl[no].blockXL * 0x200;
	gBul[i].blockYL = autpiBulTbl[no].blockYL * 0x200;
	gBul[i].view.back = autpiBulTbl[no].view.back * 0x200;
	gBul[i].view.front = autpiBulTbl[no].view.front * 0x200;
	gBul[i].view.top = autpiBulTbl[no].view.top * 0x200;
	gBul[i].view.bottom = autpiBulTbl[no].view.bottom * 0x200;
	gBul[i].x = x;
	gBul[i].y = y;
}

void Replacement_ShootBullet(void)
{
	static int soft_rensha;	// 'rensha' is Japanese for 'rapid-fire', apparently
	int result;
	char errormsg[256];

	if (empty_caret_timer != 0)
		--empty_caret_timer;

	// Only let the player shoot every 4 frames
	if (soft_rensha != 0)
		--soft_rensha;

	if (gKeyTrg & gKeyShot)
	{
		if (soft_rensha != 0)
			return;

		soft_rensha = 4;
	}

	// Run functions
	if (gMC.cond & 2)
		return;

	result = ShootActModScript(gArmsData[gSelectedArms].code);

	if (result == 1)
	{
		switch (gArmsData[gSelectedArms].code)
		{
		case 1:
			ShootBullet_Frontia1(gArmsData[gSelectedArms].level);
			break;

		case 2:
			ShootBullet_PoleStar(gArmsData[gSelectedArms].level);
			break;

		case 3:
			ShootBullet_FireBall(gArmsData[gSelectedArms].level);
			break;

		case 4:
			ShootBullet_Machinegun1(gArmsData[gSelectedArms].level);
			break;

		case 5:
			ShootBullet_Missile(gArmsData[gSelectedArms].level, FALSE);
			break;

		case 7:
			switch (gArmsData[gSelectedArms].level)
			{
			case 1:
				ShootBullet_Bubblin1();
				break;

			case 2:
				ShootBullet_Bubblin2(2);
				break;

			case 3:
				ShootBullet_Bubblin2(3);
				break;
			}

			break;

		case 9:
			switch (gArmsData[gSelectedArms].level)
			{
			case 1:
				ShootBullet_Sword(1);
				break;

			case 2:
				ShootBullet_Sword(2);
				break;

			case 3:
				ShootBullet_Sword(3);
				break;
			}

			break;

		case 10:
			ShootBullet_Missile(gArmsData[gSelectedArms].level, TRUE);
			break;

		case 12:
			ShootBullet_Nemesis(gArmsData[gSelectedArms].level);
			break;

		case 13:
			ShootBullet_Spur(gArmsData[gSelectedArms].level);
			break;
		}
	}
	else if (result == 0)
	{
		sprintf(errormsg, "Couldn't execute Shoot function of Weapon %d", gArmsData[gSelectedArms].code);
		MessageBoxA(ghWnd, errormsg, "ModScript Error", MB_OK);
		return;
	}

	return;
}


// Old
void ReplacementForShootBullet()
{
	char errormsg[256];
	int result;

	result = ShootActModScript(gArmsData[gSelectedArms].code);

	if (result == 1)
		ShootBullet();
	else if (result == 0)
	{
		sprintf(errormsg, "Couldn't execute Shoot function of Weapon %d", gArmsData[gSelectedArms].code);
		MessageBoxA(ghWnd, errormsg, "ModScript Error", MB_OK);
	}
}

void ActBulletCode(BULLET* bul, int code)
{
	switch (code)
	{
			// Snake
		case 1:
			ActBullet_Frontia1(bul);
			break;
		case 2:
			ActBullet_Frontia2(bul, 2);
			break;
		case 3:
			ActBullet_Frontia2(bul, 3);
			break;

			// Polar Star
		case 4:
			ActBullet_PoleStar(bul, 1);
			break;
		case 5:
			ActBullet_PoleStar(bul, 2);
			break;
		case 6:
			ActBullet_PoleStar(bul, 3);
			break;

			// Fireball
		case 7:
			ActBullet_FireBall(bul, 1);
			break;
		case 8:
			ActBullet_FireBall(bul, 2);
			break;
		case 9:
			ActBullet_FireBall(bul, 3);
			break;

			// Machine Gun
		case 10:
			ActBullet_MachineGun(bul, 1);
			break;
		case 11:
			ActBullet_MachineGun(bul, 2);
			break;
		case 12:
			ActBullet_MachineGun(bul, 3);
			break;

			// Missile Launcher
		case 13:
			ActBullet_Missile(bul, 1);
			break;
		case 14:
			ActBullet_Missile(bul, 2);
			break;
		case 15:
			ActBullet_Missile(bul, 3);
			break;

			// Missile Launcher explosion
		case 16:
			ActBullet_Bom(bul, 1);
			break;
		case 17:
			ActBullet_Bom(bul, 2);
			break;
		case 18:
			ActBullet_Bom(bul, 3);
			break;

			// Bubbler
		case 19:
			ActBullet_Bubblin1(bul);
			break;
		case 20:
			ActBullet_Bubblin2(bul);
			break;
		case 21:
			ActBullet_Bubblin3(bul);
			break;

			// Bubbler level 3 spines
		case 22:
			ActBullet_Spine(bul);
			break;

			// Blade slashes
		case 23:
			ActBullet_Edge(bul);
			break;

			// Falling spike that deals 127 damage
		case 24:
			ActBullet_Drop(bul);
			break;

			// Blade
		case 25:
			ActBullet_Sword1(bul);
			break;
		case 26:
			ActBullet_Sword2(bul);
			break;
		case 27:
			ActBullet_Sword3(bul);
			break;

			// Super Missile Launcher
		case 28:
			ActBullet_SuperMissile(bul, 1);
			break;
		case 29:
			ActBullet_SuperMissile(bul, 2);
			break;
		case 30:
			ActBullet_SuperMissile(bul, 3);
			break;

			// Super Missile Launcher explosion
		case 31:
			ActBullet_SuperBom(bul, 1);
			break;
		case 32:
			ActBullet_SuperBom(bul, 2);
			break;
		case 33:
			ActBullet_SuperBom(bul, 3);
			break;

			// Nemesis
		case 34:	// Identical to case 43
			ActBullet_Nemesis(bul, 1);
			break;
		case 35:
			ActBullet_Nemesis(bul, 2);
			break;
		case 36:
			ActBullet_Nemesis(bul, 3);
			break;

			// Spur
		case 37:
			ActBullet_Spur(bul, 1);
			break;
		case 38:
			ActBullet_Spur(bul, 2);
			break;
		case 39:
			ActBullet_Spur(bul, 3);
			break;

			// Spur trail
		case 40:
			ActBullet_SpurTail(bul, 1);
			break;
		case 41:
			ActBullet_SpurTail(bul, 2);
			break;
		case 42:
			ActBullet_SpurTail(bul, 3);
			break;

			// Curly's Nemesis
		case 43:	// Identical to case 34
			ActBullet_Nemesis(bul, 1);
			break;

			// Screen-nuke that kills all enemies
		case 44:
			ActBullet_EnemyClear(bul);
			break;

			// Whimsical Star
		case 45:
			ActBullet_Star(bul);
			break;
	}
}

BOOL Replacement_ActBullet(void)
{
	int i;
	int code;
	int result;
	char errormsg[256];

	for (i = 0; i < BULLET_MAX; ++i)
	{
		if (gBul[i].cond & 0x80)
		{
			if (gBul[i].life < 1)
			{
				gBul[i].cond = 0;
				continue;
			}

			code = gBul[i].code_bullet;

			result = BulletActModScript(code, i);

			if (result == 1)
				ActBulletCode(&gBul[i], code);
			else if (result == 0)
			{
				sprintf(errormsg, "Couldn't execute Act function of Bullet ActNo. %d", code);
				MessageBoxA(ghWnd, errormsg, "ModScript Error", MB_OK);
				return FALSE;
			}
		}
	}

	return TRUE;
}