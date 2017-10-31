--
-- eek.lua
-- formerly Möan.lua
--
-- Copyright (c) 2017 twentytwoo
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

local utf8 = require("utf8")
local PATH = (...):match('^(.*[%./])[^%.%/]+$') or ''
eek = {
  indicatorCharacter = ">", -- Next message indicator
  optionCharacter = "- ",   -- Option select character
  indicatorDelay = 25,      -- Delay between each flash of indicator
  selectButton = "space",   -- Key that advances message
  typeSpeed = 0.01,         -- Delay per character typed out
  debug = false,            -- Display some debugging
  allMsgs = {},

  history = {},             -- contains all previous messages + titles
  currentMessage  = "",
  currentMsgInstance = 1,   -- The eek.speak function instance
  currentMsgKey= 1,         -- Key of value in the eek.speak messages
  currentOption = 1,        -- Key of option function in eek.speak option array
  currentImage = nil,       -- Avatar image

  _VERSION     = '0.2.9',
  _URL         = 'https://github.com/twentytwoo/eek.lua',
  _DESCRIPTION = 'A simple messagebox system for LÖVE',

  UI = {}
}

-- Section of the text printed so far
local printedText  = ""
-- Timer to know when to print a new letter
local typeTimer    = eek.typeSpeed
local typeTimerMax = eek.typeSpeed
-- Current position in the text
local typePosition = 0
-- Initialise timer for the indicator
local indicatorTimer = 0
local defaultFont = love.graphics.newFont()

if eek.font == nil then
  eek.font = defaultFont
end

