#include <Windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include "TextScr.h"

#include "Lua.h"

#include "../mod_loader.h"
#include "../cave_story.h"

static BOOL fcuking = TRUE;

static int gArguments;
static BOOL gCommand;

int gReadValue;

static int lua_TscRun(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (g_GameFlags & 4)
	{
		SerenaAlert(L, "ModCS.Tsc.Run used while TSC was running");
		printf("Are you sure you did not mean to use ModCS.Tsc.Jump instead?\n");
	}

	if (!StartTextScript(no))
		SerenaAlert(L, "Unable to run TSC event");

	return 0;
}

static int lua_TscJump(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (!(g_GameFlags & 4))
	{
		SerenaAlert(L, "ModCS.Tsc.Jump used outside of running TSC");
		printf("Are you sure you did not mean to use ModCS.Tsc.Run instead?\n");
	}

	if (!JumpTextScript(no))
		SerenaAlert(L, "Unable to jump to TSC event");
	else
		gReadValue = 0;

	return 0;
}

static int lua_TscWait(lua_State* L)
{
	if (!(g_GameFlags & 4))
		SerenaAlert(L, "ModCS.Tsc.Wait used outside of running TSC");

	gTS.mode = 4;
	gTS.wait_next = (int)luaL_checknumber(L, 1);

	return 0;
}

void GetTextScriptString(char** returnData, int start)
{
	int i = 0;
	while (gTS.data[start] != '$') {
		(*returnData)[i] = gTS.data[start];
		start++;
		i++;
	}
	// Insert the null terminator overtop the $
	(*returnData)[i] = '\0';
}

static int lua_TscGetString(lua_State* L)
{
	int start = gTS.p_read + 4; // required

	// Find the length of the string
	int length = 0;
	while (gTS.data[start + length] != '$') {
		length++;
	}

	// Allocate memory dynamically based on the length of the string
	char* string2 = (char*)malloc((length + 1) * sizeof(char));
	if (string2 == NULL) {
		// Handle memory allocation failure
		return 0; // or appropriate error code
	}

	// Call GetTextScriptString and pass the dynamically allocated memory
	GetTextScriptString(&string2, start);

	lua_pushstring(L, string2);
	
	free(string2); // Free dynamically allocated memory

	gTS.p_read += (length + 1); // silly way to fix the command to skip the string after we've read it
	return 1;
}

static int lua_TscGetArgument(lua_State* L)
{
	int no = (int)luaL_checknumber(L, 1);

	if (!gCommand)
		SerenaAlert(L, "ModCS.Tsc.GetArgument used outside of TSC command");

	if (no > gArguments)
		gArguments = no;

	if (no <= 1)
		gReadValue += 4;
	else
		gReadValue += 5;

	int x = GetTextScriptNo(gTS.p_read + 4 + (no - 1) * 5);

	lua_pushnumber(L, x);

	return 1;
}

static int lua_TscIsRunning(lua_State* L)
{
	if (g_GameFlags & 4)
		lua_pushboolean(L, TRUE);
	else
		lua_pushboolean(L, FALSE);

	return 1;
}

FUNCTION_TABLE TscFunctionTable[FUNCTION_TABLE_TSC_SIZE] =
{
	{"Run", lua_TscRun},
	{"Jump", lua_TscJump},
	{"Wait", lua_TscWait},
	{"GetArgument", lua_TscGetArgument},
	{"GetString", lua_TscGetString},
	{"IsRunning", lua_TscIsRunning}
};

int TSCCommandModScript(char command[4])
{
	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "Tsc");
	lua_getfield(gL, -1, "Command");
	lua_getfield(gL, -1, command);

	if (lua_isnil(gL, -1))
	{
		char trolololo[0x10];
		sprintf(trolololo, "Command%.3s", command);
		lua_getfield(gL, -3, trolololo);

		if (lua_isnil(gL, -1))
		{
			lua_settop(gL, 0); // Clear stack
			return -1;
		}

		if (fcuking)
		{
			printf("WARNING: Defining TSC Command functions using ModCS.Tsc.CommandXXX (where XXX is the TSC Command) has been deprecated. It's recommended to define TSC Command functions in the ModCS.Tsc.Command namespace instead.\n");
			fcuking = FALSE;
		}
	}

	gArguments = 0; // Reset number of arguments
	gReadValue = 4;
	gCommand = TRUE;

	if (lua_pcall(gL, 0, 1, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		return -2;
	}

	int returnval = 1;

	// Check if there is return value
	// We can use this value as returned exit code (0 = exit, 1 = continue, 2 = restart)
	if (lua_type(gL, -1) == LUA_TNUMBER) {
		returnval = (int)lua_tonumber(gL, -1);
	}

	// Do nothing if this is invalid
	if (returnval < 0 || returnval > 2) {
		returnval = 1;
	}

	gTS.p_read += gReadValue;

	gCommand = FALSE;
	lua_settop(gL, 0); // Clear stack

	return returnval;
}