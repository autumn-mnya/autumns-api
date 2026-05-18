#pragma once

#include <windows.h>
#include "../cave_story.h"

extern "C"
{
#include <lua.h>
}

#include "Lua.h"

#define FUNCTION_TABLE_CAMERA_SIZE 14
extern FUNCTION_TABLE CameraFunctionTable[FUNCTION_TABLE_CAMERA_SIZE];