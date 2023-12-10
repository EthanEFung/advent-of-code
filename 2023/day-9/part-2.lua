io.input("input.txt")

local sum = 0
for history in io.lines() do
    local matrix = {}
    local initial = {}
    for num in history:gmatch("[%-%d+]+") do
        local x = math.tointeger(num)
        if x ~= nil then
            table.insert(initial, x)
        end
    end
    table.insert(matrix, initial)
    local hasMore = true

    while hasMore do
        local hist = matrix[#matrix]
        local seq = {}
        local zeros = 0
        for i = 2, #hist do
            local delta = (hist[i] - hist[i-1])
            if delta == 0 then zeros = zeros + 1 end
            table.insert(seq, delta)
        end
        if zeros == #seq then
            hasMore = false
        end
        table.insert(matrix, seq)
    end

    for i = #matrix, 1, -1 do
        local seq = matrix[i]
        local prev = matrix[i+1]
        local next = seq[1]
        if prev ~= nil then
            next = next - prev[0]
        end
        matrix[i][0] = next
    end
    for i = 1, #matrix do
        local out = "" 
        for j = 0, #matrix[i] do
            out = out .. matrix[i][j] .. ", "
        end
        -- print(out)
    end
    sum = sum + matrix[1][0]
end
print("sum: " .. sum)

