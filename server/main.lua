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
				print("Login: " .. ip .. ":" .. port)
				local p = {}
				p.id = playerId
				p.ip = ip
				p.port = port
				p.x = 0
				p.y = 0
				p.d = 0
				p.s = 0
				
				playerId = playerId + 1
				
				player[ip .. "|" .. port] = p
				
				for i, p2 in pairs(player) do
					local data = {}
					local x = math.random(10000, 12000)
					local y = math.random(10000, 12000)
					local d = math.random(0, 10)
					
					data.id = "CreateShip"
					data.msg = {}
					data.msg.id = p.id
					data.msg.x = x
					data.msg.y = y
					data.msg.d = d
					data.msg.s = s
					
					udp:sendto(Tserial.pack(data), p2.ip,  p2.port)
					
					data = {}
					
					data.id = "PlayerId"
					data.msg = {}
					data.msg.id = p.id
					
					-- send to other player
					udp:sendto(Tserial.pack(data), p.ip,  p.port)
					
					-- send return to player
					if p.id ~= p2.id then
						udp:sendto(Tserial.pack({id="CreateShip",msg={id=p2.id,x=p2.x or 0,y=p2.y or 0,d=p2.d or 0,s=p2.s or 0}}), ip, port)
					end
				end
			elseif data2.id == "Logout" then
				print("Logout: " .. ip .. ":" .. port)
				
				for i, p2 in pairs(player) do
					if player[ip .. "|" .. port] then
						local data3 = {}
						data3.id = "DestroyShip"
						data3.msg = {}
						data3.msg.id = player[ip .. "|" .. port].id
						
						udp:sendto(Tserial.pack(data3), p2.ip,  p2.port)
					end
				end
				
				player[ip .. "|" .. port] = nil
			else
				if player[ip .. "|" .. port] then
					--print(data)
					player[ip .. "|" .. port].x = data2.msg.x or player[ip .. "|" .. port].x
					player[ip .. "|" .. port].y = data2.msg.y or player[ip .. "|" .. port].y
					player[ip .. "|" .. port].d = data2.msg.d or player[ip .. "|" .. port].d
					player[ip .. "|" .. port].s = data2.msg.s or player[ip .. "|" .. port].s
					for i, p in pairs(player) do
						if player[ip .. "|" .. port].id ~= p.id then
							udp:sendto(data, p.ip,  p.port)
						end
					end
				end
			end
		end
	end
end

function love.draw()
	if player then
		love.graphics.setColor(0, 255, 0)
		for i, p in pairs(player) do
			--love.graphics.rectangle("fill", p.x * 0.01 - 2, p.y * 0.01 - 2, 4, 4)
			love.graphics.print(p.id, p.x * 0.01, p.y * 0.01)
		end
	end
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