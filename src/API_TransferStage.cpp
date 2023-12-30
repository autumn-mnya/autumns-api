#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_TransferStage.h"

#include "mod_loader.h"
#include "cave_story.h"

// TRANSFERSTAGEINIT //

std::vector<TransferStageInitElementHandler> transferstageinitElementHandlers;

void RegisterTransferStageInitElement(TransferStageInitElementHandler handler)
{
    transferstageinitElementHandlers.push_back(handler);
}

void ExecuteTransferStageInitElementHandlers()
{
    for (const auto& handler : transferstageinitElementHandlers)
    {
        handler();
    }
}

void TransferStageInitCode()
{
    ResetFlash();
    ExecuteTransferStageInitElementHandlers();
}