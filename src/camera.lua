camera = {}
camera.x = 0
camera.y = 0
camera.scale = 1
camera.draw = function(self)
	love.graphics.print("scale: ".. self.scale)
	love.graphics.translate(-self.x, -self.y)
	love.graphics.scale(self.scale, self.scale)
end