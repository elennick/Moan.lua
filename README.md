# Möan.lua

A simple visual-novel messagebox for the LÖVE game framework.
May be unstable since I suck at version control.

Depends on [flux.lua](https://github.com/rxi/flux) and [HUMP camera](https://github.com/vrld/hump), both of which are included.

![Preview of Moan.lua](preview.gif)

## Features

- Multiple choice options
- Typing effect
- Pausing
- Smooth camera movement to specific locations
- Message box icons
- UTF-8 support, (multiple languages)

### To do:

- Specific coloured text

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

### Moan.new

```lua
-- Arguements
Moan.new(title, messages, config)
```
- **title**, string
- **messages**, table, contains strings
- **config**, table, contains message configs, takes;
  * x, camera x position (int)
  * y, camera y position (int)
  * image, message icon image (string)
  * onstart, function to be executed on message start
  * oncomplete, function executed on message end
  * options, table, contains **3** options
    - [1], string describing option
    - [2], function to be exected if option is selected

A full example:
```lua
Moan.new("Mike", {"Message one", "two--and", "three..."}, {x=10, y=10, image="Image.png",
                  onstart=function() something() end, oncomplete=function() something() end,
                  options={
                   {"Option one",  function() option1() end},
                   {"Option two",  function() option2() end},
                   {"Option three",function() option3() end}}
                  })
```

```lua
-- Single message
Moan.new("Title", {"Hello", "world!"}, {x=10, y=10, image="Title.png"})
```
Which creates a messagebox with two messages, camera will look at `x=10`, `y=10`, and the image `Title.png` will be used.

For a message with multiple choice, the last arguement in the function is a table, with three more tables, each containing the option text, and the function that should be ran when the option is selected.
```lua
Moan.new("Title", {"Array", "of", "messages"}, {x=10, y=10, image="img.png",
         options={
           {"Option one",  function() option1() end},
           {"Option two",  function() option2() end},
           {"Option three",function() option3() end}}
         })
```

On the final message in the array of messages, the three options will be displayed. Upon pressing return, the function relative to the open will be called.
There must be three options, no less and no more - else an error will be thrown.

```
-- Pauses
Moan.new("Title", {"Hello--World--This--Is--Lots--of pauses."})
```

A double dash, `--`, causes Moan.lua to stop typing, and will only continue when `Moan.selectButton` is pressed.

A good way to use Moan.lua is to utilise the `unpack()` function, you could enter messages into a table, and then unpack them, i.e.

```lua
dialogue = {
    [1] = {"Title", {"This is a test instance of unpack()"}},
    [2] = {"Title", {"Nice clean code."}, {x=100, y=10, image="image.png"}}
    [3] = {"Title", {"Goodbye!"}}
}

for i=1, #dialogue do
    Moan.new(unpack(dialogue[i]))
end
```

### Moan.setSpeed()

Controls the speed at which letters are typed

```lua
Moan.setSpeed(speed)
```

- `"fast"`
- `"medium"`
- `"slow"`

### Moan.clearMessages()

```lua
Moan.clearMessages()
```

Removes all messages from the queue and closes the messagebox.

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