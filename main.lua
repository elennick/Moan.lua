Moan = require("Moan")

Camera = require("assets.camera")
flux = require("assets.flux")

function love.load()
	-- The FontStruction “Pixel UniCode” (https://fontstruct.com/fontstructions/show/908795)
	-- by “ivancr72” is licensed under a Creative Commons Attribution license
	-- (http://creativecommons.org/licenses/by/3.0/)
	Moan.font = love.graphics.newFont("assets/Pixel UniCode.ttf", 32)

	-- Add font fallbacks for Japanese characters
	local JPfallback = love.graphics.newFont("assets/JPfallback.ttf", 32)
	Moan.font:setFallbacks(JPfallback)

	-- Audio from bfxr (https://www.bfxr.net/)
	Moan.typeSound = love.audio.newSource("assets/typeSound.wav", "static")
	Moan.optionOnSelectSound = love.audio.newSource("assets/optionSelect.wav", "static")
	Moan.optionSwitchSound = love.audio.newSource("assets/optionSwitch.wav", "static")
  Moan.noImage = love.graphics.newImage("assets/noImage.png")

	love.graphics.setBackgroundColor(100/255, 100/255, 100/255, 255/255)
	math.randomseed(os.time())

	-- Make some objects
	p1 = { x=100, y=200 }
	p2 = { x=400, y=150 }
	p3 = { x=200, y=300 }

	-- Create a HUMP camera and let Moan use it
	camera = Camera(p1.x, p1.y)
	Moan.setCamera(camera)

	-- Set up our image for image argument in Moan.speak config table
	avatar = love.graphics.newImage("assets/Obey_Me.png")

	-- Put some messages into the Moan queue
	Moan.speak({"Möan.lua", {255/255,105/255,180/255}}, {"Hello World!"}, {image=avatar})
	Moan.speak({"Tutorial", {0/255,191/255,255/255}}, {"Möan.lua is a simple to use messagebox library, it includes;", "Multiple choices,--UTF8 text,--Pauses,--Optional camera control,--Onstart/Oncomplete functions,--Complete customization,--Variable typing speeds umongst other things."},
			     {x=p2.x, y=p2.y, image=avatar, onstart=function() rand() Moan.UI.messageboxPos = "top" Moan.UI.imagePos = "right" end})
	Moan.speak("Tutorial", {"Typing sound modulates with speed..."}, {onstart=function() Moan.setSpeed("slow") Moan.UI.messageboxPos = "bottom" end, oncomplete=function() Moan.setSpeed("fast") Moan.UI.titleBoxPos = "left" end})
  Moan.speak("Tutorial", {"Here's some options:"}, {
			options={{"Red", function() red() end},
					 {"Blue", function() blue() end},
					 {"Green", function() green() end}}})
end

function love.update(dt)
	-- Update Moan
	Moan.update(dt)

	-- Update external libs (optional)
	flux.update(dt)
	require("assets.lovebird").update()
end

function love.draw()
  -- Attach the HUMP camera to the objects
  camera:attach()
  	love.graphics.rectangle("fill", p1.x, p1.y, 16, 16)
  	love.graphics.rectangle("fill", p2.x, p2.y, 16, 16)
  	love.graphics.rectangle("fill", p3.x, p3.y, 16, 16)
  camera:detach()
  love.graphics.print("Moan.lua demo - twentytwoo\n ==================\n" ..
                      "'spacebar': Cycle through messages \n" ..
                      "'f': Force message cycle \n" ..
                      "'c': Clear all messages \n" ..
                      "'m': Add a single message to the queue \n" ..
                      "'`': Enable debugger", 10, 300)

  -- Moan.draw() should be drawn last since we want it to be ontop of everything else
  Moan.draw()
end

function love.keyreleased(key)
  -- Pass keypresses to Moan
	Moan.keyreleased(key)

	if key == "f" then
		Moan.advanceMsg()
  elseif key == "t" then
    Moan.UI.boxColour = {100/255,0/255,0/255}
	elseif key == "`" then
		Moan.debug = not Moan.debug
	elseif key == "c" then
		Moan.clearMessages()
	elseif key == "m" then
		Moan.speak("Title", {"Message one", "two", "and three..."}, {onstart=function() rand() end})
	end
end

-- DEMO FUNCTIONS ===========================================================================

function rand()
	love.graphics.setBackgroundColor(math.random(), math.random(), math.random())
end

function red()
	love.graphics.setBackgroundColor(255/255,0/255,0/255)
	Moan.speak("Hey!", {"You picked Red!"})
	moreMessages()
end

function blue()
	love.graphics.setBackgroundColor(0/255,0/255,255/255)
	Moan.speak("Hey!", {"You picked Blue!"})
	moreMessages()
end

function green()
	love.graphics.setBackgroundColor(0/255,255/255,0/255)
	Moan.speak("Hey!", {"You picked Green!"})
	moreMessages()
end

function moreMessages()
	Moan.speak("Message queue", {"Each message is added to a \"message queue\", i.e. they're presented in the order that they're called. This is part of the design of Möan.lua"}, {x=p1.x, y=p1.y, onstart=function() rand() end})
	Moan.speak("UTF8 example", {"アイ・ドーント・ノー・ジャパニーズ・ホープフリー・ジス・トランズレーター・ダズント・メス・ジス・アップ・トゥー・マッチ"})
	Moan.speak("Goodbye", {"See ya around!"}, {x=p3.x, y=p3.y, oncomplete=function() rand() end})
end
