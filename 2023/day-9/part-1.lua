io.input("input.txt")

local sum = 0
for history in io.lines() do
    local t = {}
    local initial = {}
    for num in history:gmatch("[%-%d+]+") do
        local x = math.tointeger(num)
        if x ~= nil then
            table.insert(initial, x)
        end
    end
    table.insert(t, initial)
    local hasMore = true
    while hasMore do
        local h = t[#t]
        local newHist = {}
        local zeros = 0
        for i = 2, #h do
            local delta = (h[i] - h[i-1])
            if delta == 0 then zeros = zeros + 1 end
            table.insert(newHist, delta)
        end
        if zeros == #newHist then
            hasMore = false
        end
        table.insert(t, newHist)
    end
    local next = 0
    for i = #t, 1, -1 do
        local seq = t[i]
        next = next + seq[#seq]
        table.insert(t[i], next)
    end
    sum = sum + next
end
print("sum: " .. sum)
