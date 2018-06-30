Moan = require("Moan")

love.load = () ->
  Messenger = Moan.newContainer()

  Messenger.UI = {
    x: 10
    y: 10
    w: 500
    h: 250
    -- backgroundColor: {255,255,0,100}
    textColor: {255,255,0,100}
    iconDimensions: {500,500}
    iconPosition: {0, 0} -- relative to x, y
    borderTexture: {love.graphics.newImage("assets/Sides.png"), love.graphics.newImage("assets/Corner.png")}
    backgroundTexture: love.graphics.newImage("assets/Texture.png")
    optionIndicator: ">"
  }

  Messenger\defineTag("Moe")
  Messenger.tags["Moe"].onStart         = -> print("Tag onStart")
  Messenger.tags["Moe"].onComplete      = -> print("Tag onComplete")
  Messenger.tags["Moe"].icon            = love.graphics.newImage("assets/Moe.png")
  Messenger.tags["Moe"].title           = "So not moe!"
  Messenger.tags["Moe"].typewriter      = true
  Messenger.tags["Moe"].onNewChar       = -> love.audio.play("boop.m4a")
  Messenger.tags["Moe"].onKeypress      = -> love.audio.play("beep.m4a")
  Messenger.tags["Moe"].onOptionSelect  = -> love.audio.play("bleep.m4a")
  Messenger.tags["Moe"].onOptionChange  = -> love.audio.play("bam.m4a")

  with Messenger\new("<wavy><red>Hi There</red></wavy>", "How's it going?")
    \setTitle("Moan.lua demo")
    \setOptions({
      [1]: {"Option 1", -> print("Option 1")}
      [2]: {"Option 2", -> print("Option 2")}
      [3]: {"Option 3", -> print("Option 3")}
    })
    \setTag("Moe")
    \onStart(-> print("On start"))
    \onComplete(-> print("On complete"))

love.update = (dt) ->
  Messenger\update(dt)

love.draw = () ->
  Messenger\draw()

love.keypressed = (key) ->
  Messenger\keypressed(key)