function eek.speak(title, messages, config)
  if type(title) == "table" then
    titleColor = title[2]
    title = title[1]
  else -- just a string
    titleColor = {255, 255, 255}
  end

  -- Config checking / defaulting
  local config = config or {}
  local x = config.x
  local y = config.y
  local image = config.image or "nil"
  local options = config.options -- or {{"",function()end},{"",function()end},{"",function()end}}
  local onstart = config.onstart or function() end
  local oncomplete = config.oncomplete or function() end
  if image == nil or type(image) ~= "userdata" then
    -- image = eek.noImage
  end

  -- Insert \n before text is printed, stops half-words being printed
  -- and then wrapped onto new line
  if eek.autoWrap then
    for i=1, #messages do
      messages[i] = eek.wordwrap(messages[i], 65)
    end
  end

  -- Insert the eek.speak into its own instance (table)
  eek.allMsgs[#eek.allMsgs+1] = {
    title=title,
    titleColor=titleColor,
    messages=messages,
    x=x,
    y=y,
    image=image,
    options=options,
    onstart=onstart,
    oncomplete=oncomplete
  }
  eek.history[#eek.history+1] = {title, messages}

  -- Set the last message as "\n", an indicator to change currentMsgInstance
  eek.allMsgs[#eek.allMsgs].messages[#messages+1] = "\n"
  eek.showingMessage = true

  -- Only run .onstart()/setup if first message instance on first eek.speak
  -- Prevents onstart=eek.speak(... recursion crashing the game.
  if eek.currentMsgInstance == 1 then
    -- Set the first message up, after this is set up via advanceMsg()
    typePosition = 0
    eek.currentMessage = eek.allMsgs[eek.currentMsgInstance].messages[eek.currentMsgKey]
    eek.currentTitle = eek.allMsgs[eek.currentMsgInstance].title
    eek.currentImage = eek.allMsgs[eek.currentMsgInstance].image
    eek.showingOptions = false
    -- Run the first startup function
    eek.allMsgs[eek.currentMsgInstance].onstart()
  end
end

function eek.update(dt)
  -- Check if the output string is equal to final string, else we must be still typing it
  if printedText == eek.currentMessage then
    typing = false else typing = true
  end

  if eek.showingMessage then
    -- Tiny timer for the message indicator
    if (eek.paused or not typing) then
      indicatorTimer = indicatorTimer + 1
      if indicatorTimer > eek.indicatorDelay then
        eek.showIndicator = not eek.showIndicator
        indicatorTimer = 0
      end
    else
      eek.showIndicator = false
    end

    -- Check if we're the 2nd to last message, verify if an options table exists, on next advance show options
    if eek.allMsgs[eek.currentMsgInstance].messages[eek.currentMsgKey+1] == "\n" and type(eek.allMsgs[eek.currentMsgInstance].options) == "table" then
      eek.showingOptions = true
    end
    if eek.showingOptions then
      -- Constantly update the option prefix
      for i=1, #eek.allMsgs[eek.currentMsgInstance].options do
        -- Remove the indicators from other selections
        eek.allMsgs[eek.currentMsgInstance].options[i][1] = string.gsub(eek.allMsgs[eek.currentMsgInstance].options[i][1], eek.optionCharacter.." " , "")
      end
      -- Add an indicator to the current selection
      if eek.allMsgs[eek.currentMsgInstance].options[eek.currentOption][1] ~= "" then
        eek.allMsgs[eek.currentMsgInstance].options[eek.currentOption][1] = eek.optionCharacter.." ".. eek.allMsgs[eek.currentMsgInstance].options[eek.currentOption][1]
      end
    end

    -- Detect a 'pause' by checking the content of the last two characters in the printedText
    if string.sub(eek.currentMessage, string.len(printedText)+1, string.len(printedText)+2) == "--" then
      eek.paused = true
      else eek.paused = false
    end

    --https://www.reddit.com/r/love2d/comments/4185xi/quick_question_typing_effect/
    if typePosition <= string.len(eek.currentMessage) then
      -- Only decrease the timer when not paused
      if not eek.paused then
        typeTimer = typeTimer - dt
      end
      -- Timer done, we need to print a new letter:
      -- Adjust position, use string.sub to get sub-string
      if typeTimer <= 0 then
        -- Only make the keypress sound if the next character is a letter
        if string.sub(eek.currentMessage, typePosition, typePosition) ~= " " and typing then
          eek.playSound(eek.typeSound)
        end
        typeTimer = typeTimerMax
        typePosition = typePosition + 1
          -- UTF8 support, thanks @FluffySifilis
        local byteoffset = utf8.offset(eek.currentMessage, typePosition)
        if byteoffset then
          printedText = string.sub(eek.currentMessage, 0, byteoffset - 1)
        end
      end
    end
  end
end

function eek.advanceMsg()
  if eek.showingMessage then
    -- Check if we're at the last message in the instances queue (+1 because "\n" indicated end of instance)
    if eek.allMsgs[eek.currentMsgInstance].messages[eek.currentMsgKey+1] == "\n" then
      -- Last message in instance, so run the final function.
      eek.allMsgs[eek.currentMsgInstance].oncomplete()

      -- Check if we're the last instance in eek.allMsgs
      if eek.allMsgs[eek.currentMsgInstance+1] == nil then
        eek.currentMsgInstance = 1
        eek.currentMsgKey = 1
        eek.currentOption = 1
        typing = false
        eek.showingMessage = false
        typePosition = 0
        eek.showingOptions = false
        eek.allMsgs = {}
      else
        -- We're not the last instance, so we can go to the next one
        -- Reset the msgKey such that we read the first msg of the new instance
        eek.currentMsgInstance = eek.currentMsgInstance + 1
        eek.currentMsgKey = 1
        eek.currentOption = 1
        typePosition = 0
        eek.showingOptions = false
        eek.moveCamera()
      end
    else
      -- We're not the last message and we can show the next one
      -- Reset type position to restart typing
      typePosition = 0
      eek.currentMsgKey = eek.currentMsgKey + 1
    end
  end

  -- Check showingMessage - throws an error if next instance is nil
  if eek.showingMessage then
    if eek.currentMsgKey == 1 then
      eek.allMsgs[eek.currentMsgInstance].onstart()
    end
    eek.currentMessage = eek.allMsgs[eek.currentMsgInstance].messages[eek.currentMsgKey] or ""
    eek.currentTitle = eek.allMsgs[eek.currentMsgInstance].title or ""
    eek.currentImage = eek.allMsgs[eek.currentMsgInstance].image
  end
end

function eek.draw()
  -- This section is mostly unfinished...
  -- Lots of magic numbers and generally takes a lot of
  -- trial and error to look right, beware.

  love.graphics.setDefaultFilter( "nearest", "nearest")
  if eek.showingMessage then
    local scale = 0.26
    local padding = 10

    local boxH = 118
    local boxW = love.graphics.getWidth()-(2*padding)
    local boxX = padding
    local boxY = love.graphics.getHeight()-(boxH+padding)

    local fontHeight = eek.font:getHeight(" ")

    local imgX = (boxX+padding)*(1/scale)
    local imgY = (boxY+padding)*(1/scale)

    if type(eek.currentImage) == "userdata" then
      imgW = eek.currentImage:getWidth()
      imgH = eek.currentImage:getHeight()
    else
      imgW = -10/(scale)
      imgH = 0
    end

    local titleBoxW = eek.font:getWidth(eek.currentTitle)+(2*padding)
    local titleBoxH = fontHeight+padding
    local titleBoxX = boxX
    local titleBoxY = boxY-titleBoxH-(padding/2)

    local titleColor = eek.allMsgs[eek.currentMsgInstance].titleColor
    local titleX = titleBoxX+padding
    local titleY = titleBoxY+2

    local textX = (imgX+imgW)/(1/scale)+padding
    local textY = boxY

    local optionsY = textY+eek.font:getHeight(printedText)-(padding/1.6)
    local optionsSpace = fontHeight/1.5

    local msgTextY = textY+eek.font:getHeight()/1.2
    local msgLimit = boxW-(imgW/(1/scale))-(4*padding)

    local fontColour = { 255, 255, 255, 255 }
    local boxColour = { 0, 0, 0, 222 }

    love.graphics.setFont(eek.font)

    -- Message title
    love.graphics.setColor(boxColour)
    love.graphics.rectangle("fill", titleBoxX, titleBoxY, titleBoxW, titleBoxH)
    love.graphics.setColor(titleColor)
    love.graphics.print(eek.currentTitle, titleX, titleY)

    -- Main message box
    love.graphics.setColor(boxColour)
    love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
    love.graphics.setColor(fontColour)

    -- Message avatar
    if type(eek.currentImage) == "userdata" then
      love.graphics.push()
        love.graphics.scale(scale, scale)
        love.graphics.draw(eek.currentImage, imgX, imgY)
      love.graphics.pop()
    end

    -- Message text
    if eek.autoWrap then
      love.graphics.print(printedText, textX, textY)
    else
      love.graphics.printf(printedText, textX, textY, msgLimit)
    end

    -- Message options (when shown)
    if eek.showingOptions and typing == false then
      for k, option in pairs(eek.allMsgs[eek.currentMsgInstance].options) do
        -- First option has no Y padding...
        love.graphics.print(option[1], textX+padding, optionsY+((k-1)*optionsSpace))
      end
    end

    -- Next message/continue indicator
    if eek.showIndicator then
      love.graphics.print(eek.indicatorCharacter, boxX+boxW-(2.5*padding), boxY+boxH-(padding/2)-fontHeight)
    end
  end

  -- Reset fonts, run debugger if allowed
  love.graphics.setFont(defaultFont)
  eek.drawDebug()
end

function eek.keypressed(key)
  -- Lazily handle the keypress
  eek.keyreleased(key)
end

function eek.keyreleased(key)
  if eek.showingOptions then
    if key == eek.selectButton and not typing then
      if eek.currentMsgKey == #eek.allMsgs[eek.currentMsgInstance].messages-1 then
        -- Execute the selected function
        for i=1, #eek.allMsgs[eek.currentMsgInstance].options do
          if eek.currentOption == i then
            eek.allMsgs[eek.currentMsgInstance].options[i][2]()
            eek.playSound(eek.optionSwitchSound)
          end
        end
      end
      -- Option selection
      elseif key == "down" or key == "s" then
        eek.currentOption = eek.currentOption + 1
        eek.playSound(eek.optionSwitchSound)
      elseif key == "up" or key == "w" then
        eek.currentOption = eek.currentOption - 1
        eek.playSound(eek.optionSwitchSound)
      end
      -- Return to top/bottom of options on overflow
      if eek.currentOption < 1 then
        eek.currentOption = #eek.allMsgs[eek.currentMsgInstance].options
      elseif eek.currentOption > #eek.allMsgs[eek.currentMsgInstance].options then
        eek.currentOption = 1
    end
  end
  -- Check if we're still typing, if we are we can skip it
  -- If not, then go to next message/instance
  if key == eek.selectButton then
    if eek.paused then
      -- Get the text left and right of "--"
      leftSide = string.sub(eek.currentMessage, 1, string.len(printedText))
      rightSide = string.sub(eek.currentMessage, string.len(printedText)+3, string.len(eek.currentMessage))
      -- And then concatenate them, kudos to @pfirsich for the help :)
      eek.currentMessage = leftSide .. " " .. rightSide
      -- Put the typerwriter back a bit and start up again
      typePosition = typePosition - 1
      typeTimer = 0
    else
      if typing == true then
        -- Skip the typing completely, replace all -- with spaces since we're skipping the pauses
        eek.currentMessage = string.gsub(eek.currentMessage, "%-%-", " ")
        printedText = eek.currentMessage
        typePosition = string.len(eek.currentMessage)
      else
        eek.advanceMsg()
      end
    end
  end
end

function eek.setSpeed(speed)
  if speed == "fast" then
    eek.typeSpeed = 0.01
  elseif speed == "medium" then
    eek.typeSpeed = 0.04
  elseif speed == "slow" then
    eek.typeSpeed = 0.08
  else
    assert(tonumber(speed), "eek.setSpeed() - Expected number, got " .. tostring(speed))
    eek.typeSpeed = speed
  end
  -- Update the timeout timer.
  typeTimerMax = eek.typeSpeed
end

function eek.setCamera(camToUse)
  eek.currentCamera = camToUse
end

function eek.moveCamera()
  -- Only move the camera if one exists
  if eek.currentCamera ~= nil then
    -- Move the camera to the new instances position
    if (eek.allMsgs[eek.currentMsgInstance].x and eek.allMsgs[eek.currentMsgInstance].y) ~= nil then
      flux.to(eek.currentCamera, 1, { x = eek.allMsgs[eek.currentMsgInstance].x, y = eek.allMsgs[eek.currentMsgInstance].y }):ease("cubicout")
    end
  end
end

function eek.setTheme(style)
  for _, setting in pairs(eek.UI) do
  end
end

function eek.playSound(sound)
  if type(sound) == "userdata" then
    sound:play()
  end
end

function eek.clearMessages()
  eek.showingMessage = false -- Prevents crashing
  eek.currentMsgKey = 1
  eek.currentMsgInstance = 1
  eek.allMsgs = {}
end

function eek.defMsgContainer(table)
  eek.allMsgs = table
end

function eek.drawDebug()
  if eek.debug == true then
    log = { -- It works...
      "typing", typing,
      "paused", eek.paused,
      "showOptions", eek.showingOptions,
      "indicatorTimer", indicatorTimer,
      "showIndicator", eek.showIndicator,
      "printedText", printedText,
      "textToPrint", eek.currentMessage,
      "currentMsgInstance", eek.currentMsgInstance,
      "currentMsgKey", eek.currentMsgKey,
      "currentOption", eek.currentOption,
      "currentHeader", utf8.sub(eek.currentMessage, utf8.len(printedText)+1, utf8.len(printedText)+2),
      "typeSpeed", eek.typeSpeed,
      "typeSound", type(eek.typeSound) .. " " .. tostring(eek.typeSound),
      "eek.allMsgs.len", #eek.allMsgs,
      --"titleColor", unpack(eek.allMsgs[eek.currentMsgInstance].titleColor)
    }
    for i=1, #log, 2 do
      love.graphics.print(tostring(log[i]) .. ":  " .. tostring(log[i+1]), 10, 7*i)
    end
  end
end

-- External UTF8 functions
-- https://github.com/alexander-yakushev/awesompd/blob/master/utf8.lua
function utf8.charbytes (s, i)
   -- argument defaults
   i = i or 1
   local c = string.byte(s, i)

   -- determine bytes needed for character, based on RFC 3629
   if c > 0 and c <= 127 then
      -- UTF8-1
      return 1
   elseif c >= 194 and c <= 223 then
      -- UTF8-2
      local c2 = string.byte(s, i + 1)
      return 2
   elseif c >= 224 and c <= 239 then
      -- UTF8-3
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      return 3
   elseif c >= 240 and c <= 244 then
      -- UTF8-4
      local c2 = s:byte(i + 1)
      local c3 = s:byte(i + 2)
      local c4 = s:byte(i + 3)
      return 4
   end
end

function utf8.sub (s, i, j)
   j = j or -1

   if i == nil then
      return ""
   end

   local pos = 1
   local bytes = string.len(s)
   local len = 0

   -- only set l if i or j is negative
   local l = (i >= 0 and j >= 0) or utf8.len(s)
   local startChar = (i >= 0) and i or l + i + 1
   local endChar = (j >= 0) and j or l + j + 1

   -- can't have start before end!
   if startChar > endChar then
      return ""
   end

   -- byte offsets to pass to string.sub
   local startByte, endByte = 1, bytes

   while pos <= bytes do
      len = len + 1

      if len == startChar then
   startByte = pos
      end

      pos = pos + utf8.charbytes(s, pos)

      if len == endChar then
   endByte = pos - 1
   break
      end
   end

   return string.sub(s, startByte, endByte)
end

-- ripped from https://github.com/rxi/lume
function eek.wordwrap(str, limit)
  limit = limit or 72
  local check
  if type(limit) == "number" then
    check = function(s) return #s >= limit end
  else
    check = limit
  end
  local rtn = {}
  local line = ""
  for word, spaces in str:gmatch("(%S+)(%s*)") do
    local s = line .. word
    if check(s) then
      table.insert(rtn, line .. "\n")
      line = word
    else
      line = s
    end
    for c in spaces:gmatch(".") do
      if c == "\n" then
        table.insert(rtn, line .. "\n")
        line = ""
      else
        line = line .. c
      end
    end
  end
  table.insert(rtn, line)
  return table.concat(rtn)
end

return eek