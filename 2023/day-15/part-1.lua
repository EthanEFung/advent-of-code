local filepath = arg[1]
print("filepath", filepath)
if filepath == nil then
    print("no filepath provided")
    os.exit()
end
io.input(filepath)
local input = io.read("a")
if input == nil then
    print("no file found")
    os.exit()
end

local sum = 0
for seq in string.gmatch(input, "([^,^%s]+)") do
    local value = 0
    for i = 1, #seq do
        value = value + seq:byte(i, i)
        value = value * 17
        value = value % 256
    end
    print(seq, value)
    sum = sum + value
end
print("sum: " .. sum)
