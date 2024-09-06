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