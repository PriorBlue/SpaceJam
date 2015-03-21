local event = require("src/events")

function love.load()

end

function love.update(dt)
	event.push("ShootFire", {x = 16, y = 32})

	bullets = event.pull("ShootFire")
	
	for k, b in pairs(bullets) do
		print(b.x)
	end
	
	event.clearAll()
end

function love.draw()
    love.graphics.print("Hello World!", 200, 200)
end

function resetGame()

end

function love.mousepressed(x, y, button)
  
end

function love.mousereleased(x, y, button)
  
end

function love.keypressed(key)

end

function love.keyreleased(key)
  if key == 'escape' then
        love.event.quit()
  end
end