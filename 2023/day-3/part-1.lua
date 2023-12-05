--[[
-- First what we'll do is create list of numerically index'd numbers
-- we then create a map of the x, y coordinates that will point to the 
-- referenced indices so for example
--
-- map = {
--     1 = {
--          1 = 1,
--          2 = 1,
--          3 = 1
--     }
-- }
-- ^ remember that in lua tables, strings, etc are 1-indexed
-- but in this map the first layer represents the row and the second columns
-- and they are referencing index 1 which in the array has not been set, so 
-- we push the number to the array
-- numbers = {467}
-- 
-- once we've set up the data we then iterate to find the symbols that are not
-- "."
--
-- we rotate in a clock wise fashion to find the indices of the numbers to add
-- and we add to a set
-- hashset = {1 = true,3 = true,4 = true,5 = true,7 = true...}
--]]

io.input("input.txt")
local justSymbolsPattern = "[^%d%.]+"
local justNumbersPattern = "%d+"

local lines = {}
local numbers = {}
local nummap = {}
for line in io.lines() do
    table.insert(lines, line)
    local start = 1

    while true do
        local i, j = string.find(line, justNumbersPattern, start)
        if i == nil then break end
        start = j + 1

        local num = string.sub(line, i, j)

        table.insert(numbers, num)

        for x = i,j do
            if nummap[#lines] == nil then
                nummap[#lines] = {}
            end
            nummap[#lines][x] = #numbers
        end
    end
end


local queue = {}
for y, line in ipairs(lines) do
    for x = 1, #line do
        local char = string.sub(line, x, x)
        if string.find(char, justSymbolsPattern) ~= nil then
            -- print(y, x, char)
            table.insert(queue, {x, y})
        end
    end
end

local dirs = {
    {-1, -1}, {-1, 0}, {-1, 1},
    {0,  -1},          { 0, 1},
    {1,  -1}, { 1, 0}, { 1, 1},
}
local numset = {}
for _, coor in ipairs(queue) do
    local x, y = coor[1], coor[2]
    for _, dir in ipairs(dirs) do
        local dx = x + dir[1]
        local dy = y + dir[2]
        -- print("("..x..","..y..") + ("..dir[1]..","..dir[2]..") = ("..dx..",".. dy..")")

        if nummap[dy] ~= nil and nummap[dy][dx] ~= nil then
            local idx = nummap[dy][dx]
            -- print("number found:" ..numbers[idx])
            numset[idx] = true
        end
    end
end

local sum = 0
for i in pairs(numset) do
    sum = sum + numbers[i]
end
print("sum: ".. sum)
