function split(input, delimiter)
    if delimiter == nil then
        delimiter = "%s"
    end
    local t={}
    for str in string.gmatch(input, "([^" .. delimiter .. "]+)") do
        table.insert(t, str)
    end
    return t
end
