local filepath = arg[1]
io.input(filepath)

local columns = {}
local totalRows = 0
for line in io.lines() do
    totalRows = totalRows + 1
    local i = 0
    for cell in line:gmatch(".") do
        i = i + 1
        if columns[i] == nil then
            columns[i] = {}
        end
        columns[i][totalRows] = cell
    end
end

-- shift all the the round rocks to the front
for i = 1, #columns do
    local k = 0
    for j = 1, #columns[i] do
        if columns[i][j] == "O" then
            k = k + 1
            while columns[i][k] == "#" do k = k + 1 end
            local temp = columns[i][j]
            columns[i][j] = columns[i][k]
            columns[i][k] = temp
        elseif columns[i][j] == "#" then
            k = j
        end
    end
end


local sum = 0
for i = 1, #columns do
    local out = ""
    for j = 1, #columns[i] do
        if columns[i][j] == "O" then

            sum = sum + (totalRows - j) + 1
        end
        out = out .. " " .. columns[i][j]
    end
end
print("sum: ".. sum)

