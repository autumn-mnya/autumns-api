#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_PutFPS.h"

#include "Main.h"
#include "mod_loader.h"
#include "cave_story.h"

DEFINE_ELEMENT_HANDLERS(PutFPSElementHandler, PutFPSElement)

void Replacement_PutFPS(void)
{
	if (bFPS)
	{
		const unsigned long fps = CountFramePerSecound();
		PutNumber4(WINDOW_WIDTH - 40, 8, fps, FALSE);
	}

	ExecutePutFPSElementHandlers();
}