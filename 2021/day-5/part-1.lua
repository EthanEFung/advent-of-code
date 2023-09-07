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

local function markGrid(grid, lines)
	for _, line in ipairs(lines) do
		local xA, yA = coords(line[1])
		local xB, yB = coords(line[2])
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

print("\n" .. printGrid(grid))

print(" count: " .. count(grid))

