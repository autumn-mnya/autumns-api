#include <Windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <vector>

extern "C"
{
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

#include "Lua.h"

#include "../Main.h"
#include "../mod_loader.h"
#include "../cave_story.h"
#include "../ModSettings.h"

#include "API_Lua.h"

#include "../API_Boss.h"
#include "../API_Caret.h"
#include "../API_Npc.h"

#include "Lua_ArmsItem.h"
#include "Lua_Bullet.h"
#include "Lua_Caret.h"
#include "Lua_Draw.h"
#include "Lua_Flags.h"
#include "Lua_Frame.h"
#include "Lua_Game.h"
#include "Lua_KeyControl.h"
#include "Lua_Mod.h"
#include "Lua_ModLoader.h"
#include "Lua_MyChar.h"
#include "Lua_Npc.h"
#include "Lua_Profile.h"
#include "Lua_Sound.h"
#include "Lua_Stage.h"
#include "Lua_TextScr.h"

// Credit for the majority of this goes to yasinbread and aikyuu. All I did was port it and add some extra stuff.

lua_State* gL = NULL;

void PrintStack(lua_State* L) {
	int top = lua_gettop(L);
	for (int i = 1; i <= top; i++) {
		printf("%d\t%s\t", i, luaL_typename(L, i));
		switch (lua_type(L, i)) {
		case LUA_TNUMBER:
			printf("%g\n", lua_tonumber(L, i));
			break;
		case LUA_TSTRING:
			printf("%s\n", lua_tostring(L, i));
			break;
		case LUA_TBOOLEAN:
			printf("%s\n", (lua_toboolean(L, i) ? "true" : "false"));
			break;
		case LUA_TNIL:
			printf("%s\n", "nil");
			break;
		default:
			printf("%p\n", lua_topointer(L, i));
			break;
		}
	}
}

void SerenaAlert(lua_State* L, const char* warning)
{
	lua_Debug d;
	lua_getstack(L, 1, &d);
	lua_getinfo(L, "nSl", &d);
	printf("WARNING: %s at line %d\n", warning, d.currentline);
}

BOOL ReadStructBasic(lua_State* L, const char* name, STRUCT_TABLE* table, void* data, int length)
{
	for (int i = 0; i < length; ++i)
	{
		if (strcmp(name, table[i].name) == 0)
		{
			switch (table[i].type)
			{
			case TYPE_NUMBER:
			{
				lua_pushnumber(L, *(int*)((char*)data + table[i].offset));
				break;
			}

			/*case TYPE_STRING:
			{
				...I'll deal with this later, I'll probably not have strings for a while
			}*/

			case TYPE_OTHER_RECT:
			{
				OTHER_RECT* rect = (OTHER_RECT*)lua_newuserdata(L, sizeof(OTHER_RECT));

				*rect = *(OTHER_RECT*)((char*)data + table[i].offset);

				luaL_getmetatable(L, "RangeRectMeta");
				lua_setmetatable(L, -2);

				lua_newtable(L);
				lua_setuservalue(L, -2);
				break;
			}

			case TYPE_RECT:
			{
				RECT* rect = (RECT*)lua_newuserdata(L, sizeof(RECT));

				*rect = *(RECT*)((char*)data + table[i].offset);

				luaL_getmetatable(L, "RectMeta");
				lua_setmetatable(L, -2);

				lua_newtable(L);
				lua_setuservalue(L, -2);
				break;
			}

			case TYPE_COLOR:
			{
				COLOR* color = (COLOR*)lua_newuserdata(L, sizeof(COLOR));

				*color = *(COLOR*)((char*)data + table[i].offset);

				luaL_getmetatable(L, "ColorMeta");
				lua_setmetatable(L, -2);

				lua_newtable(L);
				lua_setuservalue(L, -2);
				break;
			}

			case TYPE_SURFACE:
			{
				lua_pushnumber(L, *(int*)((char*)data + table[i].offset));

				luaL_getmetatable(L, "SurfaceMeta");
				lua_setmetatable(L, -2);

				break;
			}

			case TYPE_NPC:
			{
				NPCHAR* tNpc = *(NPCHAR**)((char*)data + table[i].offset);

				if (tNpc == NULL || !(tNpc->cond & 0x80))
				{
					lua_pushnil(L);
					break;
				}

				NPCHAR** npc = (NPCHAR**)lua_newuserdata(L, sizeof(NPCHAR*));
				*npc = tNpc;

				luaL_getmetatable(L, "NpcMeta");
				lua_setmetatable(L, -2);

				break;
			}

			case TYPE_PIXEL:
			{
				lua_pushnumber(L, *(int*)((char*)data + table[i].offset) / 512.0f);
				break;
			}
			}

			return TRUE;
		}
	}

	return FALSE;
}

BOOL Write2StructBasic(lua_State* L, const char* name, STRUCT_TABLE* table, void* data, int length)
{
	for (int i = 0; i < length; ++i)
	{
		if (strcmp(name, table[i].name) == 0)
		{
			switch (table[i].type)
			{
			case TYPE_SURFACE:
			case TYPE_NUMBER:
			{
				*(int*)((char*)data + table[i].offset) = (int)luaL_checknumber(L, 3);
				break;
			}

			/*case TYPE_STRING:
			{
				...I'll deal with this later, I'll probably not have strings for a while
			}*/

			case TYPE_OTHER_RECT:
			{
				*(OTHER_RECT*)((char*)data + table[i].offset) = *(OTHER_RECT*)luaL_checkudata(L, 3, "RangeRectMeta");
				break;
			}

			case TYPE_RECT:
			{
				*(RECT*)((char*)data + table[i].offset) = *(RECT*)luaL_checkudata(L, 3, "RectMeta");
				break;
			}

			case TYPE_COLOR:
			{
				*(COLOR*)((char*)data + table[i].offset) = *(COLOR*)luaL_checkudata(L, 3, "ColorMeta");
				break;
			}

			case TYPE_NPC:
			{
				*(NPCHAR**)((char*)data + table[i].offset) = *(NPCHAR**)luaL_checkudata(L, 3, "NpcMeta");
				break;
			}

			case TYPE_PIXEL:
			{
				*(int*)((char*)data + table[i].offset) = (int)(luaL_checknumber(L, 3) * 0x200);
				break;
			}
			}

			return TRUE;
		}
	}

	return FALSE;
}

static METATABLE_TABLE MetatableTable[] =
{
	{"RangeRectMeta", lua_OtherRectIndex, lua_OtherRectNextIndex},
	{"RectMeta", lua_RectIndex, lua_RectNextIndex},
	{"ColorMeta", lua_ColorIndex, lua_ColorNextIndex},
	{"NpcMeta", lua_NpcIndex, lua_NpcNextIndex},
	{"CaretMeta", lua_CaretIndex, lua_CaretNextIndex},
	{"BulletMeta", lua_BulletIndex, lua_BulletNextIndex},
	{"PlayerMeta", lua_PlayerIndex, lua_PlayerNextIndex},
	{"ArmsMeta", lua_ArmsIndex, lua_ArmsNextIndex},
	{"ItemMeta", lua_ItemIndex, lua_ItemNextIndex}
};

void PushFunctionTable(lua_State* L, const char* name, const FUNCTION_TABLE* table, int length, BOOL pop)
{
	lua_newtable(L);
	lua_pushvalue(L, -1);
	lua_setfield(L, -3, name);

	for (int i = 0; i < length; ++i)
	{
		lua_pushcfunction(L, table[i].f);
		lua_setfield(L, -2, table[i].name);
	}

	if (pop)
		lua_pop(L, 1);
}

void PushFunctionTableModName(lua_State* L, const char* modname, const char* name, const FUNCTION_TABLE* table, int length, BOOL pop)
{
	lua_newtable(L);

	lua_pushvalue(L, -1);
	lua_setfield(L, -3, modname);

	lua_pushvalue(L, -1);
	lua_setfield(L, -2, name);

	for (int i = 0; i < length; ++i)
	{
		lua_pushcfunction(L, table[i].f);
		lua_setfield(L, -2, table[i].name);
	}

	// Pop the tables created if pop is set
	if (pop)
		lua_pop(L, 1);
}
void PushSimpleMetatables(lua_State* L, const METATABLE_TABLE* table, int length)
{
	for (int i = 0; i < length; ++i)
	{
		luaL_newmetatable(L, table[i].name);
		lua_pushstring(L, "__index");
		lua_pushcfunction(L, table[i].index);
		lua_settable(L, -3);

		lua_pushstring(L, "__newindex");
		lua_pushcfunction(L, table[i].newindex);
		lua_settable(L, -3);
	}
}

static int lua_WriteLog(lua_State* L)
{
	const char* message = luaL_checkstring(L, 1);
	int x = (int)luaL_optnumber(L, 2, 0);
	int y = (int)luaL_optnumber(L, 3, 0);
	int z = (int)luaL_optnumber(L, 4, 0);

	WriteLog(message, x, y, z);

	return 0;
}

static int lua_PutNumber(lua_State* L)
{
	int num = (int)luaL_checknumber(L, 1);
	int x = (int)luaL_checknumber(L, 2);
	int y = (int)luaL_checknumber(L, 3);

	BOOL zero = FALSE;
	if (!lua_isnoneornil(L, 4))
	{
		luaL_checktype(L, 4, LUA_TBOOLEAN);
		zero = (BOOL)lua_toboolean(L, 4);
	}

	PutNumber4(x, y, num, zero);

	return 0;
}

static int lua_AddCaret(lua_State* L)
{
	const char* caretName = luaL_checkstring(L, 1);
	size_t len = strlen(caretName);
	char* caretNameFunc = new char[len + 1];
	strncpy(caretNameFunc, caretName, len);
	caretNameFunc[len] = '\0';
	char ModNamePath[MAX_PATH];
	sprintf(ModNamePath, "%s%s", "Lua@", gModAuthor);
	AutPI_AddCaret(ActCaretNull, ModNamePath, caretNameFunc);
	return 0;
}

static int lua_AddEntity(lua_State* L)
{
	const char* entityName = luaL_checkstring(L, 1);
	// Determine the length of the source string
	size_t len = strlen(entityName);
	char* entityNameFunc = new char[len + 1];
	strncpy(entityNameFunc, entityName, len);
	entityNameFunc[len] = '\0'; // Null-terminate the string
	char ModNamePath[MAX_PATH];
	sprintf(ModNamePath, "%s%s", "Lua@", gModAuthor);
	AutPI_AddEntity(ActNpc000, ModNamePath, entityNameFunc);
	return 0;
}

static int lua_ModPrintString(lua_State* L)
{
	const char* string = luaL_checkstring(L, 1);
	printf("%s\n", string);
	return 0;
}

static int lua_ModPrintVal(lua_State* L)
{
	int val = (int)luaL_checknumber(L, 1);
	printf("%d\n", val);
	return 0;
}

static int Print2Console(lua_State* L) {
	int nargs = lua_gettop(L);

	for (int i = 1; i <= nargs; ++i) {
		if (i > 1) {
			printf("\t");
		}

		const char* str = lua_tostring(L, i);
		if (str == NULL) {
			lua_getglobal(L, "tostring");
			lua_pushvalue(L, i);
			lua_call(L, 1, 1);
			str = lua_tostring(L, -1);
		}

		printf("%s", str);
	}
	printf("\n");

	return 0;
}

static int lua_GetModulePath(lua_State* L)
{
	lua_pushstring(L, exeModulePath);
	return 1;
}

static int lua_GetDataPath(lua_State* L) {
	lua_pushstring(L, exeDataPath);
	return 1;
}

static int lua_SetModulePath(lua_State* L)
{
	strcpy(exeModulePath, luaL_checkstring(L, 1));
	return 0;
}

static int lua_SetDataPath(lua_State* L)
{
	strcpy(exeDataPath, luaL_checkstring(L, 1));
	return 0;
}

static int lua_FlipSystemTask(lua_State* L)
{
	if (Flip_SystemTask(ghWnd))
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

// Define the macro for checking the state of a key
#define CHECK_KEY_STATE(keyInteger, keyButton, keyCheck) \
    do { \
        if (GetAsyncKeyState(keyButton) & 0x8000) \
            keyInteger |= keyCheck; \
        else \
            keyInteger &= ~keyCheck; \
    } while (0)

long mouseKey;
long mouseKeyTrg;

void AutPI_MouseGetTrg()
{
	static int key_old;
	mouseKeyTrg = mouseKey ^ key_old;
	mouseKeyTrg = mouseKey & mouseKeyTrg;
	key_old = mouseKey;
}

enum KeyBindMouse
{
	KEY_LMOUSE = 0x00000001,
	KEY_RMOUSE = 0x00000002,
	KEY_MMOUSE = 0x00000004,
};

POINT cursorPos;

void GetCursorPosition(HWND hWnd)
{
	if (GetCursorPos(&cursorPos))
	{
		if (ScreenToClient(hWnd, &cursorPos))
		{
			// printf("Cursor Position is: X = %ld, Y = %ld\n", cursorPos.x, cursorPos.y);
		}
	}
}

void UpdateAutPIInput()
{
	// Check if the current window is the active window
	if (GetForegroundWindow() == ghWnd)
	{
		CHECK_KEY_STATE(mouseKey, VK_LBUTTON, KEY_LMOUSE);
		CHECK_KEY_STATE(mouseKey, VK_RBUTTON, KEY_RMOUSE);
		CHECK_KEY_STATE(mouseKey, VK_MBUTTON, KEY_MMOUSE);
		// Create a vector that runs CHECK_KEY_STATE with user-inputed variables
	}
}

static int lua_KeyMouseLeft(lua_State* L)
{
	KeyCheck(L, mouseKey, mouseKeyTrg, KEY_LMOUSE);

	return 1;
}

static int lua_KeyMouseRight(lua_State* L)
{
	KeyCheck(L, mouseKey, mouseKeyTrg, KEY_RMOUSE);

	return 1;
}

static int lua_KeyMouseMiddle(lua_State* L)
{
	KeyCheck(L, mouseKey, mouseKeyTrg, KEY_MMOUSE);

	return 1;
}

#define cursorX (cursorPos.x / window_magnification)
#define cursorY (cursorPos.y / window_magnification)

#define worldcursorX ((cursorX * 0x200) + gFrame.x)
#define worldcursorY ((cursorY * 0x200) + gFrame.y)

#define tilecursorX ((worldcursorX / 0x200) + 8) / 0x10
#define tilecursorY ((worldcursorY / 0x200) + 8) / 0x10

#define CursorTouchingFreeForm(x, y, sizeX, sizeY) \
    (cursorX >= (x) && cursorX <= (x) + (sizeX) && \
     cursorY >= (y) && cursorY <= (y) + (sizeY))

#define WorldCursorTouchingFreeForm(x, y, sizeX, sizeY) \
    (worldcursorX >= (x) && worldcursorX <= (x) + (sizeX) && \
     worldcursorY >= (y) && worldcursorY <= (y) + (sizeY))

static int lua_GetScreenCursorX(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)cursorX);

	return 1;
}

