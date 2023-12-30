#include <windows.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <unordered_map>
#include <functional>

#include "API_Tile.h"

#include "mod_loader.h"
#include "cave_story.h"

// Define the global map to store tile types and their corresponding handling functions
std::unordered_map<unsigned char, TileHandlerFunction> tileHandlers;

// Function to register a new tile type and its handling function
void RegisterTileType(unsigned char tileType, TileHandlerFunction handlerFunction)
{
    tileHandlers[tileType] = handlerFunction;
}

// Updated function to handle tile types using the registered functions
void Replacement_HitMyCharMap(void)
{
    int x, y;
    int i;
    unsigned char atrb[4];

    x = gMC.x / 0x10 / 0x200;
    y = gMC.y / 0x10 / 0x200;

    int offx[4] = { 0, 1, 0, 1 };
    int offy[4] = { 0, 0, 1, 1 };

    for (i = 0; i < 4; ++i)
    {
        atrb[i] = GetAttribute(x + offx[i], y + offy[i]);

        // Check if the tile type has a registered handler
        if (tileHandlers.find(atrb[i]) != tileHandlers.end())
        {
            // Call the registered handler for the tile type
            tileHandlers[atrb[i]](x + offx[i], y + offy[i]);
        }
    }

    if (gMC.y > gWaterY + (4 * 0x200))
        gMC.flag |= 0x100;
}

void RegisterDefaultTileTypes()
{
    // Block
    RegisterTileType(0x05, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharBlock(x, y);
        });
    RegisterTileType(0x41, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharBlock(x, y);
        });
    RegisterTileType(0x43, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharBlock(x, y);
        });
    RegisterTileType(0x46, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharBlock(x, y);
        });

    // Slopes
    RegisterTileType(0x50, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleA(x, y);
        });
    RegisterTileType(0x51, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleB(x, y);
        });
    RegisterTileType(0x52, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleC(x, y);
        });
    RegisterTileType(0x53, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleD(x, y);
        });
    RegisterTileType(0x54, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleE(x, y);
        });
    RegisterTileType(0x55, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleF(x, y);
        });
    RegisterTileType(0x56, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleG(x, y);
        });
    RegisterTileType(0x57, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleH(x, y);
        });

    // Spikes
    RegisterTileType(0x42, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharDamage(x, y);
        });

    // Water spikes
    RegisterTileType(0x62, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharDamageW(x, y);
        });

    // Wind
    RegisterTileType(0x80, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharVectLeft(x, y);
        });
    RegisterTileType(0x81, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharVectUp(x, y);
        });
    RegisterTileType(0x82, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharVectRight(x, y);
        });
    RegisterTileType(0x83, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharVectDown(x, y);
        });

    // Water
    RegisterTileType(0x02, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });

    // Water and water blocks (same as the previous case)
    RegisterTileType(0x60, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0x61, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharBlock(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });

    // Water slopes
    RegisterTileType(0x70, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleA(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0x71, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleB(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0x72, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleC(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0x73, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleD(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0x74, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleE(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0x75, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleF(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0x76, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleG(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0x77, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharTriangleH(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });

    // Water current
    RegisterTileType(0xA0, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharVectLeft(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0xA1, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharVectUp(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0xA2, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharVectRight(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
    RegisterTileType(0xA3, [](int x, int y) {
        gMC.flag |= JudgeHitMyCharVectDown(x, y);
        gMC.flag |= JudgeHitMyCharWater(x, y);
        });
}