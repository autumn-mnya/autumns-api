#pragma once

typedef void (*TransferStageInitElementHandler)();

extern std::vector<TransferStageInitElementHandler> transferstageinitElementHandlers;

extern "C" __declspec(dllexport) void RegisterTransferStageInitElement(TransferStageInitElementHandler handler);
void ExecuteTransferStageInitElementHandlers();
void TransferStageInitCode();