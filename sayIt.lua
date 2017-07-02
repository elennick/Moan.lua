-- A really crappy hacky love2d dialogue thing
-- github.com/twentytwoo
sayIt = {}
function sayIt.Init()
	sayIt.Font = love.graphics.newFont("monobit.ttf", 32)
	love.graphics.setDefaultFilter("nearest", "nearest") -- No AA
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

function sayIt.New(title, message, x, y)
	-- Let the first message have the first title
	table.insert(titles, title)
	messages.title = titles[1]
	-- Set up the images, x, y
	sayIt.Next()
	-- Insert our messages into the table to be parsed
	for k,v in ipairs(message) do
		table.insert(messages, message[k])
	end -- Let them be displayed
	textToPrint = messages[1]
	showingMessage = true
end

function sayIt.Update(dt)
	collectgarbage() -- Somewhat helps things with below newImage

	if messages[currentMessage] == "\n" then -- End of sayIt.New (multiple)
		if messages[currentMessage + 1] ~= nil then -- Allow "\n" on single message
			-- Skip the "\n" msg, go to next title and dispaly it
			currentMessage = currentMessage + 1
			currentTitle = currentTitle + 1
			textToPrint = messages[currentMessage]
			messages.title = titles[currentTitle]
			titleImage = messages.title
			sayIt.Next()
		else -- Hide the "\n" whitespace (hacky :P)
			showingMessage = false
		end
	end

    --camera:lookAt(p2.x, p2.y)

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
		        printedText = string.sub(textToPrint, 0, typePosition)
		    end
	    end
	end
end

function sayIt.Draw(dt)
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
	local padding = 10
	local boxHeight = 125
	local scale = 0.25
	-- img dimensions = boxHeight - (2*padding)
	local msgBoxPosX = 0+padding
	local msgBoxPosY = height-padding
	local msgBoxBg = { 0, 0, 0, 255 } -- RGBA
	local msgFontColor = { 255, 255, 255, 255}
	if showingMessage then -- Draw the message
		-- Replace spaces in title with _ for the image
	    love.graphics.setColor( msgBoxBg )
	    love.graphics.rectangle("fill", msgBoxPosX, msgBoxPosY, width-(padding*2), -(boxHeight), 10, 0, 10 )

	    love.graphics.push()
	    	love.graphics.scale(scale, scale)
	    	love.graphics.setColor(255,255,255)
			love.graphics.draw(titleImage, (msgBoxPosX+padding)*(1/scale), msgBoxPosY*(1/scale)-titleImgHeight-padding*(1/scale)) -- Look into a better way of this -> collectgarbage()
	    love.graphics.pop()

	    love.graphics.push()
	    	love.graphics.setFont(sayIt.Font)
		    love.graphics.setColor( msgFontColor )
		    love.graphics.print(messages.title, msgBoxPosX+(2*padding)+(titleImgWidth/(1/scale)), msgBoxPosY-boxHeight)
			love.graphics.printf(printedText, msgBoxPosX+(2*padding)+(titleImgWidth/(1/scale)), msgBoxPosY-boxHeight+(padding*2), msgBoxPosX+width-(4*padding), "left")
			if messages[currentMessage+1] ~= nil then
				love.graphics.print(">", msgBoxPosX+width-(4*padding), msgBoxPosY-(3.5*padding))
			end
		love.graphics.pop()
	end
end

function sayIt.Handler(key)
	if key == "return" and showingMessage then
		if typing == true then -- We can skip the typing
			printedText = messages[currentMessage]
			-- Tell it we've finished typing
			typePosition = string.len(messages[currentMessage])
		else -- We can show a new message!
			-- Check the current message queue if we've finsihed
			if messages[currentMessage + 1] == nil then -- Close everything
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

function sayIt.Next()
	titleImage = love.graphics.newImage(string.gsub(messages.title, " ", "_") .. ".png")
	titleImgWidth, titleImgHeight = titleImage:getWidth(), titleImage:getHeight()
end