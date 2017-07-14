require("Moan/Moan")

function love.load()
love.graphics.setBackgroundColor(100, 100, 100, 255)
p1 = { x=100, y=200}
p2 = { x=400, y=150}
p3 = { x=200, y=300}
camera = Camera(0, 0) -- Initialise the HUMP camera

	Moan.new("Möan.lua", {"Hello World!"}, {}, p1.x, p1.y, "Obey_Me.png")
	Moan.new("A title", {"Message... One", "Hey check this out! \nI've got text wrapping and blah blah blah blah blah blah blah blah", "Aaaaaand multiple choice -  Nice."},
			{{"Red", function() red() end},
			 {"Green", function() green() end},
			 {"Blue", function() blue() end}}, p3.x, p3.y, "Obey_Me.png")
	Moan.new("Mike", {"アイ・ドーント・ノー・ジャパニーズ・ホープフリー・ジス・トランズレーター・ダズント・メス・ジス・アップ・トゥー・マッチ", "We've got UTF8 support, キューティー... \nAs well as camera tracking!", "More options? That's neat huh."},
			{{"Red", function() red() end},
			 {"Green", function() green() end},
			 {"Blue", function() blue() end}}, p2.x, p2.y, "someimagethatdoesn'texist.png")
	Moan.new("Title", {"See ya around!"}, {}, p1.x, p1.y, "Obey_Me.png")
end

function love.update(dt)
	Moan.update(dt)
end

function love.draw()
    camera:attach()
		love.graphics.rectangle("fill", p1.x, p1.y, 16, 16)
		love.graphics.rectangle("fill", p2.x, p2.y, 16, 16)
		love.graphics.rectangle("fill", p3.x, p3.y, 16, 16)
    camera:detach()

	Moan.draw()
end

function love.keyreleased(key)
	Moan.keyreleased(key)
end

-- Test functions
function red()
	love.graphics.setBackgroundColor(255, 0, 0, 255)
	Moan.new("Hey", {"You selected red!"}, {}, 10, 10)
end
function green()
	love.graphics.setBackgroundColor(0, 255, 0, 255)
	Moan.new("Hey", {"You selected green!"}, {}, 10, 10)
end
function blue()
	love.graphics.setBackgroundColor(0, 0, 255, 255)
	Moan.new("Hey", {"You selected blue!"}, {}, 10, 10)
end
