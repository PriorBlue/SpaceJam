local socket = require("socket")

udp = socket.udp()
udp:settimeout(0)
udp:setpeername("192.168.2.103", 1337)

local NetworkManager = {}
NetworkManager.playerId = 0;

NetworkManager.events = nil
NetworkManager.player = {}

NetworkManager.init = function(events)
	NetworkManager.events = events
	udp:send(TSerial.pack({id = "Login"}))
end

NetworkManager.update = function(dt)
	local data = udp:receive()
	
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

				udp:send(TSerial.pack(data))
			end
		end
	end
end

NetworkManager.quit = function()
	udp:send(TSerial.pack({id = "Logout", msg = {id = NetworkManager.playerId}}))
end

return NetworkManager