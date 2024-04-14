#pragma once

#include "cave_story.h"

void Replacement_ActNpChar(void);
void Replacement_ChangeNpCharByEvent(int code_event, int code_char, int dir);
void Replacement_ChangeCheckableNpCharByEvent(int code_event, int code_char, int dir);
extern "C" __declspec(dllexport) void AutPI_AddEntity(NPCFUNCTION func);