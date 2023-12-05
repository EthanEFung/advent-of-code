
--]]

io.input("input.txt")
local gearPattern = "%*"
local justNumbersPattern = "%d+"

local nummap = {}
local numbers = {}
local queue = {}
local y = 0
for line in io.lines() do
    y = y + 1
    local start = 1

    while true do
        local i, j = string.find(line, justNumbersPattern, start)
        if i == nil then break end
        start = j + 1
        local num = string.sub(line, i, j)
        table.insert(numbers, num)

        for x = i, j do
            if nummap[y] == nil then
                nummap[y] = {}
            end
            nummap[y][x] = #numbers
            -- print("(" .. x .. ", " .. y .. ") => " .. num)
        end
    end

    -- check for gear characters
    for x = 1, #line do
        local char = string.sub(line, x, x)
        -- if char == "*" then
        if string.find(char, gearPattern) ~= nil then
            table.insert(queue, {x, y})
        end
    end
end

local sum = 0
local dirs = {
    {-1, -1}, {-1, 0}, {-1, 1},
    {0,  -1},          { 0, 1},
    {1,  -1}, { 1, 0}, { 1, 1},
}
for _, coor in ipairs(queue) do
    local numset = {}
    for _, dir in ipairs(dirs) do
        local dx = coor[1] + dir[1]
        local dy = coor[2] + dir[2]

        if nummap[dy] ~= nil and nummap[dy][dx] ~= nil then
            local idx = nummap[dy][dx]

            -- print("number found [".. idx .. "]: " .. numbers[idx])
            numset[idx] = true
        end
    end

    local count = 0
    local indices = {}
    for idx in pairs(numset) do
        count = count + 1
        table.insert(indices, idx)
    end

    if count == 2 then
        local a = numbers[indices[1]]
        local b = numbers[indices[2]]
        -- print("a, b = (" .. a .. ", " .. b .. ")")
        sum = sum + (a * b)
    end
end
print("sum: " .. sum)
