--- Tserial v1.5, a simple table serializer which turns tables into Lua script
-- @author Taehl (SelfMadeSpirit@gmail.com)
Tserial = {}
TSerial = Tserial	-- for backwards-compatibility

function Tserial.pack(t, drop, indent)
	assert(type(t) == "table", "Can only Tserial.pack tables.")
	local s, empty, indent = "{"..(indent and "\n" or ""), true, indent and math.max(type(indent)=="number" and indent or 0,0)
	local function proc(k,v, omitKey)	-- encode a key/value pair
		empty = nil	-- helps ensure empty tables return as "{}"
		local tk, tv, skip = type(k), type(v)
		if type(drop)=="table" and drop[k] then k = "["..drop[k].."]"
		elseif tk == "boolean" then k = k and "[true]" or "[false]"
		elseif tk == "string" then local f = string.format("%q",k) if f ~= '"'..k..'"' then k = '['..f..']' end
		elseif tk == "number" then k = "["..k.."]"
		elseif tk == "table" then k = "["..Tserial.pack(k, drop, indent and indent+1).."]"
		elseif type(drop) == "function" then k = "["..string.format("%q",drop(k)).."]"
		elseif drop then skip = true
		else error("Attempted to Tserial.pack a table with an invalid key: "..tostring(k))
		end
		if type(drop)=="table" and drop[v] then v = drop[v]
		elseif tv == "boolean" then v = v and "true" or "false"
		elseif tv == "string" then v = string.format("%q", v)
		elseif tv == "number" then	-- no change needed
		elseif tv == "table" then v = Tserial.pack(v, drop, indent and indent+1)
		elseif type(drop) == "function" then v = string.format("%q",drop(v))
		elseif drop then skip = true
		else error("Attempted to Tserial.pack a table with an invalid value: "..tostring(v))
		end
		if not skip then return string.rep("\t",indent or 0)..(omitKey and "" or k.."=")..v..","..(indent and "\n" or "") end
		return ""
	end
	local l=-1 repeat l=l+1 until rawget(t,l+1)==nil	-- #t "can" lie!
	for i=1,l do s = s..proc(i, t[i], true) end	-- use ordered values when possible for better string
	for k, v in pairs(t) do if not (type(k)=="number" and k<=l) then s = s..proc(k, v) end end
	if not empty then s = string.sub(s,1,string.len(s)-1) end
	if indent then s = string.sub(s,1,string.len(s)-1).."\n" end
	return s..string.rep("\t",(indent or 1)-1).."}"
end

function Tserial.unpack(s, safe)
	if safe then s = string.match(s, "(%b{})") end
	assert(type(s) == "string", "Can only Tserial.unpack strings.")
	local f, result = loadstring("Tserial.table="..s)
	if not safe then assert(f,result) elseif not f then return nil, result end
	result = f()
	local t = Tserial.table
	Tserial.table = nil
	return t, result
end