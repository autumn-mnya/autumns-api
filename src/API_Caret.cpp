#include <Windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

#include "API_Caret.h"
#include "Main.h"

#include "mod_loader.h"
#include "cave_story.h"

#include "lua/Lua_Caret.h"

// Global variables
CARET_TABLE autpiCaretTable[MAX_CARET_TABLE_SIZE];
CARETFUNCTION gpCaretAPIFuncTbl[MAX_CARET_FUNC_TABLE_SIZE];
size_t caretFuncCount = 0;

void ActCaretCode(CARET* crt, int code)
{
	gpCaretFuncTbl[code](crt);
}

void ActCaretNull(CARET* crt)
{
	(void)crt;
}

void SetDefaultCaretTable()
{
	int i = 0;

	for (i = 0; i < 18; ++i)
	{
		autpiCaretTable[i].view_left = gCaretTable[i].view_left;
		autpiCaretTable[i].view_top = gCaretTable[i].view_top;
	}
}

void LoadCaretTable()
{
	FILE* fp;
	char path[MAX_PATH];

	// Construct the file path
	sprintf(path, "%s\\%s", gDataPath, "caret.tbl");
	memset(autpiCaretTable, 0, sizeof(CARET_TABLE));

	// Open the file for reading
	fp = fopen(path, "rb");
	if (fp == NULL) {
		// Handle the error...
		printf("%s%s", "caret.tbl", " was not found.\nUsing default caret table inside executable instead!\n");
		SetDefaultCaretTable();
		return;
	}

	// Read the data to the file
	fread(autpiCaretTable, sizeof(CARET_TABLE), MAX_CARET_TABLE_SIZE, fp);

	// Close the file
	fclose(fp);
}

#pragma runtime_checks("s", off)
void CallCaretActFunction(int code, CARET* crt)
{
	// MSVC syntax
	__asm {
		push ebx
		push esi
		push edi
	}

	if (code <= 17)
		gpCaretFuncTbl[code](crt);
	else
		gpCaretAPIFuncTbl[code - 18](crt);

	__asm {
		pop edi
		pop esi
		pop ebx
	}
}
#pragma runtime_checks("s", restore)

void Replacement_ActCaret(void)
{
	int i;
	int code;
	int result;
	char errormsg[256];

	for (i = 0; i < CARET_MAX; ++i)
	{
		if (gCrt[i].cond & 0x80)
		{
			code = gCrt[i].code;

			result = CaretActModScript(code, i);

			if (result == 1)
			{
				CallCaretActFunction(code, &gCrt[i]);
			}
			else if (result == 0)
			{
				sprintf(errormsg, "Couldn't execute Act function of Caret ActNo. %d", code);
				MessageBoxA(ghWnd, errormsg, "ModScript Error", MB_OK);
				return;
			}
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
	gCrt[c].view_left = autpiCaretTable[code].view_left;
	gCrt[c].view_top = autpiCaretTable[code].view_top;
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