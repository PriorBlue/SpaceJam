local event = require("src/events")
local ships = require("src/spaceship")
local network = require("src/network")
require("src/map")
require("src/camera")

function love.load()
	map = createMap()
	map.randomiseBodies()
	network.init(event)
	ships.init(event)
	-- TODO: remove dummies
	event.push("CreateShip", {id = 1, x = 100, y = 100})
	event.push("CreateShip", {id = 2, x = 200, y = 200})
	event.push("CreateShip", {id = 3, x = 400, y = 300})
end

function love.update(dt)
	if love.keyboard.isDown("left") then
		camera.x = camera.x - 200 * dt
	end
	if love.keyboard.isDown("right") then
		camera.x = camera.x + 200 * dt
	end
	if love.keyboard.isDown("up") then
		camera.y = camera.y - 200 * dt
	end
	if love.keyboard.isDown("down") then
		camera.y = camera.y + 200 * dt
	end
	map.update(dt)
	camera:update(dt)
	ships.updateInput()
	network.update(dt)
	ships.update(dt)
	camera.target = ships.ships[1]
	
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
	if key == "." then
		camera.scale = camera.scale + .1
	end
	if key == "," then
		camera.scale = camera.scale - .1
	end
end