io.input("input.txt")

local times;
local distances;
for line in io.lines() do
    local numbers = {}

    for num in string.gmatch(line, "%d+") do
        table.insert(numbers, num)
    end
    if times ~= nil then
        distances = numbers
    else
        times = numbers
    end
end
print("times", #times, "distances", #distances)
local races = {}
for i, time in ipairs(times) do
    table.insert(races, {
        time = math.tointeger(time),
        record = math.tointeger(distances[i]),
    })
end

local product = 1
for _, race in ipairs(races) do
    local out = string.format("time: %s distance: %s", race.time, race.record)
    print(out)

    -- first lets determine how little we can hold the button to beat the record
    local least;
    local s, e = 0, race.time
    while s + 1 < e do
        local m = math.floor((s + e) / 2)
        local time = race.time - m
        local totalDist = time * m
        if totalDist > race.record then
            e = m
        else
            s = m + 1
        end
    end
    local time = race.time - s
    local totalDist = time * s
    if totalDist > race.record then
        least = s
    else
        time = race.time - e
        totalDist = time * e
        least = e
    end

    print("least", least)

    -- now lets determine for how long we can hold the button to beat the record
    local most;
    s, e = 0, race.time
    while s + 1 < e do
        local m = math.floor((s+e) / 2)
        local rate = m
        local time = race.time - rate
        local totalDist = time * rate

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
    print("most", most)
    local waysToWin = most - least + 1
    print("ways to win", waysToWin)
    product = product * waysToWin
    
end

print("result: ".. product)

