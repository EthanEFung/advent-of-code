local path = "./input.txt"

local f = io.open(path)
if not f then
	print("file not found")
	return
end

f:close()

local function split(str, delimiter)
	local t = {}
	for w in string.gmatch(str, "([^"..delimiter.."]+)") do
		table.insert(t, w)
	end
	return t
end

local function coords(str)
	local substrs = split(str, ",")
	if #substrs ~= 2 then
		return
	end
	return tonumber(substrs[1]), tonumber(substrs[2])
end

local function createGrid(lines)
	local m, n = 0, 0
	local grid = {}
	for _, line in ipairs(lines) do
		for _, str in ipairs(line) do
			local x, y = coords(str)
			if type(x) == "number" and x > n then n = x end
			if type(y) == "number" and y > m then m = y end
		end
	end
	for y=0,m do
		grid[y] = {}
		for x=0,n do
			grid[y][x] = 0
		end
	end
	return grid
end

local function printGrid(grid)
	local str = ""
	for y=0,#grid do
		for x=0,#grid[y] do
			str = str .. " " .. grid[y][x]
		end
		str = str .. "\n"
	end
	return str
end

local function diagonal(xA, yA, xB, yB)

	local minX, maxX = xA, xB
	if maxX < minX then
		minX, maxX = maxX, minX
	end

	if minX == xA and yA < yB then
		while xA < xB do
			xA, yA = xA + 1, yA + 1
		end
		if xA == xB and yA == yB then
			return "upward"
		end
	elseif minX == xA then
		while xA < xB do
			xA, yA = xA + 1, yA - 1
		end
		if xA == xB and yA == yB then
			return "downward"
		end
	elseif minX == xB and yB < yA then
		while xB < xA do
			xB, yB = xB + 1, yB + 1
		end
		if xA == xB and yA == yB then
			return "upward"
		end
	elseif minX == xB then
		while xB < xA do
			xB, yB = xB + 1, yB - 1
		end
		if xA == xB and yA == yB then
			return "downward"
		end
	end
end

local function upward(xA, yA, xB, yB)
	local minX, maxX = xA, xB
	if maxX < minX then
		minX, maxX = maxX, minX
	end

	return function()
		local x, y = 0, 0
		if minX == xA and yA <= yB then
			x, y  = xA, yA
			xA, yA = xA + 1, yA + 1
			minX = xA
			return x, y
		elseif minX == xB and yB <= yA then
			x, y  = xB, yB
			xB, yB = xB + 1, yB + 1
			minX = xB
			return x, y
		end
	end
end

local function downward(xA, yA, xB, yB)
	local minX, maxX = xA, xB
	if maxX < minX then
		minX, maxX = maxX, minX
	end

	return function()
		local x, y = 0, 0
		if minX == xA and yA >= yB then
			x, y  = xA, yA
			xA, yA = xA + 1, yA - 1
			minX = xA
			return x, y
		elseif minX == xB and yB >= yA then
			x, y  = xB, yB
			xB, yB = xB + 1, yB - 1
			minX = xB
			return x, y
		end
	end
end

local function markGrid(grid, lines)
	for _, line in ipairs(lines) do
		local xA, yA = coords(line[1])

		local xB, yB = coords(line[2])

		local onDiag = diagonal(xA, yA, xB, yB)

		if xA == nil or yA == nil or xB == nil or yB == nil then
			print("unexpected nil value")
			break
		end
		if xA == xB then
			local min, max = yA, yB
			if max < min then
				min, max = max, min
			end
			for y=min,max do
				grid[y][xA] = grid[y][xA] + 1
			end
		elseif yA == yB then
			local min, max = xA, xB
			if max < min then
				min, max = max, min
			end
			for x=min,max do
				grid[yA][x] = grid[yA][x] + 1
			end

		elseif onDiag == "upward" then
			for x, y in upward(xA, yA, xB, yB) do
				grid[y][x] = grid[y][x] + 1
			end
		elseif onDiag == "downward" then
			for x, y in downward(xA, yA, xB, yB) do
				grid[y][x] = grid[y][x] + 1
			end
		end
	end
	return grid
end


local function count(grid)
	local c = 0
	for y=0,#grid do
		for x=0, #grid[y] do
			if grid[y][x] > 1 then c = c + 1 end
		end
	end
	return c
end

local lines = {}

for fileLine in io.lines(path) do
	local coordinates = split(fileLine, "%s->%s")
	table.insert(lines, coordinates)
end

local grid = createGrid(lines)

grid = markGrid(grid, lines)

-- print("\n" .. printGrid(grid))

print(" count: " .. count(grid))


