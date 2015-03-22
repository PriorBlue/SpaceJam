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
				p.x = math.random(10000, 12000)
				p.y = math.random(10000, 12000)
				p.d = math.random(0, 10)
				p.s = 0
				p.ds = 2
				p.ss = 100
				p.sd = 0
				p.dd = 0
				p.smin = -100
				p.smax = 200
				
				playerId = playerId + 1
				
				player[ip .. "|" .. port] = p
				
				local data = {}
				data.id = "CreateShip"
				data.msg = {}
				data.msg.id = p.id
				data.msg.x = p.x
				data.msg.y = p.y
				data.msg.d = p.d
				data.msg.s = p.s
				data.msg.ds = p.ds
				data.msg.ss = p.ss
				data.msg.sd = p.sd
				data.msg.dd = p.dd
				data.msg.smin = p.smin
				data.msg.smax = p.smax
				
				for i, p2 in pairs(player) do
					if p2.ip then
						udp:sendto(Tserial.pack(data), p2.ip,  p2.port)
					end
					
					-- send return to player
					if p.id ~= p2.id then
						local data = {}
						data.id = "CreateShip"
						data.msg = {}
						data.msg.id = p2.id
						data.msg.x = p2.x
						data.msg.y = p2.y
						data.msg.d = p2.d
						data.msg.s = p2.s
						data.msg.ds = p2.ds
						data.msg.ss = p2.ss
						data.msg.sd = p2.sd
						data.msg.dd = p2.dd
						data.msg.smin = p2.smin
						data.msg.smax = p2.smax

						udp:sendto(Tserial.pack(data), ip, port)
					end
				end
				
				data = {}
				
				data.id = "PlayerId"
				data.msg = {}
				data.msg.id = p.id
				
				-- send id to player
				udp:sendto(Tserial.pack(data), ip,  port)
				print(Tserial.pack(data), ip,  port)
			elseif data2.id == "Logout" then
				print("Logout: " .. ip .. ":" .. port)
				
				for i, p2 in pairs(player) do
					if p2.ip and player[ip .. "|" .. port] then
						local data3 = {}
						data3.id = "DestroyShip"
						data3.msg = {}
						data3.msg.id = player[ip .. "|" .. port].id
						
						udp:sendto(Tserial.pack(data3), p2.ip,  p2.port)
					end
				end
				
				player[ip .. "|" .. port] = nil
			elseif data2.id == "Shoot" then
				print("shoot")
				
				local p = player[ip .. "|" .. port]
				
				local b = {}
				b.id = playerId
				b.x = p.x
				b.y = p.y
				b.d = p.d
				b.s = 500
				b.ds = 0
				b.ss = 0
				b.sd = 0
				b.dd = 0
				b.smin = -1000
				b.smax = 1000
				
				player["bullet" .. playerId] = b
				
				playerId = playerId + 1

				local data = {}
				
				data.id = "CreateShip"
				data.msg = {}
				data.msg.id = b.id
				data.msg.x = b.x
				data.msg.y = b.y
				data.msg.d = b.d
				data.msg.s = b.s
				data.msg.ds = b.ds
				data.msg.ss = b.ss
				data.msg.sd = b.sd
				data.msg.dd = b.dd
				data.msg.smin = b.smin
				data.msg.smax = b.smax
				
				local sdata = Tserial.pack(data)
				
				for i, p2 in pairs(player) do
					if p2.ip then
						udp:sendto(sdata, p2.ip,  p2.port)
					end
				end
			else
				if player[ip .. "|" .. port] then
					--print(data)
					local p = player[ip .. "|" .. port]
					p.x = data2.msg.x or p.x
					p.y = data2.msg.y or p.y
					p.d = data2.msg.d or p.d
					p.s = data2.msg.s or p.s
					p.ds = data2.msg.ds or p.ds
					p.ss = data2.msg.ss or p.ss
					p.sd = data2.msg.sd or p.sd
					p.dd = data2.msg.dd or p.dd
					p.min = data2.msg.min or p.min
					p.max = data2.msg.max or p.max
					print(data)
					for i, p2 in pairs(player) do
						if p2.ip and p.id ~= p2.id then
							udp:sendto(data, p2.ip,  p2.port)
						end
					end
				end
			end
		end
	end
	
	for i, p in pairs(player) do
		if p.sd == 1 then
			p.s = p.s + p.ss * dt
		elseif p.sd == -1 then
			p.s = p.s - p.ss * dt
		end
		
		if p.dd == 1 then
			p.d = p.d - p.ds * dt
		elseif p.dd == -1 then
			p.d = p.d + p.ds * dt
		end

		p.s = math.max(p.smin, p.s)
		p.s = math.min(p.smax, p.s)
		
		p.x = p.x + math.sin(p.d) * dt * p.s
		p.y = p.y - math.cos(p.d) * dt * p.s
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