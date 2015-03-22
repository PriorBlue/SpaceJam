local cache = require("src/ImgCache")
local lg = love.graphics

local drawBody = function(self)
	lg.draw(self.img, self.x, self.y, self.rotation, self.scale, self.scale, self.width / 2, self.height / 2)
end

local updateBody = function(self, dt)
	self.rotation = self.rotation + self.rotationsPerSecond * dt
end

function createBody(spritePath, x, y, s, rr)
	local body = {}
	body.img = cache:get(spritePath)
	body.width = body.img:getWidth()
	body.height = body.img:getHeight()
	body.draw = drawBody
	body.update = updateBody
	body.rotationsPerSecond = rr or 0
	body.rotation = 0
	body.x = x
	body.y = y
	body.scale = s or 1;
	return body
end