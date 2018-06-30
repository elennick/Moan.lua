Moan = require("Moan")

love.load = () ->
  Messenger = Moan.newContainer()

  Messenger.config = {
    selectors: {
      ["u"]: ->
      ["b"]: ->
      ["i"]: ->
    }
  }
  Messenger.UI = {
    x: 10
    y: 10
    w: 500
    h: 250
    container: {
      textColor: {255,255,255,255}
      backgroundColor: {0,0,0,255}
      backgroundTexture: love.graphics.newImage("assets/Texture.png")
      borderTexture: {love.graphics.newImage("assets/Sides.png"), love.graphics.newImage("assets/Corner.png")}
    }
    icon: {
      position: {0,0}
      dimensions: {500,500}
    }
    options: {
      indicator: ">"
    }
  }

  Messenger\defineTag("Moe")
  Messenger.tags["Moe"].onStart         = -> print("Tag onStart")
  Messenger.tags["Moe"].onComplete      = -> print("Tag onComplete")
  Messenger.tags["Moe"].icon            = love.graphics.newImage("assets/Moe.png")
  Messenger.tags["Moe"].title           = "So not moe!"
  Messenger.tags["Moe"].typewriter      = true
  Messenger.tags["Moe"].typeDelay       = 0.02
  Messenger.tags["Moe"].everyCharacter  = -> love.audio.play("boop.m4a")
  Messenger.tags["Moe"].onMessageNext   = -> love.audio.play("beep.m4a")
  Messenger.tags["Moe"].onMessageSkip   = -> love.audio.play("skip.m4a")
  Messenger.tags["Moe"].onOptionSelect  = -> love.audio.play("bleep.m4a")
  Messenger.tags["Moe"].onOptionChange  = -> love.audio.play("bam.m4a")

  with Messenger\new("<wavy><red>Hi There</red></wavy>", "<u>How's it going?</u>")
    \setTitle("Moan.lua demo")
    \setOptions({
      [1]: {"Option 1", -> print("Option 1")}
      [2]: {"Option 2", -> print("Option 2")}
      [3]: {"Option 3", -> print("Option 3")}
    })
    \setTag("Moe")
    \onStart(-> print("On start"))
    \onComplete(-> print("On complete"))
    \setFont("Inconsolata")

love.update = (dt) ->
  Messenger\update(dt)

love.draw = () ->
  Messenger\draw()

love.keypressed = (key) ->
  Messenger\keypressed(key)