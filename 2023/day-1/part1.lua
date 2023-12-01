--[[
-- what we would like to do is
--      look for a flag that specifies a file to read
--      if not assume that the input comes from stdin
-- read from the input.txt file
-- for each line in the buffer
-- do a for loop to find the first and last digit
--   combine the digits and add to a sum (so convert string to number
-- print to standard out the sum
--]]
io.input("input.txt")
local sum = 0
for line in io.lines() do
    local first = nil
    local last = nil
    for d in string.gmatch(line, "%d") do
        if not first then
            first = d
        end
        last = d
    end
    sum = sum + (first .. last)
end
print(sum)

