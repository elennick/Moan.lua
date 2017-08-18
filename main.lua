require("Moan/Moan")

function love.load()
	love.graphics.setBackgroundColor(100, 100, 100, 255)
	p1 = { x=100, y=200 }
	p2 = { x=400, y=150 }
	p3 = { x=200, y=300 }
	camera = Camera(0, 0) -- Initialise the HUMP camera

	Moan.new("Möan.lua", {"Hello World!...--This is a very long uh,--testing string that...--I'm not actually going to use..."},
			 { x=p1.x, y=p1.y, image="Obey_Me.png", oncomplete=function() red() Moan.setSpeed("slow") end})
	Moan.new("Memean.lua", {"Please don't heck me up--please"},
			 { x=p1.x, y=p1.y, image="Obey_Me.png", onstart=function() blue() end})
	Moan.new("Memean.lua", {"I'm red", "maybe--and then blue!"},
			 { x=p1.x, y=p1.y, image="Obey_Me.png", onstart=function() red() end, oncomplete=function() blue() end})

end

function love.update(dt)
	Moan.update(dt)
	require("lovebird").update()
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
	if key == "f" and not typing then
		Moan.advanceMsg()
	elseif key == "c" then
		Moan.clearMessages()
	elseif key == "p" then
		Moan.pause()
	elseif key == "o" then
		Moan.resume()
	elseif key == "s" then
		Moan.new("Title", {"Message one", "two", "and three..."}, {onstart=function() red() end, oncomplete=function() green() end})
	end
end

-- Test functions
function red()
	love.graphics.setBackgroundColor(255, 0, 0, 255)
	--Moan.new("Hey", {"You selected red!"}, {x=p3.x, y=p3.y})
	--addMoreToMoanQueue()
end
function green()
	love.graphics.setBackgroundColor(0, 255, 0, 255)
	--Moan.new("Hey", {"You selected green!"}, {x=p3.x, y=p3.y})
	--addMoreToMoanQueue()
end
function blue()
	love.graphics.setBackgroundColor(0, 0, 255, 255)
	--Moan.new("Hey", {"You selected blue!"}, {x=p3.x, y=p3.y})
	--addMoreToMoanQueue()
end
function addMoreToMoanQueue()
	--Moan.new("Title", {"Each message is added to a \"message queue\", i.e. they're presented in the order that they're called. This is part of the design of Möan.lua"})
	--Moan.new("Title", {"アイ・ドーント・ノー・ジャパニーズ・ホープフリー・ジス・トランズレーター・ダズント・メス・ジス・アップ・トゥー・マッチ", "We've got UTF8 support, キューティー -- \nAs well as camera tracking!"}, {x=p2.x, y=p2.y})
	--Moan.new(unpack(dialogue[1]))
	--Moan.new("Title", {"See ya around!"}, {x=p3.x, y=p3.y, image="Obey_Me.png"})
end