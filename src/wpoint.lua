-- wpoint.lua
-- a point on the world map, use this to create them
-- details will hold special information on the point later
-- examples: 	wpoint.new(42,100,{color = {64,64,255,127},oColor={0,0,0,255}})
-- 				wpoint.new(350,250)
wpoint = {}
function wpoint.new(x,y,details)
	local p = {}
	p.x,p.y = x,y
	p.details = details	-- specification of this variable:
						-- p.details.color {r,g,b,a} - color of the inner part of the point
						-- p.details.oColor {r,g,b,a} - color of the outer part of the point
	
	function p.draw()
		local pointSize = love.graphics.getPointSize()
		local pointStyle = love.graphics.getPointStyle()
		local tr,tg,tb,ta = love.graphics.getColor()
		if p.details and p.details.oColor then
			love.graphics.setColor(p.details.oColor)
		else
			love.graphics.setColor(255,255,255,127)
		end
		love.graphics.setPointSize(12)
		love.graphics.setPointStyle("rough")
		love.graphics.point(p.x,p.y)
		
		if p.details and p.details.color then
			love.graphics.setColor(p.details.color)
		else
			love.graphics.setColor(255,64,64,127)
		end
		love.graphics.setPointSize(8)
		love.graphics.setPointStyle("smooth") -- depending on the used graphics drivers this may or may not have any impact
		love.graphics.point(p.x,p.y)
		
		love.graphics.setPointSize(pointSize)
		love.graphics.setPointStyle(pointStyle)
		love.graphics.setColor(tr,tg,tb,ta)
	end
	
	return p
end

return wpoint
