io.input("input.txt")

local fiveOfAKind = 7
local fourOfAKind = 6
local fullHouse = 5
local threeOfAKind = 4
local twoPair = 3
local onePair = 2
local highCard = 1

ranks = {
    "highCard", "onePair", "twoPair", "threeOfAKind", "fullHouse", "fourOfAKind", "fiveOfAKind"
}


local function hactual(cards)
    local types = {}
    for t in cards:gmatch(".") do
        if types[t] == nil then types[t] = 0 end
        types[t] = types[t] + 1
    end

    local most = 0
    for _, count in pairs(types) do
        if count > most then most = count end
    end
    -- print("cards", cards, "most", most)
    if most == 1 then return highCard end
    if most == 5 then return fiveOfAKind end
    if most == 4 then return fourOfAKind end

    local pairFound = false
    local tripleFound = false
    for _, count in pairs(types) do
        if count == 3 and pairFound then return fullHouse end
        if count == 3 then tripleFound = true end
        if count == 2 and tripleFound then return fullHouse end
        if count == 2 and pairFound then return twoPair end
        if count == 2 then pairFound = true end
    end
    if tripleFound then return threeOfAKind end
    if pairFound then return onePair end
    return most
end

local function hstrength(cards)
    local types = {}
    local nJokers = 0
    local most = 0
    for t in cards:gmatch(".") do
        if t == "J" then
            nJokers = nJokers + 1
        elseif types[t] == nil then
            types[t] = 1
        else
            types[t] = types[t] + 1
        end
        if t ~= "J" and types[t] > most then
            most = types[t]
        end
    end
    if nJokers >= 3 then
        if nJokers >= 4 then return fiveOfAKind end
        if nJokers == 3 and most == 2 then return fiveOfAKind end
        return fourOfAKind
    elseif nJokers == 2 then
        if most == 3 then return fiveOfAKind end
        if most == 2 then return fourOfAKind end
        return threeOfAKind
    elseif nJokers == 1 then
        if most == 4 then return fiveOfAKind end
        if most == 3 then return fourOfAKind end
        if most == 2 then
            local pairFound = false
            for _, count in pairs(types) do
                if count == 2 and pairFound then
                    return fullHouse
                elseif count == 2 then
                    pairFound = true
                end
            end
            return threeOfAKind
        end
        return onePair
    end
    return hactual(cards)
end

local function cstrength(card)
    return ("J23456789TQKA"):find(card)
end


local hands = {}
for line in io.lines() do
    local c, bid = line:match("(%S+)%s+(%d+)")
    local strength = hstrength(c)
    local hand = {
        cards = c,
        strength = strength,
        bid = math.tointeger(bid)
    }
    table.insert(hands, hand)
end

table.sort(hands, function(a, b)
    if a.strength ~= b.strength then
        return a.strength < b.strength
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
    print(rank .. ') ' .. hand.cards .. ' - ' ..ranks[hand.strength])

    winnings = winnings + (rank * hand.bid)
end
print("winnings: " .. winnings)
