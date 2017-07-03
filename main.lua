require('sayIt/sayIt')

function love.load()
	sayIt.Init()
	p1 = { x = 100, y = 250 }
	p2 = { x = 600, y = 250 }
	dialog = {"Hello", "World", "My", "Name", "Is", "SayIt", x = 20, y = 50}
end

function love.update(dt)
	sayIt.Update(dt)
end

function love.draw(dt)
	love.graphics.setBackgroundColor( 100, 100, 100 )

    camera:attach()
		love.graphics.rectangle("fill", p1.x, p1.y, 50, 50 )
		love.graphics.rectangle("fill", p2.x, p2.y, 50, 50 )
		love.graphics.circle("fill", -200, -400, 20)
    camera:detach()

	sayIt.Draw()
end

function love.keyreleased(key)
	sayIt.Handler(key)
	if key == "w" then
		for i=1, 6 do
			sayIt.New("Bill Nye", {dialog[i] }, dialog.x, dialog.y)
		end
		sayIt.New("Mike Pence", {"How's things with you? Sorry I'm not very good at small talk - after all, this is just a demonstration", "Heck I ran out of space back there, better move onto a new box, maybe a new line even!", "So yeah, how are you?" }, p2.x, p2.y)
		sayIt.New("Bill Nye", {"I'm alright, running my new show on Netflix, things are looking up for me!", "It's got lots of...", "SCHMEAR :^)", "Hey, look up there!" }, p1.x, p1.y)
		sayIt.New("Mike Pence", {"Wow a circle!" }, -200, -400)
		sayIt.New("Mike Pence", {"That's pretty cool..."}, p2.x, p2.y)
	end
end

function love.quit()
	sayIt.Debug()
end
