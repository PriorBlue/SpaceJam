require("map")
require("camera")

function love.load()
	map = createMap()
end

function love.update(dt)
	if love.keyboard.isDown("up") then
		camera.y = camera.y + 300 * dt
	end
	if love.keyboard.isDown("down") then
		camera.y = camera.y - 300 * dt
	end
	if love.keyboard.isDown("left") then
		camera.x = camera.x + 300 * dt
	end
	if love.keyboard.isDown("right") then
		camera.x = camera.x - 300 * dt
	end
end

function love.draw()
    map.draw()
    camera.draw()
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