local filename = arg[1]

local f = io.open(filename, "rb")
if not f then return end
f:close()

local lines = {}
for line in io.lines(filename) do
    lines[#lines + 1] = tonumber(line)
end

print("lines:" .. #lines)

local size = 0
local sum = 0
local last = nil
local count = 0

for k,v in pairs(lines) do
    if size ~= 3 then
        sum = sum + v
        size = size + 1
    else
        last = sum
        sum = sum + v
        sum = sum - lines[k-3]
        if sum > last then
            count = count + 1
        end
    end
end

print("count:" .. count)

