-- Event example --
--[[
event.push("ShootFire", {x = 16, y = 32})

bullets = event.pull("ShootFire")

if bullets then
	for k, b in pairs(bullets) do
		print(b.x)
	end
end
]]--

local event = {}

event.msg = {}

event.push = function(id, msg)
	if not event.msg[id] then
		event.msg[id] = {}
	end
	
	table.insert(event.msg[id], msg)
end

event.pull = function(id)
	return event.msg[id]
end

event.clearAll = function()
	event.msg = {}
end

return event