#pragma once

#include "cave_story.h"

#define MAX_NPC_TABLE_SIZE 20000

void ActNpcCode(NPCHAR* npc, int code_char);
void ChangeNpChar(NPCHAR* npc, int code_char);

void Replacement_ActNpChar(void);
void Replacement_ChangeNpCharByEvent(int code_event, int code_char, int dir);
void Replacement_ChangeCheckableNpCharByEvent(int code_event, int code_char, int dir);
extern "C" __declspec(dllexport) void AutPI_AddEntity(NPCFUNCTION func, char* author, char* name);