# Möan.lua
A simple messagebox system for LÖVE.

```lua
Moan.new("Title", {"Hello world!", "It's me;--Möan.lua!"})
```

![Preview of Moan.lua](preview.gif)

## Features
- Multiple choices prompt
- Typing effect + sounds
- Pauses
- UTF-8 support
- Optional HUMP camera integration
- Message box icons

### Current bugs
- UI is kind of dodgy with placement of text, you may have to tweak some values if you're using your own font

### To do:
- Rich text, i.e. coloured/bold/italic text

## How to
* Download the `Moan/` folder in this repo
* Include it via adding, `require('Moan/Moan')`, to the top of your `main.lua`
* Add the following to your main.lua

```lua
require('Moan/Moan')

function love.load()
  -- Open a message
  Moan.new("Title", {"Hello World!"})
end

function love.update(dt)
    Moan.update(dt)
end

function love.draw()
    -- Draw your stuff here

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
Moan.new(title, messages, config)
```
- **title**, string
- **messages**, table, contains strings
- **config**, table, contains message configs, takes;
  * x, camera x position (int) -- Only passed if using camera
  * y, camera y position (int) -- See Moan.setCamera()
  * image, message icon image e.g. `love.graphics.newImage("img.png")`
  * onstart, function to be executed on message start
  * oncomplete, function executed on message end
  * options, table, contains **3** options
    - [1], string describing option
    - [2], function to be exected if option is selected

A full example:
```lua
avatar = love.graphics.newImage("image.png")
Moan.new("Mike", {"Message one", "two--and", "three..."}, {x=10, y=10, image=avatar,
                  onstart=function() something() end, oncomplete=function() something() end,
                  options={
                   {"Option one",  function() option1() end},
                   {"Option two",  function() option2() end},
                   {"Option three",function() option3() end}}
                  })
```

For a message with multiple choice, the last arguement in the function is a table, with three more tables, each containing the option text, and the function that should be ran when the option is selected.
```lua
Moan.new("Title", {"Array", "of", "messages"}, {image="img.png",
         options={
           {"Option one",  function() option1() end},
           {"Option two",  function() option2() end},
           {"Option three",function() option3() end}}
         })
```

On the final message in the array of messages, the three options will be displayed. Upon pressing return, the function relative to the open will be called.
There must be three options, no less and no more - else an error will be thrown. (I'll get around to this soon...)

```lua
Moan.new("Title", {"Hello--World--This--Is--Lots--of pauses."})
```

A double dash, `--`, causes Moan.lua to stop typing, and will only continue when `Moan.selectButton` is pressed, each `--` will be replaced with space.

### Moan.setCamera()
Sets the HUMP camera for Moan to use.

Depends on [flux.lua](https://github.com/rxi/flux) and [HUMP camera](https://github.com/vrld/hump).

```lua
Moan.setCamera(camToUse)
```

```lua
Camera = require("libs/hump/camera")
flux = require("libs/flux")

function love.load()
  camera = Camera(0,0)
  Moan.setCamera(camera)

  Moan.new("", {"Look here..."}, {x=10, y=50})
  Moan.new("", {"And there there...". {x=70, y=0})
end

function love.update(dt)
  flux.update(dt)
  Moan.update(dt
end

function love.draw()
  camera:attach()
    draw_world()
  camera:detach()

  Moan.draw()
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
- Or some number, default is 0.01

### Moan.clearMessages()

```lua
Moan.clearMessages()
```

Removes all messages from the queue and closes the messagebox.

## Configuration

### Controls
* `Moan.typeSound` - Typing sound, should be a very short clip
  - e.g. `Moan.typeSound = love.audio.newSource("typeSound.wav", "static")`
* `Moan.optionSound` - Sound to be played when a option is selected
* `Moan.selectButton` - Button that cycles messagess, skips typing and chooses an option (string), default: `"return"`
* `Moan.indicatorCharacter` - Character before option to indicate selection (string), default: ">"
* `Moan.typeSpeed` - Speed at which a character is inputted (int), default: `0.02`
* `Moan.currentImage` - Image currently displayed in the messagebox
* `Moan.currentMessage` - Full current message (string)

### UI
* `Moan.font` - Messagebox font
  - e.g. `Moan.font = love.graphics.newFont("Moan/main.ttf", 32)`
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