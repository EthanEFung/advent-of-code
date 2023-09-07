local path = "input.txt"

local f = io.open(path, "rb")

if not f then
    print("file not found")
    return
end

local content = f:read("*all")

f:close()

local function split(str, delimiter)
    local t = {}
    for s in string.gmatch(str, "([^"..delimiter.."]+)") do
        table.insert(t, s)
    end
    return t
end

local function map(t, cb)
    local u = {}
    for _, item in ipairs(t) do
        table.insert(u, cb(item))
    end
    return u
end

local function sum(t)
    local s = 0
    for i=0, #t do
        s = s + t[i]
    end
    return s
end

local function printTableV(t)
    local out = ""
    for _, item in ipairs(t) do
        out = out .. " " .. item
    end
    return out
end


local strs = split(content, ",")

local fish = map(strs, tonumber)

print("number of initial fish:" .. #fish)

local counts = {}

for i=0,8 do
    counts[i] = 0
end

for _, x in ipairs(fish) do
    counts[x] = counts[x] + 1
end



for _=1,256 do
    local temp = 0
    for i=8,0,-1 do
        local fishes = counts[i]
        if type(fishes) ~= "number" then
            print(i, "fishes is not a number", type(fishes))
        end
        counts[i] = temp
        temp = fishes
    end
    counts[6] = counts[6] + temp
    counts[8] = temp

    -- print("after "..n.." day: ".. printTableV(fish))
end

print(printTableV(counts))
print("after 256 days:" .. sum(counts))






