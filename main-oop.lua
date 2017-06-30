local class = require 'middleclass'

Message = class('Message') --this is the same as class('Message', Object) or Object:subclass('Message')
function Message:initialize(msg)
  self.msg = msg
end

function Message:speak()
  print('Hi, I am ' .. self.msg ..'.')
end

function love.load()
	messages = {}
end

function love.update(dt)

end

function love.draw()
	for k,v in pairs(messages) do
		love.graphics.print(messages[k],10,10)
	end
end

