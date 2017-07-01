-- A really crappy lua messenger
sayIt = {}
function sayIt.Init()
	messages = {}
	titles = {}
	currentMessage = 1
	currentTitle = 1
	showingMessage = false
end

function sayIt.New(title, message)
	table.insert(titles, title)
	messages.title = titles[1]
	-- Insert our messages into the table to be parsed
	for k,v in ipairs(message) do
		table.insert(messages, message[k])
	end -- Let them be displayed
	showingMessage = true
end

function sayIt.Update()
	-- If all messages have been shown, close the msgbox.
	if currentMessage > #messages then
		showingMessage = false -- Hide the messages
		currentMessage, currentTitle = 1, 1 -- Reset the counter position
		-- Remove the shown messages / titles
		for k,v in pairs(messages) do messages[k] = nil end
		for k,v in pairs(titles) do titles[k] = nil end
	end
	if messages[currentMessage] == "\n" then -- End of sayIt.New
		if messages[currentMessage+1] ~= nil then -- Allow "\n" on single message
			-- Skip the "\n" msg, go to next title and disply it
			currentMessage = currentMessage + 1
			currentTitle = currentTitle + 1
			messages.title = titles[currentTitle]
		else -- Hide the "\n" whitespace (hacky :P)
			showingMessage = false
		end
	end
end

function sayIt.Draw()
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	local padding = 10
	local boxHeight = 150
	local msgBoxPosX = 0+padding
	local msgBoxPosY = height-padding
	local msgBoxBg = { 255, 255, 255, 255 } -- RGBA
	local msgFontColor = { 0, 0, 0, 255}
	if showingMessage then
	    love.graphics.setColor( msgBoxBg )
	    love.graphics.rectangle("fill", msgBoxPosX, msgBoxPosY, width-(padding*2), -(boxHeight) )
	    love.graphics.setColor( msgFontColor )
	    love.graphics.print(messages.title, msgBoxPosX+padding, msgBoxPosY-boxHeight+(padding))
		love.graphics.print(messages[currentMessage], msgBoxPosX+padding, msgBoxPosY-boxHeight+(padding*3))
		if messages[currentMessage+1] ~= nil then
			love.graphics.print("Next", msgBoxPosX+width-(6*padding), msgBoxPosY-(2*padding))
		end
	end
end

function sayIt.Handler(key)
	if key == "return" and showingMessage then
		-- Show the next message in the array
		currentMessage = currentMessage + 1
	end
end