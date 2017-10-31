eek = require("eek")

Camera = require("assets.camera")
flux = require("assets.flux")

function love.load()
	-- The FontStruction “Pixel UniCode” (https://fontstruct.com/fontstructions/show/908795)
	-- by “ivancr72” is licensed under a Creative Commons Attribution license
	-- (http://creativecommons.org/licenses/by/3.0/)
	eek.font = love.graphics.newFont("assets/Pixel UniCode.ttf", 32)

	-- Add font fallbacks for Japanese characters
	local JPfallback = love.graphics.newFont("assets/JPfallback.ttf", 32)
	eek.font:setFallbacks(JPfallback)

	-- Audio from bfxr (https://www.bfxr.net/)
	eek.typeSound = love.audio.newSource("assets/typeSound.wav", "static")
	eek.optionOnSelectSound = love.audio.newSource("assets/optionSelect.wav", "static")
	eek.optionSwitchSound = love.audio.newSource("assets/optionSwitch.wav", "static")
  eek.noImage = love.graphics.newImage("assets/noImage.png")

	love.graphics.setBackgroundColor(100, 100, 100, 255)
	math.randomseed(os.time())

	-- Make some objects
	p1 = { x=100, y=200 }
	p2 = { x=400, y=150 }
	p3 = { x=200, y=300 }

	-- Create a HUMP camera and let eek use it
	camera = Camera(p1.x, p1.y)
	eek.setCamera(camera)

	-- Set up our image for image argument in eek.speak config table
	avatar = love.graphics.newImage("assets/Obey_Me.png")

	-- Put some messages into the eek queue
	eek.speak({"eek.lua", {255,105,180}}, {"Hello World!"}, {image=avatar})
	eek.speak({"Tutorial", {0,191,255}}, {"eek.lua is a simple to use messagebox library, it includes;", "Multiple choices,--UTF8 text,--Pauses,--Optional camera control,--Onstart/Oncomplete functions,--Complete customization,--Variable typing speeds umongst other things."},
			     {x=p2.x, y=p2.y, image=avatar, onstart=function() rand() end})
	eek.speak("Tutorial", {"Typing sound modulates with speed..."}, {onstart=function() eek.setSpeed("slow") end, oncomplete=function() eek.setSpeed("fast") end})
  eek.speak("Tutorial", {"Here's some options:"}, {
			options={{"Red", function() red() end},
					 {"Blue", function() blue() end},
					 {"Green", function() green() end}}})
end

function love.update(dt)
	-- Update eek
	eek.update(dt)

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
  love.graphics.print("eek.lua demo - twentytwoo\n ==================\n" ..
                      "'spacebar': Cycle through messages \n" ..
                      "'f': Force message cycle \n" ..
                      "'c': Clear all messages \n" ..
                      "'m': Add a single message to the queue \n" ..
                      "'`': Enable debugger", 10, 300)

  -- eek.draw() should be drawn last since we want it to be ontop of everything else
  eek.draw()
end

function love.keyreleased(key)
  -- Pass keypresses to eek
	eek.keyreleased(key)

	if key == "f" then
		eek.advanceMsg()
  elseif key == "t" then
    eek.UI.boxColour = {100,0,0}
	elseif key == "`" then
		eek.debug = not eek.debug
	elseif key == "c" then
		eek.clearMessages()
	elseif key == "m" then
		eek.speak("Title", {"Message one", "two", "and three..."}, {onstart=function() rand() end})
	end
end

-- DEMO FUNCTIONS ===========================================================================

function rand()
	love.graphics.setBackgroundColor(math.random(255), math.random(255), math.random(255))
end

function red()
	love.graphics.setBackgroundColor(255,0,0)
	eek.speak("Hey!", {"You picked Red!"})
	moreMessages()
end

function blue()
	love.graphics.setBackgroundColor(0,0,255)
	eek.speak("Hey!", {"You picked Blue!"})
	moreMessages()
end

function green()
	love.graphics.setBackgroundColor(0,255,0)
	eek.speak("Hey!", {"You picked Green!"})
	moreMessages()
end

function moreMessages()
	eek.speak("Message queue", {"Each message is added to a \"message queue\", i.e. they're presented in the order that they're called. This is part of the design of eek.lua"}, {x=p1.x, y=p1.y, onstart=function() rand() end})
	eek.speak("UTF8 example", {"アイ・ドーント・ノー・ジャパニーズ・ホープフリー・ジス・トランズレーター・ダズント・メス・ジス・アップ・トゥー・マッチ"})
	eek.speak("Goodbye", {"See ya around!"}, {x=p3.x, y=p3.y, oncomplete=function() rand() end})
end
