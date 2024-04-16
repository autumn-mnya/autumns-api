#pragma once

#include "cave_story.h"

#define MAX_CARET_TABLE_SIZE 5000
#define MAX_CARET_FUNC_TABLE_SIZE 5000

void LoadCaretTable();
void Replacement_ActCaret(void);
void Replacement_SetCaret(int x, int y, int code, int dir);
extern "C" __declspec(dllexport) void AutPI_AddCaret(CARETFUNCTION func, char* author, char* name);