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

local function printTableV(t)
    local out = ""
    for _, item in ipairs(t) do
        out = out .. " " .. item
    end
    return out
end


local strs = split(content, ",")

local fish = map(strs, tonumber)

print("number of initial fish: " .. #fish)

for _=1,80 do
    local spawned = 0
    for i, x in ipairs(fish) do
        if x == 0 then
            spawned = spawned + 1
            fish[i] = 6
        else
            fish[i] = x - 1
        end
    end
    for _=1,spawned do
        table.insert(fish, 8)
    end

    -- print("after "..n.." day: ".. printTableV(fish))
end

print("number of fish after 80 days: ".. #fish)


