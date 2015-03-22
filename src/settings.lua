require("src/Tserial")

local settings = {}

function settings.init()
	if not love.filesystem.exists("settings.ini") then
		-- TODO create settings.ini
	end
	local settingsStr = love.filesystem.read("settings.ini")
	settings.loaded = Tserial.unpack(settingsStr)
	print(settings.loaded.ip)
end

return settings