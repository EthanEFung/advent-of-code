local filename = arg[1]
print(filename)

local f = io.open(filename, "rb")

if not f then
    print("file not found")
    return
end

f:close()

local str = ""
local numbers = {}
local cards = {}

for line in io.lines(filename) do
    if line == "" then
        if #numbers == 0 then
            print(str)
            numbers = split(str, ",")
        else
            local card = CreateCard(str)
            table.insert(cards, card)
        end
        str = ""
    else
        str = str .. "\n" .. line
    end
end

table.insert(cards, CreateCard(str))

for i, x in ipairs(numbers) do
    numbers[i] = tonumber(x)
end

local last = ""
for _, x in ipairs(numbers) do
    for i, card in ipairs(cards) do
        card.mark(x)
    end
    for i, card in ipairs(cards) do
        if card.check() then
            local sum = card.remainder()
            last = "final score: " .. sum .. " + " .. x .. " = " .. sum * x
            table.remove(cards, i)
            print("cards left: " .. #cards)
        end
    end
end


if #last == 0 then
    print("unexpected: winner not found")
else
    print(last)
end

