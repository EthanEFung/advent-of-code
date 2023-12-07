io.input("input.txt")

local function hstrength(cards)
    local types = {}
    for t in cards:gmatch(".") do
        if types[t] == nil then types[t] = 0 end
        types[t] = types[t] + 1
    end

    local most = 0
    local pairFound = false
    local tripleFound = false
    for _, count in pairs(types) do
        if count > most then most = count end
    end
    -- print("cards", cards, "most", most)
    if most == 1 then return 1 end
    if most >= 4 then return most + 2 end

    for _, count in pairs(types) do
        if count == 3 and pairFound then return 5 end
        if count == 3 then tripleFound = true end
        if count == 2 and tripleFound then return 5 end
        if count == 2 and pairFound then return 3 end
        if count == 2 then pairFound = true end
    end
    if tripleFound then return 4 end
    return most
end

local function cstrength(card)
    return ("23456789TJQKA"):find(card)
end


local hands = {}
for line in io.lines() do
    local cards, bid = line:match("(%S+)%s+(%d+)")
    -- print("cards", cards, "bid", bid)
    local hand = {
        cards = cards,
        bid = math.tointeger(bid)
    }
    table.insert(hands, hand)
end

table.sort(hands, function(a, b)
    as, bs = hstrength(a.cards), hstrength(b.cards)
    if as ~= bs then
        return as < bs
    end
    for i = 1,5 do
        if cstrength(a.cards:sub(i, i)) ~= cstrength(b.cards:sub(i,i)) then
            return cstrength(a.cards:sub(i, i)) < cstrength(b.cards:sub(i,i))
        end
    end
    return cstrength(a.cards:sub(5, 5)) < cstrength(b.cards:sub(5, 5))
end)

local winnings = 0
for rank, hand in ipairs(hands) do
    print(hand.cards)
    winnings = winnings + (rank * hand.bid)
end
print("winnings: " .. winnings)
