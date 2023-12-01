--[[
-- part 2 is tricky because lua doesn't have a full POSIX regular expression
-- implementation. this means we can't pattern match words like /[one|two|three]/g
--]]
io.input("input.txt");

local sum = 0
local nums = {
    one = "1",
    two = "2",
    three = "3",
    four = "4",
    five = "5",
    six = "6",
    seven = "7",
    eight = "8",
    nine = "9",
}

for line in io.lines() do
    local first = string.len(line)
    local firstDigit = nil

    local last = 0 -- this is fine in lua because tables, strings, etc are 1-indexed
    local lastDigit = nil
    local i, j

    for w in pairs(nums) do
        i = string.find(line, w)

        if i ~= nil and i < first then
            first = i
            firstDigit = nums[w]
        end

        i, j = string.find(line, ".*("..w..")")
        if i ~= nil and i >= last then
            last = i
            lastDigit = nums[w]
        end
        if j ~= nil and j >= last then
            last = j
            lastDigit = nums[w]
        end
    end

    i = string.find(line, "%d")

    if i ~= nil and i <= first then
        first = i
        firstDigit = string.sub(line, i, i)
    end

    i, j = string.find(line, ".*(%d)")
    if i ~= nil and i >= last then
        last = i
        lastDigit = string.sub(line, i, i)
    end
    if j ~= nil and j >= last then
        last = j
        lastDigit = string.sub(line, j, j)
    end
    -- print("EVAL", line, (firstDigit .. lastDigit), sum, sum + (firstDigit .. lastDigit))
    sum = sum + (firstDigit .. lastDigit)
end
print("sum:", sum)
