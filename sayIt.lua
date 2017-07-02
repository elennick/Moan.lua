-- A really crappy lua messenger
sayIt = {}
function sayIt.Init()
	messages = {}
	titles = {}
	currentMessage = 1
	currentTitle = 1
	showingMessage = false

	textToPrint = messages[1] or ""
	printedText  = "" -- Section of the text printed so far

	-- Timer to know when to print a new letter
	typeTimerMax = 0.01
	typeTimer    = 0.01
	-- Current position in the text
	typePosition = 0
end

function sayIt.New(title, message)
	table.insert(titles, title)
	messages.title = titles[1]
	-- Insert our messages into the table to be parsed
	for k,v in ipairs(message) do
		table.insert(messages, message[k])
	end -- Let them be displayed
	textToPrint = messages[1]
	showingMessage = true
end

function sayIt.Update(dt)
	if messages[currentMessage] == "\n" then -- End of sayIt.New (multiple)
		if messages[currentMessage + 1] ~= nil then -- Allow "\n" on single message
			-- Skip the "\n" msg, go to next title and dispaly it
			currentMessage = currentMessage + 1
			currentTitle = currentTitle + 1
			textToPrint = messages[currentMessage]
			messages.title = titles[currentTitle]
		else -- Hide the "\n" whitespace (hacky :P)
			showingMessage = false
		end
	end

	if messages[currentMessage] == printedText then -- We've finished typing the sentence
		typing = false
		else typing = true
	end

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
		        typeTimer = 0.05
		        typePosition = typePosition + 1

		        printedText = string.sub(textToPrint,0,typePosition)
		    end
	    end
	end
end

function sayIt.Draw(dt)
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
		love.graphics.printf(printedText, msgBoxPosX+padding, msgBoxPosY-boxHeight+(padding*3), msgBoxPosX+width-(4*padding), "left")
		if messages[currentMessage+1] ~= nil then
			love.graphics.print(">", msgBoxPosX+width-(4*padding), msgBoxPosY-(2*padding))
		end
	end
end

function sayIt.Handler(key)
	if key == "return" and showingMessage then
		if typing == true then -- We can skip the typing
			-- Make the output == to message
			printedText = messages[currentMessage]
			-- Tell it we've finished typing
			typePosition = string.len(messages[currentMessage])
		else -- We can show a new message!
			-- Check the current message queue
			if messages[currentMessage+1] == nil then -- Close everything
				textToPrint = "" -- Do not crash - please!
				showingMessage = false
				currentMessage, currentTitle = 1, 1 -- Reset the counter position
				-- Remove the shown messages / titles
				for k,v in pairs(messages) do messages[k] = nil end
				for k,v in pairs(titles) do titles[k] = nil end
				currentMessage = 1
			else -- Show the next message in the array
				currentMessage = currentMessage + 1
				textToPrint = messages[currentMessage]
				typePosition = 0 -- Start typing from the start
			end
		end
	end
end