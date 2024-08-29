#pragma once

#include <vector>

#include "Main.h"

typedef void (*TransferStageInitElementHandler)();

ELEMENT_HEADERS(TransferStageInitElementHandler, TransferStageInitElement)

void TransferStageInitCode();