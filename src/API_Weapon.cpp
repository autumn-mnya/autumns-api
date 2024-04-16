#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "API_Weapon.h"

#include "mod_loader.h"
#include "cave_story.h"

static int empty;

BULLET_TABLE gBulTblExtra[MAX_BULLET_TABLE];

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
	if (no < 47)
	{
		gBul[i].damage = gBulTbl[no].damage;
		gBul[i].life = gBulTbl[no].life;
		gBul[i].life_count = gBulTbl[no].life_count;
		gBul[i].bbits = gBulTbl[no].bbits;
		gBul[i].enemyXL = gBulTbl[no].enemyXL * 0x200;
		gBul[i].enemyYL = gBulTbl[no].enemyYL * 0x200;
		gBul[i].blockXL = gBulTbl[no].blockXL * 0x200;
		gBul[i].blockYL = gBulTbl[no].blockYL * 0x200;
		gBul[i].view.back = gBulTbl[no].view.back * 0x200;
		gBul[i].view.front = gBulTbl[no].view.front * 0x200;
		gBul[i].view.top = gBulTbl[no].view.top * 0x200;
		gBul[i].view.bottom = gBulTbl[no].view.bottom * 0x200;
	}
	else
	{
		gBul[i].damage = gBulTblExtra[no - 47].damage;
		gBul[i].life = gBulTblExtra[no - 47].life;
		gBul[i].life_count = gBulTblExtra[no - 47].life_count;
		gBul[i].bbits = gBulTblExtra[no - 47].bbits;
		gBul[i].enemyXL = gBulTblExtra[no - 47].enemyXL * 0x200;
		gBul[i].enemyYL = gBulTblExtra[no - 47].enemyYL * 0x200;
		gBul[i].blockXL = gBulTblExtra[no - 47].blockXL * 0x200;
		gBul[i].blockYL = gBulTblExtra[no - 47].blockYL * 0x200;
		gBul[i].view.back = gBulTblExtra[no - 47].view.back * 0x200;
		gBul[i].view.front = gBulTblExtra[no - 47].view.front * 0x200;
		gBul[i].view.top = gBulTblExtra[no - 47].view.top * 0x200;
		gBul[i].view.bottom = gBulTblExtra[no - 47].view.bottom * 0x200;
	}

	gBul[i].x = x;
	gBul[i].y = y;
}

void addNewEntryToBulTblExtra(signed char damage, signed char life, int life_count, int bbits, int enemyXL, int enemyYL, int blockXL, int blockYL, OTHER_RECT view) {
	static int nextIndex = 0;

	if (nextIndex < 3000) {
		gBulTblExtra[nextIndex].damage = damage;
		gBulTblExtra[nextIndex].life = life;
		gBulTblExtra[nextIndex].life_count = life_count;
		gBulTblExtra[nextIndex].bbits = bbits;
		gBulTblExtra[nextIndex].enemyXL = enemyXL;
		gBulTblExtra[nextIndex].enemyYL = enemyYL;
		gBulTblExtra[nextIndex].blockXL = blockXL;
		gBulTblExtra[nextIndex].blockYL = blockYL;
		gBulTblExtra[nextIndex].view = view;
		nextIndex++;
	}
	else {
		// Handle error: gBulTblExtra array is full
		printf("Error: Cannot add more entries, gBulTblExtra is full.\n");
	}
}

