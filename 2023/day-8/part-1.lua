io.input("input.txt")

local input = io.read("a")

local dir, network = string.match(input, "(%S+)%s+(.+)")
local adjacency = {}
for node, left, right in string.gmatch(network, "(%S+) = %((%S+),%s+(%S+)%)%s+") do
    adjacency[node] = { L = left, R  = right }
end

local curr = "AAA"
local steps = 0

while curr ~= "ZZZ" do
    for d in string.gmatch(dir, ".") do
        steps = steps + 1
        curr = adjacency[curr][d]
        if curr == "ZZZ" then break end
    end
end
print("steps: " .. steps)

