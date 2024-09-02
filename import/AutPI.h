// AutPI.h

#include <Windows.h>
#include "cave_story.h"
#include <vector>
#include "lua/Lua.h"

extern "C"
{
#include <lua.h>
}

#define DEFINE_REGISTER_FUNCTION(HandlerType, HandlerName) \
    std::vector<HandlerType> HandlerName##Handlers; \
    \
    void Register##HandlerName##(HandlerType handler) \
    { \
        RegisterElement(HandlerName##Handlers, "Register" #HandlerName, reinterpret_cast<void (*)()>(handler)); \
    }

#define DEFINE_REGISTER_HEADER(HandlerType, HandlerName) \
    void Register##HandlerName##(HandlerType handler);

extern HMODULE autpiDLL;  // Global variable

// Boss API
void AutPI_AddBoss(BOSSFUNCTION func, char* author, char* name);

// Caret API
void AutPI_AddCaret(CARETFUNCTION func, char* author, char* name);

// Game()
typedef void (*OpeningBelowFadeElementHandler)();
typedef void (*OpeningAboveFadeElementHandler)();
// GetTrg()
typedef void (*GetTrgElementHandler)();
// ModeOpening()
typedef void (*PreModeElementHandler)();
typedef void (*ReleaseElementHandler)();
typedef void (*OpeningBelowTextBoxElementHandler)();
typedef void (*OpeningAboveTextBoxElementHandler)();
typedef void (*OpeningEarlyActionElementHandler)();
typedef void (*OpeningActionElementHandler)();
typedef void (*OpeningInitElementHandler)();
typedef void (*OpeningBelowPutCaretElementHandler)();
typedef void (*OpeningAbovePutCaretElementHandler)();
typedef void (*OpeningBelowPutBackElementHandler)();
typedef void (*OpeningAbovePutBackElementHandler)();
typedef void (*MOBelowPutFPSElementHandler)();
typedef void (*MOAbovePutFPSElementHandler)();
typedef void (*OpeningBelowPutStage_BackElementHandler)();
typedef void (*OpeningAbovePutStage_BackElementHandler)();
typedef void (*OpeningBelowPutStage_FrontElementHandler)();
typedef void (*OpeningAbovePutStage_FrontElementHandler)();
// ModeTitle()
typedef void (*TitleInitElementHandler)();
typedef void (*TitleActionElementHandler)();
typedef void (*TitleBelowCounterElementHandler)();
typedef void (*MTBelowPutFPSElementHandler)();
typedef void (*MTAbovePutFPSElementHandler)();
// ModeAction()
typedef void (*PlayerHudElementHandler)();
typedef void (*CreditsHudElementHandler)();
typedef void (*BelowFadeElementHandler)();
typedef void (*AboveFadeElementHandler)();
typedef void (*BelowTextBoxElementHandler)();
typedef void (*AboveTextBoxElementHandler)();
typedef void (*BelowPlayerElementHandler)();
typedef void (*AbovePlayerElementHandler)();
typedef void (*EarlyActionElementHandler)();
typedef void (*ActionElementHandler)();
typedef void (*CreditsActionElementHandler)();
typedef void (*InitElementHandler)();
typedef void (*BelowPutCaretElementHandler)();
typedef void (*AbovePutCaretElementHandler)();
typedef void (*MABelowPutFPSElementHandler)();
typedef void (*MAAbovePutFPSElementHandler)();
typedef void (*BelowPutBackElementHandler)();
typedef void (*AbovePutBackElementHandler)();
typedef void (*BelowPutStage_BackElementHandler)();
typedef void (*AbovePutStage_BackElementHandler)();
typedef void (*BelowPutStage_FrontElementHandler)();
typedef void (*AbovePutStage_FrontElementHandler)();
// Profile
typedef void (*SaveProfilePreCloseElementHandler)();
typedef void (*SaveProfilePostCloseElementHandler)();
typedef void (*LoadProfilePreCloseElementHandler)();
typedef void (*LoadProfilePostCloseElementHandler)();
typedef void (*InitializeGameInitElementHandler)();
// PutFPS
typedef void (*PutFPSElementHandler)();
// TextScript
typedef void (*TextScriptSVPElementHandler)();
// TransferStage()
typedef void (*TransferStageInitElementHandler)();
// Lua
typedef void (*LuaPreGlobalModCSElementHandler)();
typedef void (*LuaMetadataElementHandler)();
typedef void (*LuaFuncElementHandler)();

void LoadAutPiDll();

// NpcTbl API
void AutPI_AddEntity(NPCFUNCTION func, char* author, char* name);

DEFINE_REGISTER_HEADER(PreModeElementHandler, PreModeElement)
DEFINE_REGISTER_HEADER(ReleaseElementHandler, ReleaseElement)
DEFINE_REGISTER_HEADER(GetTrgElementHandler, GetTrgElement)
DEFINE_REGISTER_HEADER(OpeningBelowFadeElementHandler, OpeningBelowFadeElement)
DEFINE_REGISTER_HEADER(OpeningAboveFadeElementHandler, OpeningAboveFadeElement)
DEFINE_REGISTER_HEADER(OpeningBelowTextBoxElementHandler, OpeningBelowTextBoxElement)
DEFINE_REGISTER_HEADER(OpeningAboveTextBoxElementHandler, OpeningAboveTextBoxElement)
DEFINE_REGISTER_HEADER(OpeningEarlyActionElementHandler, OpeningEarlyActionElement)
DEFINE_REGISTER_HEADER(OpeningActionElementHandler, OpeningActionElement)
DEFINE_REGISTER_HEADER(OpeningInitElementHandler, OpeningInitElement)
DEFINE_REGISTER_HEADER(OpeningBelowPutCaretElementHandler, OpeningBelowPutCaretElement)
DEFINE_REGISTER_HEADER(OpeningAbovePutCaretElementHandler, OpeningAbovePutCaretElement)
DEFINE_REGISTER_HEADER(MOBelowPutFPSElementHandler, ModeOpeningBelowPutFPSElement)
DEFINE_REGISTER_HEADER(MOAbovePutFPSElementHandler, ModeOpeningAbovePutFPSElement)
DEFINE_REGISTER_HEADER(OpeningBelowPutBackElementHandler, OpeningBelowPutBackElement)
DEFINE_REGISTER_HEADER(OpeningAbovePutBackElementHandler, OpeningAbovePutBackElement)
DEFINE_REGISTER_HEADER(OpeningBelowPutStage_BackElementHandler, OpeningBelowPutStage_BackElement)
DEFINE_REGISTER_HEADER(OpeningAbovePutStage_BackElementHandler, OpeningAbovePutStage_BackElement)
DEFINE_REGISTER_HEADER(OpeningBelowPutStage_FrontElementHandler, OpeningBelowPutStage_FrontElement)
DEFINE_REGISTER_HEADER(OpeningAbovePutStage_FrontElementHandler, OpeningAbovePutStage_FrontElement)
DEFINE_REGISTER_HEADER(TitleInitElementHandler, TitleInitElement)
DEFINE_REGISTER_HEADER(TitleActionElementHandler, TitleActionElement)
DEFINE_REGISTER_HEADER(TitleBelowCounterElementHandler, TitleBelowCounterElement)
DEFINE_REGISTER_HEADER(MTBelowPutFPSElementHandler, ModeTitleBelowPutFPSElement)
DEFINE_REGISTER_HEADER(MTAbovePutFPSElementHandler, ModeTitleAbovePutFPSElement)
DEFINE_REGISTER_HEADER(PlayerHudElementHandler, PlayerHudElement)
DEFINE_REGISTER_HEADER(CreditsHudElementHandler, CreditsHudElement)
DEFINE_REGISTER_HEADER(BelowFadeElementHandler, BelowFadeElement)
DEFINE_REGISTER_HEADER(AboveFadeElementHandler, AboveFadeElement)
DEFINE_REGISTER_HEADER(BelowTextBoxElementHandler, BelowTextBoxElement)
DEFINE_REGISTER_HEADER(AboveTextBoxElementHandler, AboveTextBoxElement)
DEFINE_REGISTER_HEADER(BelowPlayerElementHandler, BelowPlayerElement)
DEFINE_REGISTER_HEADER(AbovePlayerElementHandler, AbovePlayerElement)
DEFINE_REGISTER_HEADER(EarlyActionElementHandler, EarlyActionElement)
DEFINE_REGISTER_HEADER(ActionElementHandler, ActionElement)
DEFINE_REGISTER_HEADER(CreditsActionElementHandler, CreditsActionElement)
DEFINE_REGISTER_HEADER(InitElementHandler, InitElement)
DEFINE_REGISTER_HEADER(BelowPutCaretElementHandler, BelowPutCaretElement)
DEFINE_REGISTER_HEADER(AbovePutCaretElementHandler, AbovePutCaretElement)
DEFINE_REGISTER_HEADER(MABelowPutFPSElementHandler, ModeActionBelowPutFPSElement)
DEFINE_REGISTER_HEADER(MAAbovePutFPSElementHandler, ModeActionAbovePutFPSElement)
DEFINE_REGISTER_HEADER(BelowPutBackElementHandler, BelowPutBackElement)
DEFINE_REGISTER_HEADER(AbovePutBackElementHandler, AbovePutBackElement)
DEFINE_REGISTER_HEADER(BelowPutStage_BackElementHandler, BelowPutStage_BackElement)
DEFINE_REGISTER_HEADER(AbovePutStage_BackElementHandler, AbovePutStage_BackElement)
DEFINE_REGISTER_HEADER(BelowPutStage_FrontElementHandler, BelowPutStage_FrontElement)
DEFINE_REGISTER_HEADER(AbovePutStage_FrontElementHandler, AbovePutStage_FrontElement)
DEFINE_REGISTER_HEADER(SaveProfilePreCloseElementHandler, SaveProfilePreCloseElement)
DEFINE_REGISTER_HEADER(SaveProfilePostCloseElementHandler, SaveProfilePostCloseElement)
DEFINE_REGISTER_HEADER(LoadProfilePreCloseElementHandler, LoadProfilePreCloseElement)
DEFINE_REGISTER_HEADER(LoadProfilePostCloseElementHandler, LoadProfilePostCloseElement)
DEFINE_REGISTER_HEADER(InitializeGameInitElementHandler, InitializeGameInitElement)
DEFINE_REGISTER_HEADER(PutFPSElementHandler, PutFPSElement)
DEFINE_REGISTER_HEADER(TextScriptSVPElementHandler, SVPElement)
DEFINE_REGISTER_HEADER(TransferStageInitElementHandler, TransferStageInitElement)
DEFINE_REGISTER_HEADER(LuaPreGlobalModCSElementHandler, LuaPreGlobalModCSElement)
DEFINE_REGISTER_HEADER(LuaMetadataElementHandler, LuaMetadataElement)
DEFINE_REGISTER_HEADER(LuaFuncElementHandler, LuaFuncElement)

// Lua API
lua_State* GetLuaL();
BOOL ReadStructBasic(lua_State* L, const char* name, STRUCT_TABLE* table, void* data, int length);
BOOL Write2StructBasic(lua_State* L, const char* name, STRUCT_TABLE* table, void* data, int length);
void PushFunctionTable(lua_State* L, const char* name, const FUNCTION_TABLE* table, int length, BOOL pop);
void PushFunctionTableModName(lua_State* L, const char* modname, const char* name, const FUNCTION_TABLE* table, int length, BOOL pop);
void PushSimpleMetatables(lua_State* L, const METATABLE_TABLE* table, int length);
BOOL LoadStageTable(char* name);
BOOL ReloadModScript();
unsigned char ModLoader_GetByte(void* address);
unsigned short ModLoader_GetWord(void* address);
unsigned long ModLoader_GetLong(void* address);