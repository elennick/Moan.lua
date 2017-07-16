# Möan.lua

A simple visual-novel messagebox for the LÖVE game framework.

## Features

- Multiple choice options
- Typing effect
- Smooth camera movement to specific locations
- Message box icons
- Messagebox titles (for peoples names)
- UTF-8 support, (multiple languages)

![Preview of Moan.lua](preview.gif)

Depends on [flux.lua](https://github.com/rxi/flux) and [HUMP camera](https://github.com/vrld/hump), both of which are included.

## How to

* Download the `Moan/` folder in this repo
* Include it via adding, `require('Moan/Moan')`, to the top of your `main.lua`
* Add the following to your main.lua

```lua
require('Moan/Moan')

function love.load()
    -- Initialise the HUMP camera, looking at x=0, y=0, scale 0.5
    camera = Camera(0, 0, 0.5)
end

function love.update(dt)
    Moan.update(dt)
    -- ...
end

function love.draw()
    camera:attach()
        -- Draw your stuff here
    camera:detach()

    -- We want the messagebox to be ontop of all other elements, so we draw it last
    Moan.draw()
end

function love.keyreleased(key)
    Moan.keyreleased(key)
end
```

## Syntax

```lua
-- Single message
Moan.new("Title", {"Hello", "world!"}, 10, 10, "Title.png")
```
Which creates a messagebox with two messages, camera will look at `x=10`, `y=10`, and the image `Title.png` will be used.

For a message with multiple choice, the last arguement in the function is a table, with three more tables, each containing the option text, and the function that should be ran when the option is selected.
```lua
Moan.new("Title", {"Array", "of", "messages"}, x, y, "img.png",
        {{"Option one",   function() option1() end},
         {"Option two",   function() option2() end},
         {"Option three", function() option3() end}})
```

On the final message in the array of messages, the three options will be displayed. Upon pressing return, the function relative to the open will be called.
There must be three options, no less and no more - else an error will be thrown.

A good way to use Moan.lua is to utilise the `unpack()` function, you could enter messages into a table, and then unpack them, i.e.

```lua
dialogue = {
    [1] = {"Title", {"This is a test instance of unpack()"}, 10, 10},
    [2] = {"Title", {"Nice clean code.", "Try out these:"}, 100, 10, "image.png",
          {{"Option 1", function() one() end},
           {"Option 2", function() two() end},
           {"Option 3", function() three() end}}},
    [3] = {"Title", {"Goodbye!"}}
}

for i=1, #dialogue do
    Moan.new(unpack(dialogue[i]))
end
```

## Configuration

### Controls
* `Moan.selectButton` - Button that cycles messagess, skips typing and chooses an option (string), default: `"return"`
* `Moan.indicatorCharacter` - Character before option to indicate selection (string), default: ">"
* `Moan.typeSpeed` - Speed at which a character is inputted (int), default: `0.02`
* `Moan.currentImage` - Image currently displayed in the messagebox
* `Moan.currentMessage` - Full current message (string)

### UI
* `Moan.Font` - Messagebox font, default: `love.graphics.newFont(PATH .. "main.ttf", 32)`
* `padding` - Image, text padding
* `boxH` - Height of messagebox
* `boxW` - Width of messagebox
* `boxX` - x position of messagebox
* `boxY` - y position of messagebox
* `imgX` - x position of messagebox image
* `imgY` - y position of messagebox image
* `imgW` - width of image
* `imgH` - height of image
* `textX` - x position of text
* `textY` - x position of text
* `msgTextY` - x position of actual message
* `msgLimit` - Point at which the text begins to wrap onto a new line
* `fontColour` - RGBA text colour
* `boxColor` - RGBA messagebox background colour

### Other
* `Moan.currentMsgInstance` - Current `Moan.new` (int)
* `Moan.currentMsgKey` - Current key in the `currentMsgInstance` (int)
* `Moan.currentOption` - Currently selected option (int)