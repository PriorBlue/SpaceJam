local socket = require("socket")

local NetworkManager = {}
NetworkManager.playerId = 0;

NetworkManager.events = nil
NetworkManager.player = {}

NetworkManager.udp = socket.udp()
NetworkManager.udp:settimeout(0)

NetworkManager.init = function(events)
	NetworkManager.udp:setpeername(settings.loaded.ip, settings.loaded.port)
	NetworkManager.events = events
	NetworkManager.udp:send(TSerial.pack({id = "Login"}))
end

NetworkManager.update = function(dt)
	local data = NetworkManager.udp:receive()
	
	if data then
		data = TSerial.unpack(data)
		NetworkManager.events.push(data.id, data.msg)
	end
	
	-- Get PlayerId
	local events = NetworkManager.events.pull("PlayerId")

	if events then
		for i, e in pairs(events) do
			NetworkManager.playerId = e.id;
		end
	end
	
	-- MoveShip
	local events = NetworkManager.events.pull("MoveShip")

	if NetworkManager.playerId ~= 0 and events then
		for i, e in pairs(events) do
			if e.id == NetworkManager.playerId then
				local data = {}
				data.id = "MoveShip"
				data.msg = {}
				data.msg.id = e.id
				data.msg.action = e.action
				data.msg.x = e.x
				data.msg.y = e.y
				data.msg.d = e.d
				data.msg.s = e.s
				data.msg.ds = e.ds
				data.msg.ss = e.ss
				data.msg.sd = e.sd
				data.msg.dd = e.dd
				data.msg.smin = e.smin
				data.msg.smax = e.smax

				NetworkManager.udp:send(TSerial.pack(data))
			end
		end
	end
	
	-- Shoot
	local events = NetworkManager.events.pull("Shoot")

	if NetworkManager.playerId ~= 0 and events then
		for i, e in pairs(events) do
			if e.id == NetworkManager.playerId then
				local data = {}
				data.id = "Shoot"
				data.msg = {}
				data.msg.id = NetworkManager.playerId
				
				NetworkManager.udp:send(TSerial.pack(data))
			end
		end
	end
end

NetworkManager.quit = function()
	NetworkManager.udp:send(TSerial.pack({id = "Logout", msg = {id = NetworkManager.playerId}}))
end

return NetworkManager