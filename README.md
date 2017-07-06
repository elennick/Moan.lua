# Möan.lua

A kind of hackish and limited dialogue box that works suprisingly well.

## Features

- Typing effect
- Smooth camera movement to specific locations
- Message box icons
- Very easy to call
- Messagebox titles (for peoples names)
- UTF-8 support, (multiple languages)

![Preview of Moan.lua](preview.gif)

Depends on [flux.lua](https://github.com/rxi/flux) and [HUMP camera](https://github.com/vrld/hump), both of which are included.

## How to

Include it via adding, `require('Moan/Moan')`, to the top of your `main.lua` and all the update/draw functions, i.e.

```lua
require('Moan/Moan')

function love.load()
    Moan.Init()
    camera = Camera(0, 0, 0.5) -- Initialise the HUMP camera, looking at 0,0 scale 0.5
	-- ...
end

function love.update(dt)
	Moan.Update(dt)
	-- ...
end

function love.draw()
    camera:attach()
    	-- Draw your stuff here
    camera:detach()

    -- We want the messagebox to be static in the window, and on top of everythin
    -- So this must be the in the draw function.
	Moan.Draw()
end

function love.keyreleased(key)
    Moan.Handler(key)
end
```

## Syntax

```lua
-- Create a new messageBox, title "Obey Me" with two messages, look at position x, y
Moan.New("Obey Me", {"Message one", "Message n"}, x, y)

-- Go to the next message
Moan.AdvanceMsg()
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
	Moan.Handler(key)
	if key == "w" then
		for i,v in pairs(dialogue[1]) do
			Moan.New(dialogue[1][1], {dialogue[1][i]}, dialogue[1]["x"], dialogue[1]["y"])
		end
	end
end
```

Which is kind of a crap way of implementing it, but you get the idea.

## Configuration

- `Moan.Console` - (bool), displays some debugging info.
- `Moan.Font` - The messagebox font
- `Moan.advanceMsgKey` - The key that cycles through messages
- `assetDir` - The folder in which Moan.Init() finds the messagebox icons.
- `cameraSpeed` - How long in seconds it takes the camera to move from A to B.
- `boxHeight` - The height of the messagebox
- `padding` - The space between text, images, etc.
- `msgBoxPosX/Y` - The x/y coordinates of the messagebox
- `msgFontColor` - The messagebox font colour
- `msgBgColor` - The background colour of the messagebox
- `scale` - Used for scaling fonts to specific ratios - This is kind of a mess at the minute so I'll have to work on a more permanent way of setting unaliased fonts later

Using the default config, the icons must be **420x420px** - this is because of the ratio between `boxHeight` and padding.
