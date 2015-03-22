camera = {}
camera.x = 0
camera.y = 0
camera.rotation = 0
camera.scale = 1
camera.target = nil
camera.followTargetRotation = true
camera.offsetX = 0
camera.offsetY = 0

camera.draw = function(self)
	love.graphics.push()
	love.graphics.print("scale: ".. self.scale .. "\nrotation: " .. self.rotation .. "\ntargetId: " .. ((self.target or {id="none"}).id or "NONE"))
	love.graphics.translate(love.window.getWidth() * 0.5, love.window.getHeight() * 0.5)
	love.graphics.scale(self.scale, self.scale)
	--love.graphics.translate(-self.offsetX, - self.offsetY)
	love.graphics.rotate(self.rotation)
	love.graphics.translate(-self.x, -self.y) -- + self.offsetX, -self.y + self.offsetY)
end

camera.reset = function()
	love.graphics.pop()
end

camera.update = function(self)
	if self.target ~= nil and self.target.x ~= nil and self.target.y ~= nil then
		self.x = self.target.x
		self.y = self.target.y
		self.offsetX = love.window.getWidth() / 2
		self.offsetY = love.window.getHeight() * 0.9
	else
		self.offsetX = 0
		self.offsetY = 0
	end
	if self.followTargetRotation and self.target ~= nil then
		self.rotation = - (self.target.direction or 0)
	end
end