void ShootBullet_Custom(int level)
{
	int bul_no;
	static int wait;

	if (CountArmsBullet(14) > 4)
		return;

	switch (level)
	{
		case 1:
			bul_no = 47;
			break;

		case 2:
			bul_no = 48;
			break;

		case 3:
			bul_no = 49;
			break;
	}

	if (!(gKey & gKeyShot))
		gMC.rensha = 6;

	if (gKey & gKeyShot)
	{
		if (++gMC.rensha < 6)
			return;

		gMC.rensha = 0;

		if (!UseArmsEnergy(1))
		{
			PlaySoundObject(37, SOUND_MODE_PLAY);

			if (empty == 0)
			{
				SetCaret(gMC.x, gMC.y, CARET_EMPTY, DIR_LEFT);
				empty = 50;
			}

			return;
		}

		if (gMC.up)
		{
			if (level == 3)
				gMC.ym += 0x100;

			if (gMC.direct == 0)
			{
				SetBullet(bul_no, gMC.x - (3 * 0x200), gMC.y - (8 * 0x200), 1);
				SetCaret(gMC.x - (3 * 0x200), gMC.y - (8 * 0x200), CARET_SHOOT, DIR_LEFT);
			}
			else
			{
				SetBullet(bul_no, gMC.x + (3 * 0x200), gMC.y - (8 * 0x200), 1);
				SetCaret(gMC.x + (3 * 0x200), gMC.y - (8 * 0x200), CARET_SHOOT, DIR_LEFT);
			}
		}
		else if (gMC.down)
		{
			if (level == 3)
			{
				if (gMC.ym > 0)
					gMC.ym /= 2;

				if (gMC.ym > -0x400)
				{
					gMC.ym -= 0x200;
					if (gMC.ym < -0x400)
						gMC.ym = -0x400;
				}
			}

			if (gMC.direct == 0)
			{
				SetBullet(bul_no, gMC.x - (3 * 0x200), gMC.y + (8 * 0x200), 3);
				SetCaret(gMC.x - (3 * 0x200), gMC.y + (8 * 0x200), CARET_SHOOT, DIR_LEFT);
			}
			else
			{
				SetBullet(bul_no, gMC.x + (3 * 0x200), gMC.y + (8 * 0x200), 3);
				SetCaret(gMC.x + (3 * 0x200), gMC.y + (8 * 0x200), CARET_SHOOT, DIR_LEFT);
			}
		}
		else
		{
			if (gMC.direct == 0)
			{
				SetBullet(bul_no, gMC.x - (12 * 0x200), gMC.y + (3 * 0x200), 0);
				SetCaret(gMC.x - (12 * 0x200), gMC.y + (3 * 0x200), CARET_SHOOT, DIR_LEFT);
			}
			else
			{
				SetBullet(bul_no, gMC.x + (12 * 0x200), gMC.y + (3 * 0x200), 2);
				SetCaret(gMC.x + (12 * 0x200), gMC.y + (3 * 0x200), CARET_SHOOT, DIR_LEFT);
			}
		}

		if (level == 3)
			PlaySoundObject(49, SOUND_MODE_PLAY);
		else
			PlaySoundObject(32, SOUND_MODE_PLAY);
	}
	else
	{
		++wait;

		if (gMC.equip & EQUIP_TURBOCHARGE)
		{
			if (wait > 1)
			{
				wait = 0;
				ChargeArmsEnergy(1);
			}
		}
		else
		{
			if (wait > 4)
			{
				wait = 0;
				ChargeArmsEnergy(1);
			}
		}
	}
}

void ShootBulletAutPI()
{
	static int soft_rensha;	// 'rensha' is Japanese for 'rapid-fire', apparently

	if (empty != 0)
		--empty;

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

	switch (gArmsData[gSelectedArms].code)
	{
		case 14:
			ShootBullet_Custom(1);
			break;
	}
}

void ActBulletAutPI()
{
	int i;

	for (i = 0; i < BULLET_MAX; ++i)
	{
		if (gBul[i].cond & 0x80)
		{
			if (gBul[i].life < 1)
			{
				gBul[i].cond = 0;
				continue;
			}

			switch (gBul[i].code_bullet)
			{
				// Snake
			case 47:
				ActBullet_Frontia1(&gBul[i]);
				break;
			case 48:
				ActBullet_Frontia1(&gBul[i]);
				break;
			case 49:
				ActBullet_Frontia1(&gBul[i]);
				break;
			}
		}
	}
}

// 0x4105A6
void ReplacementForShootBullet()
{
	if (gArmsData[gSelectedArms].code < 14)
		ShootBullet();
	else
		ShootBulletAutPI();
}

// 0x4105AB
void ReplacementForActBullet()
{
	ActBullet();
	ActBulletAutPI();
}