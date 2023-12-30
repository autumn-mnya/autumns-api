#pragma once

#include "cave_story.h"

#include <functional>
#include <unordered_map>

// Define a function pointer type for tile handling functions
typedef std::function<void(int, int)> TileHandlerFunction;

// Declare the global map to store tile types and their corresponding handling functions
extern std::unordered_map<unsigned char, TileHandlerFunction> tileHandlers;

void RegisterTileType(unsigned char tileType, TileHandlerFunction handlerFunction);
void Replacement_HitMyCharMap(void);
void RegisterDefaultTileTypes();