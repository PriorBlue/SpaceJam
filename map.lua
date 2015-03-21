require("camera")

function createMap()
	local bg = love.graphics.newImage("backgrounds/background_stars.png")
	bg:setWrap("repeat")
	local bgQuad = love.graphics.newQuad(0, 0, love.window.getWidth(), love.window.getHeight(), bg:getDimensions())

	local map = {}
	map.bg = {img = bg, quad = bgQuad}
	map.draw = function ()
		map.bg.quad:setViewport(
			camera.x - (love.window.getWidth() / 2),
			camera.y - (love.window.getHeight() / 2),
			love.window.getWidth(),
			love.window.getHeight())
		love.graphics.draw(map.bg.img, map.bg.quad, 0, 0)
	end
	map.scale = {x = 1, y = 1}

	return map
end