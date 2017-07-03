-- A really crappy hacky love2d dialogue thing
-- github.com/twentytwoo
Camera = require("Moan/libs/camera")
flux = require("Moan/libs/flux")
Moan = {
  _VERSION     = 'Moan v0.1',
  _URL         = 'https://github.com/twentytwoo/Moan.lua',
  _DESCRIPTION = 'A simple dialogue box for LOVE',
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

function Moan.Init()
	-- Main config options, graphical config in Moan.Draw(dt)
	assetsDir = "assets/"
	cameraSpeed = 1
	typeSpeed = 0.005
	Moan.Console = true
	Moan.Font = love.graphics.newFont("Moan/monobit.ttf", 32)

	-- Other stuff you don't care about
	Moan.defaultFont = love.graphics.getFont()
	love.graphics.setDefaultFilter("nearest", "nearest") -- No AA
	messages = {}
	titles = {}
	coords = {}
	currentMessage = 1
	currentMsgCount = 1
	showingMessage = false
	textToPrint = messages[1] or ""
	printedText  = "" -- Section of the text printed so far
	-- Timer to know when to print a new letter
	typeTimerMax = typeSpeed
	typeTimer    = typeSpeed
	-- Current position in the text
	typePosition = 0
end

function Moan.New(title, message, x, y)
	-- Let the first message have the first title
	table.insert(titles, title)
	-- Create a subtable for our coords inside coords table
	coords[#coords+1] = {x, y}
	messages.title = titles[1]
	-- Set up initial the images + x, y
	Moan.Next()
	for k,v in ipairs(message) do
		table.insert(messages, message[k])
	end
	--[[ Hackish way of ending the functions message, tells us that this message is over,
	     and we should change x/y + title according to the next Moan.New() called ]]
	table.insert(messages, "\n")
	textToPrint = messages[1]
	showingMessage = true
end

function Moan.Update(dt)
	collectgarbage() -- Stops the new titleImage filling up the RAM
	if messages[currentMessage] == "\n" then -- End of Moan.New function
		if messages[currentMessage + 2] ~= nil then -- Allow "\n" on single message
			-- Skip the "\n" msg, go to next title/msg and display it
			currentMessage = currentMessage + 1
			currentMsgCount = currentMsgCount + 1
			textToPrint = messages[currentMessage]
			messages.title = titles[currentMsgCount]
			titleImage = messages.title
			Moan.Next()
		else -- Hide the "\n" whitespace (hacky :P)
			showingMessage = false
		end
	end

	if messages[currentMessage] == printedText then -- We've finished typing the sentence
		typing = false
		else typing = true
	end

	-- Update tweening lib
	flux.update(dt)

	-- https://www.reddit.com/r/love2d/comments/4185xi/quick_question_typing_effect/
	if typePosition <= string.len(textToPrint) then
		if showingMessage == true then
			-- Decrease timer
		    typeTimer = typeTimer - dt
		end
	    if typeTimer <= 0 then
		    -- Timer done, we need to print a new letter:
		    -- Adjust position, use string.sub to get sub-string
		    if typeTimer <= 0 then
		        typeTimer = typeSpeed
		        typePosition = typePosition + 1
		        printedText = string.sub(textToPrint, 0, typePosition)
		    end
	    end
	end
end

function Moan.Draw(dt)
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	local padding = 10
	local boxHeight = 125
	local scale = 0.25
	-- img dimensions = boxHeight - (2*padding)
	local msgBoxPosX = 0+padding
	local msgBoxPosY = height-padding
	local msgBgColor = { 0, 0, 0, 255 } -- RGBA
	local msgFontColor = { 255, 255, 255, 255}
	if showingMessage then -- Draw the message
		-- Replace spaces in title with _ for the image
	    love.graphics.setColor( msgBgColor )
	    love.graphics.rectangle("fill", msgBoxPosX, msgBoxPosY, width-(padding*2), -(boxHeight), 10, 0, 10 )

	    love.graphics.push()
	    	love.graphics.scale(scale, scale)
	    	love.graphics.setColor(255,255,255)
			love.graphics.draw(titleImage, (msgBoxPosX+padding)*(1/scale), msgBoxPosY*(1/scale)-titleImgHeight-padding*(1/scale)) -- Look into a better way of this -> collectgarbage()
	    love.graphics.pop()

	    love.graphics.push()
	    	love.graphics.setFont(Moan.Font)
		    love.graphics.setColor( msgFontColor )
		    love.graphics.print(messages.title, msgBoxPosX+(2*padding)+(titleImgWidth/(1/scale)), msgBoxPosY-boxHeight)
			love.graphics.printf(printedText, msgBoxPosX+(2*padding)+(titleImgWidth/(1/scale)), msgBoxPosY-boxHeight+(padding*2.2), msgBoxPosX+width-(6*padding)-(titleImgWidth/(1/scale)), "left")
			if messages[currentMessage + 2] ~= nil then -- not "`\n"
				love.graphics.print(">", msgBoxPosX+width-(4*padding), msgBoxPosY-(3.5*padding))
			end
		love.graphics.pop()
	end

	if Moan.Console == true then
	    love.graphics.push()
	    	love.graphics.setFont(Moan.defaultFont)
		    love.graphics.setColor( 255, 255, 255 )
			love.graphics.printf("currentMessage: " .. currentMessage 	.. "\n" ..
								"currentMsgCount: " .. currentMsgCount 		.. "\n" ..
								"To print: " .. textToPrint 			.. "\n" ..
								"No. messages: " .. #messages 			.. "\n" ..
								"Typing?: " .. tostring(typing) 		.. "\n" -- END
								, 10, 10, love.graphics.getWidth( )/2)
		love.graphics.pop()
	end
end

function Moan.Handler(key)
	if key == "return" and showingMessage then
		if typing == true then -- We can skip the typing
			printedText = messages[currentMessage]
			-- Tell it we've finished typing
			typePosition = string.len(messages[currentMessage])
		else -- We can show a new message!
			-- Check the current message queue if we've finsihed
			if messages[currentMessage + 2] == nil then -- Close everything
				showingMessage = false
				textToPrint = "" -- Do not crash - please!
				typePosition = 0
				currentMessage, currentMsgCount = 1, 1 -- Reset the counter position
				-- Remove the shown messages / titles
				Moan.ResetTable(messages)
				Moan.ResetTable(titles)
				Moan.ResetTable(coords)
				currentMessage = 1
			else -- Show the next message in the array
				currentMessage = currentMessage + 1
				textToPrint = messages[currentMessage]
				typePosition = 0 -- Start typing from the start
			end
		end
	end
end

function Moan.Next() -- DRY
	if (coords[currentMsgCount][1] and coords[currentMsgCount][2]) ~= nil then
		-- Tween the camera to the next position
		flux.to(camera, cameraSpeed, { x = coords[currentMsgCount][1], y = coords[currentMsgCount][2] }):ease("cubicout")
	end
	-- Combine the asset directory w/ the title and replace spaces with _'s
	titleImage = love.graphics.newImage(string.gsub(assetsDir .. messages.title, " ", "_") .. ".png")
	titleImgWidth, titleImgHeight = titleImage:getWidth(), titleImage:getHeight()
end

function Moan.ResetTable(table)
	for k,v in ipairs(table) do table[k] = nil end
end

function Moan.Debug()
	for k,v in pairs(messages) do print(k,v) end
	for k,v in pairs(titles) do print(k,v) end
	for k,v in pairs(coords) do print(k,v) end
end