static int lua_GetScreenCursorY(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)cursorY);

	return 1;
}

static int lua_GetWorldCursorX(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)worldcursorX);

	return 1;
}

static int lua_GetWorldCursorY(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)worldcursorY);

	return 1;
}

static int lua_GetTileCursorX(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)tilecursorX);

	return 1;
}

static int lua_GetTileCursorY(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)tilecursorY);

	return 1;
}

static int lua_IfScreenCursorTouching(lua_State* L)
{
	int x = (int)luaL_checknumber(L, 1);
	int y = (int)luaL_checknumber(L, 2);
	int sx = (int)luaL_checknumber(L, 3);
	int sy = (int)luaL_checknumber(L, 4);

	if (CursorTouchingFreeForm(x, y, sx, sy))
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

static int lua_IfWorldCursorTouching(lua_State* L)
{
	int x = (int)luaL_checknumber(L, 1);
	int y = (int)luaL_checknumber(L, 2);
	int sx = (int)luaL_checknumber(L, 3);
	int sy = (int)luaL_checknumber(L, 4);

	if (WorldCursorTouchingFreeForm(x, y, sx, sy))
		lua_pushboolean(L, 1);
	else
		lua_pushboolean(L, 0);

	return 1;
}

#define FUNCTION_TABLE_MOUSE_KEY_SIZE 11

FUNCTION_TABLE MouseKeyFunctionTable[FUNCTION_TABLE_MOUSE_KEY_SIZE] =
{
	{"LeftClick", lua_KeyMouseLeft},
	{"RightClick", lua_KeyMouseRight},
	{"MiddleClick", lua_KeyMouseMiddle},
	{"GetX", lua_GetScreenCursorX},
	{"GetY", lua_GetScreenCursorY},
	{"GetWorldX", lua_GetWorldCursorX},
	{"GetWorldY", lua_GetWorldCursorY},
	{"GetTileX", lua_GetTileCursorX},
	{"GetTileY", lua_GetTileCursorY},
	{"CursorTouching", lua_IfScreenCursorTouching},
	{"WorldCursorTouching", lua_IfWorldCursorTouching},
};

void AutPI_GetTrg_ForInput()
{
	AutPI_MouseGetTrg();
	GetCursorPosition(ghWnd);
	UpdateAutPIInput();
}

static int lua_ShutDown(lua_State* L)
{
	PostMessage(ghWnd, WM_CLOSE, 0, 0);
	return 0;
}

static int lua_CallEscape(lua_State* L)
{
	int ret = Call_Escape(ghWnd);
	lua_pushnumber(L, (lua_Number)ret);
	return 1;
}

static int lua_Sleep(lua_State* L)
{
	int val = (int)luaL_checknumber(L, 1);
	Sleep(val);
	return 0;
}

static int lua_Tick(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)GetTickCount());
	return 1;
}

