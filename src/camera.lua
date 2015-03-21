camera = {}
camera.x = 0
camera.y = 0
camera.draw = function()
	love.graphics.translate(camera.x, camera.y)
end