-- worldmap.lua
-- the world map has different sectors to select and points that mark special locations
local wpoint = require "src/wpoint"
local wsection = require "src/wsection"
local worldmap = {}

worldmap.sectionSize = 32 -- pixel border size of the sections

function worldmap.init(len, wid) -- can also be used for a reset
	local w = {}
	w.length = len or 10
	w.width = wid or 10
	
	w.map = {}		-- this table stores all the sections of the map
	w.points = {}		-- this table just stores points
	-- fill map with empty sections
	for i=0,w.width-1 do
		w.map[i] = {}
		for j=0,w.length-1 do
			local gameMap = createMap()
			local visual = love.math.random(wsection.maxTextureIndex) -- see wsection.lua for more details
			w.map[i][j] = wsection.new(gameMap,visual)
		end
	end

	-- takes coordinates for the world map and puts it into the table
	function w.addPoint(x,y,details)
		local wmpoint = wpoint.new(x,y,details)
		table.insert(points,wmpoint)
	end
	
	-- returns a world map point at the given coordinate or nil
	function w.getPointAt(x,y)
		for k,v in pairs(points) do
			if (v.x == x) and (v.y == y) then
				return v
			end
		end
		return nil
	end
	
	function w.draw()
		for k,i in pairs(w.map) do
			for l,j in pairs(i) do
				w.map[k][l].draw(k*worldmap.sectionSize,l*worldmap.sectionSize)
			end
		end
		for k,v in pairs(w.points) do
			v.draw() -- maybe add coordinates
		end
	end
	
	return w
end

return worldmap
