-- wsection
-- this is a square on the world map and has a game map attatched to it
wsection = {}
wsection.maxTextureIndex = 1
function wsection.new(gameMap, visuals)
	local s = {}
	s.visuals = visuals or 0 -- index for the texture of this world section
	s.map = gameMap

	function s.draw(posX,posY)
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
