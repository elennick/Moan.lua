require('Moan/Moan')

--[[
	Moan.lua demo
	Press "e" to load some messages into the queue,
	"enter" to cycle through messages.
]]

function love.load()
	Moan.Init()
	p1 = { x = 100, y = 250, canMove = true }
	p2 = { x = 600, y = 250 }
    camera = Camera(0, 0, 0.5)
end

function love.update(dt)
	Moan.Update(dt)

	if love.keyboard.isDown("q") then Moan.AdvanceMsg() end -- A bad way
	-- Could used timer.every nth seconds Moan.AdvanceMsg() as an autoreader

	-- Moan only saves static coordinates, thus the camera cannot follow
	-- a variables position, thus we must disable player movement when the
	-- camera returns.
    if showingMessage == false then
	    camera:lockPosition(p1.x, p1.y, Camera.smooth.damped(2))
	    p1.canMove = true
	else
		p1.canMove = false
	end

	if p1.canMove then
		if love.keyboard.isDown("up", "w") then p1.y = p1.y - 600 * dt end
		if love.keyboard.isDown("down", "s") then p1.y = p1.y + 600 * dt end
		if love.keyboard.isDown("left", "a") then p1.x = p1.x - 600 * dt end
		if love.keyboard.isDown("right", "d") then p1.x = p1.x + 600 * dt end
	end
end

function love.draw()
	love.graphics.setBackgroundColor( 100, 100, 100 )

    camera:attach()
		love.graphics.rectangle("fill", p1.x, p1.y, 50, 50 )
		love.graphics.rectangle("fill", p2.x, p2.y, 50, 50 )
		love.graphics.circle("fill", -200, -400, 20)
    camera:detach()

	Moan.Draw()
end

function love.keyreleased(key)
	Moan.Handler(key)
	if key == "e" then -- Add some messages to the queue
		Moan.New("Test", {"How's things with you? Sorry I'm not very good at small talk - after all, this is just a demonstration, Maybe I should wrap again", "Heck I ran out of space back there, better move onto a new box, maybe a new line even!", "So yeah, how are you?" }, p2.x, p2.y)
		Moan.New("Bill Nye", {"I'm alright, running my new show on Netflix, things are looking up for me!", "It's got lots of...", "SCHMEAR :^)", "Hey, look up there!" }, p1.x, p1.y)
		Moan.New("Mike Pence", {"Wow a circle!" }, -200, -400)
		Moan.New("Mike Pence", {"That's pretty cool..."}, p2.x, p2.y)
		Moan.New("UTF8", {"I've added UTF8 support", "アイ・ドーント・ノー・ジャパニーズ・ホープフリー・ジス・トランズレーター・ダズント・メス・ジス・アップ・トゥー・マッチ", "Thanks @FuffySifilis"})
	end
end

function love.quit()
	Moan.Debug()
end
