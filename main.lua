require 'sayIt'

function love.load()
	sayIt.Init()
end

function love.update(dt)
	sayIt.Update()
	if love.keyboard.isDown('q') then
		sayIt.New("Mike Pence", {"Take it up the crapper...", "Get the zapper!", "Traps are qt.", "\n"})
	end
end

function love.draw( )
	love.graphics.setBackgroundColor( 100, 100, 100 )
	love.graphics.print(currentMessage, 10, 10)
	sayIt.Draw()
end

function love.keyreleased(key)
	sayIt.Handler(key)
	if key == "w" then
		sayIt.New("Mike Pence", {"Take it up the crapper...", "Get the zapper!", "Traps are qt.", "\n"})
		sayIt.New("Scotch Egg", {"Say...", "You wouldn't have happen to come across any", "Female cohorts whom art being taught?", "\n" })
		sayIt.New("Bill Nye", {"This next segment coming up is really good", "Lots of schmear", "Oy vey!"})
	end
end

function love.quit( )
	for k,v in pairs(messages) do print(k,v) end
	for k,v in pairs(titles) do print(k,v) end
end
