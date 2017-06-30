function love.load()
	sayIt_Init()
end

function love.update( dt )

end

function love.draw( )
	love.graphics.setBackgroundColor( 100, 100, 100  )
	sayIt_New({"Test", "Test no. two", "And three :)" }, 100, 10, 0, "box")
end


function love.keyreleased(key)
	sayIt_Handler(key)
end

function sayIt_New(message, x, y, size, msgType, effect )
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	-- Config
	local padding = 10
	local boxHeight = 150
	local msgBoxPosX = 0+padding
	local msgBoxPosY = height-padding
	local msgBoxBg = { 255, 255, 255, 255 } -- RGBA
	local msgFontColor = { 0, 0, 0, 255}
	if showMessage then
		if message[count] == nil then
			message[count] = "" -- stops the expected string?
			showMessage = false
		end
		if msgType == "box" then
		    love.graphics.setColor( msgBoxBg )
		    love.graphics.rectangle("fill", msgBoxPosX, msgBoxPosY, width-(padding*2), -(boxHeight) )
		    love.graphics.setColor( msgFontColor )
			love.graphics.print(message[count], msgBoxPosX+padding, msgBoxPosY-boxHeight+padding)
		else
		    love.graphics.setColor( msgFontColor )
		    love.graphics.print(message, x, y )
		end
	end
end

function sayIt_Update(dt)

end

function sayIt_Init()
	count = 1
	showMessage = true
end

function sayIt_Handler(key)
   if key == "return" then
      count = count + 1
   end
end