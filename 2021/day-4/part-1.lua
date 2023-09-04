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

for _, x in ipairs(numbers) do
    for _, card in ipairs(cards) do
        card.mark(x)
        if card.check() then
            local sum = card.remainder()
            print("won " .. sum * x)
            return
        end
    end
end

print("unexpected: winner not found")
