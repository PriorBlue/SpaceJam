require("map")
require("camera")

function love.load()
	map = createMap()
end

function love.update(dt)

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
end