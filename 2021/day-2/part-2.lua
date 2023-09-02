
local x, y, aim = 0, 0, 0

for line in io.lines("./input.txt") do
    local words = split(line)

    ---[[
    if words[1] == "forward" then
        x = x + tonumber(words[2])
        y = y + tonumber(words[2]) * aim
    elseif words[1] == "down" then
        aim = aim + tonumber(words[2])
    elseif words[1] == "up" then
        aim = aim - tonumber(words[2])
    end
    --]]
end

print("solution: ", x * y)
