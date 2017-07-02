require('sayIt')
Camera = require "camera"


function love.load()
	sayIt.Init()
	defaultfont = love.graphics.getFont()
	p1 = { x = 100, y = 250 }
	p2 = { x = 600, y = 250 }
    camera = Camera(p1.x, p1.y, 0.5)
end

function love.update(dt)

	sayIt.Update(dt)
	if love.keyboard.isDown('q') then
		sayIt.New("Mike Pence", {"This is a message", "another one.", "Finally..."})
	end
end

function love.draw(dt)
    camera:attach()
		love.graphics.rectangle("fill", p1.x, p1.y, 50, 50 )
		love.graphics.rectangle("fill", p2.x, p2.y, 50, 50 )
    camera:detach()

    love.graphics.push()
    	love.graphics.setFont(defaultfont)
	    love.graphics.setColor( 255, 255, 255 )
		love.graphics.setBackgroundColor( 100, 100, 100 )
		love.graphics.print("Current queue: " .. currentMessage .. "\n" ..
							"To print: " .. textToPrint 		.. "\n" ..
							"No. messages: " .. #messages 		.. "\n" ..
							"Typing?: " .. tostring(typing) 	.. "\n" -- END
							, 10, 10)
	love.graphics.pop()


	sayIt.Draw()
end

function love.keyreleased(key)
	sayIt.Handler(key)
	if key == "w" then
		sayIt.New("Mike Pence", {"This is a message", "another one.", "Finally...", "\n"}, p2.x, p2.y)
		sayIt.New("Bill Nye", {"I love this next segment...", "Lots of schmear"}, p1.x, p1.y)
	end
	if key == "q" then
		love.quit()
	end
end

function love.quit()
	for k,v in pairs(messages) do print(k,v) end
	for k,v in pairs(titles) do print(k,v) end
end
