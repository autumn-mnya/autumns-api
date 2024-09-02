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

#include "Lua.h"

#include "../Main.h"
#include "../mod_loader.h"
#include "../cave_story.h"

#include "../AutPI.h"

#define gL GetLuaL()

// Can ignore these if you like.

// I'd look at the Autumns Various Additions code if you're curious why these type of functions exist.
// They allow *you* to add to the ModCS lua api in your dll. Very handy!

void SetModGlobalString()
{
	
}

void PushModMetadata()
{

}

void SetModLua()
{

}