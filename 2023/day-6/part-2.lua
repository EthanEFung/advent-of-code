io.input("input.txt")
local input = io.read("a")

local joined = string.gsub(input, "%s+", "")

local time = string.match(joined, "Time:(%d+)Distance:%d+")
local distance = string.match(joined, "Time:%d+Distance:(%d+)")
print("time", time, "distance", distance)

local race = {
    time = math.tointeger(time),
    record = math.tointeger(distance)
}

-- first lets determine how little we can hold the button to beat the record
local least;
local s, e = 0, race.time
while s + 1 < e do
    local m = math.floor((s + e) / 2)
    local totalDist = (race.time - m) * m
    if totalDist > race.record then
        e = m
    else
        s = m + 1
    end
end
local totalDist = (race.time - s) * s
if totalDist > race.record then
    least = s
else
    time = race.time - e
    totalDist = time * e
    least = e
end

print("least: " ..least)

-- now lets determine for how long we can hold the button to beat the record
local most;
s, e = 0, race.time
while s + 1 < e do
    local m = math.floor((s+e) / 2)
    local rate = m
    local totalDist = (race.time - rate) * rate

    -- local out = string.format("rate %d time %d totalDist %d", rate, time, totalDist)
    -- print(out)
    if totalDist > race.record then
        s = m
    else
        e = m - 1
    end
end
time = race.time - e
totalDist = time * e
if totalDist > race.record then
    most = e
else
    most = s
end

print("most: " ..most)

local waysToWin = most - least + 1

print("ways to win: " ..waysToWin)


