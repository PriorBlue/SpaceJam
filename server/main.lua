local socket = require("socket")
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname('*', 1337)

function love.load()

end

function love.update(dt)
	data, msg_or_ip, port_or_nil = udp:receivefrom()

	if data then
		udp:sendto("test", msg_or_ip,  port_or_nil)
		print("test", msg_or_ip, port_or_nil)
	end
end

function love.draw()

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)
  
end

function love.keyreleased(key)
	if key == 'escape' then
		love.event.quit()
	end
end