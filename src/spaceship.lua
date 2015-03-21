local ShipManager = {}

ShipManager.events = nil
ShipManager.ships = {}
ShipManager.shipId = 1;

ShipManager.init = function(events)
	ShipManager.events = events
end

ShipManager.updateInput = function()
	local events = ShipManager.events.pull("CreateShip")

	if ShipManager.shipId ~= 0 then
		if love.keyboard.isDown("w") then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "speedUp"})
		elseif love.keyboard.isDown("s") then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "speedDown"})
		end
		
		if love.keyboard.isDown("a") then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "rotateLeft"})
		elseif love.keyboard.isDown("d") then
			ShipManager.events.push("MoveShip", {id = ShipManager.shipId, action = "rotateRight"})
		end
	end
end

ShipManager.update = function(dt)
	local events = ShipManager.events.pull("CreateShip")

	if events then
		for i, e in pairs(events) do
			ShipManager.ships[e.id] = CreateSpaceShip(e.x, e.y, e.id)
		end
	end
	
	events = ShipManager.events.pull("MoveShip")

	if events then
		for i, e in pairs(events) do
			local obj = ShipManager.ships[e.id]

			if obj then
				if e.action == "speedUp" then
					obj.speed = obj.speed + obj.boostSpeed * dt
				elseif e.action == "speedDown" then
					obj.speed = obj.speed - obj.boostSpeed * dt
				end
				
				if e.action == "rotateLeft" then
					obj.direction = obj.direction - obj.rotationSpeed * dt
				elseif e.action == "rotateRight" then
					obj.direction = obj.direction + obj.rotationSpeed * dt
				end
			end
		end
	end
	
	if ShipManager.ships then
		for i, s in pairs(ShipManager.ships) do
			s.update(dt)
		end
	end
end

ShipManager.draw = function()
	if ShipManager.ships then
		for i, s in pairs(ShipManager.ships) do
			s.draw()
		end
	end
end

function CreateSpaceShip(x, y, id)
	local obj = {}

	obj.id = id
	obj.x = x
	obj.y = y
	obj.img = love.graphics.newImage("gfx/ship1.png")
	obj.speed = 0
	obj.speedMax = 200
	obj.speedMin = -100
	obj.boostSpeed = 100
	obj.rotationSpeed = 2
	obj.direction = 0

	obj.update = function(dt)
		obj.speed = math.max(obj.speedMin, obj.speed)
		obj.speed = math.min(obj.speedMax, obj.speed)
		
		obj.x = obj.x + math.sin(obj.direction) * dt * obj.speed
		obj.y = obj.y - math.cos(obj.direction) * dt * obj.speed
	end

	obj.draw = function()
		love.graphics.draw(obj.img, obj.x, obj.y, obj.direction, 1, 1, 16, 16)
	end
	
	return obj
end

return ShipManager