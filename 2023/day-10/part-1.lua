io.input("input.txt")

local maze = {}
local north = {-1,  0}
local east =  { 0,  1}
local south = { 1,  0}
local west =  { 0, -1}
local cardinal = { north=north, east=east, south=south, west=west }


-- build the matrix of the maze and find the starting coordinates
local y = 0
local sx, sy
local connectionsTo = {
    north = "|F7",
    east = "-7J",
    south = "|JL",
    west = "-FL",
}
for line in io.lines() do
    y = y + 1
    maze[y] = {}
    local x = 0
    for cell in string.gmatch(line, ".") do
        x = x + 1
        maze[y][x] = cell
        if cell == "S" then
            sx = x
            sy = y
        end
    end
end
print(string.format("starting index: %d, %d", sy, sx))

-- also find the direction in which we need to move through the pipes
local startingDir = nil
for dir, coor in pairs(cardinal) do
    local dy, dx = sy + coor[1], sx + coor[2]
    if dy > 0 and dy <= #maze and dx > 0 and dx <= #maze[1] then
        local pipe = maze[dy][dx]
        local conn = connectionsTo[dir]
        for expected in conn:gmatch(".") do
            if pipe == expected then
                startingDir = dir
            end
        end
    end
end

-- depending on the direction moving to and from determines where where
-- a cursor is placed on the maze
local fromMap = {
    north = {
        ["|"] = "south",
        ["J"] = "west",
        ["L"] = "east"
    },
    east = {
        ["-"] = "west",
        ["F"] = "south",
        ["L"] = "north"
    },
    south = {
        ["|"] = "north",
        ["7"] = "west",
        ["F"] = "east"
    },
    west = {
        ["-"] = "east",
        ["J"] = "north",
        ["7"] = "south"
    },
}
local steps = 1
local to = startingDir
local from;
local dir = cardinal[startingDir]
local cy, cx = sy + dir[1], sx + dir[2]
local curr = maze[cy][cx]
while curr ~= "S" do
    steps = steps + 1
    if     to == "west"  then from = "east"
    elseif to == "north" then from = "south"
    elseif to == "east"  then from = "west"
    elseif to == "south" then from = "north"
    end

    to = fromMap[from][curr]
    if to == nil then
        print("you messed up")
    end
    dir = cardinal[to]
    cy, cx = cy + dir[1], cx + dir[2]
    curr = maze[cy][cx]
end
print("steps:", math.tointeger(steps / 2))
