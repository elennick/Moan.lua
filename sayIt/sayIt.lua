-- A really crappy hacky love2d dialogue thing
-- github.com/twentytwoo
Camera = require("sayIt/libs/camera")
flux = require("sayIt/libs/flux")
sayIt = {}
function sayIt.Init()
	sayIt.console = true
	sayIt.Font = love.graphics.newFont("sayIt/monobit.ttf", 32)
	sayIt.defaultFont = love.graphics.getFont()
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
	typeTimerMax = 0.005
	typeTimer    = 0.005
	-- Current position in the text
	typePosition = 0
    camera = Camera(0, 0, 0.5)
end

function sayIt.New(title, message, x, y)
	-- Let the first message have the first title
	table.insert(titles, title)
	-- Create a subtable for our coords inside coords table
	coords[#coords+1] = {x, y}
	messages.title = titles[1]
	-- Set up initial the images + x, y
	sayIt.Next()
	for k,v in ipairs(message) do
		table.insert(messages, message[k])
	end
	--[[ Hacly way of ending the functions message, tells us that this message is over,
	     and we should change x/y + title according to the next sayIt.New() called ]]
	table.insert(messages, "\n")
	textToPrint = messages[1]
	showingMessage = true
end

function sayIt.Update(dt)
	collectgarbage() -- Stops the new titleImage filling up the RAM
	if messages[currentMessage] == "\n" then -- End of sayIt.New function
		if messages[currentMessage + 1] ~= nil then -- Allow "\n" on single message
			-- Skip the "\n" msg, go to next title/msg and display it
			currentMessage = currentMessage + 1
			currentMsgCount = currentMsgCount + 1
			textToPrint = messages[currentMessage]
			messages.title = titles[currentMsgCount]
			titleImage = messages.title
			sayIt.Next()
		else -- Hide the "\n" whitespace (hacky :P)
			showingMessage = false
		end
	end

	if messages[currentMessage] == printedText then -- We've finished typing the sentence
		typing = false
		else typing = true
	end


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
		        typeTimer = 0.005
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
			love.graphics.printf(printedText, msgBoxPosX+(2*padding)+(titleImgWidth/(1/scale)), msgBoxPosY-boxHeight+(padding*2.2), msgBoxPosX+width-(6*padding)-(titleImgWidth/(1/scale)), "left")
			if messages[currentMessage+1] ~= nil then
				love.graphics.print(">", msgBoxPosX+width-(4*padding), msgBoxPosY-(3.5*padding))
			end
		love.graphics.pop()
	end
	if sayIt.console == true then
	    love.graphics.push()
	    	love.graphics.setFont(sayIt.defaultFont)
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

function sayIt.Handler(key)
	if key == "return" and showingMessage then
		if typing == true then -- We can skip the typing
			printedText = messages[currentMessage]
			-- Tell it we've finished typing
			typePosition = string.len(messages[currentMessage])
		else -- We can show a new message!
			-- Check the current message queue if we've finsihed
			if messages[currentMessage + 1] == nil then -- Close everything
				showingMessage = false
				textToPrint = "" -- Do not crash - please!
				typePosition = 0
				currentMessage, currentMsgCount = 1, 1 -- Reset the counter position
				-- Remove the shown messages / titles
				sayIt.ResetTable(messages)
				sayIt.ResetTable(titles)
				sayIt.ResetTable(coords)
				currentMessage = 1
			else -- Show the next message in the array
				currentMessage = currentMessage + 1
				textToPrint = messages[currentMessage]
				typePosition = 0 -- Start typing from the start
			end
		end
	end
end

function sayIt.Next() -- DRY
	if (coords[currentMsgCount][1] and coords[currentMsgCount][2]) ~= nil then
		-- Tween the camera to the next position
		flux.to(camera, 1, { x = coords[currentMsgCount][1], y = coords[currentMsgCount][2] }):ease("cubicout")
	end
	titleImage = love.graphics.newImage(string.gsub(messages.title, " ", "_") .. ".png")
	titleImgWidth, titleImgHeight = titleImage:getWidth(), titleImage:getHeight()
end

function sayIt.ResetTable(table)
	for k,v in ipairs(table) do table[k] = nil end
end

function sayIt.Debug()
	for k,v in pairs(messages) do print(k,v) end
	for k,v in pairs(titles) do print(k,v) end
end