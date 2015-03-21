-- wsection
-- this is a square on the world map and has a game map attatched to it
wsection = {}
wsection.maxTextureIndex = 19
wsection.visualsColor = {}
wsection.visualsImage = {}

for i=1,wsection.maxTextureIndex+1 do
	wsection.visualsColor[i] = {love.math.random(255),love.math.random(255),love.math.random(255),255} -- TODO set this to a color that fits the image below 
	--wsection.visualsImage[i] = nil -- TODO insert image(s) here
end

function wsection.new(gameMap, visuals)
	local s = {}
	s.visuals = visuals or 0 -- index for the texture of this world section
	s.map = gameMap

	function s.draw(posX,posY, size)
		-- love.graphics.draw(wsection.visualsImage[visuals],posX,posY) -- TODO enable this when fitting images are in the game
		local tr,tb,tg,ta = love.graphics.getColor()
		love.graphics.setColor(wsection.visualsColor[visuals])
		local q = love.graphics.polygon("line", posX*size+3,posY*size+3, posX*size+size-3,posY*size+3, posX*size+size-3,posY*size+size-3, posX*size+3,posY*size+size-3)
		love.graphics.setColor(tr,tb,tg,ta)
		--posX,posY, posX+size,posY, posX,posY+size, posX+size,posY+size)
		
		--print("drawing a wsection at "..posX..", "..posY)
	end
	
	-- optional function to get the game map for this world map section
	function s.getGameMap()
		if not s.map then
			print("no sector here yet, please add code to automatically create a new one")
		else
			return s.map
		end
	end
	
	-- optional function to change the visuals for this world map section
	function s.setVisuals(newVis)
		s.visuals = newVis
	end
	return s
end

return wsection
