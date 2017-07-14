local PATH = (...):match('^(.*[%./])[^%.%/]+$') or '' -- ech
Moan = {
	selectButton = "return",
	indicatorCharacter = ">",
	currentMsgInstance = 1, -- The Moan.New called
	currentMsgKey= 1,
	currentOption = 1,
	currentImage = nil,
	typeSpeed = 0.02,
	currentMessage  = "",
	Font = love.graphics.newFont(PATH .. "main.ttf", 32),

	_VERSION     = 'Möan v0.2.1',
	_URL         = 'https://github.com/twentytwoo/Moan.lua',
	_DESCRIPTION = 'A simple visual-novel messagebox for LÖVE',
	_LICENSE     = [[
	MIT LICENSE

	Copyright (c) 2017 May W.

	Permission is hereby granted, free of charge, to any person obtaining a
	copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be included
	in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
	TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
	SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
	]]
}
-- Require libs
Camera = require(PATH .."/libs/camera")
local flux = require(PATH .."libs/flux")
local utf8 = require("utf8")

-- Create the message instance container
allMessages ={}

local printedText  = "" -- Section of the text printed so far
-- Timer to know when to print a new letter
local typeTimer    = Moan.typeSpeed
local typeTimerMax = Moan.typeSpeed
-- Current position in the text
local typePosition = 0

love.graphics.setDefaultFilter( "nearest", "nearest")

function Moan.new(title, messages, x, y, image, options)
	-- Set default options to nothing such that no error is thrown in advanceMsg()
	options = options or {{"",function()end},{"",function()end},{"",function()end}}
	if image == nil or love.filesystem.exists(image) == false then
		image = PATH .. "noImg.png"
	end
	-- Insert the Moan.new into its own instance (table)
	allMessages[#allMessages+1] = {title=title, messages=messages, x=x, y=y, image=image, options=options}
	-- Set the last message as "\n", an indicator to change currentMsgInstance
	allMessages[#allMessages].messages[#messages+1] = "\n"
	Moan.showingMessage = true
	typePosition = 0
	-- Set the first message up, after this is set up via advanceMsg()
	Moan.currentMessage = allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey]
	Moan.currentTitle = allMessages[Moan.currentMsgInstance].title
	Moan.currentImage = love.graphics.newImage(allMessages[Moan.currentMsgInstance].image)
	Moan.showingOptions = false

end

function Moan.update(dt)
	-- Update tweening library
	flux.update(dt)
	-- Be wary of updating the camera every dt...
	Moan.moveCamera()
	--collectgarbage()
	-- Check if we're on the 2nd to last message in the instance, on the next advance we should be able to select an option
	if Moan.showingMessage then
		if allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey+1] == "\n" then
			Moan.showingOptions = true
		end
		if Moan.showingOptions then
			-- Constantly update the option prefix
			for i=1, 3 do
				-- Remove "- " from other selections
				allMessages[Moan.currentMsgInstance].options[i][1] = string.gsub(allMessages[Moan.currentMsgInstance].options[i][1], Moan.indicatorCharacter.." " , "")
			end
			-- Add an indicator to the current selection
			if allMessages[Moan.currentMsgInstance].options[Moan.currentOption][1] ~= "" then
				allMessages[Moan.currentMsgInstance].options[Moan.currentOption][1] = Moan.indicatorCharacter.." ".. allMessages[Moan.currentMsgInstance].options[Moan.currentOption][1]
			end
		end
	end

	-- Check the current typing status
	if printedText == Moan.currentMessage then
		typing = false else typing = true
	end

	if Moan.showingMessage then
		--https://www.reddit.com/r/love2d/comments/4185xi/quick_question_typing_effect/
		if typePosition <= string.len(Moan.currentMessage) then
		    -- Decrease timer
		    typeTimer = typeTimer - dt
		    -- Timer done, we need to print a new letter:
		    -- Adjust position, use string.sub to get sub-string
		    if typeTimer <= 0 then
		        typeTimer = typeTimerMax
		        typePosition = typePosition + 1

		        -- UTF8 support, thanks @FluffySifilis
				local byteoffset = utf8.offset(Moan.currentMessage, typePosition)
				if byteoffset then
					printedText = string.sub(Moan.currentMessage, 0, byteoffset - 1)
				end
		    end
		end
	end
end

