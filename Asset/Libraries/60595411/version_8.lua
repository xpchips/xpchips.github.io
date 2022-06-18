local t = {}

 

 --JSON Encoder and Parser for Lua 5.1
 --
 --Copyright 2007 Shaun Brown  (http://www.chipmunkav.com)
 --All Rights Reserved.
 
 --Permission is hereby granted, free of charge, to any person 
 --obtaining a copy of this software to deal in the Software without 
 --restriction, including without limitation the rights to use, 
 --copy, modify, merge, publish, distribute, sublicense, and/or 
 --sell copies of the Software, and to permit persons to whom the 
 --Software is furnished to do so, subject to the following conditions:
 
 --The above copyright notice and this permission notice shall be 
 --included in all copies or substantial portions of the Software.
 --If you find this software useful please give www.chipmunkav.com a mention.

 --THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 --EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 --OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 --IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
 --ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
 --CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
 --CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
local string = string
local math = math
local table = table
local error = error
local tonumber = tonumber
local tostring = tostring
local type = type
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local assert = assert
local Chipmunk = Chipmunk


local StringBuilder = {
	buffer = {}
}

function StringBuilder:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.buffer = {}
	return o
end

function StringBuilder:Append(s)
	self.buffer[#self.buffer+1] = s
end

function StringBuilder:ToString()
	return table.concat(self.buffer)
end

local JsonWriter = {
	backslashes = {
		['\b'] = "\\b",
		['\t'] = "\\t",	
		['\n'] = "\\n", 
		['\f'] = "\\f",
		['\r'] = "\\r", 
		['"']  = "\\\"", 
		['\\'] = "\\\\", 
		['/']  = "\\/"
	}
}

function JsonWriter:New()
	local o = {}
	o.writer = StringBuilder:New()
	setmetatable(o, self)
	self.__index = self
	return o
end

function JsonWriter:Append(s)
	self.writer:Append(s)
end

function JsonWriter:ToString()
	return self.writer:ToString()
end

function JsonWriter:Write(o)
	local t = type(o)
	if t == "nil" then
		self:WriteNil()
	elseif t == "boolean" then
		self:WriteString(o)
	elseif t == "number" then
		self:WriteString(o)
	elseif t == "string" then
		self:ParseString(o)
	elseif t == "table" then
		self:WriteTable(o)
	elseif t == "function" then
		self:WriteFunction(o)
	elseif t == "thread" then
		self:WriteError(o)
	elseif t == "userdata" then
		self:WriteError(o)
	end
end

function JsonWriter:WriteNil()
	self:Append("null")
end

function JsonWriter:WriteString(o)
	self:Append(tostring(o))
end

function JsonWriter:ParseString(s)
	self:Append('"')
	self:Append(string.gsub(s, "[%z%c\\\"/]", function(n)
		local c = self.backslashes[n]
		if c then return c end
		return string.format("\\u%.4X", string.byte(n))
	end))
	self:Append('"')
end

function JsonWriter:IsArray(t)
	local count = 0
	local isindex = function(k) 
		if type(k) == "number" and k > 0 then
			if math.floor(k) == k then
				return true
			end
		end
		return false
	end
	for k,v in pairs(t) do
		if not isindex(k) then
			return false, '{', '}'
		else
			count = math.max(count, k)
		end
	end
	return true, '[', ']', count
end

function JsonWriter:WriteTable(t)
	local ba, st, et, n = self:IsArray(t)
	self:Append(st)	
	if ba then		
		for i = 1, n do
			self:Write(t[i])
			if i < n then
				self:Append(',')
			end
		end
	else
		local first = true;
		for k, v in pairs(t) do
			if not first then
				self:Append(',')
			end
			first = false;			
			self:ParseString(k)
			self:Append(':')
			self:Write(v)			
		end
	end
	self:Append(et)
end

function JsonWriter:WriteError(o)
	error(string.format(
		"Encoding of %s unsupported", 
		tostring(o)))
end

function JsonWriter:WriteFunction(o)
	if o == Null then 
		self:WriteNil()
	else
		self:WriteError(o)
	end
end

local StringReader = {
	s = "",
	i = 0
}

function StringReader:New(s)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.s = s or o.s
	return o	
end

function StringReader:Peek()
	local i = self.i + 1
	if i <= #self.s then
		return string.sub(self.s, i, i)
	end
	return nil
end

function StringReader:Next()
	self.i = self.i+1
	if self.i <= #self.s then
		return string.sub(self.s, self.i, self.i)
	end
	return nil
end

function StringReader:All()
	return self.s
end

local JsonReader = {
	escapes = {
		['t'] = '\t',
		['n'] = '\n',
		['f'] = '\f',
		['r'] = '\r',
		['b'] = '\b',
	}
}

function JsonReader:New(s)
	local o = {}
	o.reader = StringReader:New(s)
	setmetatable(o, self)
	self.__index = self
	return o;
end

function JsonReader:Read()
	self:SkipWhiteSpace()
	local peek = self:Peek()
	if peek == nil then
		error(string.format(
			"Nil string: '%s'", 
			self:All()))
	elseif peek == '{' then
		return self:ReadObject()
	elseif peek == '[' then
		return self:ReadArray()
	elseif peek == '"' then
		return self:ReadString()
	elseif string.find(peek, "[%+%-%d]") then
		return self:ReadNumber()
	elseif peek == 't' then
		return self:ReadTrue()
	elseif peek == 'f' then
		return self:ReadFalse()
	elseif peek == 'n' then
		return self:ReadNull()
	elseif peek == '/' then
		self:ReadComment()
		return self:Read()
	else
		return nil
	end
end
		
function JsonReader:ReadTrue()
	self:TestReservedWord{'t','r','u','e'}
	return true
end

function JsonReader:ReadFalse()
	self:TestReservedWord{'f','a','l','s','e'}
	return false
end

function JsonReader:ReadNull()
	self:TestReservedWord{'n','u','l','l'}
	return nil
end

function JsonReader:TestReservedWord(t)
	for i, v in ipairs(t) do
		if self:Next() ~= v then
			 error(string.format(
				"Error reading '%s': %s", 
				table.concat(t), 
				self:All()))
		end
	end
end

function JsonReader:ReadNumber()
        local result = self:Next()
        local peek = self:Peek()
        while peek ~= nil and string.find(
		peek, 
		"[%+%-%d%.eE]") do
            result = result .. self:Next()
            peek = self:Peek()
	end
	result = tonumber(result)
	if result == nil then
	        error(string.format(
			"Invalid number: '%s'", 
			result))
	else
		return result
	end
end

function JsonReader:ReadString()
	local result = ""
	assert(self:Next() == '"')
        while self:Peek() ~= '"' do
		local ch = self:Next()
		if ch == '\\' then
			ch = self:Next()
			if self.escapes[ch] then
				ch = self.escapes[ch]
			end
		end
                result = result .. ch
	end
        assert(self:Next() == '"')
	local fromunicode = function(m)
		return string.char(tonumber(m, 16))
	end
	return string.gsub(
		result, 
		"u%x%x(%x%x)", 
		fromunicode)
end

function JsonReader:ReadComment()
        assert(self:Next() == '/')
        local second = self:Next()
        if second == '/' then
            self:ReadSingleLineComment()
        elseif second == '*' then
            self:ReadBlockComment()
        else
            error(string.format(
		"Invalid comment: %s", 
		self:All()))
	end
end

function JsonReader:ReadBlockComment()
	local done = false
	while not done do
		local ch = self:Next()		
		if ch == '*' and self:Peek() == '/' then
			done = true
                end
		if not done and 
			ch == '/' and 
			self:Peek() == "*" then
                    error(string.format(
			"Invalid comment: %s, '/*' illegal.",  
			self:All()))
		end
	end
	self:Next()
end

function JsonReader:ReadSingleLineComment()
	local ch = self:Next()
	while ch ~= '\r' and ch ~= '\n' do
		ch = self:Next()
	end
end

function JsonReader:ReadArray()
	local result = {}
	assert(self:Next() == '[')
	local done = false
	if self:Peek() == ']' then
		done = true;
	end
	while not done do
		local item = self:Read()
		result[#result+1] = item
		self:SkipWhiteSpace()
		if self:Peek() == ']' then
			done = true
		end
		if not done then
			local ch = self:Next()
			if ch ~= ',' then
				error(string.format(
					"Invalid array: '%s' due to: '%s'", 
					self:All(), ch))
			end
		end
	end
	assert(']' == self:Next())
	return result
end

function JsonReader:ReadObject()
	local result = {}
	assert(self:Next() == '{')
	local done = false
	if self:Peek() == '}' then
		done = true
	end
	while not done do
		local key = self:Read()
		if type(key) ~= "string" then
			error(string.format(
				"Invalid non-string object key: %s", 
				key))
		end
		self:SkipWhiteSpace()
		local ch = self:Next()
		if ch ~= ':' then
			error(string.format(
				"Invalid object: '%s' due to: '%s'", 
				self:All(), 
				ch))
		end
		self:SkipWhiteSpace()
		local val = self:Read()
		result[key] = val
		self:SkipWhiteSpace()
		if self:Peek() == '}' then
			done = true
		end
		if not done then
			ch = self:Next()
                	if ch ~= ',' then
				error(string.format(
					"Invalid array: '%s' near: '%s'", 
					self:All(), 
					ch))
			end
		end
	end
	assert(self:Next() == "}")
	return result
end

function JsonReader:SkipWhiteSpace()
	local p = self:Peek()
	while p ~= nil and string.find(p, "[%s/]") do
		if p == '/' then
			self:ReadComment()
		else
			self:Next()
		end
		p = self:Peek()
	end
end

function JsonReader:Peek()
	return self.reader:Peek()
end

function JsonReader:Next()
	return self.reader:Next()
end

function JsonReader:All()
	return self.reader:All()
end

function Encode(o)
	local writer = JsonWriter:New()
	writer:Write(o)
	return writer:ToString()
end

function Decode(s)
	local reader = JsonReader:New(s)
	return reader:Read()
end

function Null()
	return Null
end
-------------------- End JSON Parser ------------------------


t.DecodeJSON = function(jsonString)
	if type(jsonString) == "string" then
		return Decode(jsonString)
	end
	print("RbxUtil.DecodeJSON expects string argument!")
	return nil
end

t.EncodeJSON = function(jsonTable)
	return Encode(jsonTable)
end









------------------------------Terrain Utilities Begin--------------------------------

--makes a wedge at location x, y, z
--sets cell x, y, z to default material if parameter is provided, if not sets cell x, y, z to be whatever material it previously was
--returns true if made a wedge, false if the cell remains a block
t.MakeWedge = function(x, y, z, defaultmaterial)
	local c = game:GetService("TerrainService")
	--gather info about all the cells around x, y, z
	surroundings = {} --surroundings is a 3 x 3 x 3 array of the material of the cells adjacent to x, y, z
	for i = x - 1, x + 1 do
		surroundings[i] = {}
		for j = y - 1, y + 1 do
			surroundings[i][j] = {}
			for k = z - 1, z + 1 do
				local material, wedge, rotation = c:GetCellFull(i, j, k)
				surroundings[i][j][k] = material
			end
		end
	end
	--make some useful arrays and counters
	local sides = {} --sides is an array of the material of the 4 adjacent sides
	sides[0] = surroundings[x - 1][y][z]
	sides[1] = surroundings[x][y][z + 1]
	sides[2] = surroundings[x + 1][y][z]
	sides[3] = surroundings[x][y][z - 1]
	local adjacentSides = 0
	for n = 0, 3 do
		if sides[n] and sides[n] > 0 then
			adjacentSides = adjacentSides + 1
		end
	end
	local sidesAbove = {} --sides is an array of the material of the 4 adjacent sides 1 height above
	sidesAbove[0] = surroundings[x - 1][y + 1][z]
	sidesAbove[1] = surroundings[x][y + 1][z + 1]
	sidesAbove[2] = surroundings[x + 1][y + 1][z]
	sidesAbove[3] = surroundings[x][y + 1][z - 1]
	local adjacentSidesAbove = 0
	for n = 0, 3 do
		if sidesAbove[n] and sidesAbove[n] > 0 then
			adjacentSidesAbove = adjacentSidesAbove + 1
		end
	end
	local corners = {} --corners is an array of the material of the 4 adjacent corners
	corners[0] = surroundings[x - 1][y][z - 1]
	corners[1] = surroundings[x - 1][y][z + 1]
	corners[2] = surroundings[x + 1][y][z + 1]
	corners[3] = surroundings[x + 1][y][z - 1]
	local adjacentCorners = 0
	for n = 0, 3 do
		if corners[n] and corners[n] > 0 then
			adjacentCorners = adjacentCorners + 1
		end
	end
	local cornersAbove = {} --corners is an array of the material of the 4 adjacent corners 1 height above
	cornersAbove[0] = surroundings[x - 1][y + 1][z - 1]
	cornersAbove[1] = surroundings[x - 1][y + 1][z + 1]
	cornersAbove[2] = surroundings[x + 1][y + 1][z + 1]
	cornersAbove[3] = surroundings[x + 1][y + 1][z - 1]
	local adjacentCornersAbove = 0
	for n = 0, 3 do
		if cornersAbove[n] and cornersAbove[n] > 0 then
			adjacentCornersAbove = adjacentCornersAbove + 1
		end
	end
	--determine what type of wedge to make
	local material = nil
	local wedge = nil
	local rotation = nil 
	if defaultmaterial then
		material = defaultmaterial
	else
		material, wedge, rotation = c:GetCellFull(x, y, z) --start with the existing material, wedge, and rotation
	end
	wedge = 0 --default wedge is a block
	rotation = 0 --default rotation is 0
	--type 1: 45 degree ramp //must not have a block on top and must have a block under, and be surrounded by 1 side; or 3 sides and the 2 corners between them
	if surroundings[x][y + 1][z] == 0 and surroundings[x][y - 1][z] > 0 then
		if adjacentSides == 1 then
			for n = 0, 3 do
				if sides[n] and sides[n] > 0 then
					wedge = 1
					rotation = (n + 1) % 4
					c:SetCellFull(x, y, z, material, wedge, rotation)
					return true
				end
			end
		elseif  adjacentSides == 3 then
			for n = 0, 3 do
				if sides[n] and sides[n] > 0 and corners[(n + 1) % 4] > 0 and sides[(n + 1) % 4] > 0 and corners[(n + 2) % 4] > 0 and sides[(n + 2) % 4] > 0 then
					wedge = 1
					rotation = (n + 2) % 4
					c:SetCellFull(x, y, z, material, wedge, rotation)
					return true
				end
			end
		end
	end
	--type 2: 45 degree corner //must not have a block on top and must have a block under, and be surrounded by 2 sides and the 1 corner between them; or 3 sides and 1 corner between 2 of them (facing towards that corner)
	if surroundings[x][y + 1][z] == 0 and surroundings[x][y - 1][z] > 0 then
		for n = 0, 3 do
			if sides[n] and sides[n] > 0 and corners[(n + 1) % 4] > 0 and sides[(n + 1) % 4] > 0 and (adjacentSides == 2 or (adjacentSides == 3 and (corners[(n + 3) % 4] > 0 or (sides[(n + 2) % 4] > 0 and corners[(n + 2) % 4] > 0) or (sides[(n + 3) % 4] > 0 and corners[n] > 0)))) then
				wedge = 2
				rotation = (n + 2) % 4
				c:SetCellFull(x, y, z, material, wedge, rotation)
				return true
			end
		end
	end
	--type 3: 45 degree inverse corner //surrounded by three sides or 4 sides and 3 corners, with nothing above or else a block on top surrounded on 2 sides and the corner between them
	if adjacentSides == 3 and surroundings[x][y + 1][z] > 0 then
		if adjacentCorners > 1 then
			for n = 0, 3 do
				if sides[n] and (corners[n] == 0 or cornersAbove[n] == 0) and (sides[(n - 1) % 4] == 0 or sides[n] == 0) and (sidesAbove[n] == 0 and sidesAbove[(n + 1) % 4] > 0 and sidesAbove[(n + 2) % 4] > 0 and sidesAbove[(n + 3) % 4] == 0) then 
					wedge = 3
					rotation = (n + 3) % 4
					c:SetCellFull(x, y, z, material, wedge, rotation)
					return true
				end
			end
		end
	elseif adjacentSides == 4 and adjacentCorners == 3 then
		for n = 0, 3 do
			if corners[n] and corners[n] == 0 and (surroundings[x][y + 1][z] == 0 or (sidesAbove[n] == 0 and sidesAbove[(n + 1) % 4] > 0 and cornersAbove[(n + 2) % 4] > 0 and sidesAbove[(n + 2) % 4] > 0 and sidesAbove[(n + 3) % 4] == 0)) then
				wedge = 3
				rotation = (n + 3) % 4
				c:SetCellFull(x, y, z, material, wedge, rotation)
				return true
			end
		end
	end
	--type 4: half a cube, as if it were cut diagonally from front to back //surrounded by 2 sides
	if adjacentSides == 2 and adjacentCorners < 4 then
		for n = 0, 3 do
			if sides[n] and sides[n] == 0 and sides[(n + 1) % 4] == 0 and (surroundings[x][y + 1][z] == 0 or (sidesAbove[n] == 0 and sidesAbove[(n + 1) % 4] == 0 and sidesAbove[(n + 2) % 4] > 0 and sidesAbove[(n + 3) % 4] > 0)) then
				wedge = 4
				rotation = n
				c:SetCellFull(x, y, z, material, wedge, rotation)
				return true
			end
		end
	end
	local success, error = pcall(function() c:SetCellFull(x, y, z, material, wedge, rotation) end)
	if not success then
		print("RbxUtility error:",error)
	end
	return false
end

-----------------------------Terrain Utilities End-----------------------------







t.Help = 
	function(funcNameOrFunc) 
		--input argument can be a string or a function.  Should return a description (of arguments and expected side effects)
		if funcNameOrFunc == "DecodeJSON" or funcNameOrFunc == t.DecodeJSON then
			return "Function DecodeJSON.  " ..
				   "Arguments: (string).  " .. 
				   "Side effect: returns a table with all parsed JSON values" 
		end
		if funcNameOrFunc == "EncodeJSON" or funcNameOrFunc == t.EncodeJSON then
			return "Function EncodeJSON.  " ..
				   "Arguments: (table).  " .. 
				   "Side effect: returns a string composed of argument table in JSON data format" 
		end  
		if funcNameOrFunc == "MakeWedge" or funcNameOrFunc == t.MakeWedge then
			return "Function MakeWedge. " ..
					"Arguments: (x, y, z, [default material]). " ..
					"Description: Makes a wedge at location x, y, z. Sets cell x, y, z to default material if parameter is provided, if not sets cell x, y, z to be whatever material it previously was. Returns true if made a wedge, false if the cell remains a block "
		end
	end
	
return t


























