love.load = function()
  local Messenger = Moan.newContainer()
  Messenger:defineTag("Moe")
  Messenger.tags["Moe"].onStart = function()
    return print("Tag onStart")
  end
  Messenger.tags["Moe"].onComplete = function()
    return print("Tag onComplete")
  end
  Messenger.tags["Moe"].icon = love.graphics.newImage("assets/Moe.png")
  Messenger.tags["Moe"].title = "Moe"
  do
    local _with_0 = Messenger:new("<wavy><red>Hi There</red></wavy>", "How's it going?")
    _with_0:setTitle("Moan.lua demo")
    _with_0:setOptions({
      [1] = {
        "Option 1",
        function()
          return print("Option 1")
        end
      },
      [2] = {
        "Option 2",
        function()
          return print("Option 2")
        end
      },
      [3] = {
        "Option 3",
        function()
          return print("Option 3")
        end
      }
    })
    _with_0:setTag("Moe")
    _with_0:onStart(function()
      return print("On start")
    end)
    _with_0:onComplete(function()
      return print("On complete")
    end)
    return _with_0
  end
end
love.update = function(dt)
  return Messenger:update(dt)
end
love.draw = function()
  return Messenger:draw()
end
love.keypressed = function(key)
  return Messenger:keypressed(key)
end
