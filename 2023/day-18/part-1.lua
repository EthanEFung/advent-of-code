local filepath = arg[1]
if filepath == nil then
    print("filepath not specified")
    os.exit()
end

io.input(filepath)

---@class Direction
---@field cardinal string
---@field meters int
---@field color string

---@type Direction[]
local plan = {}

for line in io.lines() do
    local cardinal, meters, color = string.match(line, "(%w+) (%d+) %((.+)%)")
    print(cardinal, meters, color)
    table.insert(plan, {
        cardinal = cardinal,
        meters = math.tointeger(meters),
        color = color
    })
end

local rStart, rEnd, cStart, cEnd = 1, 1, 1, 1
local cursor = {1, 1}
local edges = { [1] = { [1] = true } }

for _, direction in ipairs(plan) do
    for _ = 1, direction.meters do
        if direction.cardinal == "U" then
            cursor[1] = cursor[1] - 1
            if cursor[1] < rStart then
                rStart = cursor[1]
            end
        elseif direction.cardinal == "R" then
            cursor[2] = cursor[2] + 1
            if cursor[2] > cEnd then
                cEnd = cursor[2]
            end
        elseif direction.cardinal == "D" then
            cursor[1] = cursor[1] + 1
            if cursor[1] > rEnd then
                rEnd = cursor[1]
            end
        elseif direction.cardinal == "L" then
            cursor[2] = cursor[2] - 1
            if cursor[2] < cStart then
                cStart = cursor[2]
            end
        end
        if edges[cursor[1]] == nil then
            edges[cursor[1]] = {}
        end
        edges[cursor[1]][cursor[2]] = true
    end
end

print(string.format("row: %d, %d - col: %d, %d", rStart, rEnd, cStart, cEnd))

-- build the grid
rStart = rStart - 1
cStart = cStart - 1
rEnd = rEnd + 1
cEnd = cEnd + 1

local grid = {}
for r = rStart, rEnd do
    for c = cStart, cEnd do
        local val = "."
        if edges[r] and edges[r][c] then val = "#" end
        if grid[r] == nil then grid[r] = {} end
        grid[r][c] = val
    end
end

-- increase the dimensions so that the exterior of the trenches can be connected

-- print the grid
for r = rStart, rEnd do
    local out = ""
    local sep = ""
    for c = cStart, cEnd do
        out = out .. sep ..  grid[r][c]
        sep = " "
    end
    print("row", r, out)
end

-- fill the externals of the trench
local cardinal = {
    { -1,  0},
    {  0,  1},
    {  1,  0},
    {  0, -1}
}
local list = { {rStart, cStart} }
local inserted = {}


for _, coor in ipairs(list) do
    local cy, cx = coor[1], coor[2]
    grid[cy][cx] = "x"
    for _, dir in ipairs(cardinal) do
        local dy, dx = dir[1], dir[2]
        local y, x = cy + dy, cx + dx
        if y >= rStart and y <= rEnd
        and x >= cStart and x <= cEnd
        and (inserted[y] == nil or inserted[y][x] == nil)
        and grid[y][x] == "." then
            table.insert(list, {y, x})
            if inserted[y] == nil then inserted[y] = {} end
            inserted[y][x] = true
        end
    end
end


-- print the grid
local count = 0
for r = rStart, rEnd do
    local out = ""
    local sep = ""
    for c = cStart, cEnd do
        out = out .. sep ..  grid[r][c]
        sep = " "
        if grid[r][c] ~= "x" then
            count = count + 1
        end
    end
    print("row", r, out)
end
print("count: ".. count)
