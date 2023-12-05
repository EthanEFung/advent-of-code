io.input("input.txt")

local sum = 0
for line in io.lines() do
    print(line)
    for cardId, winningNumbers, numbers in string.gmatch(line, "Card%s+(%d+):%s+(.+) | (.+)") do
        print(cardId)
        print(winningNumbers)
        print(numbers)
        local winners = {}
        for num in string.gmatch(winningNumbers, "%d+") do
            winners[num] = true
        end
        local product = 0
        for num in string.gmatch(numbers, "%d+") do
            if winners[num] then
                if product == 0 then
                    product = 1
                else
                    product = product * 2
                end
            end
        end
        sum = sum + product
    end
end
print("sum: " .. sum)
