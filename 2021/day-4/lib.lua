function CreateCard(str)
    local Card = {}
    local rows = split(str, "\n")
    local stamp = -1

    for _, r in ipairs(rows) do
        local cols = split(r)
        for i, x in ipairs(cols) do
            cols[i] = tonumber(x)
        end

        table.insert(Card, cols)
    end

    function Card.mark(num)
        num = tonumber(num)
        for y, r in ipairs(Card) do
            for x, c in ipairs(r) do
                if c == num then
                    Card[y][x] = stamp
                end
            end
        end
    end

    function Card.check()
        --[[
        check for rows
        --]]
        local won = false
        for y=1,5 do
            local marked = 0
            for x=1,5 do
                if Card[y][x] == stamp then marked = marked + 1 end
            end
            if marked == 5 then won = true end
        end

        --[[ check for cols ]]
        for x=1,5 do
            local marked = 0
            for y=1,5 do
                if Card[y][x] == stamp then marked = marked + 1 end
            end
            if marked == 5 then won = true end
        end

        return won
    end

    function Card.remainder()
        local sum = 0
        for y=1, 5 do
            for x=1, 5 do
                if Card[y][x] ~= stamp then sum = sum + Card[y][x] end
            end
        end
        return sum
    end

    -- print("str " .. str)
    -- print("rows " .. #Card)
    -- print("cols " .. #Card[1])
    return Card
end
