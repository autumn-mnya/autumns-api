--[[
Port of CSE2-Wii's Text Renderer to a lua script, allowing you to draw text using a simple bitmap without lagging the game or dealing with jank.
by autumn_mnya

Free to use, no credit needed

Run InitFont() in a ModCS.Game.Init() function
--]]

local fontSurfaceId = 3
local fontBitmapName = "font"

function InitFont()
	if not fontSurface then
		fontSurface = ModCS.Surface.Create(fontSurfaceId, fontBitmapName)
	end
end

function PutTextBitmap(x, y, text)
    local rcCharacter = ModCS.Rect.Create(0, 0, 0, 0)
    local rcView = grcFull

    for i = 1, #text do
        local charCode = string.byte(text, i)

        rcCharacter.left = (charCode % 0x20) * 12
        rcCharacter.top = (math.floor(charCode / 0x20) - 1) * 12
        rcCharacter.right = rcCharacter.left + 12
        rcCharacter.bottom = rcCharacter.top + 12

        local dx = x + 5 * (i - 1)

        ModCS.Rect.Put(rcCharacter, dx, y, fontSurfaceId)
    end
end
