io.input("input.txt")

local cards = {}

for line in io.lines() do
    for id, winning, strnumbers in string.gmatch(line, "Card%s+(%d+):%s+(.+)%s+|%s+(.+)") do
        local winners = {}
        for w in string.gmatch(winning, "%d+") do
            w = math.tointeger(w)
            if w ~= nil then
                winners[w] = true
            end
        end

        local numbers = {}
        for n in string.gmatch(strnumbers, "%d+") do
            local x = math.tointeger(n)
            if x ~= nil then
                table.insert(numbers, x)
            end
        end

        id = math.tointeger(id)
        if id ~= nil then
            cards[id] = {
                copies = 1,
                winners = winners,
                numbers = numbers
            }
        end
    end
end

for id, card in pairs(cards) do
    local copies = 0
    for _, num in ipairs(card.numbers) do
        if card.winners[num] then
            copies = copies + 1
        end
    end

    for x = 1,copies do
        local next = id + x
        if cards[next] ~= nil then
            cards[next].copies = cards[next].copies + card.copies
        end
    end
end

local sum = 0
for _, card in pairs(cards) do
    sum = sum + card.copies
end
print("sum: " .. sum)

