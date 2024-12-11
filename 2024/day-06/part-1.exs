example = "
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"

# we want to simulate the steps of a guard who when encountering a # will
# rotate 90 degrees, and count the areas on the grid that the guard will
# visit. 
# - if there is something directly in front of you, turn right 90 degrees
# - otherwise continue forward

# conventionally we would search for the location of the arrow in the grid
# once we find the direction, 
#  find if the cell next to it is a #
# if so turn 90 degrees
# continue to iterate for as long as the next index is not off the grid

# What would this look like with functions?

# first lets find the location of the guard.
#   list comprehensions find the row and column of a ^, >, v, or <
# then create a transformer that will return a different grid each time
# the guard takes an action

# the act function will check the direction of the guard
# if the direction is of the grid return the current state
# else if the guard is facing a # 
#   call the act function recursively evaluate the direction and rotate 90 degrees
# else
#   call the act function recursively replacing the cell the guard will occupy

defmodule Part1 do
  def graphemes(str) do
    String.split(str, "\n", trim: true) |> Enum.map(&String.graphemes/1)
  end

  def indices(grid) do
    for {row, row_index} <- Enum.with_index(grid),
        {col, col_index} <- Enum.with_index(row),
        col == "^" || col == ">" || col == "v" || col == "<" do
      {row_index, col_index}
    end
    |> List.first()
  end

  def val(grid, {row, col}), do: Enum.at(Enum.at(grid, row), col)

  def rotate("^"), do: fn _ -> ">" end
  def rotate(">"), do: fn _ -> "v" end
  def rotate("v"), do: fn _ -> "<" end
  def rotate("<"), do: fn _ -> "^" end

  def act(grid, {row, col}) do
    # create a list comprehension that will look at directions, and indices
    for {dir, {drow, dcol}} <- [
          {"^", {row - 1, col}},
          {">", {row, col + 1}},
          {"v", {row + 1, col}},
          {"<", {row, col - 1}}
        ],
        val(grid, {row, col}) == dir do
      # once we find the location of the guard we check if the cell in front of the guard is occupied
      if drow >= 0 && drow < length(grid) && dcol >= 0 && dcol < length(Enum.at(grid, row)) do
        case val(grid, {drow, dcol}) do
          # if we hit a wall we rotate
          "#" ->
            {:recurse, List.update_at(grid, row, fn r -> List.update_at(r, col, rotate(dir)) end)}

          # otherwise this is a valid move
          _ ->
            {:recurse,
             List.update_at(grid, row, fn r -> List.update_at(r, col, fn _ -> "X" end) end)
             |> List.update_at(drow, fn r -> List.update_at(r, dcol, fn _ -> dir end) end)}
        end
      else
        {:base, grid}
      end
    end
    |> List.first()
    |> (fn {cond, g} ->
          case cond do
            :base -> g
            :recurse -> act(g, indices(g))
          end
        end).()
  end

  def count(grid) do
    Enum.reduce(grid, 0, fn row, sum ->
      row_count = Enum.filter(row, &(&1 != "." && &1 != "#")) |> Enum.count()
      row_count + sum
    end)
  end

  def exec(grid) do
    act(grid, indices(grid)) |> count()
  end
end

input =
  case File.read("input.txt") do
    {:ok, content} -> content
    _ -> "something happened"
  end

# example |> Part1.graphemes() |> Part1.exec() |> IO.inspect()
input |> Part1.graphemes() |> Part1.exec() |> IO.inspect(label: "brute force")
