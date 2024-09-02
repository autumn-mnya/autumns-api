// AutPI.cpp

#include <windows.h>
#include <iostream>
#include "AutPI.h"
#include "mod_loader.h"
#include "cave_story.h"
#include "lua/Lua.h"

HMODULE autpiDLL = nullptr;  // Global variable

// Function pointer for dynamically loaded functions
typedef void (*RegisterElementFunc)(void (*)());

// Function to register an element handler
void RegisterElement(std::vector<void (*)()>& handlers, const char* functionName, void (*handler)())
{
    if (autpiDLL != nullptr) {
        RegisterElementFunc registerFunc =
            reinterpret_cast<RegisterElementFunc>(
                GetProcAddress(autpiDLL, functionName));

        if (registerFunc != nullptr) {
            registerFunc(handler);
            handlers.push_back(handler);
        }
        else {
            std::cerr << "Failed to get the function pointer for " << functionName << "\n";
            // You might want to handle the error appropriately.
        }
    }
}

void AutPI_AddBoss(BOSSFUNCTION func, char* author, char* name)
{
    typedef void (*AutPI_AddBossFunc)(BOSSFUNCTION, char*, char*);
    AutPI_AddBossFunc addBossFunc = reinterpret_cast<AutPI_AddBossFunc>(
        GetProcAddress(autpiDLL, "AutPI_AddBoss"));

    if (addBossFunc == nullptr) {
        std::cerr << "Failed to get the function pointer for AutPI_AddBoss\n";
        return;
    }

    addBossFunc(func, author, name);
}

void AutPI_AddCaret(CARETFUNCTION func, char* author, char* name)
{
    typedef void (*AutPI_AddCaretFunc)(CARETFUNCTION, char*, char*);
    AutPI_AddCaretFunc addCaretFunc = reinterpret_cast<AutPI_AddCaretFunc>(
        GetProcAddress(autpiDLL, "AutPI_AddCaret"));

    if (addCaretFunc == nullptr) {
        std::cerr << "Failed to get the function pointer for AutPI_AddCaret\n";
        return;
    }

    addCaretFunc(func, author, name);
}

void AutPI_AddEntity(NPCFUNCTION func, char* author, char* name)
{
    typedef void (*AutPI_AddEntityFunc)(NPCFUNCTION, char*, char*);
    AutPI_AddEntityFunc addEntityFunc = reinterpret_cast<AutPI_AddEntityFunc>(
        GetProcAddress(autpiDLL, "AutPI_AddEntity"));

    if (addEntityFunc == nullptr) {
        std::cerr << "Failed to get the function pointer for AutPI_AddEntity\n";
        return;
    }

    addEntityFunc(func, author, name);
}

// Function to load autpi.dll
void LoadAutPiDll()
{
    autpiDLL = LoadLibrary("autpi.dll");
    if (autpiDLL == nullptr) {
        std::cerr << "Failed to load autpi.dll\n";
        // You might want to handle the error appropriately, e.g., throw an exception or return early.
    }
}

