require("src/TSerial")
local event = require("src/events")
local ships = require("src/spaceship")
local network = require("src/network")
require("src/map")
require("src/camera")

function love.load()
	map = createMap()
	network.init(event)
	ships.init(event)
end

function love.update(dt)
	network.update(dt)
	ships.update(dt)
	
	-- clear events
	event.clearAll()
end

function love.draw()
	map.draw()
	ships.draw()
end

function love.quit()
	network.quit()
end

function resetGame()

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)
  
end

function love.keypressed(key)
	ships.keypressed(key)
end

function love.keyreleased(key)
	if key == 'escape' then
		love.event.quit()
	end
	
	ships.keyreleased(key)
end