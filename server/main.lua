require("TSerial")
local socket = require("socket")
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname('*', 1337)

local playerId = 1
local player = {}

function love.load()

end

function love.update(dt)
	data, ip, port = udp:receivefrom()

	if data then
		data2 = Tserial.unpack(data)

		if data2 then
			if data2.id == "Login" then
				local p = {}
				p.id = playerId
				p.ip = ip
				p.port = port
				
				playerId = playerId + 1
				
				player[ip .. "|" .. port] = p
				
				for i, p2 in pairs(player) do
					local data = {}
					local x = math.random(100, 200)
					local y = math.random(100, 200)
					local d = math.random(0, 10)
					
					data.id = "CreateShip"
					data.msg = {}
					data.msg.id = p.id
					data.msg.x = x
					data.msg.y = y
					data.msg.d = d
					
					udp:sendto(Tserial.pack(data), p2.ip,  p2.port)
					
					data = {}
					
					data.id = "PlayerId"
					data.msg = {}
					data.msg.id = p.id
					
					-- send to other player
					udp:sendto(Tserial.pack(data), p.ip,  p.port)
					
					-- send return to player
					if p.id ~= p2.id then
						udp:sendto(Tserial.pack({id="CreateShip",msg={id=p2.id,x=x,y=y,d=d}}), ip, port)
					end
				end
			else
				print(data)
				for i, p in pairs(player) do
					if player[ip .. "|" .. port].id ~= p.id then
						udp:sendto(data, p.ip,  p.port)
					else
						print("self")
					end
				end
			end
		end
	end
end

function love.draw()

end

function love.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)
  
end

function love.keyreleased(key)
	if key == 'escape' then
		love.event.quit()
	end
end