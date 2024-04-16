#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "API_Caret.h"
#include "Main.h"

#include "mod_loader.h"
#include "cave_story.h"

// Global variables
CARET_TABLE gCaretTableAPI[MAX_CARET_TABLE_SIZE];
CARETFUNCTION gpCaretAPIFuncTbl[MAX_CARET_FUNC_TABLE_SIZE];
size_t caretFuncCount = 0;

void LoadCaretTable()
{
	FILE* fp;
	char path[MAX_PATH];

	// Construct the file path
	sprintf(path, "%s\\%s", gDataPath, "caret.tbl");

	// Open the file for writing
	fp = fopen(path, "rb");
	if (fp == NULL) {
		// Handle the error...
		return;
	}

	// Read the data to the file
	fread(gCaretTableAPI, sizeof(CARET_TABLE), MAX_CARET_TABLE_SIZE, fp);

	// Close the file
	fclose(fp);
}

void Replacement_ActCaret(void)
{
	int i;
	int code;

	for (i = 0; i < CARET_MAX; ++i)
	{
		if (gCrt[i].cond & 0x80)
		{
			code = gCrt[i].code;
			if (code <= 17)
				gpCaretFuncTbl[code](&gCrt[i]);
			else
				gpCaretAPIFuncTbl[code - 18](&gCrt[i]);
		}
	}
}

void Replacement_SetCaret(int x, int y, int code, int dir)
{
	int c;
	for (c = 0; c < CARET_MAX; ++c)
		if (gCrt[c].cond == 0)
			break;

	if (c == CARET_MAX)
		return;

	memset(&gCrt[c], 0, sizeof(CARET));
	gCrt[c].cond = 0x80;
	gCrt[c].code = code;
	gCrt[c].x = x;
	gCrt[c].y = y;
	gCrt[c].view_left = gCaretTableAPI[code].view_left;
	gCrt[c].view_top = gCaretTableAPI[code].view_top;
	gCrt[c].direct = dir;
}

void AutPI_AddCaret(CARETFUNCTION func, char* author, char* name) {
	if (caretFuncCount < MAX_CARET_FUNC_TABLE_SIZE) {
		// Add the new function to the end of the array
		gpCaretAPIFuncTbl[caretFuncCount++] = func;
		printf("Added CARET '%s:%s' to caret function table with ID %d.\n", author, name, caretFuncCount + 17);
	}
	else {
		fprintf(stderr, "Maximum CARET count reached. Cannot add more functions.\n");
	}
}