DEFINE_REGISTER_FUNCTION(PreModeElementHandler, PreModeElement)
DEFINE_REGISTER_FUNCTION(ReleaseElementHandler, ReleaseElement)
DEFINE_REGISTER_FUNCTION(GetTrgElementHandler, GetTrgElement)
DEFINE_REGISTER_FUNCTION(OpeningBelowFadeElementHandler, OpeningBelowFadeElement)
DEFINE_REGISTER_FUNCTION(OpeningAboveFadeElementHandler, OpeningAboveFadeElement)
DEFINE_REGISTER_FUNCTION(OpeningBelowTextBoxElementHandler, OpeningBelowTextBoxElement)
DEFINE_REGISTER_FUNCTION(OpeningAboveTextBoxElementHandler, OpeningAboveTextBoxElement)
DEFINE_REGISTER_FUNCTION(OpeningEarlyActionElementHandler, OpeningEarlyActionElement)
DEFINE_REGISTER_FUNCTION(OpeningActionElementHandler, OpeningActionElement)
DEFINE_REGISTER_FUNCTION(OpeningInitElementHandler, OpeningInitElement)
DEFINE_REGISTER_FUNCTION(OpeningBelowPutCaretElementHandler, OpeningBelowPutCaretElement)
DEFINE_REGISTER_FUNCTION(OpeningAbovePutCaretElementHandler, OpeningAbovePutCaretElement)
DEFINE_REGISTER_FUNCTION(MOBelowPutFPSElementHandler, ModeOpeningBelowPutFPSElement)
DEFINE_REGISTER_FUNCTION(MOAbovePutFPSElementHandler, ModeOpeningAbovePutFPSElement)
DEFINE_REGISTER_FUNCTION(OpeningBelowPutBackElementHandler, OpeningBelowPutBackElement)
DEFINE_REGISTER_FUNCTION(OpeningAbovePutBackElementHandler, OpeningAbovePutBackElement)
DEFINE_REGISTER_FUNCTION(OpeningBelowPutStage_BackElementHandler, OpeningBelowPutStage_BackElement)
DEFINE_REGISTER_FUNCTION(OpeningAbovePutStage_BackElementHandler, OpeningAbovePutStage_BackElement)
DEFINE_REGISTER_FUNCTION(OpeningBelowPutStage_FrontElementHandler, OpeningBelowPutStage_FrontElement)
DEFINE_REGISTER_FUNCTION(OpeningAbovePutStage_FrontElementHandler, OpeningAbovePutStage_FrontElement)
DEFINE_REGISTER_FUNCTION(TitleInitElementHandler, TitleInitElement)
DEFINE_REGISTER_FUNCTION(TitleActionElementHandler, TitleActionElement)
DEFINE_REGISTER_FUNCTION(TitleBelowCounterElementHandler, TitleBelowCounterElement)
DEFINE_REGISTER_FUNCTION(MTBelowPutFPSElementHandler, ModeTitleBelowPutFPSElement)
DEFINE_REGISTER_FUNCTION(MTAbovePutFPSElementHandler, ModeTitleAbovePutFPSElement)
DEFINE_REGISTER_FUNCTION(PlayerHudElementHandler, PlayerHudElement)
DEFINE_REGISTER_FUNCTION(CreditsHudElementHandler, CreditsHudElement)
DEFINE_REGISTER_FUNCTION(BelowFadeElementHandler, BelowFadeElement)
DEFINE_REGISTER_FUNCTION(AboveFadeElementHandler, AboveFadeElement)
DEFINE_REGISTER_FUNCTION(BelowTextBoxElementHandler, BelowTextBoxElement)
DEFINE_REGISTER_FUNCTION(AboveTextBoxElementHandler, AboveTextBoxElement)
DEFINE_REGISTER_FUNCTION(BelowPlayerElementHandler, BelowPlayerElement)
DEFINE_REGISTER_FUNCTION(AbovePlayerElementHandler, AbovePlayerElement)
DEFINE_REGISTER_FUNCTION(EarlyActionElementHandler, EarlyActionElement)
DEFINE_REGISTER_FUNCTION(ActionElementHandler, ActionElement)
DEFINE_REGISTER_FUNCTION(CreditsActionElementHandler, CreditsActionElement)
DEFINE_REGISTER_FUNCTION(InitElementHandler, InitElement)
DEFINE_REGISTER_FUNCTION(BelowPutCaretElementHandler, BelowPutCaretElement)
DEFINE_REGISTER_FUNCTION(AbovePutCaretElementHandler, AbovePutCaretElement)
DEFINE_REGISTER_FUNCTION(MABelowPutFPSElementHandler, ModeActionBelowPutFPSElement)
DEFINE_REGISTER_FUNCTION(MAAbovePutFPSElementHandler, ModeActionAbovePutFPSElement)
DEFINE_REGISTER_FUNCTION(BelowPutStage_BackElementHandler, BelowPutStage_BackElement)
DEFINE_REGISTER_FUNCTION(AbovePutStage_BackElementHandler, AbovePutStage_BackElement)
DEFINE_REGISTER_FUNCTION(BelowPutStage_FrontElementHandler, BelowPutStage_FrontElement)
DEFINE_REGISTER_FUNCTION(AbovePutStage_FrontElementHandler, AbovePutStage_FrontElement)
DEFINE_REGISTER_FUNCTION(BelowPutBackElementHandler, BelowPutBackElement)
DEFINE_REGISTER_FUNCTION(AbovePutBackElementHandler, AbovePutBackElement)
DEFINE_REGISTER_FUNCTION(SaveProfilePreCloseElementHandler, SaveProfilePreCloseElement)
DEFINE_REGISTER_FUNCTION(SaveProfilePostCloseElementHandler, SaveProfilePostCloseElement)
DEFINE_REGISTER_FUNCTION(LoadProfilePreCloseElementHandler, LoadProfilePreCloseElement)
DEFINE_REGISTER_FUNCTION(LoadProfilePostCloseElementHandler, LoadProfilePostCloseElement)
DEFINE_REGISTER_FUNCTION(InitializeGameInitElementHandler, InitializeGameInitElement)
DEFINE_REGISTER_FUNCTION(PutFPSElementHandler, PutFPSElement)
DEFINE_REGISTER_FUNCTION(TextScriptSVPElementHandler, SVPElement)
DEFINE_REGISTER_FUNCTION(TransferStageInitElementHandler, TransferStageInitElement)
DEFINE_REGISTER_FUNCTION(LuaPreGlobalModCSElementHandler, LuaPreGlobalModCSElement)
DEFINE_REGISTER_FUNCTION(LuaMetadataElementHandler, LuaMetadataElement)
DEFINE_REGISTER_FUNCTION(LuaFuncElementHandler, LuaFuncElement)

// Lua API
typedef lua_State* (*GetLuaLFunc)();

lua_State* GetLuaL()
{
    // Load GetLuaL function pointer from the DLL
    GetLuaLFunc getLuaLFunc = reinterpret_cast<GetLuaLFunc>(
        GetProcAddress(autpiDLL, "GetLuaL"));

    if (getLuaLFunc == nullptr) {
        std::cerr << "Failed to get the function pointer for GetLuaL\n";
        return nullptr;
    }

    // Call GetLuaL function to retrieve lua_State*
    lua_State* luaL = getLuaLFunc();
    return luaL; // Return the lua_State* obtained from GetLuaL
}

