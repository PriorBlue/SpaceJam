function love.load()

end

function love.update(dt)

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