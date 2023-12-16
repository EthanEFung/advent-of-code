local filepath = arg[1]
if filepath == nil then
    print ("filepath not found")
    os.exit()
    return
end
io.input(filepath)

---@type string[][]
local grid = {}

local nRows = 0
for line in io.lines() do
    nRows = nRows + 1
    local row = {}
    for cell in string.gmatch(line, ".") do
        table.insert(row, cell)
    end
    table.insert(grid, row)
end

---@type table|nil
local list = { value = {1, 0}, direction = "east", next = nil }
local energized = {}
local seen = {}

while list do
    local value = list.value
    local direction = list.direction

    -- begin adding to the linked list
    local cy, cx = value[1], value[2]
    energized[cy .. "," .. cx] = true

    local dy, dx = cy, cx
    if direction == "east" then
        dx = dx + 1
    elseif direction == "north" then
        dy = dy - 1
    elseif direction == "west" then
        dx = dx - 1
    elseif direction == "south" then
        dy = dy + 1
    end

    local next = nil
    local key = cy .. "," .. cx .. "," .. direction

    if seen[key] then

    elseif dx < 1 or dx > #grid[1] then
        -- do nothing
    elseif dy < 1 or dy > #grid then
        -- do nothing
    else
        seen[key] = true
        if grid[dy][dx] == "." then
            next = { value = {dy, dx}, direction = direction }
        elseif grid[dy][dx] == "\\" then
            local newDirection = nil
            if direction == "east" then newDirection = "south"
            elseif direction == "south" then newDirection = "east"
            elseif direction == "west" then newDirection = "north"
            elseif direction == "north" then newDirection = "west"
            end

            next = { value = {dy, dx}, direction = newDirection }
        elseif grid[dy][dx] == "/" then
            local newDirection = nil
            if direction == "east" then newDirection = "north"
            elseif direction == "south" then newDirection = "west"
            elseif direction == "west" then newDirection = "south"
            elseif direction == "north" then newDirection = "east"
            end

            next = { value = {dy, dx}, direction = newDirection }
        elseif grid[dy][dx] == "|" and (direction == "south" or direction == "north") then

            next = { value = {dy, dx}, direction = direction }
        elseif grid[dy][dx] == "|" then

            next = { value = {dy, dx}, direction = "north" }
            next.next = { value = {dy, dx}, direction = "south" }
        elseif grid[dy][dx] == "-" and (direction == "west" or direction == "east") then

            next = { value = {dy, dx}, direction = direction }
        elseif grid[dy][dx] == "-" then

            next = { value = {dy, dx}, direction = "west" }
            next.next = { value = {dy, dx}, direction = "east" }
        end
        local curr = list
        while curr and curr.next do
            curr = curr.next
        end
        curr.next = next
    end
    list = list.next
end

local count = 0
for k in pairs(energized) do
    local sy, sx = k:match("(%d+),(%d+)")
    local y = math.tointeger(sy)
    local x = math.tointeger(sx)
    grid[y][x] = "#"
    count = count + 1
end

local out = ""
for i = 1, #grid do
    for j = 1, #grid[i] do
        out = out .. grid[i][j]
    end
    out = out .. "\n"
end
print(out)

print("energized: " .. count - 1 )
