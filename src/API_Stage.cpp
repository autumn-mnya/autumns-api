#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_Stage.h"

#include "File.h"
#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(TransferStageInitElementHandler, TransferStageInitElement)

STAGE_TABLE* gStageTable;

bool stage_table_patched = false;

void PatchStageTable()
{
	ModLoader_WriteLong((void*)0x420C2F, (unsigned int)gStageTable + 0x0);
	ModLoader_WriteLong((void*)0x420C73, (unsigned int)gStageTable + 0x0);

	ModLoader_WriteLong((void*)0x420CB5, (unsigned int)gStageTable + 0x20);
	ModLoader_WriteLong((void*)0x420CF6, (unsigned int)gStageTable + 0x20);
	ModLoader_WriteLong((void*)0x420D38, (unsigned int)gStageTable + 0x20);

	ModLoader_WriteLong((void*)0x420D9E, (unsigned int)gStageTable + 0x40);

	ModLoader_WriteLong((void*)0x420D7A, (unsigned int)gStageTable + 0x44);

	ModLoader_WriteLong((void*)0x420DD9, (unsigned int)gStageTable + 0x64);

	ModLoader_WriteLong((void*)0x420E1C, (unsigned int)gStageTable + 0x84);

	ModLoader_WriteLong((void*)0x420EA8, (unsigned int)gStageTable + 0xA4);

	ModLoader_WriteLong((void*)0x420E6A, (unsigned int)gStageTable + 0xA5);
}

BOOL LoadStageTable(char* name)
{
	char path[MAX_PATH];

	unsigned char* file_buffer;
	size_t file_size;

	// Try to load stage.tbl
	sprintf(path, "%s\\%s", exeDataPath, name);
	file_buffer = LoadFileToMemory(path, &file_size);

	if (file_buffer != NULL)
	{
		const unsigned long entry_count = file_size / 0xE5;

		STAGE_TABLE* pTMT = (STAGE_TABLE*)malloc(entry_count * sizeof(STAGE_TABLE));

		if (pTMT != NULL)
		{
			for (unsigned long i = 0; i < entry_count; ++i)
			{
				unsigned char* entry = file_buffer + i * 0xE5;

				memcpy(pTMT[i].parts, entry, 0x20);
				memcpy(pTMT[i].map, entry + 0x20, 0x20);
				pTMT[i].bkType = (entry[0x40 + 3] << 24) | (entry[0x40 + 2] << 16) | (entry[0x40 + 1] << 8) | entry[0x40];
				memcpy(pTMT[i].back, entry + 0x44, 0x20);
				memcpy(pTMT[i].npc, entry + 0x64, 0x20);
				memcpy(pTMT[i].boss, entry + 0x84, 0x20);
				pTMT[i].boss_no = entry[0xA4];
#ifdef JAPANESE
				memcpy(pTMT[i].name, entry + 0xA5, 0x20);
#else
				memcpy(pTMT[i].name, entry + 0xC5, 0x20);
#endif
			}



			gStageTable = pTMT;

			if (stage_table_patched == false)
				PatchStageTable();

			free(file_buffer);
			return TRUE;
		}

		free(file_buffer);
	}

	printf("Failed to load %s.tbl\n", name);
	return FALSE;
}

void TransferStageInitCode()
{
    ResetFlash();
    ExecuteTransferStageInitElementHandlers();
}

STAGE_TABLE* GetStageTable()
{
	if (stage_table_patched)
		return gStageTable;
	else
		return gTMT;
}

char* GetStageTileset(int stageNo)
{
	STAGE_TABLE* gStage;

	if (stage_table_patched)
		gStage = gStageTable;
	else
		gStage = gTMT;

	return gStage[stageNo].parts;
}

char* GetStageFilename(int stageNo)
{
	STAGE_TABLE* gStage;

	if (stage_table_patched)
		gStage = gStageTable;
	else
		gStage = gTMT;

	return gStage[stageNo].map;
}

int GetStageBackgroundMode(int stageNo)
{
	STAGE_TABLE* gStage;

	if (stage_table_patched)
		gStage = gStageTable;
	else
		gStage = gTMT;

	return gStage[stageNo].bkType;
}

char* GetStageBackground(int stageNo)
{	
	STAGE_TABLE* gStage;

	if (stage_table_patched)
		gStage = gStageTable;
	else
		gStage = gTMT;

	return gStage[stageNo].back;
}

char* GetStageNpcSheet1(int stageNo)
{
	STAGE_TABLE* gStage;

	if (stage_table_patched)
		gStage = gStageTable;
	else
		gStage = gTMT;

	return gStage[stageNo].npc;
}

char* GetStageNpcSheet2(int stageNo)
{
	STAGE_TABLE* gStage;

	if (stage_table_patched)
		gStage = gStageTable;
	else
		gStage = gTMT;

	return gStage[stageNo].boss;
}

int GetStageBossNo(int stageNo)
{
	STAGE_TABLE* gStage;

	if (stage_table_patched)
		gStage = gStageTable;
	else
		gStage = gTMT;

	return gStage[stageNo].boss_no;
}

char* GetStageName(int stageNo)
{
	STAGE_TABLE* gStage;

	if (stage_table_patched)
		gStage = gStageTable;
	else
		gStage = gTMT;

	return gStage[stageNo].name;
}

unsigned char GetTileID(int x, int y)
{
	size_t a;

	if (x < 0 || y < 0 || x >= gMap.width || y >= gMap.length)
		return 0;

	a = *(gMap.data + x + (y * gMap.width));
	return a;
}