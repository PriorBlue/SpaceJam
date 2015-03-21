require("src/map")
require("src/camera")

function love.load()
	map = createMap()
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
end

function love.draw()
	map.draw()
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