static int lua_SetMag(lua_State* L)
{
	// Workaround for using graphics enhancement
	int cur_width = WINDOW_WIDTH;
	int cur_height = WINDOW_HEIGHT;

	int val = (int)luaL_checknumber(L, 1);
	window_magnification = val;
	grcGame.left = grcFull.left = 0;
	grcGame.top = grcFull.top = 0;
	grcGame.right = grcFull.right = cur_width * val;
	grcGame.bottom = grcFull.bottom = cur_height * val;
	return 0;
}

static int lua_GetMag(lua_State* L)
{
	lua_pushnumber(L, (lua_Number)window_magnification);
	return 1;
}

BOOL InitModScript(void)
{
	char scriptpath[MAX_PATH];
	char path[MAX_PATH];
	gL = luaL_newstate();

	sprintf(path, "%s\\Scripts\\main.lua", exeDataPath);
	sprintf(scriptpath, "%s\\Scripts\\?.lua", exeDataPath);

	luaL_openlibs(gL);

	// Replace the standard Lua 'print' function with customPrint
	lua_pushcfunction(gL, Print2Console);
	lua_setglobal(gL, "print");

	lua_pushcfunction(gL, lua_Sleep);
	lua_setglobal(gL, "sleep");
	lua_pushcfunction(gL, lua_Tick);
	lua_setglobal(gL, "tick");

	lua_getglobal(gL, "package");
	lua_pushstring(gL, scriptpath);
	lua_setfield(gL, -2, "path");

	PushSimpleMetatables(gL, MetatableTable, sizeof(MetatableTable) / sizeof(METATABLE_TABLE));

	RunLuaMetadataCode(); // API for users to inject metadata code here

	luaL_newmetatable(gL, "SurfaceMeta");
	lua_pushstring(gL, "__index");
	lua_pushcfunction(gL, lua_SurfaceIndex);
	lua_settable(gL, -3);

	// Allow other dlls to inject code *before* setting the global gL to "ModCS".
	RunLuaPreGlobalModCSCode();

	lua_newtable(gL);
	lua_pushvalue(gL, -1);
	lua_setglobal(gL, "ModCS");

	lua_pushcfunction(gL, lua_ModPrintString);
	lua_setfield(gL, -2, "PrintString");

	lua_pushcfunction(gL, lua_ModPrintVal);
	lua_setfield(gL, -2, "PrintNum");

	lua_pushcfunction(gL, lua_WriteLog);
	lua_setfield(gL, -2, "WriteLog");

	lua_pushcfunction(gL, lua_PutText);
	lua_setfield(gL, -2, "PutText");

	lua_pushcfunction(gL, lua_PutNumber);
	lua_setfield(gL, -2, "PutNumber");

	lua_pushcfunction(gL, lua_GetFullRect);
	lua_setfield(gL, -2, "GetFullRect");

	lua_pushcfunction(gL, lua_GetGameRect);
	lua_setfield(gL, -2, "GetGameRect");

	lua_pushcfunction(gL, lua_AddCaret);
	lua_setfield(gL, -2, "AddCaret");

	lua_pushcfunction(gL, lua_AddEntity);
	lua_setfield(gL, -2, "AddEntity");

	lua_pushcfunction(gL, lua_GetModulePath);
	lua_setfield(gL, -2, "GetModulePath");

	lua_pushcfunction(gL, lua_GetDataPath);
	lua_setfield(gL, -2, "GetDataPath");

	lua_pushcfunction(gL, lua_SetModulePath);
	lua_setfield(gL, -2, "SetModulePath");

	lua_pushcfunction(gL, lua_SetDataPath);
	lua_setfield(gL, -2, "SetDataPath");

	lua_pushcfunction(gL, lua_FlipSystemTask);
	lua_setfield(gL, -2, "SystemTask");

	lua_pushcfunction(gL, lua_ShutDown);
	lua_setfield(gL, -2, "ShutDown");

	lua_pushcfunction(gL, lua_CallEscape);
	lua_setfield(gL, -2, "CallEscape");

	lua_pushcfunction(gL, lua_SetMag);
	lua_setfield(gL, -2, "SetMag");

	lua_pushcfunction(gL, lua_GetMag);
	lua_setfield(gL, -2, "GetMag");

	PushFunctionTable(gL, "RangeRect", OtherRectFunctionTable, FUNCTION_TABLE_OTHER_RECT_SIZE, TRUE);
	PushFunctionTable(gL, "Game", GameFunctionTable, FUNCTION_TABLE_GAME_SIZE, TRUE);
	PushFunctionTable(gL, "Rect", RectFunctionTable, FUNCTION_TABLE_RECT_SIZE, TRUE);
	PushFunctionTable(gL, "Color", ColorFunctionTable, FUNCTION_TABLE_COLOR_SIZE, TRUE);
	PushFunctionTable(gL, "Surface", SurfaceFunctionTable, FUNCTION_TABLE_SURFACE_SIZE, TRUE);
	PushFunctionTable(gL, "Flag", FlagFunctionTable, FUNCTION_TABLE_FLAG_SIZE, TRUE);
	PushFunctionTable(gL, "SkipFlag", SkipFlagFunctionTable, FUNCTION_TABLE_SKIPFLAG_SIZE, TRUE);
	PushFunctionTable(gL, "Stage", StageFunctionTable, FUNCTION_TABLE_STAGE_SIZE, TRUE);
	PushFunctionTable(gL, "Map", MapFunctionTable, FUNCTION_TABLE_MAP_SIZE, TRUE);
	PushFunctionTable(gL, "Mod", ModFunctionTable, FUNCTION_TABLE_MOD_SIZE, TRUE);
	PushFunctionTable(gL, "ModLoader", ModLoaderFunctionTable, FUNCTION_TABLE_MOD_LOADER_SIZE, TRUE);
	
	PushFunctionTable(gL, "Sound", SoundFunctionTable, FUNCTION_TABLE_SOUND_SIZE, TRUE);
	PushFunctionTable(gL, "Organya", OrgFunctionTable, FUNCTION_TABLE_ORG_SIZE, TRUE);
	PushFunctionTable(gL, "Music", OrgFunctionTable, FUNCTION_TABLE_ORG_SIZE, TRUE);

	PushFunctionTable(gL, "Key", KeyFunctionTable, FUNCTION_TABLE_KEY_SIZE, TRUE);
	PushFunctionTable(gL, "Profile", ProfileFunctionTable, FUNCTION_TABLE_PROFILE_SIZE, TRUE);
	PushFunctionTable(gL, "Item", ItemFunctionTable, FUNCTION_TABLE_ITEM_SIZE, TRUE);
	PushFunctionTable(gL, "Camera", CameraFunctionTable, FUNCTION_TABLE_CAMERA_SIZE, TRUE);

	PushFunctionTable(gL, "Mouse", MouseKeyFunctionTable, FUNCTION_TABLE_MOUSE_KEY_SIZE, TRUE);

	PushFunctionTable(gL, "Npc", NpcFunctionTable, FUNCTION_TABLE_NPC_SIZE, FALSE);
	lua_newtable(gL);
	lua_pushvalue(gL, -1);
	lua_setfield(gL, -3, "Act");
	lua_pop(gL, 2);

	PushFunctionTable(gL, "Bullet", BulletFunctionTable, FUNCTION_TABLE_BULLET_SIZE, FALSE);
	lua_newtable(gL);
	lua_pushvalue(gL, -1);
	lua_setfield(gL, -3, "Act");
	lua_pop(gL, 2);

	PushFunctionTable(gL, "Caret", CaretFunctionTable, FUNCTION_TABLE_CARET_SIZE, FALSE);
	lua_newtable(gL);
	lua_pushvalue(gL, -1);
	lua_setfield(gL, -3, "Act");
	lua_pop(gL, 2);

	PushFunctionTable(gL, "Arms", ArmsFunctionTable, FUNCTION_TABLE_ARMS_SIZE, FALSE);
	lua_newtable(gL);
	lua_pushvalue(gL, -1);
	lua_setfield(gL, -3, "Shoot");
	lua_pop(gL, 2);

	PushFunctionTable(gL, "Tsc", TscFunctionTable, FUNCTION_TABLE_TSC_SIZE, FALSE);
	lua_newtable(gL);
	lua_pushvalue(gL, -1);
	lua_setfield(gL, -3, "Command");
	lua_pop(gL, 2);


	PushFunctionTable(gL, "Player", PlayerFunctionTable, FUNCTION_TABLE_PLAYER_SIZE, FALSE);
	luaL_getmetatable(gL, "PlayerMeta");
	lua_setmetatable(gL, -2);
	lua_pop(gL, 1);

	AddAutPILuaFunctions(); // API for the user to add lua functionality here, allowing for more ModCS capabilities from other users.

	if (luaL_dofile(gL, path) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);
		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		return FALSE;
	}

	return TRUE;
}

