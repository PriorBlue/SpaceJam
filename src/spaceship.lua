local ShipManager = {}

ShipManager.events = nil
ShipManager.ships = {}
ShipManager.shipId = 0;

ShipManager.init = function(events)
	ShipManager.events = events
end

ShipManager.keyreleased = function(key)
	if ShipManager.shipId ~= 0 then
	    local scode = love.keyboard.getScancodeFromKey(key)
		local ship = ShipManager.ships[ShipManager.shipId]

		if scode == "w" then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "speedStop", x = ship.x, y = ship.y, d = ship.direction, s = ship.speed})
		elseif scode == "s" then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "speedStop", x = ship.x, y = ship.y, d = ship.direction, s = ship.speed})
		end
		
		if scode == "a" then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "rotateStop", x = ship.x, y = ship.y, d = ship.direction, s = ship.speed})
		elseif scode == "d" then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "rotateStop", x = ship.x, y = ship.y, d = ship.direction, s = ship.speed})
		end
	end
end

ShipManager.keypressed = function(key)
	if ShipManager.shipId ~= 0 then
		local scode = love.keyboard.getScancodeFromKey(key)
		local ship = ShipManager.ships[ShipManager.shipId]

		if scode == "w" then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "speedUp", x = ship.x, y = ship.y, d = ship.direction, s = ship.speed})
		elseif scode == "s" then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "speedDown", x = ship.x, y = ship.y, d = ship.direction, s = ship.speed})
		end
		
		if scode == "a" then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "rotateLeft", x = ship.x, y = ship.y, d = ship.direction, s = ship.speed})
		elseif scode == "d" then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "rotateRight", x = ship.x, y = ship.y, d = ship.direction, s = ship.speed})
		end
	end
end

ShipManager.update = function(dt)
	-- Create Ship
	local events = ShipManager.events.pull("CreateShip")

	if events then
		for i, e in pairs(events) do
			print("create",e.x, e.y)
			ShipManager.ships[e.id] = CreateSpaceShip(e.x, e.y, e.id)
		end
	end
	
	-- Destroy Ship
	local events = ShipManager.events.pull("DestroyShip")

	if events then
		for i, e in pairs(events) do
			print("destroy",e.id)
			ShipManager.ships[e.id] = nil
		end
	end
	
	-- Get PlayerId
	local events = ShipManager.events.pull("PlayerId")

	if events then
		for i, e in pairs(events) do
			ShipManager.shipId = e.id;
		end
	end
	
	-- MoveShip
	events = ShipManager.events.pull("MoveShip")

	if events then
		for i, e in pairs(events) do
			local obj = ShipManager.ships[e.id]
			obj.x = e.x
			obj.y = e.y
			obj.direction = e.d
			obj.speed = e.s
			if obj then
				if e.action == "speedUp" then
					obj.speedTrigger = 1
				elseif e.action == "speedDown" then
					obj.speedTrigger = -1
				elseif e.action == "speedStop" then
					obj.speedTrigger = 0
				end
				
				if e.action == "rotateLeft" then
					obj.rotationTrigger = 1
				elseif e.action == "rotateRight" then
					obj.rotationTrigger = -1
				elseif e.action == "rotateStop" then
					obj.rotationTrigger = 0
				end
			end
		end
	end
	
	-- Update Ships
	if ShipManager.ships then
		for i, s in pairs(ShipManager.ships) do
			s.update(dt)
		end
	end
end

ShipManager.draw = function()
	if ShipManager.ships then
		for i, s in pairs(ShipManager.ships) do
			s.draw(i)
		end
	end
end

ShipManager.drawMarker = function()
	love.graphics.setColor(0, 0, 255, 31)
	love.graphics.rectangle("fill", love.graphics.getWidth()-256,0,256,256)
	if ShipManager.ships then
		for i, s in pairs(ShipManager.ships) do
			s.drawMarker(i)
		end
	end
	love.graphics.setColor(255, 255, 255)
end

function CreateSpaceShip(x, y, id)
	local obj = {}

	obj.id = id
	obj.x = x
	obj.y = y
	obj.img = love.graphics.newImage("gfx/ship1.png")
	obj.speed = 0
	obj.speedTrigger = 0
	obj.speedMax = 200
	obj.speedMin = -100
	obj.boostSpeed = 100
	obj.rotationSpeed = 2
	obj.rotationTrigger = 0
	obj.direction = 0

	obj.update = function(dt)
		if obj.speedTrigger == 1 then
			obj.speed = obj.speed + obj.boostSpeed * dt
		elseif obj.speedTrigger == -1 then
			obj.speed = obj.speed - obj.boostSpeed * dt
		end
		
		if obj.rotationTrigger == 1 then
			obj.direction = obj.direction - obj.rotationSpeed * dt
		elseif obj.rotationTrigger == -1 then
			obj.direction = obj.direction + obj.rotationSpeed * dt
		end

		obj.speed = math.max(obj.speedMin, obj.speed)
		obj.speed = math.min(obj.speedMax, obj.speed)
		
		obj.x = obj.x + math.sin(obj.direction) * dt * obj.speed
		obj.y = obj.y - math.cos(obj.direction) * dt * obj.speed
	end

	obj.draw = function(i)
		love.graphics.draw(obj.img, obj.x, obj.y, obj.direction, 1, 1, 16, 16)
		--love.graphics.print(i, obj.x, obj.y)
	end
	
	obj.drawMarker = function(i)
		love.graphics.setColor(0, 255, 0, 127)
		love.graphics.rectangle("fill", love.graphics.getWidth()-256 + math.min(256, (math.max(0, obj.x * 0.01))) - 3, math.min(256, (math.max(0, obj.y * 0.01))) - 3, 5, 5)
	end
	
	return obj
end

return ShipManager