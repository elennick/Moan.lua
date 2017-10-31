# eek.lua
A simple messagebox system for LÖVE.

```lua
eek.speak("Title", {"Hello world!", "It's me;--eek.lua!"})
```

![Preview of eek.lua](preview.gif)

## Features
- Multiple choices prompt
- Typing effect + sounds
- Pauses
- UTF-8 support
- Optional HUMP camera integration
- Message box icons
- Autowrapped text

### To do:
- Add simple theming interface
- Improves Auto-wrap algo. to calculate string length (in px) based on character width
- Rich text, i.e. coloured/bold/italic text
- Possibly go towards a more OO approach

## How to
* Download the `eek.lua` file in this repo
* Include it via adding, `eek = require('eek')`, to the top of your `main.lua`
* Add the following to your main.lua

```lua
eek = require('eek')

function love.load()
  eek.speak("Title", {"Hello World!"})
end

function love.update(dt)
    eek.update(dt)
end

function love.draw()
    -- Draw your stuff here

    -- We want the messagebox to be ontop of all other elements, so we draw it last
    -- Alternatively use a z-orderer (https://love2d.org/wiki/Tutorial:Drawing_Order)
    eek.draw()
end

function love.keyreleased(key)
    eek.keyreleased(key) -- or eek.keypressed(key)
end
```

## Syntax

### eek.speak
```lua
eek.speak(title, messages, config)
```
- **title**, string or table
  * if table then title[1] = string, messagebox title
  * title[2] = table, contains rgb e.g. `{255,0,255}`
- **messages**, table, contains strings
- **config**, table, contains message configs, takes;
  * `x`, camera x position (int) -- Only passed if using camera
  * `y`, camera y position (int) -- See eek.setCamera()
  * `image`, message icon image e.g. `love.graphics.newImage("img.png")`
  * `onstart`, function to be executed on message start
  * `oncomplete`, function executed on message end
  * `options`, table, contains multiple-choice options
    - [1], string describing option
    - [2], function to be exected if option is selected

A full example:
```lua
avatar = love.graphics.newImage("image.png")
eek.speak({"Mike", {0,255,0}}, {"Message one", "two--and", "Here's those options!"}, {x=10, y=10, image=avatar,
                  onstart=function() camera:move(100, 20) end, oncomplete=function() eek.setSpeed("slow") end,
                  options={
                   {"Option one",  function() option1() end},
                   {"Option two",  function() option2() end},
                   {"Option three",function() option3() end}}
                   {"Option n...", function() optionn() end}}
                  })
```

On the final message in the array of messages, the options will be displayed. Upon pressing return, the function relative to the open will be called.
There can be "infinite" options, however the options will probably overflow depending on your UI configuration.

#### Pauses

```lua
eek.speak("Title", {"Hello--World--This--Is--a lot--of pauses."})
```

A double dash, `--`, causes eek.lua to stop typing, and will only continue when `eek.selectButton` is pressed, each `--` will be replaced with space.

### eek.setCamera()
Sets the HUMP camera for eek to use.

Depends on [flux.lua](https://github.com/rxi/flux) and [HUMP camera](https://github.com/vrld/hump).

```lua
eek.setCamera(HUMPcameraToUse)
```

Example;
```lua
Camera = require("libs/hump/camera")
flux = require("libs/flux")

function love.load()
  camera = Camera(0,0)
  eek.setCamera(camera)

  eek.speak("", {"Look here..."}, {x=10, y=50})
  eek.speak("", {"And there there...". {x=70, y=0})
end

function love.update(dt)
  flux.update(dt)
  eek.update(dt)
end

function love.draw()
  camera:attach()
    draw_world()
  camera:detach()

  eek.draw()
end
```

### eek.setSpeed()

Controls the speed at which letters are typed

```lua
eek.setSpeed(speed)
```

- `"fast"`
- `"medium"`
- `"slow"`
- Or some number, default is `0.01`

### eek.clearMessages()

```lua
eek.clearMessages()
```

Removes all messages from the queue and closes the messagebox.


### eek.keyreleased / eek.keypressed

```lua
function love.keypressed(key)
  eek.keypressed(key)
end

function love.released(key)
  eek.keyreleased(key)
end
```

Pass keys to eek to cycle through messages

### eek.defMsgContainer()

```lua
aMessageContainer = {}
eek.defMsgContainer(aMessageContainer)

eek.speak("Test", "Testing defMsgContainer")
print(aMessageContainer[1].title) -- => "Test"
```

Define an alternative table to store your messages for whatever reason... As opposed to default `eek.allMsgs` table.

## Configuration

### Controls
* `eek.autoWrap` - Pre-wrap sentences by adding `\n`'s into sentences (bool)
* `eek.typeSound` - Typing sound, should be a very short clip
  - e.g. `eek.typeSound = love.audio.newSource("typeSound.wav", "static")`
* `eek.optionSound` - Sound to be played when a option is selected
* `eek.selectButton` - Button that cycles messagess, skips typing and chooses an option (string), default: `"return"`
* `eek.indicatorCharacter` - Character before option to indicate selection (string), default: ">"
* `eek.typeSpeed` - Speed at which a character is inputted (int), default: `0.02`
* `eek.currentImage` - Image currently displayed in the messagebox
* `eek.currentMessage` - Full current message (string)

### UI
* `eek.font` - Messagebox font
  - e.g. `eek.font = love.graphics.newFont("eek/main.ttf", 32)`

Currently these values are local to eek.draw() so you'll have to edit the eek.lua source
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
* `eek.currentMsgInstance` - Current `eek.speak` (int)
* `eek.currentMsgKey` - Current key in the `currentMsgInstance` (int)
* `eek.currentOption` - Currently selected option (int)