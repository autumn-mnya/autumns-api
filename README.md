# Autumns API (AutPI)
This is an API mod for Cave Story freeware --> Allowing myself or other code modders to add custom code to Cave Story. It can be compiled using Visual Studio 2022.
This mod is using [Clownacy's Mod Loader](https://github.com/Clownacy/Cave-Story-Mod-Loader/releases).

# Features

- A port of [ModCS](https://modcavestory.github.io) to Freeware, with newer additions as well.
- Ways to "Register" code at different spots in the game, such as adding your own functions to the "Act" part of the Action Mode in Cave Storys code.

# ModCS

Credits to yasinbread, and aikyuu.
Yasinbread sent the source code of ModCS to me, and gave permission for it. The lua api credits go entirely to them, its awesome.

# Installation

You'll first need a copy of [Visual Studio 2022](https://visualstudio.microsoft.com/downloads/). When you're installing it, go to the individual components tab and select the "C++ Windows XP Support for VS 2017 (v141) tools [Deprecated]".

![v141 tools](WindowsXPSupport.png)

If you already have Visual Studio 2022, search your computer for "Visual Studio Installer", and click modify on Visual Studio 2022. Go to the invididual components tab, and select the "C++ Windows XP Support for VS 2017 (v141) tools [Deprecated]" like shown above.

After that's all installed, you should be able to just compile the dll using the mod.sln file, and test it just by opening the game.

Note that anyone who plays mods using your dll should install the latest [vc_redist](https://aka.ms/vs/17/release/vc_redist.x86.exe) for x86 if they do not have it. It has to be x86, even if your computer is x64.
