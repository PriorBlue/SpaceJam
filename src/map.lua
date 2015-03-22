require("src/camera")
require("src/bodies")

local g = love.graphics

function createMap()
	local bg = love.graphics.newImage("backgrounds/background_stars.png")
	bg:setWrap("repeat")
	local bgQuad = love.graphics.newQuad(0, 0, love.window.getWidth() * 1.5, love.window.getWidth() * 1.5, bg:getDimensions())

	local map = {}
	map.bg = {img = bg, quad = bgQuad}
	map.celestialBodys = {}
	map.draw = function ()
		map.bg.quad:setViewport(
			(camera.x - (love.window.getWidth() / 2)) * .5,
			(camera.y - (love.window.getWidth() / 2)) * .5,
			love.window.getWidth() * 1.5,
			love.window.getWidth() * 1.5)
		love.graphics.draw(
			map.bg.img, map.bg.quad,
			love.window.getWidth() * 0.5,
			love.window.getHeight() * 0.5,
			camera.rotation, 1, 1,
			love.window.getWidth() * 0.75,
			love.window.getWidth() * 0.75
		)
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
	map.randomiseBodies = function()
		math.randomseed(117)
		for x=-10,10 do
			for y=-10,10 do
				local ranOffsetX = math.random(-100, 100)
				local ranOffsetY = math.random(-100, 100)
				local ranScale = math.random(1, 3)
				local ranRotationRate = math.random(-2, 2)
				table.insert(map.celestialBodys, createBody("sprites/asteroid_color.png", x * 1000 + ranOffsetX, y * 1000 + ranOffsetY, ranScale, ranRotationRate))
			end
		end
	end

	return map
end