require("src/camera")
require("src/bodies")

local g = love.graphics

function createMap()
	local bg = love.graphics.newImage("backgrounds/background_stars.png")
	bg:setWrap("repeat")
	local bgQuad = love.graphics.newQuad(0, 0, love.window.getWidth(), love.window.getHeight(), bg:getDimensions())

	local map = {}
	map.bg = {img = bg, quad = bgQuad}
	map.celestialBodys = {}
	map.draw = function ()
		map.bg.quad:setViewport(
			(camera.x - (love.window.getWidth() / 2)) * .5,
			(camera.y - (love.window.getHeight() / 2)) * .5,
			love.window.getWidth(),
			love.window.getHeight())
		love.graphics.draw(map.bg.img, map.bg.quad, 0, 0)
		camera:draw()
		for i,body in ipairs(map.celestialBodys) do
			body:draw()
		end
	end
	map.update = function (dt)
		for i,body in ipairs(map.celestialBodys) do
			body:update(dt)
		end
	end

	math.randomseed(117)
	for x=-10,10 do
		for y=-10,10 do
			local ranOffsetX = math.random(-100, 100)
			local ranOffsetY = math.random(-100, 100)
			local ranScale = math.random(1, 3)
			local ranRotationRate = math.random(-2, 2)
			table.insert(map.celestialBodys, createBody("sprites/ufo.png", x * 1000 + ranOffsetX, y * 1000 + ranOffsetY, ranScale, ranRotationRate))
		end
	end

	return map
end