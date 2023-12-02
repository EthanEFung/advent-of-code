io.input("input.txt")

local sum = 0
for line in io.lines() do
    local product = 1
    local minimums = {
        red = 0,
        green = 0,
        blue = 0,
    }
    line = string.gsub(line, "[,;]", "")
    for sub in string.gmatch(line, "%d+ %S+") do
        local xStr = string.match(sub, "(%d+) %S+")
        local x = math.tointeger(xStr)
        local color = string.match(sub, "%d+ (%S+)")
        if x > minimums[color] then
            minimums[color] = x
        end
    end
    for _, min in pairs(minimums) do
        if min == 0 then
            print("something went wrong")
            break
        end
        product = product * min
    end
    sum = sum + product
end
print("total:"..sum)
