io.input("input.txt")

local function gcd(a, b)
    if a == 0 then return b end
    return gcd(b % a, a)
end

local function lcm(a, b)
    return (a * b) / gcd(a, b)
end

local input = io.read("a")
local dir, network = input:match("(%S+)%s+(.+)")
local adj = {}
local nodes = {}
for node, left, right in network:gmatch("(%w+)%s+=%s+%((%w+)%s*,%s+(%w+)%)") do
    adj[node] = { L = left, R = right }
    if node:find("(.+A)$") ~= nil then table.insert(nodes, node) end
end

local lengths = {}
for _, node in ipairs(nodes) do
    local steps = 0
    while node:find("(.+Z)$") == nil do
        for d in dir:gmatch(".") do
            steps = steps + 1
            node = adj[node][d]
            if node:find("(.+Z)$") ~= nil then
                table.insert(lengths, steps)
                break
            end
        end
    end
end

local agg = 1
for _, steps in ipairs(lengths) do
    agg = lcm(agg, steps)
end

print("lcm: ", agg)