function Moan.advanceMsg()
	if Moan.showingMessage then
		-- Check if we're at the last message in the instances queue (+1 because "\n" indicated end of instance)
		if allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey+1] == "\n" then
			-- Check if we're the last instance in allMessages
			if allMessages[Moan.currentMsgInstance+1] == nil then
				Moan.currentMsgInstance = 1
				Moan.currentMsgKey = 1
				Moan.currentOption = 1
				typing = false
				Moan.showingMessage = false
				typePosition = 0
				Moan.showingOptions = false
				for k,v in pairs(allMessages) do k = nil end
			else
				-- We're not the last instance, so we can go to the next one
				-- Reset the msgKey such that we read the first msg of the new instance
				Moan.currentMsgInstance = Moan.currentMsgInstance + 1
				Moan.currentMsgKey = 1
				Moan.currentOption = 1
				typePosition = 0
				Moan.showingOptions = false
				Moan.moveCamera()
			end
		else
			-- We're not the last message and we can show the next one
			-- Reset type position to restart typing
			typePosition = 0
			Moan.currentMsgKey = Moan.currentMsgKey + 1
		end
	Moan.currentMessage = allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey] or ""
	Moan.currentTitle = allMessages[Moan.currentMsgInstance].title or ""
	Moan.currentImage = love.graphics.newImage(allMessages[Moan.currentMsgInstance].image)
	end

end

function Moan.draw()
	if Moan.showingMessage then
		local scale = 0.30
		local padding = 10
		local boxH = 133
		local boxW = love.graphics.getWidth()-(2*padding)
		local boxX = padding
		local boxY = love.graphics.getHeight()-(boxH+padding)
		local imgX = (boxX+padding)*(1/scale)
		local imgY = (boxY+padding)*(1/scale)
		local imgW = Moan.currentImage:getWidth()
		local imgH = Moan.currentImage:getHeight()
		local textX = (imgX+imgW)/(1/scale)+padding
		local textY = boxY+padding
		local msgTextY = textY+Moan.Font:getHeight()
		local msgLimit = boxW-(imgW/(1/scale))-(2*padding)
		local fontColour = { 255, 255, 255, 255 }
		local boxColour = { 0, 0, 0, 255 }
		love.graphics.setColor(boxColour)
		love.graphics.rectangle("fill", boxX, boxY, boxW, boxH)
		love.graphics.setColor(fontColour)
		love.graphics.push()
			love.graphics.scale(scale, scale)
			love.graphics.draw(Moan.currentImage, imgX, imgY)
		love.graphics.pop()
		love.graphics.setFont(Moan.Font)
		love.graphics.printf(Moan.currentTitle, textX, textY, boxW)
		love.graphics.printf(printedText, textX, msgTextY, msgLimit)
		if Moan.showingOptions and typing == false then
			love.graphics.print(allMessages[Moan.currentMsgInstance].options[1][1], textX+padding, msgTextY+1*(2.4*padding))
			love.graphics.print(allMessages[Moan.currentMsgInstance].options[2][1], textX+padding, msgTextY+2*(2.4*padding))
			love.graphics.print(allMessages[Moan.currentMsgInstance].options[3][1], textX+padding, msgTextY+3*(2.4*padding))
		end
		--if allMessages[Moan.currentMsgInstance+1] ~= nil and allMessages[Moan.currentMsgInstance].messages[Moan.currentMsgKey+1] ~= "\n" then
			love.graphics.print(">", boxX+boxW-(2.5*padding), boxY+boxH-(3*padding))
		--end
	end
end

function Moan.keyreleased(key)
	if Moan.showingOptions then
		if key == Moan.selectButton and not typing then
			if Moan.currentOption == 1 then
				-- First key is option (string), 2nd is function
				-- options[option][function]
				allMessages[Moan.currentMsgInstance].options[1][2]()
			elseif Moan.currentOption == 2 then
				allMessages[Moan.currentMsgInstance].options[2][2]()
			elseif Moan.currentOption == 3 then
				allMessages[Moan.currentMsgInstance].options[3][2]()
			end
		-- Option selection
		elseif key == "down" or key == "s" then
			Moan.currentOption = Moan.currentOption + 1
		elseif key == "up" or key == "w" then
			Moan.currentOption = Moan.currentOption - 1
		end
		-- Return to top/bottom of options on overflow
		if Moan.currentOption < 1 then
			Moan.currentOption = 3
		elseif Moan.currentOption > 3 then
			Moan.currentOption = 1
		end
	end
	-- Check if we're still typing, if we are we can skip it
	-- If not, then go to next message/instance
	if key == Moan.selectButton then
		if typing == true then
			printedText = Moan.currentMessage
			typePosition = string.len(Moan.currentMessage)
		else
			Moan.advanceMsg()
		end
	end
end

function Moan.moveCamera()
	-- Move the camera to the new instances position
	if (allMessages[Moan.currentMsgInstance].x and allMessages[Moan.currentMsgInstance].y) ~= nil then
		flux.to(camera, 1, { x = allMessages[Moan.currentMsgInstance].x, y = allMessages[Moan.currentMsgInstance].y }):ease("cubicout")
	end
end

function Moan.clearMessages()
	for k,v in pairs(allMessages) do k = nil end
end