// Mod loader for Freeware Cave Story
// Public domain

#include "ASM_Patches.h"
#include "mod_loader.h"

#include <stdbool.h>
#include <windows.h>

typedef struct Settings Settings;

extern void InitMod(void);

void (*ModLoader_WriteRelativeAddress)(void* const address, const void* const new_destination);
void (*ModLoader_WriteByte)(void* const address, const unsigned char value);
void (*ModLoader_WriteWord)(void* const address, const unsigned short value);
void (*ModLoader_WriteLong)(void* const address, const unsigned int value);
void (*ModLoader_WriteWordBE)(void* const address, const unsigned short value);
void (*ModLoader_WriteLongBE)(void* const address, const unsigned int value);
void (*ModLoader_WriteJump)(void* const address, const void* const new_destination);
void (*ModLoader_WriteCall)(void* const address, const void* const new_destination);
void (*ModLoader_WriteNOPs)(void* const address, const unsigned int count);
void (*ModLoader_FixDoorEnterBug)(void);
void (*ModLoader_PrintErrorMessageBox)(const char* const format, ...);
void (*ModLoader_PrintError)(const char* const format, ...);
void (*ModLoader_PrintDebug)(const char* const format, ...);
void (*ModLoader_AddStackableHook)(void * address, unsigned int length, MLHookCallback cb, void * ud);

const char *mod_loader_path_to_dll;

static const char* (*GetSettingString)(const char* const filename, const char* const default_string, const Settings* const settings);
static int (*GetSettingInt)(const char* const filename, const int default_int, const Settings* const settings);
static bool (*GetSettingBool)(const char* const filename, const bool default_bool, const Settings* const settings);

static const Settings *settings;

const char* ModLoader_GetSettingString(const char* const setting_name, const char* const default_string)
{
	return GetSettingString(setting_name, default_string, settings);
}

int ModLoader_GetSettingInt(const char* const setting_name, const int default_int)
{
	return GetSettingInt(setting_name, default_int, settings);
}

bool ModLoader_GetSettingBool(const char* const setting_name, const bool default_bool)
{
	return GetSettingBool(setting_name, default_bool, settings);
}

#ifdef __cplusplus
extern "C"
#endif
__declspec(dllexport) void ModEntry(const HMODULE mod_loader_hmodule, const Settings* const settings_p, const char* const path_to_dll)
{
	settings = settings_p;
	mod_loader_path_to_dll = path_to_dll;

	ModLoader_WriteRelativeAddress = (void (*)(void* const, const void* const))GetProcAddress(mod_loader_hmodule, "WriteRelativeAddress");
	ModLoader_WriteByte = (void (*)(void* const, const unsigned char))GetProcAddress(mod_loader_hmodule, "WriteByte");
	ModLoader_WriteWord = (void (*)(void* const, const unsigned short))GetProcAddress(mod_loader_hmodule, "WriteWord");
	ModLoader_WriteLong = (void (*)(void* const, const unsigned int))GetProcAddress(mod_loader_hmodule, "WriteLong");
	ModLoader_WriteWordBE = (void (*)(void* const, const unsigned short))GetProcAddress(mod_loader_hmodule, "WriteWordBE");
	ModLoader_WriteLongBE = (void (*)(void* const, const unsigned int))GetProcAddress(mod_loader_hmodule, "WriteLongBE");
	ModLoader_WriteJump = (void (*)(void* const, const void* const))GetProcAddress(mod_loader_hmodule, "WriteJump");
	ModLoader_WriteCall = (void (*)(void* const, const void* const))GetProcAddress(mod_loader_hmodule, "WriteCall");
	ModLoader_WriteNOPs = (void (*)(void* const, const unsigned int))GetProcAddress(mod_loader_hmodule, "WriteNOPs");
	ModLoader_FixDoorEnterBug = (void (*)(void))GetProcAddress(mod_loader_hmodule, "FixDoorEnterBug");

	GetSettingString = (const char* (*)(const char* const, const char* const, const Settings* const))GetProcAddress(mod_loader_hmodule, "GetSettingString");
	GetSettingInt = (int (*)(const char* const, const int, const Settings* const))GetProcAddress(mod_loader_hmodule, "GetSettingInt");
	GetSettingBool = (bool (*)(const char* const, const bool, const Settings* const))GetProcAddress(mod_loader_hmodule, "GetSettingBool");

	ModLoader_PrintErrorMessageBox = (void (*)(const char* const format, ...))GetProcAddress(mod_loader_hmodule, "PrintMessageBoxError");
	ModLoader_PrintError = (void (*)(const char* const format, ...))GetProcAddress(mod_loader_hmodule, "PrintError");
	ModLoader_PrintDebug = (void (*)(const char* const format, ...))GetProcAddress(mod_loader_hmodule, "PrintDebug");

	ModLoader_AddStackableHook = (void (*)(void * address, unsigned int length, MLHookCallback cb, void * ud))GetProcAddress(mod_loader_hmodule, "AddStackableHook");

	InitMod();
}

unsigned char ModLoader_GetByte(void* address)
{
	if (!address)
		return 0;
	return *reinterpret_cast<unsigned char*>(address);
}

unsigned short ModLoader_GetWord(void* address)
{
	if (!address)
		return 0;
	return *reinterpret_cast<unsigned short*>(address);
}

unsigned long ModLoader_GetLong(void* address)
{
	if (!address)
		return 0;
	return *reinterpret_cast<unsigned long*>(address);
}

// periwinkle 60fps
void Toggle60FPSPatch(bool enable)
{
    const unsigned int base = 0x40B340;

    static unsigned char original[95];

    static const unsigned char patch[95] = {
        0x55,0x89,0xE5,0x53,0x31,0xDB,0xB9,0x3C,0xD4,0x49,0x00,0x8B,0x01,0xFF,0x01,0x31,
        0xD2,0x6A,0x03,0x59,0xF7,0xF1,0x85,0xD2,0x0F,0x95,0xC3,0x83,0xC3,0x10,0xEB,0x1C,
        0xFF,0x15,0x58,0xC2,0x48,0x00,0x89,0xC2,0xA1,0x38,0xD4,0x49,0x00,0x8D,0x0C,0x18,
        0x39,0xCA,0x73,0x19,0x6A,0x01,0xFF,0x15,0x20,0xC1,0x48,0x00,0xE8,0xEF,0x81,0x00,
        0x00,0x85,0xC0,0x75,0xDB,0x31,0xC0,0x5B,0xE9,0xBD,0x00,0x00,0x00,0x83,0xC0,0x64,
        0x39,0xC2,0x0F,0x43,0xCA,0x89,0x0D,0x38,0xD4,0x49,0x00,0x5B,0x90,0x90,0x90
    };

    static AsmPatch patchObj = {
        (void*)base,
        patch,
        original,
        sizeof(patch),
        false,
        false
    };

    ApplyAsmPatch(patchObj, enable);
}