void CloseModScript(void)
{
	lua_close(gL);
}

BOOL ReloadModScript()
{
	CloseModScript();

	if (!InitModScript())
		return FALSE;

	return TRUE;
}

void InitMod_Lua()
{
	if (!InitModScript())
		return;
}

void Lua_GameInit()
{
	if (!GameInitModScript())
		return;
}

void Lua_GameAct()
{
	if (!GameActModScript())
		return;
}

void Lua_GameActTrg()
{
	GetTrg();

	if (!GameActModScript())
		return;
}

void Lua_GameUpdate()
{
	if (!GameUpdateModScript())
		return;
}

void Lua_GameDraw()
{
	if (!GameDrawModScript())
		return;
}

void Lua_GameDrawBelowFade()
{
	if (!GameDrawBelowFadeModScript())
		return;
}

void Lua_GameDrawAboveFade()
{
	if (!GameDrawAboveFadeModScript())
		return;
}

void Lua_GameDrawBelowTextBox()
{
	if (!GameDrawBelowTextBoxModScript())
		return;
}

void Lua_GameDrawAboveTextBox()
{
	if (!GameDrawAboveTextBoxModScript())
		return;
}

void Lua_GameDrawHUD()
{
	if (!GameDrawHUDModScript())
		return;
}

void Lua_GameDrawBelowPlayer()
{
	if (!GameDrawBelowPlayerModScript())
		return;
}

void Lua_GameDrawAbovePlayer()
{
	if (!GameDrawAbovePlayerModScript())
		return;
}

void Lua_FrameInit()
{
	// This is ran first before lua is initted so just don't do anything
	if (gL == NULL) {
		return;
	}

	lua_getglobal(gL, "ModCS");
	lua_getfield(gL, -1, "FrameInit");

	if (lua_isnil(gL, -1))
	{
		lua_settop(gL, 0); // Clear stack
		return;
	}

	if (lua_pcall(gL, 0, 0, 0) != LUA_OK)
	{
		const char* error = lua_tostring(gL, -1);

		ErrorLog(error, 0);
		printf("ERROR: %s\n", error);
		MessageBoxA(ghWnd, "Couldn't execute frame init function", "ModScript Error", MB_OK);
		return;
	}

	lua_settop(gL, 0); // Clear stack

	return;
}
