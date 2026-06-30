# 1.3

This is the biggest update that AutPI / ModCS has received, well, ever!

Many new functions have been added in this update, more than I can list here. However, a few functions have been removed. Non-important ones, I will list those below..

## Removed Functions

- ModCS.SetModulePath() ~ This function is a bit too dangerous to use. I think it makes more sense to not allow this to be changed.

- ModCS.SetDataPath() ~ Same as above.

- ModCS.AddCaret() ~ Just an AutPI C++ handler that did nothing but tell the game that your Lua was taking up a slot, so other dlls would add their carets after. However no one uses AutPI (currently) to add their own carets, and even so it doesnt really matter.

- ModCS.AddEntity() ~ Same as the above but with entities.
