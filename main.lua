require('sayIt')

function love.load()
	sayIt.Init()
end

function love.update(dt)
	sayIt.Update(dt)
	if love.keyboard.isDown('q') then
		sayIt.New("Mike Pence", {"Take it up the crapper...", "Get the zapper!", "Traps are qt."})
	end
end

function love.draw(dt)
    love.graphics.setColor( 255, 255, 255 )
	love.graphics.setBackgroundColor( 100, 100, 100 )
	love.graphics.print("Current queue: " .. currentMessage, 10, 10)
	love.graphics.print("To print: " .. textToPrint, 10, 25)
	love.graphics.print("Typing?: " .. tostring(typing), 10, 40)
	sayIt.Draw()
end

function love.keyreleased(key)
	sayIt.Handler(key)
	if key == "w" then
		sayIt.New("Mike Pence", {"Take it up the crapper...", "Get the zapper!", "Traps are qt."})
	end
end

function love.quit( )
	for k,v in pairs(messages) do print(k,v) end
	for k,v in pairs(titles) do print(k,v) end
end