BOOL ReadStructBasic(lua_State* L, const char* name, STRUCT_TABLE* table, void* data, int length)
{
    typedef BOOL(*ReadStructBasicFunc)(lua_State*, const char*, STRUCT_TABLE*, void*, int);

    ReadStructBasicFunc Func = reinterpret_cast<ReadStructBasicFunc>(
        GetProcAddress(autpiDLL, "ReadStructBasic"));

    if (Func == nullptr) {
        std::cerr << "Failed to get the function pointer for ReadStructBasic\n";
        return FALSE;
    }

    Func(L, name, table, data, length);
}

BOOL Write2StructBasic(lua_State* L, const char* name, STRUCT_TABLE* table, void* data, int length)
{
    typedef BOOL(*Write2StructBasicFunc)(lua_State*, const char*, STRUCT_TABLE*, void*, int);

    Write2StructBasicFunc Func = reinterpret_cast<Write2StructBasicFunc>(
        GetProcAddress(autpiDLL, "Write2StructBasic"));

    if (Func == nullptr) {
        std::cerr << "Failed to get the function pointer for Write2StructBasic\n";
        return FALSE;
    }

    Func(L, name, table, data, length);
}

void PushFunctionTable(lua_State* L, const char* name, const FUNCTION_TABLE* table, int length, BOOL pop)
{
    typedef void(*PushFunctionTableFunc)(lua_State*, const char*, const FUNCTION_TABLE*, int, BOOL);

    PushFunctionTableFunc Func = reinterpret_cast<PushFunctionTableFunc>(
        GetProcAddress(autpiDLL, "PushFunctionTable"));

    if (Func == nullptr) {
        std::cerr << "Failed to get the function pointer for PushFunctionTable\n";
        return;
    }

    Func(L, name, table, length, pop);
}

void PushFunctionTableModName(lua_State* L, const char* modname, const char* name, const FUNCTION_TABLE* table, int length, BOOL pop)
{
    typedef void(*PushFunctionTableFunc)(lua_State*, const char*, const char*, const FUNCTION_TABLE*, int, BOOL);

    PushFunctionTableFunc Func = reinterpret_cast<PushFunctionTableFunc>(
        GetProcAddress(autpiDLL, "PushFunctionTableModName"));

    if (Func == nullptr) {
        std::cerr << "Failed to get the function pointer for PushFunctionTableModName\n";
        return;
    }

    Func(L, modname, name, table, length, pop);
}

void PushSimpleMetatables(lua_State* L, const METATABLE_TABLE* table, int length)
{
    typedef void(*PushSimpleMetatablesFunc)(lua_State*, const METATABLE_TABLE*, int);

    PushSimpleMetatablesFunc Func = reinterpret_cast<PushSimpleMetatablesFunc>(
        GetProcAddress(autpiDLL, "PushSimpleMetatables"));

    if (Func == nullptr) {
        std::cerr << "Failed to get the function pointer for PushSimpleMetatables\n";
        return;
    }

    Func(L, table, length);
}

BOOL LoadStageTable(char* name)
{
    typedef BOOL(*funcdef)(char*);

    funcdef func = reinterpret_cast<funcdef>(
        GetProcAddress(autpiDLL, "LoadStageTable"));

    if (func == nullptr) {
        std::cerr << "Failed to get the function pointer for LoadStageTable\n";
        return FALSE;
    }

    return func(name);
}

BOOL ReloadModScript()
{
    typedef BOOL(*funcdef)();

    funcdef func = reinterpret_cast<funcdef>(
        GetProcAddress(autpiDLL, "ReloadModScript"));

    if (func == nullptr) {
        std::cerr << "Failed to get the function pointer for ReloadModScript\n";
        return FALSE;
    }

    return func();
}

unsigned char ModLoader_GetByte(void* address)
{
    typedef unsigned char (*funcdef)(void* address);

    funcdef func = reinterpret_cast<funcdef>(
        GetProcAddress(autpiDLL, "ModLoader_GetByte"));

    if (func == nullptr) {
        std::cerr << "Failed to get the function pointer for ModLoader_GetByte\n";
        return FALSE;
    }

    return func(address);
}

unsigned short ModLoader_GetWord(void* address)
{
    typedef unsigned short (*funcdef)(void* address);

    funcdef func = reinterpret_cast<funcdef>(
        GetProcAddress(autpiDLL, "ModLoader_GetWord"));

    if (func == nullptr) {
        std::cerr << "Failed to get the function pointer for ModLoader_GetWord\n";
        return FALSE;
    }

    return func(address);
}

unsigned long ModLoader_GetLong(void* address)
{
    typedef unsigned long (*funcdef)(void* address);

    funcdef func = reinterpret_cast<funcdef>(
        GetProcAddress(autpiDLL, "ModLoader_GetLong"));

    if (func == nullptr) {
        std::cerr << "Failed to get the function pointer for ModLoader_GetLong\n";
        return FALSE;
    }

    return func(address);
}