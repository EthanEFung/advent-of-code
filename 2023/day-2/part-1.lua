io.input("input.txt")

local limits = {
    red = 12,
    green = 13,
    blue = 14,
}

local sum = 0
for line in io.lines() do
    line = string.gsub(line, "[,;]", "")
    local id = string.match(line, "Game (%d+):")
    local valid = true
    for sub in string.gmatch(line, "%d+ %S+") do
        local xStr = string.match(sub, "(%d+) %S+")
        local x = math.tointeger(xStr)
        local color = string.match(sub, "%d+ (%S+)")
        if limits[color] < x then
            valid = false
            break
        end
    end
    if valid then
        sum = sum + id
    end
end
print("total:"..sum)
