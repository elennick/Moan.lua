# sayIt

A kind of hackish and limited dialogue box that works suprisingly well.

## Features

- Typing effect
- Smooth camera movement to specific locations
- Message box icons
- Very easy to call
- Messagebox titles (for peoples names)

![Preview of sayIt.lua](preview.gif)

Depends on [tween.lua]() and [HUMP camera](), both of which are included.

## How to

Include it via adding, `require 'sayIt'`, to the top of your `main.lua`

```lua
require('sayIt/sayIt')

function love.load()
	sayIt.Init()
    camera = Camera(0, 0, 0.5) -- Initialise the HUMP camera, looking at 0,0 scale 0.5
	-- ...
end

function love.update(dt)
	sayIt.Update(dt)
	-- ...
end

function love.draw()
    camera:attach()
    	-- Draw your stuff here
    camera:detach()

    -- We want the messagebox to be static in the window, and on top of everythin
    -- So this must be the in the draw function.
	sayIt.Draw()
end

function love.keyreleased(key)
	sayIt.Handler(key)
end
```

## Syntax

```lua
sayIt.New("Obey Me", {"Message one", "Message n"}, x, y)
             ^         [-------------------------] [---]
             |                       ^               |
           title                     |        goto x/y camera coords
                              array of messages

```

The picture next to the text is found from the title, so in the instance above, the file "Obey_Me.png" will be used.

You could also make a table with the dialogue and iterate through it to keep things in order, i.e.

```lua
function love.load()
	dialogue = {
		{"Mike Pence", {"Hello", "World"}, x=10, y=100}
	}
end

function love.keyreleased(key)
	sayIt.Handler(key)
	if key == "w" then
		for i,v in pairs(dialogue[1]) do
			sayIt.New(dialogue[1][1], {dialogue[1][i]}, dialogue[1]["x"], dialogue[1]["y"])
		end
	end
end
```

Which is kind of a crap way of implementing it, but you get the idea.

## Configuration

`sayIt.Console` - (bool), displays some debugging info.
`sayIt.Font` - The messagebox font
`assetDir` - The folder in which sayIt.Init() finds the messagebox icons.
`cameraSpeed` - How long in seconds it takes the camera to move from A to B.
`boxHeight` - The height of the messagebox
`padding` - The space between text, images, etc.
`msgBoxPosX/Y` - The x/y coordinates of the messagebox
`msgFontColor` - The messagebox font colour
`msgBgColor` - The background colour of the messagebox
`scale` - Used for scaling fonts to specific ratios - This is kind of a mess at the minute so I'll have to work on a more permanent way of setting unaliased fonts later

Using the default config, the icons must be 420x420px - this is because of the ratio between `boxHeight` and padding.

Press `return` to cycle through messages.