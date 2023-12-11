io.input("input.txt")

local grid = {}
local expanded = {}
local foundRows = {}
local foundCols = {}
local galaxies = {}

local len = 0
for line in io.lines() do
    len = len + 1
    local x = 0
    grid[len] = {}
    for value in line:gmatch(".") do
        x = x + 1
        grid[len][x] = value
        if value == "#" then
            foundCols[x] = true
            foundRows[len] = true
        end
    end
end


-- add the columns to each row before repeating rows
for y = 1, #grid do
    local row = {}
    for x = 1, #grid[y] do
        table.insert(row, grid[y][x])
        if foundCols[x] == nil then
            table.insert(row, grid[y][x])
        end
    end

    table.insert(expanded, row)
    if foundRows[y] == nil then
        table.insert(expanded, row)
    end
end

for y = 1, #expanded do
    local out = ""
    for x = 1, #expanded[y] do
        out = out .. expanded[y][x]
        if expanded[y][x] == "#" then
            table.insert(galaxies, {y, x})
        end
    end
    print(out)
end
local sum = 0
for i, coor in ipairs(galaxies) do
    local a = coor
    for j = i+1, #galaxies do
        local b = galaxies[j]
        local dist = math.abs(b[2] - a[2]) + math.abs(b[1] - a[1])
        sum = sum + dist
        print(string.format("(%d, %d) -> (%d, %d) = %d", a[1], a[2], b[1], b[2], dist))
    end
end
print("sum: " .. sum)


