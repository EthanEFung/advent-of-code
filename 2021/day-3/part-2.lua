local filename = "input.txt"

local f = io.open(filename, "a")

if not f then
    print("file not found:" .. filename)
else
    f:close()
end

local binaries = {}

for line in io.lines(filename) do
    table.insert(binaries, line)
end

-- calculate oxygen
local oxy = {table.unpack(binaries)}
local example = oxy[1]

while #oxy > 1 do
    for i=1,#example do
        if #oxy == 1 then break end
        local temp = {}

        local ones  = 0
        local zeros = 0
        for _, o in ipairs(oxy) do
            if string.sub(o, i, i) == "1" then
                ones = ones + 1
            else
                zeros = zeros + 1
            end
        end

        print("at index " .. i .. " and a length of " .. #oxy .. " oxy has " .. ones .. " ones and " .. zeros .. " zeros")

        for _, o in ipairs(oxy) do
            if ones >= zeros and string.sub(o, i, i) == "1" then
                table.insert(temp, o)
            elseif ones < zeros and string.sub(o, i, i) == "0" then
                table.insert(temp, o)
            end
        end
        oxy = temp
    end
    print("length", #oxy)
end

-- calculate co2
local co2 = binaries
example = co2[1]

while #co2 > 1 do

    for i=1,#example do
        if #co2 == 1 then break end

        local temp = {}
        local ones  = 0
        local zeros = 0
        for _, o in ipairs(co2) do
            if string.sub(o, i, i) == "1" then
                ones = ones + 1
            else
                zeros = zeros + 1
            end
        end
        for _, o in ipairs(co2) do
            if zeros <= ones and string.sub(o, i, i) == "0" then
                table.insert(temp, o)
            elseif zeros > ones and string.sub(o, i, i) == "1" then
                table.insert(temp, o)
            end
        end
        co2 = temp
    end
    print("length", #co2)
end

local x = tonumber(oxy[1], 2)
local y = tonumber(co2[1], 2)
print("found oxy", x)
print("found co2", y)
print("solution", x*y)


