local ImgCache = {}
ImgCache.cache = {}
ImgCache.get = function(self, path)
	if self.cache ~= nil then 
		if self.cache[path] == nil then
			self.cache[path] = love.graphics.newImage(path)
		end
		return self.cache[path]
	end
end

return ImgCache