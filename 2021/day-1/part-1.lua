local filename = arg[1]
local f = io.open(filename, "rb")

if not f then return nil end

local count = 0
local last = nil
for line in io.lines(filename) do
    local x = tonumber(line)
    if last and x > last then
        count = count + 1
    end
    last = x
end

print("count: " .. count)
f:close()
