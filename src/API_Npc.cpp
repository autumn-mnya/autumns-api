#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "API_Npc.h"
#include "lua/Npc.h"

#include "mod_loader.h"
#include "cave_story.h"

// Global variables
NPCFUNCTION gpEntityFuncTbl[MAX_NPC_TABLE_SIZE];
size_t entityFuncCount = 0;

void ActNpcCode(NPCHAR* npc, int code_char)
{
	if (code_char <= 360)
		gpNpcFuncTbl[code_char](npc);
	else
		gpEntityFuncTbl[code_char - 361](npc);
}

void ChangeNpChar(NPCHAR* npc, int code_char)
{
	npc->bits &= ~(NPC_SOLID_SOFT | NPC_IGNORE_TILE_44 | NPC_INVULNERABLE | NPC_IGNORE_SOLIDITY | NPC_BOUNCY | NPC_SHOOTABLE | NPC_SOLID_HARD | NPC_REAR_AND_TOP_DONT_HURT | NPC_SHOW_DAMAGE);	// Clear these flags
	npc->code_char = code_char;
	npc->bits |= (*gNpcTable)[npc->code_char].bits;
	npc->exp = (*gNpcTable)[npc->code_char].exp;
	SetUniqueParameter(npc);
	npc->cond |= 0x80;
	npc->act_no = 0;
	npc->act_wait = 0;
	npc->count1 = 0;
	npc->count2 = 0;
	npc->ani_no = 0;
	npc->ani_wait = 0;
	npc->xm = 0;
	npc->ym = 0;

	if (code_char <= 360)
		gpNpcFuncTbl[code_char](npc);
	else
		gpEntityFuncTbl[code_char](npc);
}

// Call this instead of calling any NPC act function directly
#pragma runtime_checks("s", off)
void CallNPCActFunction(NPCHAR* npc)
{
	// MSVC syntax
	__asm {
		push ebx
		push esi
		push edi
	}

	if (npc->code_char <= 360)
		gpNpcFuncTbl[npc->code_char](npc);
	else
		gpEntityFuncTbl[npc->code_char - 361](npc);

	__asm {
		pop edi
		pop esi
		pop ebx
	}
}
#pragma runtime_checks("s", restore)

void Replacement_ActNpChar(void)
{
	int i;
	int code_char;
	int result;
	char errormsg[256];

	for (i = 0; i < NPC_MAX; ++i)
	{
		if (gNPC[i].cond & 0x80)
		{
			code_char = gNPC[i].code_char;

			result = NpcActModScript(code_char, i);

			if (result == 1)
			{
				CallNPCActFunction(&gNPC[i]);
			}
			else if (result == 0)
			{
				sprintf(errormsg, "Couldn't execute Act function of NPC ActNo. %d", code_char);
				MessageBoxA(ghWnd, errormsg, "ModScript Error", MB_OK);
				return;
			}

			if (gNPC[i].shock)
				--gNPC[i].shock;
		}
	}
}

void Replacement_ChangeNpCharByEvent(int code_event, int code_char, int dir)
{
	int n;

	for (n = 0; n < NPC_MAX; ++n)
	{
		if ((gNPC[n].cond & 0x80) && gNPC[n].code_event == code_event)
		{
			gNPC[n].bits &= ~(NPC_SOLID_SOFT | NPC_IGNORE_TILE_44 | NPC_INVULNERABLE | NPC_IGNORE_SOLIDITY | NPC_BOUNCY | NPC_SHOOTABLE | NPC_SOLID_HARD | NPC_REAR_AND_TOP_DONT_HURT | NPC_SHOW_DAMAGE);	// Clear these flags
			gNPC[n].code_char = code_char;
			gNPC[n].bits |= (*gNpcTable)[gNPC[n].code_char].bits;
			gNPC[n].exp = (*gNpcTable)[gNPC[n].code_char].exp;
			SetUniqueParameter(&gNPC[n]);
			gNPC[n].cond |= 0x80;
			gNPC[n].act_no = 0;
			gNPC[n].act_wait = 0;
			gNPC[n].count1 = 0;
			gNPC[n].count2 = 0;
			gNPC[n].ani_no = 0;
			gNPC[n].ani_wait = 0;
			gNPC[n].xm = 0;
			gNPC[n].ym = 0;

			if (dir == 5)
			{
				// Another empty case that has to exist for the same assembly to be generated
			}
			else if (dir == 4)
			{
				if (gNPC[n].x < gMC.x)
					gNPC[n].direct = 2;
				else
					gNPC[n].direct = 0;
			}
			else
			{
				gNPC[n].direct = dir;
			}

			if (code_char <= 360)
				gpNpcFuncTbl[code_char](&gNPC[n]);
			else
				gpEntityFuncTbl[code_char - 361](&gNPC[n]);
		}
	}
}

void Replacement_ChangeCheckableNpCharByEvent(int code_event, int code_char, int dir)
{
	int n;

	for (n = 0; n < NPC_MAX; ++n)
	{
		if (!(gNPC[n].cond & 0x80) && gNPC[n].code_event == code_event)
		{
			gNPC[n].bits &= ~(NPC_SOLID_SOFT | NPC_IGNORE_TILE_44 | NPC_INVULNERABLE | NPC_IGNORE_SOLIDITY | NPC_BOUNCY | NPC_SHOOTABLE | NPC_SOLID_HARD | NPC_REAR_AND_TOP_DONT_HURT | NPC_SHOW_DAMAGE);	// Clear these flags
			gNPC[n].bits |= NPC_INTERACTABLE;
			gNPC[n].code_char = code_char;
			gNPC[n].bits |= (*gNpcTable)[gNPC[n].code_char].bits;
			gNPC[n].exp = (*gNpcTable)[gNPC[n].code_char].exp;
			SetUniqueParameter(&gNPC[n]);
			gNPC[n].cond |= 0x80;
			gNPC[n].act_no = 0;
			gNPC[n].act_wait = 0;
			gNPC[n].count1 = 0;
			gNPC[n].count2 = 0;
			gNPC[n].ani_no = 0;
			gNPC[n].ani_wait = 0;
			gNPC[n].xm = 0;
			gNPC[n].ym = 0;

			if (dir == 5)
			{
				// Another empty case that has to exist for the same assembly to be generated
			}
			else if (dir == 4)
			{
				if (gNPC[n].x < gMC.x)
					gNPC[n].direct = 2;
				else
					gNPC[n].direct = 0;
			}
			else
			{
				gNPC[n].direct = (signed char)dir;
			}

			if (code_char <= 360)
				gpNpcFuncTbl[code_char](&gNPC[n]);
			else
				gpEntityFuncTbl[code_char - 361](&gNPC[n]);
		}
	}
}

// Function to add a new ActEntity function to the table
void AutPI_AddEntity(NPCFUNCTION func, char* author, char* name) {
    if (entityFuncCount < MAX_NPC_TABLE_SIZE) {
        // Add the new function to the end of the array
        gpEntityFuncTbl[entityFuncCount++] = func;
		printf("Added NPC '%s:%s' to entity function table with ID %d.\n", author, name, entityFuncCount + 360);
    }
    else {
        fprintf(stderr, "Maximum NPC count reached. Cannot add more functions.\n");
    }
}