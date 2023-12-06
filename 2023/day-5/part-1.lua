io.input("input.txt")

local function dump(o)
   if type(o) == 'table' then
      local s = '{'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '}'
   else
      return tostring(o)
   end
end

local function tointegers(str)
    local ints = {}
    for num in string.gmatch(str, "%d+") do
        local x = math.tointeger(num)
        if x ~= nil then
            table.insert(ints, x)
        end
    end
    return ints
end

local out = io.read("a")
local seedsStr = string.match(out, "seeds:%s+([%d ]+)")
local seeds = tointegers(seedsStr)


--[[ list might look something like this
 seed = {
    soil = {
        34 = 60
        35 = 61
    }
 }
-- ]]

local maps = {}
local other = string.gsub(out, "\n\n", "!") -- replace double return with a single character
for key, ranges in string.gmatch(other, "(%a+%-to%-%a+)%s+map:([^!]+)") do
    print(key)
    -- print(src, dst, ranges)
    if maps[key] == nil then
        maps[key] = {}
    end

    for range in string.gmatch(ranges, "([^\n]+)") do
        local v = tointegers(range)
        table.insert(maps[key], {
            dst = v[1],
            src = v[2],
            length = v[3],
        })
    end
end

-- [[
-- from here we want to iterate over the seeds
-- going from src to dst until we get to a location
-- ]]
local lowest;

for _, seed in ipairs(seeds) do
    local src
    local dst
    local map;
    -- find the destination from seed and the map
    for k, v  in pairs(maps) do
        src, dst = string.match(k, "(%a+)%-to%-(%a+)")
        if src == "seed" then
            map = v
            break
        end
    end

    while true do
        -- print("from ".. src .. " to " .. dst .. ": " .. seed)
        local curr = seed
        for _, range in ipairs(map) do
            if seed >= range.src and seed <= (range.src + range.length - 1) then
                local delta = seed - range.src
                curr = range.dst + delta

                -- print("delta", delta)
                -- srcOut = string.format("src: %d >= %d <= %d", range.src, seed, range.src + range.length - 1)
                -- dstOut = string.format("dst: %d >= %d <= %d", range.dst, curr, range.dst + range.length - 1)
                -- print(srcOut)
                -- print(dstOut)
            end
        end

        seed = curr -- change the start to the current
        src = dst
        if src == "location" then
            break
        end

        for key, _ in pairs(maps) do
            local s, d = string.match(key, "(%a+)%-to%-(%a+)")
            if s == src then
                dst = d
                map = maps[key]
                break
            end
        end
    end

    if lowest == nil or seed < lowest then
        lowest = seed
    end
end
print("lowest: ",lowest)
--
