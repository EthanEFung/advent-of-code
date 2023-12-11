local path = arg[1]
local multiplier = math.tointeger(arg[2])
io.input(path)
if multiplier == nil then
    print("unrecognized integer")
end

local foundRows = {}
local foundCols = {}
local galaxies = {}

local rows = 0
local cols = 0
local grid = {}
for line in io.lines() do
    rows = rows + 1
    grid[rows] = {}
    cols = 0
    for value in line:gmatch(".") do
        cols = cols + 1
        grid[rows][cols] = value
        if value == "#" then
            foundRows[rows] = true
            foundCols[cols] = true
        end
    end
end

local ydist = 0
for y = 1, #grid do
    if foundRows[y] ~= true then
        ydist = ydist + (multiplier - 1)
    end
    local xdist = 0
    for x = 1, #grid[y] do
        if foundCols[x] ~= true then
            xdist = xdist + (multiplier - 1)
        end
        if grid[y][x] == "#" then
            table.insert(galaxies, {y + ydist, x + xdist})
        end
    end
end

local sum = 0
for i, coor in ipairs(galaxies) do
    local a = coor
    for j = i + 1, #galaxies do
        local b = galaxies[j]
        local dist = math.abs(b[2] - a[2]) + math.abs(b[1] - a[1])
        sum = sum + dist
        print(string.format("(%d, %d) -> (%d, %d) = %d", a[1], a[2], b[1], b[2], dist))
    end
end
print("sum: " .. sum)

