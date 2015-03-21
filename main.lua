local event = require("src/events")
local ships = require("src/spaceship")
require("src/map")
require("src/camera")

function love.load()
	map = createMap()
	ships.init(event)
	-- TODO: remove dummies
	event.push("CreateShip", {id = 1, x = 100, y = 100})
	event.push("CreateShip", {id = 2, x = 200, y = 200})
	event.push("CreateShip", {id = 3, x = 400, y = 300})
end

function love.update(dt)
	ships.updateInput()
	ships.update(dt)
	
	-- clear events
	event.clearAll()
end

function love.draw()
	map.draw()
	ships.draw()
end

function resetGame()

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