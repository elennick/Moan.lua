require('Moan/Moan')

function love.load()
	Moan.Init()
	p1 = { x = 100, y = 250 }
	p2 = { x = 600, y = 250 }
    camera = Camera(0, 0, 0.5)
end

function love.update(dt)
	Moan.Update(dt)

	if love.keyboard.isDown("q") then Moan.AdvanceMsg() end -- A bad way
	-- Could used timer.every nth seconds Moan.AdvanceMsg() as an autoreader

	if love.keyboard.isDown("up") then p1.y = p1.y - 1000 * dt end
	if love.keyboard.isDown("down") then p1.y = p1.y + 1000 * dt end
	if love.keyboard.isDown("left") then p1.x = p1.x - 1000 * dt end
	if love.keyboard.isDown("right") then p1.x = p1.x + 1000 * dt end
end

function love.draw(dt)
	love.graphics.setBackgroundColor( 100, 100, 100 )

    camera:attach()
		love.graphics.rectangle("fill", p1.x, p1.y, 50, 50 )
		love.graphics.rectangle("fill", p2.x, p2.y, 50, 50 )
		love.graphics.circle("fill", -200, -400, 20)
    camera:detach()

    if not showingMessage then
	    camera:lockPosition(p1.x, p1.y)
	end

	Moan.Draw()
end

function love.keyreleased(key)
	Moan.Handler(key)
	if key == "w" then
		Moan.New("Mike Pasdence", {"How's things with you? Sorry I'm not very good at small talk - after all, this is just a demonstration", "Heck I ran out of space back there, better move onto a new box, maybe a new line even!", "So yeah, how are you?" }, p2.x, p2.y)
		Moan.New("Bill Nye", {"I'm alright, running my new show on Netflix, things are looking up for me!", "It's got lots of...", "SCHMEAR :^)", "Hey, look up there!" }, p1.x, p1.y)
		Moan.New("Mike Pence", {"Wow a circle!" }, -200, -400)
		Moan.New("Mike Pence", {"That's pretty cool..."}, p2.x, p2.y)
	end
end

function love.quit()
	Moan.Debug()
end
