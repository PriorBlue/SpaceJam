-- worldmap.lua
-- the world map has different sectors to select and points that mark special locations
local wpoint = require "src/wpoint"
local wsection = require "src/wsection"
local worldmap = {}

worldmap.sectionSize = 48 -- pixel border size of the sections

function worldmap.init(len, wid) -- can also be used for a reset
	local w = {}
	w.length = len or 10
	w.width = wid or 10
	
	w.map = {}			-- this table stores all the sections of the map
	w.points = {}		-- this table just stores points
	
	-- fill map with empty sections
	for i=0,w.width-1 do
		w.map[i] = {}
		for j=0,w.length-1 do
			--local gameMap = createMap() -- TODO add this back in later
			local visual = love.math.random(wsection.maxTextureIndex) -- see wsection.lua for more details
			w.map[i][j] = wsection.new(gameMap,visual)
		end
	end

	-- takes coordinates for the world map and puts it into the table
	function w.addPoint(x,y,details)
		local wmpoint = wpoint.new(x,y,details)
		table.insert(w.points,wmpoint)
	end

	function w.removePointByIndex(index)
		table.remove(w.points,index)
	end
	
	function w.replacePointByIndex(index,x,y,details)
		local oldPoint = w.points[index]
		w.points[index] = wpoint.new(x or oldPoint.x, y or oldPoint.y, details or oldPoint.details)
		
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
	
	-- returns the index of a point that matches the given parameters exactly or -1 if there is no such point
	function w.getIndex(x,y,details)
		for k,v in pairs(points) do
			if (v.x == x) and (v.y == y) and (v.details == details) then
				return k
			end
		end
		return -1
	end
	
	-- changes marker at specified index
	function w.changePoint(index, newX, newY, newDetails)
		local oldPoint = w.points[index] 
		w.points[index] = wpoint.new(x or oldPoint.x,y or oldPoint.y,newDetails or oldPoint.details)
	end
	
	function w.draw()
		for k,i in pairs(w.map) do
			for l,j in pairs(i) do
				w.map[k][l].draw(k, l, worldmap.sectionSize)
			end
		end
		for k,v in pairs(w.points) do
			v.draw()
		end
	end
	
	function w.update()
		marker = event.pull("changeMarker")
		newWorldSector = event.pull("changeWorldMap")
		if marker then --marker layout: m.x, m.y, m.details OR m.delete=true, m.delIndex
			for k,m in pairs(marker) do
				if m.delete then
					w.removePointByIndex(m.delIndex)
				else
					w.addPoint(m.x,m.y,m.details)
				end
			end
		end
		if newWorldSector then --newWorldSector layout: s.x, s.y, s.gameMap, s.visuals
			for k,s in pairs(newWorldSector) do
				if not (s.gameMap==nil) then
					w.map[s.x][s.y].gameMap = s.gameMap
				end
				if not (s.visuals==nil) then
					w.map[s.x][s.y].visuals = s.visuals
				end
			end
		end
	end

	return w
end

return worldmap
