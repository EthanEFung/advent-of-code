local inputFilename = "input.txt"

local f = io.open(inputFilename, "a")
if not f then
    print("noop")
    return
end
f:close()

print("reading lines")
local ones  = {}
local zeros = {}

for line in io.lines(inputFilename) do
    for i=1,#line do
        if string.sub(line, i, i) == "1" then
            ones[i] = (ones[i] or 0) + 1
        else
            zeros[i] = (zeros[i] or 0) + 1
        end
    end
end
print("read lines")

local gamma = ""
local epsilon = ""

for i=1,#ones do

    if ones[i] > zeros[i] then
        gamma = gamma .. "1"
        epsilon = epsilon .. "0"
    else
        gamma = gamma .. "0"
        epsilon = epsilon .. "1"
    end
end

print("gamma", type(gamma), gamma, tonumber(gamma, 2))
print("epsilon", type(epsilon), epsilon, tonumber(epsilon, 2))
print("solution", tonumber(gamma, 2)* tonumber(epsilon, 2))
