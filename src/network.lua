local socket = require("socket")

udp = socket.udp()
udp:settimeout(0)
udp:setpeername("192.168.2.103", 1337)

local NetworkManager = {}

NetworkManager.events = nil
NetworkManager.player = {}

NetworkManager.init = function(events)
	NetworkManager.events = events
	udp:send("lol")
	print("lol")
end

NetworkManager.update = function(dt)
	
end

return NetworkManager