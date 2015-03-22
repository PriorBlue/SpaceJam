camera = {}
camera.x = 0
camera.y = 0
camera.rotation = 0
camera.scale = 1 / 8
camera.target = nil
camera.followTargetRotation = true
camera.offsetX = 0
camera.offsetY = 0

camera.draw = function(self)
	love.graphics.push()
	local blub = self.target or {x = "nil", y="nil"}
	love.graphics.print(
		"camera Debug info:" ..
		"\nscale: ".. self.scale .. 
		"\nrotation: " .. self.rotation .. 
		"\ntargetId: " .. ((self.target or {id="none"}).id or "NONE") ..
		"\ntargetPos: {x = " .. blub.x .. ", y = ".. blub.y .. "}" ..
		"\ntargetSpeed: " .. ((self.target or {speed="none"}).speed or "NONE") ..
		"\ntargetSpeedTrigger: " .. ((self.target or {speedTrigger = "none"}).speedTrigger), 0, 0)
	love.graphics.translate(love.window.getWidth() * 0.5, love.window.getHeight() * 0.5)
	love.graphics.scale(self.scale, self.scale)
	love.graphics.rotate(self.rotation)
	love.graphics.translate(-self.x, -self.y) -- + self.offsetX, -self.y + self.offsetY)
	--love.graphics.translate(self.offsetX, self.offsetY)
end

camera.reset = function()
	love.graphics.pop()
end

camera.update = function(self)
	if self.target ~= nil and self.target.x ~= nil and self.target.y ~= nil then
		self.x = self.target.x
		self.y = self.target.y
	end
	if self.followTargetRotation and self.target ~= nil then
		self.rotation = - (self.target.direction or 0)
	end
	if self.target ~= nil and self.target.img ~= nil then
		self.offsetX = - self.target.img:getWidth() / 2
		self.offsetY = - self.target.img:getHeight() / 2
	else
		self.offsetX = 0
		self.offsetY = 0
	end
end