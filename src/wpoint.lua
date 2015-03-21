-- wpoint.lua
-- a point on the world map, use this to create them
-- details will hold special information on the point later
wpoint = {}
function wpoint.new(x,y,details)
	local p = {}
	p.x,p.y = x,y
	p.details = details	--the content of this variable is unspecified as of yet
	
	function wpoint.draw()
		print("drawing a point")
	end
	
	return p
end

return wpoint
