local x, y = 0, 0
for line in io.lines("./input.txt") do
    local words = split(line)

    ---[[
    if words[1] == "forward" then
        x = x + tonumber(words[2])
    elseif words[1] == "down" then
        y = y + tonumber(words[2])
    elseif words[1] == "up" then
        y = y - tonumber(words[2])
    end
    --]]
end

print("solution: ", x * y)
