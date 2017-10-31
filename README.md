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
Further documentation can be found at http://twentytwoo.github.io/eek.lua/
Old documentation can be found at https://github.com/twentytwoo/eek.lua/blob/5ecbd7eb81cdfe181f772242c5fda2292e363933/README.md
