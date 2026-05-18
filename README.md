# Autumns API (AutPI)
This is an API mod for Cave Story freeware --> Allowing myself or other code modders to add custom code to Cave Story. It can be compiled using Visual Studio 2022.
This mod is using [Clownacy's Mod Loader](https://github.com/Clownacy/Cave-Story-Mod-Loader/releases).

# Features

- A port of [ModCS](https://modcavestory.github.io) to Freeware, with newer additions as well.
- Ways to "Register" code at different spots in the game, such as adding your own functions to the "Act" part of the Action Mode in Cave Storys code.

# ModCS

Credits to yasinbread, and aikyuu.
Yasinbread sent the source code of ModCS to me, and gave permission for it. The lua api credits go entirely to them, its awesome.

# Building

The recommended method of compiling AutPI 1.3+ is to use [CMake](https://cmake.org/).

For windows users, I would recommend installing CMake, alongside __Visual Studio 2019__ or above. Install both, open "cmake-gui" if inexperienced, open the source code folder, and set a build directory. Configure it, and set the platform to "Win32". Generate after, and open the new `.sln` file in the build folder, and build!

# Compatibility

This dll should work for Windows 7+, but not XP or below.