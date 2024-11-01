#pragma once

#include <Windows.h>
#include <vector>

#include "cave_story.h"
#include "Main.h"

typedef void (*TransferStageInitElementHandler)();

ELEMENT_HEADERS(TransferStageInitElementHandler, TransferStageInitElement)

extern bool stage_table_patched;
extern STAGE_TABLE* gStageTable;

extern "C" __declspec(dllexport) BOOL LoadStageTable(char* name);
void TransferStageInitCode();
extern "C" __declspec(dllexport) STAGE_TABLE* GetStageTable();
extern "C" __declspec(dllexport) char* GetStageTileset(int stageNo);
extern "C" __declspec(dllexport) char* GetStageFilename(int stageNo);
extern "C" __declspec(dllexport) int GetStageBackgroundMode(int stageNo);
extern "C" __declspec(dllexport) char* GetStageBackground(int stageNo);
extern "C" __declspec(dllexport) char* GetStageNpcSheet1(int stageNo);
extern "C" __declspec(dllexport) char* GetStageNpcSheet2(int stageNo);
extern "C" __declspec(dllexport) int GetStageBossNo(int stageNo);
extern "C" __declspec(dllexport) char* GetStageName(int stageNo);
unsigned char GetTileID(int x, int y);