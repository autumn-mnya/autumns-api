// AutPI.h

#include <Windows.h>
#include <vector>

extern HMODULE autpiDLL;  // Global variable

// LoadGenericData
typedef void (*GenericDataElementHandler)();
// Game()
typedef void (*OpeningBelowFadeElementHandler)();
typedef void (*OpeningAboveFadeElementHandler)();
// ModeOpening()
typedef void (*PreModeElementHandler)();
typedef void (*ReleaseElementHandler)();
typedef void (*OpeningBelowTextBoxElementHandler)();
typedef void (*OpeningAboveTextBoxElementHandler)();
typedef void (*OpeningEarlyActionElementHandler)();
typedef void (*OpeningActionElementHandler)();
typedef void (*OpeningInitElementHandler)();
// ModeTitle()
typedef void (*TitleInitElementHandler)();
typedef void (*TitleActionElementHandler)();
typedef void (*TitleBelowCounterElementHandler)();
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

void LoadAutPiDll();

// LoadGenericData() API
void RegisterGenericDataElement(GenericDataElementHandler handler);
// Game() API
void RegisterPreModeElement(PreModeElementHandler handler);
void RegisterReleaseElement(ReleaseElementHandler handler);
// ModeOpening() API
void RegisterOpeningBelowFadeElement(OpeningBelowFadeElementHandler handler);
void RegisterOpeningAboveFadeElement(OpeningAboveFadeElementHandler handler);
void RegisterOpeningBelowTextBoxElement(OpeningBelowTextBoxElementHandler handler);
void RegisterOpeningAboveTextBoxElement(OpeningAboveTextBoxElementHandler handler);
void RegisterOpeningEarlyActionElement(OpeningEarlyActionElementHandler handler);
void RegisterOpeningActionElement(OpeningActionElementHandler handler);
void RegisterOpeningInitElement(OpeningInitElementHandler handler);
// ModeTitle() API
void RegisterTitleInitElement(TitleInitElementHandler handler);
void RegisterTitleActionElement(TitleActionElementHandler handler);
void RegisterTitleBelowCounterElement(TitleBelowCounterElementHandler handler);
// ModeAction() API
void RegisterPlayerHudElement(PlayerHudElementHandler handler);
void RegisterCreditsHudElement(CreditsHudElementHandler handler);
void RegisterBelowFadeElement(BelowFadeElementHandler handler);
void RegisterAboveFadeElement(AboveFadeElementHandler handler);
void RegisterBelowTextBoxElement(BelowTextBoxElementHandler handler);
void RegisterAboveTextBoxElement(AboveTextBoxElementHandler handler);
void RegisterEarlyActionElement(EarlyActionElementHandler handler);
void RegisterActionElement(ActionElementHandler handler);
void RegisterCreditsActionElement(CreditsActionElementHandler handler);
void RegisterInitElement(InitElementHandler handler);